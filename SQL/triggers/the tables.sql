CREATE TABLE AUDIT_Publication(
	id INT IDENTITY PRIMARY KEY,
	publication_id INT,
	dateChange DATETIME,
	userResponsible varchar(100),
	actionPerformed varchar(50)
)

CREATE TABLE AUDIT_Author(
	id INT IDENTITY PRIMARY KEY,
	author_id INT,
	dateChange DATETIME,
	userResponsible varchar(100),
	actionPerformed varchar(50)
)