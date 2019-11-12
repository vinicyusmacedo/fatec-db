import os

from flask import Flask, jsonify

from . import album_bp
from .dao import monitor


def create_app(test_config=None):
    # create and configure the app
    app = Flask(__name__, instance_relative_config=True)
    app.config.from_mapping(
        SECRET_KEY='dev',
    )

    if test_config is None:
        # load the instance config, if it exists, when not testing
        app.config.from_pyfile('config.py', silent=True)
    else:
        # load the test config if passed in
        app.config.from_mapping(test_config)

    # ensure the instance folder exists
    try:
        os.makedirs(app.instance_path)
    except OSError:
        pass

    app.register_blueprint(album_bp.bp)

    @app.route('/healthcheck', methods=['GET'])
    def healthcheck():
        return jsonify({"message": "ok"})

    @app.route('/monitor', methods=['GET'])
    def monitor_hc():
        return jsonify({"message": monitor()})

    return app
