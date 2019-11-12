from mysql import connector
import os

import click
from flask import current_app, g
from flask.cli import with_appcontext


def get_db():
    if 'db' not in g:
        g.db = connector.connect(
            user='root', password=os.getenv("MYSQL_PASSWORD"),
            host='127.0.0.1', database='yourmusic'
        )

    return g.db


def make_query(query, params=None, commit_after=False):
    db = get_db()
    cursor = db.cursor()
    if params:
        cursor.execute(query, params)
    else:
        cursor.execute(query)
    if commit_after:
        db.commit()
    return cursor
        

def close_db(e=None):
    db = g.pop('db', None)

    if db is not None:
        db.close()
