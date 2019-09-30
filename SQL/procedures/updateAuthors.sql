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