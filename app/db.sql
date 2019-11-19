DROP DATABASE IF EXISTS yourmusic;
CREATE DATABASE IF NOT EXISTS yourmusic;

USE yourmusic;

-- I know it is bad to keep CoverURL on both tables, but that's for the sake of experimenting
CREATE TABLE CoverPictures (
	CoverId INT AUTO_INCREMENT,
	CoverURL VARCHAR(200),
	CoverBlob BLOB,
	PRIMARY KEY (CoverId)
);

CREATE TABLE Albums (
	AlbumId INT AUTO_INCREMENT,
	Artist VARCHAR(100),
	Album VARCHAR(100),
	CoverURL VARCHAR(200),
	CoverId INT,
	PRIMARY KEY (AlbumId)
);

ALTER TABLE Albums
ADD Constraint FkAlbumCover FOREIGN KEY (CoverId) REFERENCES CoverPictures(CoverId);

-- Trigger to create a cover picture from an album if it doesn't exist 
DELIMITER //
CREATE TRIGGER CreateCoverPicture AFTER INSERT on Albums
FOR EACH ROW
BEGIN
    INSERT INTO CoverPictures (CoverURL) VALUES (NEW.CoverURL);
END//
DELIMITER ; 

DELIMITER //
CREATE PROCEDURE UpdateAlbumCoverId(AlbumIdSup INT)
BEGIN
    SET @CoverURL := (SELECT CoverURL FROM Albums WHERE AlbumId = AlbumIdSup LIMIT 1);
    SET @CoverId := (SELECT CoverId FROM CoverPictures WHERE CoverURL = @CoverURL LIMIT 1);
    UPDATE Albums SET CoverId = @CoverId WHERE AlbumId = AlbumIdSup;
END //
DELIMITER ;

-- Procedure to create a blob for the cover picture
DELIMITER //
CREATE PROCEDURE CreateBlobForCover(PicBlob BLOB, CoverId INT)
BEGIN
    UPDATE CoverPictures SET CoverBlob = PicBlob WHERE CoverId = CoverId;
END//
DELIMITER ; 

-- Procedure to get a blob for the cover picture
DELIMITER //
CREATE PROCEDURE GetBlobForCover(CoverId INT)
BEGIN
    SELECT TO_BASE64(CoverBlob) FROM CoverPictures WHERE CoverId = CoverId;
END//
DELIMITER ; 
