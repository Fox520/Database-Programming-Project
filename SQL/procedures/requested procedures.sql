USE SchoolProject
-- get all authors

CREATE PROCEDURE getAllAuthors
AS
SELECT * FROM Author
FOR XML RAW('author'), ROOT('authors'), ELEMENTS
Go
-- get all names

CREATE PROCEDURE getAllNames
AS
SELECT * FROM Names
FOR XML RAW('name'), ROOT('names'), ELEMENTS
GO
-- get all affiliations

CREATE PROCEDURE getAllAffiliations
AS
SELECT * FROM Affiliation
FOR XML RAW('affiliation'), ROOT('affiliations'), ELEMENTS
GO
-- get all titles in database

CREATE PROCEDURE getAllTitles
AS
SET NOCOUNT ON;
SELECT * FROM Title
FOR XML RAW('title'), ROOT('titles'), ELEMENTS
GO
-- get all publications

CREATE PROCEDURE getAllPublications
AS
SELECT * FROM Publication
FOR XML RAW('publication'), ROOT('publications'), ELEMENTS
GO

-- get authors for a certain publication

CREATE PROCEDURE getAuthorsForPublication
@Author_id nvarchar(30)
AS
SELECT * FROM Author_Publication_Junction_Table WHERE author_id = @Author_id
FOR XML RAW('author_publication'), ROOT('author_publications'), ELEMENTS
GO

-- get publications from certain city

CREATE PROCEDURE getAllPublicationsForCity
@City_id nvarchar(30)
AS
SELECT * FROM Publication WHERE city_id = @City_id
FOR XML RAW('publication_city'), ROOT('publication_cities'), ELEMENTS
GO

-- get publications from certain publishers

CREATE PROCEDURE getPublicationsForPublisher
@publisher_id nvarchar(30)
AS
SELECT * FROM Publication WHERE publication_id = @publisher_id
FOR XML RAW('publication_publisher'), ROOT('publication_publishers'), ELEMENTS
GO

-- get publication details (the fields)
-- this is the same as getAllPublications procedure in my view, that's why it's commented out
-- CREATE PROCEDURE getDetailsOfAllPublications
-- @City nvarchar(30),
-- @File nvarchar(30),
-- @Publisher_id nvarchar(30)
-- AS
-- SELECT * FROM Publication WHERE City_id = @City_id AND file_path_id = @File_id AND @Publisher = Publisher_id
-- GO

CREATE PROCEDURE getAllPublicationType
@Book nvarchar(30),
@Journal nvarchar(30),
@[Conference Proceedings] nvarchar(30)
AS
SELECT * FROM Publication WHERE Book = @Book OR Journal = @Journal OR @[Conference Proceedings] = [Conference Proceedings]
GO;
