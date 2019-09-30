USE SchoolProject
Go
CREATE PROCEDURE spAddAuthor
@affiliation_id INT,
@title_id INT,
@fname varchar(20),
@lname varchar(20)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		IF @fname IS NULL OR @lname IS NULL OR @fname = '' OR @lname = ''
		BEGIN
			;THROW 99001, 'Provide first/last name', 1;
			RETURN
		END
		
		IF @affiliation_id IS NULL OR @affiliation_id = ''
		BEGIN
			;THROW 99001, 'Provide an affiliation id', 1;
			RETURN
		END
		IF @title_id IS NULL
		BEGIN
			;THROW 99001, 'Provide a title id', 1;
			RETURN
		END
		-- make sure only letters
		IF @fname LIKE '%[0-9]%' OR @lname LIKE '%[0-9]%'
		BEGIN
			;THROW 99001, 'Only letters allowed for names', 1;
			RETURN
		END
		insert into AUTHOR(title_id, first_name, last_name, affiliation_id) values( @title_id, @fname, @lname, @affiliation_id)
	END TRY
	BEGIN CATCH
		SELECT
			ERROR_NUMBER() AS ErrorNumber,
			ERROR_STATE() AS ErrorState,
			ERROR_SEVERITY() AS ErrorSeverity,
			ERROR_PROCEDURE() AS ErrorProcedure,
			ERROR_LINE() AS ErrorLine,
			ERROR_MESSAGE() AS ErrorMessage
		FOR XML RAW('error'), ROOT('errors'), ELEMENTS
	END CATCH;
END

GO
CREATE PROCEDURE spAddTitle
@the_title VARCHAR(4)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		IF @the_title IS NULL OR @the_title = ''
		BEGIN
			;THROW 99001, 'Title cannot be empty', 1;
			RETURN
		END

		IF EXISTS(SELECT title FROM TITLE WHERE title = @the_title)
		BEGIN
			;THROW 99001, 'Title already exists', 1;
			RETURN
		END
		-- make sure only letters
		IF @the_title LIKE '%[0-9]%'
		BEGIN
			;THROW 99001, 'Only letters allowed', 1;
			RETURN
		END
		INSERT INTO TITLE(title) VALUES(@the_title)
	END TRY
	BEGIN CATCH
		SELECT
			ERROR_NUMBER() AS ErrorNumber,
			ERROR_STATE() AS ErrorState,
			ERROR_SEVERITY() AS ErrorSeverity,
			ERROR_PROCEDURE() AS ErrorProcedure,
			ERROR_LINE() AS ErrorLine,
			ERROR_MESSAGE() AS ErrorMessage
		FOR XML RAW('error'), ROOT('errors'), ELEMENTS
	END CATCH;
END

GO
CREATE PROCEDURE spAddAffiliation
@af_name VARCHAR(100)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		IF @af_name IS NULL OR @af_name = ''
		BEGIN
			;THROW 99001, 'Affiliation cannot be empty', 1;
			RETURN
		END
		IF EXISTS(SELECT affiliation_name FROM AFFILIATION WHERE affiliation_name = @af_name)
		BEGIN
			;THROW 99001, 'Affiliation already exists', 1;
			RETURN
		END
		-- make sure only letters
		IF @af_name LIKE '%[0-9]%'
		BEGIN
			;THROW 99001, 'Only letters allowed', 1;
			RETURN
		END
		INSERT INTO AFFILIATION(affiliation_name) VALUES(@af_name)
	END TRY
	BEGIN CATCH
		SELECT
			ERROR_NUMBER() AS ErrorNumber,
			ERROR_STATE() AS ErrorState,
			ERROR_SEVERITY() AS ErrorSeverity,
			ERROR_PROCEDURE() AS ErrorProcedure,
			ERROR_LINE() AS ErrorLine,
			ERROR_MESSAGE() AS ErrorMessage
		FOR XML RAW('error'), ROOT('errors'), ELEMENTS
	END CATCH;
END
GO
CREATE PROCEDURE updateAuthorNames
@authorID int,
@authorFirstName varchar (20),
@authorLastName varchar(20)
AS
BEGIN
  BEGIN TRY
      SET NOCOUNT ON
    IF @authorFirstName = '' OR @authorFirstName IS NULL OR @authorLastName = '' OR @authorLastName IS NULL OR @authorID IS NULL
    BEGIN
      BEGIN
      ;THROW 99001, 'Please supply all information', 1;
      RETURN
    END
    END
    IF NOT EXISTS(SELECT author_id FROM AUTHOR WHERE author_id= @authorID)
    BEGIN
      ;THROW 99001, 'Author not found', 1;
      RETURN
    END
      UPDATE AUTHOR
      SET  
    first_name = @authorFirstName,
    last_name = @authorLastName
      WHERE  
    author_id = @authorID
  SELECT 'Update complete'
  FOR XML RAW('message'), ROOT('messages'), ELEMENTS
  END TRY
  
  BEGIN CATCH
    SELECT
      ERROR_NUMBER() AS ErrorNumber,
      ERROR_STATE() AS ErrorState,
      ERROR_SEVERITY() AS ErrorSeverity,
      ERROR_PROCEDURE() AS ErrorProcedure,
      ERROR_LINE() AS ErrorLine,
      ERROR_MESSAGE() AS ErrorMessage
    FOR XML RAW('error'), ROOT('errors'), ELEMENTS
  END CATCH
END
GO
CREATE PROCEDURE updateAffiliation
@af_id int,
@af_name VARCHAR(100)
AS
BEGIN
  BEGIN TRY
      SET NOCOUNT ON
    IF @af_name = '' OR @af_name IS NULL OR @af_id IS NULL
    BEGIN
      BEGIN
      ;THROW 99001, 'Please supply all information', 1;
      RETURN
    END
    END
    IF NOT EXISTS(SELECT affiliation_id FROM AFFILIATION WHERE affiliation_id = @af_id)
    BEGIN
      ;THROW 99001, 'Affiliation not found', 1;
      RETURN
    END
    UPDATE AFFILIATION
    SET  
    affiliation_name = @af_name
    WHERE  
    affiliation_id = @af_id
  SELECT 'Update complete'
  FOR XML RAW('message'), ROOT('messages'), ELEMENTS
  END TRY
  
  BEGIN CATCH
    SELECT
      ERROR_NUMBER() AS ErrorNumber,
      ERROR_STATE() AS ErrorState,
      ERROR_SEVERITY() AS ErrorSeverity,
      ERROR_PROCEDURE() AS ErrorProcedure,
      ERROR_LINE() AS ErrorLine,
      ERROR_MESSAGE() AS ErrorMessage
    FOR XML RAW('error'), ROOT('errors'), ELEMENTS
  END CATCH
END

GO
CREATE PROCEDURE deleteAffiliation
@af_id int
AS
BEGIN
  BEGIN TRY
      SET NOCOUNT ON
    IF @af_id IS NULL
    BEGIN
    BEGIN
      ;THROW 99001, 'Please supply all information', 1;
      RETURN
    END
    END
    IF NOT EXISTS(SELECT affiliation_id FROM AFFILIATION WHERE affiliation_id = @af_id)
    BEGIN
      ;THROW 99001, 'Affiliation not found', 1;
      RETURN
    END
    DELETE FROM AFFILIATION
    WHERE affiliation_id = @af_id
  SELECT 'Delete complete'
  FOR XML RAW('message'), ROOT('messages'), ELEMENTS
  END TRY
  
  BEGIN CATCH
    SELECT
      ERROR_NUMBER() AS ErrorNumber,
      ERROR_STATE() AS ErrorState,
      ERROR_SEVERITY() AS ErrorSeverity,
      ERROR_PROCEDURE() AS ErrorProcedure,
      ERROR_LINE() AS ErrorLine,
      ERROR_MESSAGE() AS ErrorMessage
    FOR XML RAW('error'), ROOT('errors'), ELEMENTS
  END CATCH
END

GO
CREATE PROCEDURE deleteAuthor
@authorID int
AS
BEGIN
  BEGIN TRY
      SET NOCOUNT ON
    IF @authorID IS NULL
    BEGIN
      BEGIN
      ;THROW 99001, 'Author ID cannot be null', 1;
      RETURN
    END
    END
    IF NOT EXISTS(SELECT author_id FROM AUTHOR WHERE author_id= @authorID)
    BEGIN
      ;THROW 99001, 'Author not found', 1;
      RETURN
    END
      DELETE FROM AUTHOR
      WHERE author_id = @authorID
  SELECT 'Delete complete'
  FOR XML RAW('message'), ROOT('messages'), ELEMENTS
  END TRY
  
  BEGIN CATCH
    SELECT
      ERROR_NUMBER() AS ErrorNumber,
      ERROR_STATE() AS ErrorState,
      ERROR_SEVERITY() AS ErrorSeverity,
      ERROR_PROCEDURE() AS ErrorProcedure,
      ERROR_LINE() AS ErrorLine,
      ERROR_MESSAGE() AS ErrorMessage
    FOR XML RAW('error'), ROOT('errors'), ELEMENTS
  END CATCH
END