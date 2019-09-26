-- get all authors information


CREATE PROCEDURE getAllAuthors
AS
SELECT * FROM Author
GO;

-- get all affiliations in database


CREATE PROCEDURE getAllAffiliations
AS
SELECT * FROM Affiliation
GO;
-- get all Names in database


CREATE PROCEDURE getAllNames
AS
SELECT * FROM Names
GO;

-- get all titles in database

CREATE PROCEDURE SelectAllTitles
AS
SELECT * FROM Title
GO;

-- get all publications information


CREATE PROCEDURE getAllPublications
AS
SELECT * FROM Publication
GO;


-- get publications by certain author


CREATE PROCEDURE getAllPublicationAuthor
@Author nvarchar(30)
AS
SELECT * FROM Publication WHERE Author = @Author
GO;

-- get file path (if any) of a publication


CREATE PROCEDURE getAllFile
@Publication nvarchar(30)
AS
SELECT * FROM Publication WHERE File = @File
GO;


-- get publications from certain city

CREATE PROCEDURE getAllPublicationCity
@City nvarchar(30)
AS
SELECT * FROM Publication WHERE City = @City
GO;


-- get publications from certain publishers

CREATE PROCEDURE getAllPublicationPublisher
@Publisher nvarchar(30)
AS
SELECT * FROM Publication WHERE Publisher = @Publisher
GO;


-- get publication details (the fields)


CREATE PROCEDURE getAllPublicationDetail
@City nvarchar(30),
@File nvarchar(30),
@Publisher nvarchar(30)
AS
SELECT * FROM Publication WHERE City = @City AND File = @File AND @Publisher = Publisher
GO;


