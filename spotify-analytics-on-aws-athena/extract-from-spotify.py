import spotipy
from spotipy.oauth2 import SpotifyClientCredentials
import json


def connect_to_spotify(YOUR_APP_CLIENT_ID, YOUR_APP_CLIENT_SECRET):
    sp = spotipy.Spotify(auth_manager=SpotifyClientCredentials(client_id=YOUR_APP_CLIENT_ID,client_secret=YOUR_APP_CLIENT_SECRET))
    return sp

def get_playlist_uri(playlist_link):
    playlist_uri=playlist_link.split("/")[-1]
    return playlist_uri

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


# Execute
YOUR_APP_CLIENT_ID="ab127ec3521b4297a152d463e88471a7"
YOUR_APP_CLIENT_SECRET = "cd93f807fa85493d908b570eb5841eea"
playlist_link="https://open.spotify.com/playlist/37i9dQZF1DX18jTM2l2fJY"

sp = connect_to_spotify(YOUR_APP_CLIENT_ID,YOUR_APP_CLIENT_SECRET)
playlist_uri = get_playlist_uri(playlist_link)
albums = get_album_data(sp, playlist_uri)
print(albums[2])
print(len(albums))











