import json
import boto3
import pandas as pd
import datetime
from io import StringIO
import os


# push to s3
def put_object(client, bucket, key, data):
    client.put_object(
        Bucket = bucket,
        Key = key,
        Body = data
        )

def get_current_datetime():
    current_datetime = datetime.datetime.now()
    current_datetime_str = current_datetime.strftime("%Y-%m-%d-%H-%M-%S")
    return current_datetime_str
    
def write_to_s3(Bucket, s3_path, df, client):
    dateAndTime = get_current_datetime()
    key = s3_path +"_" + dateAndTime + ".csv"
    data_buffer = StringIO()
    df.to_csv(data_buffer)
    content = data_buffer.getvalue()
    put_object(client, Bucket, key, content)


def get_album_data(data):
    album_data = []
    for row in data['items']:
        album_id=row['track']['album']['id']
        album_name=row['track']['album']['name']
        album_release_date=row['track']['album']['release_date']
        album_total_tracks=row['track']['album']['total_tracks']
        #album=row['track']['album']['artists'][0]['external_urls']['spotify']
        album_url=row['track']['album']['external_urls']['spotify']   
        #items=json.dumps(items, indent=3)
        album = {"album_id": album_id, "album_name": album_name, "release_date": album_release_date, "album_total_tracks": album_total_tracks, "album_url": album_url}
        album_data.append(album)
    return album_data

def get_artists_data(data):
    #print(type(data))
    #for key, value in data.items():
        #print(key)
        #print(f"Data type of value for key '{key}': {type(value)}")
    #items = data['items'][3]['track']['artists'] # one song/track can have multiple artists so below for loop, loops through all such multiple artists for a track.
    #items = data['items'][3]['track']['artists']
    artist_list = []
    for row in data['items']:
        for key, value in row.items():
            if key == 'track':
                for artist in value['artists']:
                    artist_dict = {'artist_id': artist['id'], 'artist_name': artist['name'], 'external_url': artist['href']}
                    artist_list.append(artist_dict)
    

    return artist_list
    

def get_songs_data(data):
    songs_list = []
    for row in data['items']:
        song_id = row['track']['id']
        song_name = row['track']['name']
        duration_ms =  row['track']['duration_ms']
        song_url = row['track']['external_urls']['spotify']
        song_popularity = row['track']['popularity']
        song_added = row['added_at']
        album_id = row['track']['album']['id']
        artist_id = row['track']['album']['artists'][0]['id']
        songs_info = {'song_id': song_id, 'song_name': song_name, 'duration_ms': duration_ms, 'song_url': song_url, 'song_popularity': song_popularity,
                'song_added': song_added, 'album_id': album_id, 'artist_id': artist_id}
        songs_list.append(songs_info)
    return songs_list

def transform_spotify_data_to_s3(event, context):
    Bucket = os.environ.get("s3_bucket")
    Key = os.environ.get("s3_landing")
    s3_archive = os.environ.get("s3_archive")
    client = boto3.client('s3')
    spotify_data = []
    spotify_keys = []
    for file in client.list_objects(Bucket=Bucket, Prefix=Key)['Contents']:
        print(file['Key'])
        file_key = file['Key']
        if file_key.split(".")[-1] == "json":
            response = client.get_object(Bucket=Bucket, Key=file_key)
            content = response['Body']
            jsonData = json.loads(content.read())
            print(jsonData)
            spotify_data.append(jsonData)
            spotify_keys.append(file_key)
    
    for data in spotify_data:
        albums = get_album_data(data)
        artists = get_artists_data(data)
        songs = get_songs_data(data)
        
        # create album dataframe
        album_Df = pd.DataFrame.from_dict(albums)
        #print(album_Df.head())
        album_Df = album_Df.drop_duplicates(subset=['album_id'])
        
        
        # create artists dataframe
        artsits_Df = pd.DataFrame.from_dict(artists)
        #print(artsits_Df.head())
        artsits_Df = artsits_Df.drop_duplicates(subset=['artist_id'])
        
        
        # create songs dataframe
        songs_Df = pd.DataFrame.from_dict(songs)
        songs_Df = songs_Df.drop_duplicates(subset=['song_id'])
        
        # write songs data to s3
        s3_path = "transformed_data/songs/songs_transformed"
        write_to_s3(Bucket, s3_path, songs_Df, client)
        
        # write artists data to s3
        s3_path = "transformed_data/artists/artists_transformed"
        write_to_s3(Bucket, s3_path, artsits_Df, client)
        
          # write albums data to s3
        s3_path = "transformed_data/albums/albums_transformed"
        write_to_s3(Bucket, s3_path, album_Df, client)
    
    # file archive
    s3_resource = boto3.resource('s3')
    for key in spotify_keys:
        copy_source = {
            'Bucket': Bucket,
            'Key': key
        }
        s3_resource.meta.client.copy(copy_source, Bucket, s3_archive + key.split("/")[-1])
        s3_resource.Object(Bucket, key).delete()
        
        
    