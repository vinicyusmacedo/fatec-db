from .album import Album
from .db import get_db, close_db, make_query
from base64 import b64encode

def create_album(album):
    query = "INSERT INTO Albums (Artist, Album, CoverURL) VALUES (%s, %s, %s)"
    cursor = make_query(query, (album.artist_name, album.album_name, album.cover_url), True)
    cursor.close()
    album = describe_album_from_album_name(album.album_name)
    return album

def update_album(album_id, album):
    query = "UPDATE Albums SET Artist = %s, Album = %s, CoverURL = %s WHERE AlbumId = %s"
    cursor = make_query(query, (album.artist_name, album.album_name, album.cover_url, album_id), True)
    cursor.close()
    return album.get_dict()

def get_albums():
    query = "SELECT * FROM Albums"
    cursor = make_query(query)
    albums = []
    for (AlbumId, Artist, Album, CoverURL) in cursor:
        album = Album(
            Artist, Album, CoverURL,
            album_id=AlbumId
        )
        album = album.get_dict()
        albums.append(album)
    cursor.close()
    return albums

def describe_album(album_id, return_dict=True):
    query = "SELECT * FROM Albums WHERE AlbumId = %s LIMIT 1"
    cursor = make_query(query, (album_id,))
    album = {}
    for (AlbumId, Artist, AlbumName, CoverURL, CoverId) in cursor:
        album = Album(
            Artist, AlbumName, CoverURL,
            album_id=AlbumId, cover_id=CoverId
        )
        if return_dict:
            album = album.get_dict()
    cursor.close()
    return album

def describe_album_from_album_name(album_name, return_dict=True):
    query = "SELECT * FROM Albums WHERE Album = %s LIMIT 1"
    cursor = make_query(query, (album_name,))
    album = {}
    for (AlbumId, Artist, AlbumName, CoverURL, CoverId) in cursor:
        album = Album(
            Artist, AlbumName, CoverURL,
            album_id=AlbumId, cover_id=CoverId
        )
        if return_dict:
            album = album.get_dict()
    cursor.close()
    return album

def delete_album(album_id):
    query = "DELETE FROM Albums WHERE AlbumId = %s"
    cursor = make_query(query, (album_id,), True)
    cursor.close()

def update_cover_id(album_id):
    query = "CALL UpdateAlbumCoverId(%s)"
    cursor = make_query(query, (album_id,), True)
    cursor.close()

def insert_cover_blob(picture_blob, cover_id):
    query = "CALL CreateBlobForCover(%s, %s)"
    cursor = make_query(query, (picture_blob, cover_id,), True)
    cursor.close()

def get_cover_blob(cover_id):
    query = "CALL GetBlobForCover (%s)"
    cursor = make_query(query, (cover_id,))
    blob_ret = None
    for (blob) in cursor:
        blob_ret = blob
    cursor.close()
    return blob_ret

def monitor():
    query = "SELECT 1 = 1"
    cursor = make_query(query)
    for (test) in cursor:
        if 1 in test:
            return "db is healthy"
        else:
            return "db is unhealthy"
    cursor.close()

