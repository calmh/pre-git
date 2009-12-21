DROP SEQUENCE objects_serial;
CREATE SEQUENCE objects_serial INCREMENT 1 MINVALUE 1;

DROP TABLE Files;
CREATE TABLE Files (
	Name VARCHAR(255),
	Bitrate INT,
	Length INT,
	Number INT,
	Id INT NOT NULL UNIQUE DEFAULT NEXTVAL('objects_serial')
);

DROP TABLE Dirs;
CREATE TABLE Dirs (
	Name VARCHAR(255),
        Id INT NOT NULL UNIQUE DEFAULT NEXTVAL('objects_serial')
);

DROP TABLE Playlist;
CREATE TABLE Playlist (
	File_id INT,
	Playing INT,
	Auto INT,
	Id INT NOT NULL UNIQUE DEFAULT NEXTVAL('objects_serial')
);

DROP TABLE Updated;
CREATE TABLE Updated (
	Playlist DATETIME,
	Fileslist DATETIME
);
INSERT INTO Updated VALUES (now(), now());

