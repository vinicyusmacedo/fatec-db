from flask import (
    Blueprint, jsonify, request
)

from .dao import create_album, update_album, describe_album, get_albums, delete_album

from .album import Album

bp = Blueprint('album', __name__, url_prefix='/')

@bp.route('/album', methods=['GET', 'POST'])
def album():
    if request.method == 'POST':
        req = request.get_json()
        album = Album(req.get('artist_name'), req.get('album_name'), req.get('cover_url'))
        album = create_album(album)
        return jsonify(album)
    if request.method == 'GET':
        albuns = get_albums()
        return jsonify(albuns)
    return jsonify({"message": "nodata"})

@bp.route('/album/<int:album_id>', methods=['GET', 'PATCH', 'DELETE'])
def album_id(album_id):
    if request.method == 'GET':
        album = describe_album(album_id)
        return jsonify(album)
    if request.method == 'PATCH':
        req = request.get_json()
        album = Album(req.get('artist_name'), req.get('album_name'), req.get('cover_url'))
        album = update_album(album_id, album)
        return jsonify(album)
    if request.method == 'DELETE':
        album = delete_album(album_id)
        return jsonify({"message": f"{album_id} was deleted"})
    return jsonify({"message": "nodata"})
