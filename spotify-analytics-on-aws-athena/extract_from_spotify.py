# import required libraries
import spotipy
from spotipy.oauth2 import SpotifyClientCredentials
import json
import os
import boto3
from botocore.config import Config
import datetime

# constants
playlist_link="https://open.spotify.com/playlist/37i9dQZF1DX18jTM2l2fJY"

# establish the connection to spotify api
def connect_to_spotify(client_id, client_secret):
    sp = spotipy.Spotify(auth_manager=SpotifyClientCredentials(client_id=client_id,client_secret=client_secret))
    return sp

# parse the playlist URI
def get_spotify_data(sp, playlist_link):
    playlist_uri=playlist_link.split("/")[-1]
    spotify_data =  sp.playlist_tracks(playlist_uri)
    return spotify_data

# s3 client
def s3_client(region_name=None):
    my_region = os.environ['AWS_REGION']
    print(my_region)
    region_name = region_name or my_region
    client = boto3.client("s3")
    return client

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
    


# lambda handler
def extract_and_ingest_to_s3(event, context):
    try:
        client_id = os.environ.get("client_id")
        client_secret = os.environ.get("client_secret")
        s3_bucket = os.environ.get("s3_bucket")
        dateAndTime = get_current_datetime()
        filename = "spotify_raw_" + dateAndTime + ".json"
        s3_key = os.environ.get("s3_key")
        s3_key = s3_key+filename
        print(s3_key)
        sp = connect_to_spotify(client_id,client_secret)
        spotify_data = get_spotify_data(sp, playlist_link)
        spotify_data = json.dumps(spotify_data)
        s3 = s3_client()
        put_object(s3, s3_bucket, s3_key, spotify_data)
    except Exception as e:
        print(e)
