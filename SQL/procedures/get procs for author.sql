USE SchoolProject
GO
CREATE PROCEDURE spGetAuthorInformation
AS
BEGIN
	SET NOCOUNT ON;
	SELECT AUTHOR.author_id, AUTHOR.first_name, AFFILIATION.affiliation_id, AFFILIATION.affiliation_name, TITLE.title_id, TITLE.title from AUTHOR
			JOIN AFFILIATION ON AUTHOR.affiliation_id = AFFILIATION.affiliation_id
			JOIN TITLE ON AUTHOR.title_id = TITLE.title_id
			WHERE AFFILIATION.affiliation_id = AUTHOR.affiliation_id AND TITLE.title_id = AUTHOR.title_id
			
	FOR XML RAW('author'), ROOT('authors'), ELEMENTS
END
--------------------->>>>>>>>>>

USE SchoolProject
GO
CREATE PROCEDURE spGetAuthorInformation
AS
BEGIN
SET NOCOUNT ON;
BEGIN TRY
		IF @author_name IS NULL OR @author_name = ''
			;THROW 99001, 'Please provide auther name',1;
			RETURN
		END
	
	SELECT AUTHOR.author_id, AUTHOR.first_name, AFFILIATION.affiliation_id, AFFILIATION.affiliation_name, TITLE.title_id, TITLE.title from AUTHOR
			JOIN AFFILIATION ON AUTHOR.affiliation_id = AFFILIATION.affiliation_id
			JOIN TITLE ON AUTHOR.title_id = TITLE.title_id
			WHERE AFFILIATION.affiliation_id = AUTHOR.affiliation_id AND TITLE.title_id = AUTHOR.title_id
			

	
OR 	FOR XML RAW('author'), ROOT('authors'), ELEMENTS
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


