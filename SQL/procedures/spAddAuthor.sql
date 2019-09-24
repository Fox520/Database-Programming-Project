USE SchoolProject
Go
CREATE PROCEDURE spAddAuthor
@af_name varchar(100),
@title varchar(4),
@fname varchar(20),
@lname varchar(20)
AS
BEGIN
	DECLARE @scopeID int
	insert into AFFILIATION(affiliation_name) values(@af_name)
	SET @scopeID = SCOPE_IDENTITY()
	insert into TITLE(title) values(@title)
	insert into NAMES(first_name, last_name) values(@fname, @lname)
	insert into AUTHOR(title_id, name_id, affiliation_id) values( @scopeID, @scopeID, @scopeID)
END
