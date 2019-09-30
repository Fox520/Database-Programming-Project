CREATE TABLE AUDIT_CITY(
	id INT IDENTITY PRIMARY KEY,
	city_id INT,
	city_name varchar(50),
	dateChange DATETIME,
	userResponsible varchar(100),
	actionPerformed varchar(50)
)

CREATE TABLE AUDIT_AFFILIATION(
	id INT IDENTITY PRIMARY KEY,
	affiliation_id INT,
	affiliation_name varchar(100),
	dateChange DATETIME,
	userResponsible varchar(100),
	actionPerformed varchar(50)
)