from .album import Album
from .db import get_db, close_db, make_query

def create_album(album):
    query = "INSERT INTO Albums (Artist, Album, CoverURL) VALUES (%s, %s, %s)"
    cursor = make_query(query, (album.artist_name, album.album_name, album.cover_url), True)
    cursor.close()
    close_db()
    return album.get_dict()

def update_album(album_id, album):
    query = "UPDATE Albums SET Artist = %s, Album = %s, CoverURL = %s WHERE AlbumId = %s"
    cursor = make_query(query, (album.artist_name, album.album_name, album.cover_url, album_id), True)
    cursor.close()
    close_db()
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
    close_db()
    return albums

def describe_album(album_id):
    query = "SELECT * FROM Albums WHERE AlbumId = %s LIMIT 1"
    cursor = make_query(query, (album_id,))
    album = {}
    for (AlbumId, Artist, Album, CoverURL) in cursor:
        album = Album(
            artist_name, album_name, cover_url,
            album_id=album_id
        )
        album = album.get_dict()
    cursor.close()
    close_db()
    return album

def delete_album(album_id):
    query = "DELETE FROM Albums WHERE AlbumId = %s"
    cursor = make_query(query, (album_id,), True)
    cursor.close()
    close_db()

def monitor():
    query = "SELECT 1 = 1"
    cursor = make_query(query)
    for (test) in cursor:
        if 1 in test:
            return "db is healthy"
        else:
            return "db is unhealthy"
    cursor.close()
    close_db()

