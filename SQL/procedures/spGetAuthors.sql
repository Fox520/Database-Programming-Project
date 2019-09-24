USE SchoolProject
-- NOTE: including the id in return information is important
-- get all authors information
-- get publications by certain author
-- get file path (if any) of a publication
-- get publication details (the fields)
-- get all affiliations in database
-- get all titles in database
-- get publications from certain city
-- get the authors names
GO
ALTER PROCEDURE spGetAuthorInformation
AS
BEGIN
	SET NOCOUNT ON;
	SELECT * from AUTHOR
	FOR XML RAW('author'), ROOT('authors'), ELEMENTS
END

