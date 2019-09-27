USE SchoolProject
Go
-- Add publication
ALTER PROCEDURE spAddPublication
@book_id INT = NULL,
@journal_id INT = NULL,
@conference_proceedings_id INT = NULL,
@city_id INT = NULL,
@publisher_id INT=NULL,
@file_path VARCHAR(100) = NULL,
@date_of_publication DATE='',
@abstract VARCHAR(500) = NULL
AS
BEGIN
	-- check if there's a file to save
	SET NOCOUNT ON;
	DECLARE @file_path_id INT = NULL
	IF @file_path IS NOT NULL
	BEGIN 
		EXEC spAddFile
			@file_path = @file_path,
			@file_id = @file_path_id OUTPUT; 
	END
	-- try-catch if no publication id's provided
		IF @book_id IS NULL AND @journal_id IS NULL AND @conference_proceedings_id IS NULL
		BEGIN
			;THROW 99001, 'no id supllied for publication', 1;
			RETURN
		END
	insert into PUBLICATION(book_id, journal_id, conference_proceedings_id, city_id, publisher_id, file_path_id, date_of_publication, abstract)
	values(@book_id, @journal_id, @conference_proceedings_id, @city_id, @publisher_id, @file_path_id, @date_of_publication, @abstract)
	SELECT 'ADD went Through'
END

GO
CREATE PROCEDURE spAddPublisher
@publication_name VARCHAR(100)
AS
BEGIN
	insert into PUBLISHER(publisher_name) values(@publication_name)
END
GO
CREATE PROCEDURE spAddConferenceProceedings
@conf_proceedings_title VARCHAR(100)
AS
BEGIN
	insert into CONFERENCE_PROCEEDING(conference_proceedings_title) values(@conf_proceedings_title)
END
GO
CREATE PROCEDURE spAddBook
@book_title VARCHAR(100),
@edition INT
AS
BEGIN
	insert into BOOK(book_title, edition) values(@book_title, @edition)
END
GO
CREATE PROCEDURE spAddJournal
@journal_title VARCHAR(100),
@volume INT
AS
BEGIN
	insert into JOURNAL(journal_title, volume) values(@journal_title, @volume)
END
GO
CREATE PROCEDURE spAddFile
@file_path VARCHAR(100),
@file_id INT OUTPUT
AS
BEGIN
	DECLARE @scopeID int
	insert into FILES(file_path) values(@file_path)
	SET @scopeID = SCOPE_IDENTITY()
	SELECT @file_id = @scopeID
END
GO