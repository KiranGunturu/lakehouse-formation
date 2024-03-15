import spotipy
from spotipy.oauth2 import SpotifyClientCredentials
import json
import pandas as pd


def connect_to_spotify(YOUR_APP_CLIENT_ID, YOUR_APP_CLIENT_SECRET):
    sp = spotipy.Spotify(auth_manager=SpotifyClientCredentials(client_id=YOUR_APP_CLIENT_ID,client_secret=YOUR_APP_CLIENT_SECRET))
    return sp

def get_playlist_uri(playlist_link):
    playlist_uri=playlist_link.split("/")[-1]
    return playlist_uri

def get_data_types(data):
    types_set = set()
    
    def explore(item):
        if isinstance(item, dict):
            types_set.add("dict")
            for key, value in item.items():
                print(f"Key: '{key}', Data type of value: {type(value).__name__}")
                explore(value)
        elif isinstance(item, list):
            types_set.add("list")
            for value in item:
                explore(value)
        else:
            types_set.add(type(item).__name__)
    
    explore(data)
    return types_set

def get_album_data(sp, playlist_uri):
    data=sp.playlist_tracks(playlist_uri)
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

def get_artists_data(sp, playlist_uri):
    data=sp.playlist_tracks(playlist_uri)
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

def get_songs_data(sp, playlist_uri):
    data=sp.playlist_tracks(playlist_uri)
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






# Execute and test get_album_data
YOUR_APP_CLIENT_ID="ab127ec3521b4297a152d463e88471a7"
YOUR_APP_CLIENT_SECRET = "cd93f807fa85493d908b570eb5841eea"
playlist_link="https://open.spotify.com/playlist/37i9dQZF1DX18jTM2l2fJY"

sp = connect_to_spotify(YOUR_APP_CLIENT_ID,YOUR_APP_CLIENT_SECRET)
playlist_uri = get_playlist_uri(playlist_link)
albums = get_album_data(sp, playlist_uri)
print(type(albums))
#print(albums[2])
#print(len(albums))

# Execute and test get_artists_data
sp = connect_to_spotify(YOUR_APP_CLIENT_ID,YOUR_APP_CLIENT_SECRET)
playlist_uri = get_playlist_uri(playlist_link)
artists = get_artists_data(sp, playlist_uri)
#print(artists)

# Execute and test get_songs_data
sp = connect_to_spotify(YOUR_APP_CLIENT_ID,YOUR_APP_CLIENT_SECRET)
playlist_uri = get_playlist_uri(playlist_link)
songs = get_songs_data(sp, playlist_uri)
#print(songs)

# Execute and look at diff datatypes in the payload:
#my_data = get_artists_data(sp, playlist_uri)
#types = get_data_types(my_data)
#print("Different data types present in the list:", types)


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
print(songs_Df.head())
songs_Df = songs_Df.drop_duplicates(subset=['song_id'])









