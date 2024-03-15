# import required libraries
import spotipy
from spotipy.oauth2 import SpotifyClientCredentials
import json
import os

# constants
playlist_link="https://open.spotify.com/playlist/37i9dQZF1DX18jTM2l2fJY"

# establish the connection to spotify api
def connect_to_spotify(client_id, client_secret):
    sp = spotipy.Spotify(auth_manager=SpotifyClientCredentials(client_id=client_id,client_secret=client_secret))
    return sp

# parse the playlist URI
def get_playlist_uri(playlist_link):
    playlist_uri=playlist_link.split("/")[-1]
    return playlist_uri

# extract albums data from API
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

# lambda handler
def extract_and_ingest_to_s3(event, context):
    try:
        client_id = os.environ.get("client_id")
        client_secret = os.environ.get("client_secret")
        sp = connect_to_spotify(client_id,client_secret)
        playlist_uri = get_playlist_uri(playlist_link)
        albums = get_album_data(sp, playlist_uri)
        print(type(albums))
    except Exception as e:
        print(e)
