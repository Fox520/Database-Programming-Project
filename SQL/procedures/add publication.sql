USE SchoolProject
GO
-- Add publication
CREATE PROCEDURE spAddPublication
@book_id INT = NULL,
@journal_id INT = NULL,
@conference_proceedings_id INT = NULL,
@city_id INT,
@publisher_id INT,
@file_path VARCHAR(100) = NULL,
@date_of_publication DATE,
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
		;THROW 99001, 'No id supplied for book/conference proceedings/journal', 1;
		RETURN
	END

	IF @publisher_id IS NULL
	BEGIN
		;THROW 99001, 'Supply a publisher', 1;
		RETURN
	END

	IF @city_id IS NULL
	BEGIN
		;THROW 99001, 'Supply a city', 1;
		RETURN
	END

	IF @date_of_publication = ''
	BEGIN
		;THROW 99001, 'Invalid date entered', 1;
		RETURN
	END
	insert into PUBLICATION(book_id, journal_id, conference_proceedings_id, city_id, publisher_id, file_path_id, date_of_publication, abstract)
	values(@book_id, @journal_id, @conference_proceedings_id, @city_id, @publisher_id, @file_path_id, @date_of_publication, @abstract)
	SELECT 'Successfully added publication'
END