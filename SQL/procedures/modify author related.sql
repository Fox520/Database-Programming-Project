USE SchoolProject
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