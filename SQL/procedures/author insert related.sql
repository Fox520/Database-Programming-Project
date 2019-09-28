USE SchoolProject
Go
ALTER PROCEDURE spAddAuthor
@affiliation_id varchar(100),
@title_id varchar(4),
@fname varchar(20),
@lname varchar(20)
AS
BEGIN
	IF @fname IS NULL OR @lname IS NULL OR @fname = '' OR @lname = ''
	BEGIN
		;THROW 99001, 'Provide first/last name', 1;
		RETURN
	END
	IF @affiliation_id = ''
	BEGIN
		;THROW 99001, 'Provide an affiliation_id, empty', 1;
		RETURN
	END
	IF @affiliation_id IS NULL OR @affiliation_id = ''
	BEGIN
		;THROW 99001, 'Provide an affiliation_id', 1;
		RETURN
	END
	IF @title_id IS NULL OR @title_id = ''
	BEGIN
		;THROW 99001, 'Provide a title_id', 1;
		RETURN
	END
	BEGIN TRY
		insert into AUTHOR(title_id, first_name, last_name, affiliation_id) values( @title_id, @fname, @lname, @affiliation_id)
	END TRY
	BEGIN CATCH
		SELECT
			ERROR_NUMBER() AS ErrorNumber,
			ERROR_STATE() AS ErrorState,
			ERROR_SEVERITY() AS ErrorSeverity,
			ERROR_PROCEDURE() AS ErrorProcedure,
			ERROR_LINE() AS ErrorLine,
			ERROR_MESSAGE() AS ErrorMessage;
	END CATCH;
END

GO
CREATE PROCEDURE spAddTitle
@the_title VARCHAR(100)
AS
BEGIN
	IF @the_title IS NULL OR @the_title = ''
	BEGIN
		;THROW 99001, 'Title cannot be empty', 1;
		RETURN
	END
	BEGIN TRY
		INSERT INTO TITLE(title) VALUES(@the_title)
	END TRY
	BEGIN CATCH
		SELECT
			ERROR_NUMBER() AS ErrorNumber,
			ERROR_STATE() AS ErrorState,
			ERROR_SEVERITY() AS ErrorSeverity,
			ERROR_PROCEDURE() AS ErrorProcedure,
			ERROR_LINE() AS ErrorLine,
			ERROR_MESSAGE() AS ErrorMessage;
	END CATCH;
END

GO
CREATE PROCEDURE spAddAffiliation
@af_name VARCHAR(100)
AS
BEGIN
	IF @af_name IS NULL OR @af_name = ''
	BEGIN
		;THROW 99001, 'Affiliation cannot be empty', 1;
		RETURN
	END
	BEGIN TRY
		INSERT INTO AFFILIATION(affiliation_name) VALUES(@af_name)
	END TRY
	BEGIN CATCH
		SELECT
			ERROR_NUMBER() AS ErrorNumber,
			ERROR_STATE() AS ErrorState,
			ERROR_SEVERITY() AS ErrorSeverity,
			ERROR_PROCEDURE() AS ErrorProcedure,
			ERROR_LINE() AS ErrorLine,
			ERROR_MESSAGE() AS ErrorMessage;
	END CATCH;
END