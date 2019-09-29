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
