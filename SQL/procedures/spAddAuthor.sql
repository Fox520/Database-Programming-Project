USE SchoolProject
Go
CREATE PROCEDURE spAddAuthor
@affiliation_id varchar(100),
@title_id varchar(4),
@fname varchar(20),
@lname varchar(20)
AS
BEGIN
	IF @fname IS NULL OR @lname IS NULL
	BEGIN
		;THROW 99001, 'Provide first/last name', 1;
		RETURN
	END
	IF @affiliation_id IS NULL
	BEGIN
		;THROW 99001, 'Provide an affiliation_id', 1;
		RETURN
	END
	IF @title_id IS NULL
	BEGIN
		;THROW 99001, 'Provide a title_id', 1;
		RETURN
	END
	insert into AUTHOR(title_id, first_name, last_name, affiliation_id) values( @title_id, @fname, @lname, @affiliation_id)
END
