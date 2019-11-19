class Album:
    def __init__(
        self, artist_name, album_name,
        cover_url, image_blob=None, album_id=None, cover_id=None
    ):
        self.album_id = album_id
        self.artist_name = artist_name
        self.album_name = album_name
        self.cover_url = cover_url
        self.image_blob = image_blob
        self.cover_id = cover_id
    
    def get_dict(self):
        return {
            "album_id": self.album_id,
            "artist_name": self.artist_name,
            "album_name": self.album_name,
            "cover_url": self.cover_url,
            "image_blob": self.image_blob,
            "cover_id": self.cover_id
        }

