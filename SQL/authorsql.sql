CREATE DATABASE PUBLISH 

CREATE TABLE TITLE (
	conference_proceedings_id INT PRIMARY KEY NOT NULL IDENTITY,
	conference_proceedings_title VARCHAR(100) NOT NULL
);

CREATE TABLE AFFLIATION (
	book_id INT PRIMARY KEY NOT NULL IDENTITY,
	edition INT,
	book_title VARCHAR(100) NOT NULL,
);

CREATE TABLE NAMES (
	journal_id INT PRIMARY KEY NOT NULL IDENTITY,
	volume INT,
	journal_title VARCHAR(100) NOT NULL
);



CREATE TABLE AUTHOR (
	author_id INT PRIMARY KEY NOT NULL IDENTITY,
	FOREIGN KEY (name_id) REFERENCES NAME(name_id),
	FOREIGN KEY (affliation_id) REFERENCES AFFLIATION(affliation_id),
	FOREIGN KEY (title_id) REFERENCES TITLE(title_id),
);