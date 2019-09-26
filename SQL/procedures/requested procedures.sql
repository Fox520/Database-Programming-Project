-- get all authors information


CREATE PROCEDURE getAllAuthors
AS
SELECT * FROM Author
GO;

-- get publications by certain author


CREATE PROCEDURE getAllPublications
@Author nvarchar(30)
AS
SELECT * FROM Publications WHERE Author = @Author
GO;

-- get file path (if any) of a publication


CREATE PROCEDURE getAllFile
@Publication nvarchar(30)
AS
SELECT * FROM File WHERE Publication = @Publication
GO;

-- get publication details (the fields)


CREATE PROCEDURE getAllPublication
@City nvarchar(30),
@File nvarchar(30),
@Publisher nvarchar(30)
AS
SELECT * FROM Customers WHERE City = @City AND File = @File AND @Publisher = Publisher
GO;

-- get all affiliations in database


CREATE PROCEDURE getAllAffiliations
AS
SELECT * FROM Affiliation
GO;


-- get all titles in database

CREATE PROCEDURE SelectAllTitles
AS
SELECT * FROM Title
GO;


-- get publications from certain city

CREATE PROCEDURE getAllPublications
@City nvarchar(30)
AS
SELECT * FROM Publications WHERE City = @City
GO;

