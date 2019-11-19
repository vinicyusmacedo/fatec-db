from flask import (
    Blueprint, jsonify, request
)

import requests

from .dao import create_album, update_album, describe_album, get_albums, delete_album, update_cover_id, describe_album_from_album_name, insert_cover_blob, get_cover_blob

from .album import Album

bp = Blueprint('album', __name__, url_prefix='/')

@bp.route('/album', methods=['GET', 'POST'])
def album():
    if request.method == 'POST':
        req = request.get_json()
        album = Album(req.get('artist_name'), req.get('album_name'), req.get('cover_url'))
        album = create_album(album)
        update_cover_id(album.get("album_id"))
        album = describe_album_from_album_name(album.get("album_name"))
        # Performance is not a problem right now anyways
        r = requests.get(album.get("cover_url"))
        if r.status_code == 200:
            insert_cover_blob(r.content, album.get("cover_id"))
        return jsonify(album)
    if request.method == 'GET':
        albuns = get_albums()
        return jsonify(albuns)
    return jsonify({"message": "nodata"})

@bp.route('/album/<int:album_id>', methods=['GET', 'PATCH', 'DELETE'])
def album_id(album_id):
    if request.method == 'GET':
        album = describe_album(album_id, False)
        album.image_blob = get_cover_blob(album.cover_id)
        return jsonify(album.get_dict())
    if request.method == 'PATCH':
        req = request.get_json()
        album = Album(req.get('artist_name'), req.get('album_name'), req.get('cover_url'))
        album = update_album(album_id, album)
        return jsonify(album)
    if request.method == 'DELETE':
        album = delete_album(album_id)
        return jsonify({"message": f"{album_id} was deleted"})
    return jsonify({"message": "nodata"})
