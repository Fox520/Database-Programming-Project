CREATE DATABASE PUBLISH 

CREATE TABLE CONFERENCE_PROCEEDING (
	conference_proceedings_id INT PRIMARY KEY NOT NULL IDENTITY,
	conference_proceedings_title VARCHAR(100) NOT NULL
);

CREATE TABLE BOOK (
	book_id INT PRIMARY KEY NOT NULL IDENTITY,
	edition INT,
	book_title VARCHAR(100) NOT NULL,
);

CREATE TABLE JOURNAL (
	journal_id INT PRIMARY KEY NOT NULL IDENTITY,
	volume INT,
	journal_title VARCHAR(100) NOT NULL
);

CREATE TABLE CITY(
	city_id INT PRIMARY KEY NOT NULL IDENTITY,
	city_name VARCHAR(50) NOT NULL
);

CREATE TABLE FILES(
	file_path_id INT PRIMARY KEY NOT NULL IDENTITY,
	file_path VARCHAR(200) NOT NULL
);

CREATE TABLE PUBLISHER(
	publisher_id INT PRIMARY KEY NOT NULL IDENTITY,
	publisher_name VARCHAR(100) NOT NULL
);

CREATE TABLE PUBLICATION (
	publication_id INT PRIMARY KEY NOT NULL IDENTITY,
	date_of_publication DATE NOT NULL,
	abstract VARCHAR(500),
	book_id INT,
	journal_id INT,
	conference_proceedings_id INT,
	city_id INT,
	publisher_id INT,
	file_path_id INT,
	FOREIGN KEY (book_id) REFERENCES BOOK(book_id),
	FOREIGN KEY (journal_id) REFERENCES JOURNAL(journal_id),
	FOREIGN KEY (conference_proceedings_id) REFERENCES CONFERENCE_PROCEEDING(conference_proceedings_id),
	FOREIGN KEY (city_id) REFERENCES CITY(city_id),
	FOREIGN KEY (publisher_id) REFERENCES PUBLISHER(publisher_id),
	FOREIGN KEY (file_path_id) REFERENCES FILES(file_path_id),

);