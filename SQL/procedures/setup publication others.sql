USE SchoolProject
GO
CREATE PROCEDURE spAddPublisher
@publisher_name VARCHAR(100)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		IF @publisher_name IS NULL OR @publisher_name = ''
		BEGIN
			;THROW 99001, 'Provide publisher name', 1;
			RETURN
		END
		IF EXISTS(SELECT publisher_name FROM PUBLISHER WHERE publisher_name = @publisher_name)
		BEGIN
			;THROW 99001, 'Publisher already exists', 1;
			RETURN
		END

		insert into PUBLISHER(publisher_name) values(@publisher_name)
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
CREATE PROCEDURE spAddCity
@city_name VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		IF @city_name IS NULL OR @city_name = ''
		BEGIN
			;THROW 99001, 'Provide city name', 1;
			RETURN
		END
		IF EXISTS(SELECT city_name FROM CITY WHERE city_name = @city_name)
		BEGIN
			;THROW 99001, 'City already exists', 1;
			RETURN
		END

		insert into CITY(city_name) values(@city_name)
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
CREATE PROCEDURE spUpdateCity
@city_name VARCHAR(50),
@old_city_name VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		IF @city_name IS NULL OR @city_name = ''
		BEGIN
			;THROW 99001, 'Provide city name', 1;
			RETURN
		END
		IF NOT EXISTS(SELECT city_name FROM CITY WHERE city_name = @old_city_name)
		BEGIN
			;THROW 99001, 'City does not exist', 1;
			RETURN
		END
		IF @city_name LIKE '%[0-9]%'
		BEGIN
			;THROW 99001, 'Only letters allowed for city name', 1;
			RETURN
		END
		UPDATE CITY
		SET city_name = @city_name
		WHERE city_name = @old_city_name
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
CREATE PROCEDURE spUpdatePublisher
@publisher_name VARCHAR(50),
@old_publisher_name VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		IF @publisher_name IS NULL OR @publisher_name = ''
		BEGIN
			;THROW 99001, 'Provide a publisher name', 1;
			RETURN
		END
		IF NOT EXISTS(SELECT publisher_name FROM PUBLISHER WHERE publisher_name = @old_publisher_name)
		BEGIN
			;THROW 99001, 'Publisher does not exist', 1;
			RETURN
		END
		IF @publisher_name LIKE '%[0-9]%'
		BEGIN
			;THROW 99001, 'Only letters allowed for publisher name', 1;
			RETURN
		END
		UPDATE PUBLISHER
		SET publisher_name = @publisher_name
		WHERE publisher_name = @old_publisher_name
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
CREATE PROCEDURE spDeletePublisher
@publisher_name VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		IF @publisher_name IS NULL OR @publisher_name = ''
		BEGIN
			;THROW 99001, 'Provide a publisher name', 1;
			RETURN
		END
		IF NOT EXISTS(SELECT publisher_name FROM PUBLISHER WHERE publisher_name = @publisher_name)
		BEGIN
			;THROW 99001, 'Publisher does not exist', 1;
			RETURN
		END
		IF @publisher_name LIKE '%[0-9]%'
		BEGIN
			;THROW 99001, 'Only letters allowed for publisher name', 1;
			RETURN
		END
		DELETE FROM PUBLISHER
		WHERE publisher_name = @publisher_name
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
CREATE PROCEDURE spDeleteCity
@city_name VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		IF @city_name IS NULL OR @city_name = ''
		BEGIN
			;THROW 99001, 'Provide a city name', 1;
			RETURN
		END
		IF NOT EXISTS(SELECT city_name FROM CITY WHERE city_name = @city_name)
		BEGIN
			;THROW 99001, 'City does not exist', 1;
			RETURN
		END
		IF @city_name LIKE '%[0-9]%'
		BEGIN
			;THROW 99001, 'Only letters allowed for city name', 1;
			RETURN
		END
		DELETE FROM CITY
		WHERE city_name = @city_name
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
CREATE PROCEDURE spDeletePublication
@publication_id INT
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		IF @publication_id IS NULL OR @publication_id = ''
		BEGIN
			;THROW 99001, 'Provide a publication', 1;
			RETURN
		END
		IF NOT EXISTS(SELECT publication_id FROM PUBLICATION WHERE publication_id = @publication_id)
		BEGIN
			;THROW 99001, 'Publication does not exist', 1;
			RETURN
		END
		IF @publication_id LIKE '%[0-9]%'
		BEGIN
			;THROW 99001, 'Only letters allowed for publication', 1;
			RETURN
		END
		DELETE FROM PUBLISHER
		WHERE publisher_id = @publication_id
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
CREATE PROCEDURE spAddConferenceProceedings
@conf_proceedings_title VARCHAR(100),
@conf_id INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		IF @conf_proceedings_title IS NULL or @conf_proceedings_title = ''
		BEGIN
			;THROW 99001, 'Provide conference proceedings title', 1;
			RETURN
		END
		IF EXISTS(SELECT conference_proceedings_title FROM CONFERENCE_PROCEEDING WHERE conference_proceedings_title = @conf_proceedings_title)
		BEGIN
			;THROW 99001, 'Conference proceeding already exists', 1;
			RETURN
		END
	
		insert into CONFERENCE_PROCEEDING(conference_proceedings_title) values(@conf_proceedings_title)
		SET @conf_id = SCOPE_IDENTITY()
		SELECT @conf_id
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
	END CATCH;
END
GO
CREATE PROCEDURE spAddBook
@book_title VARCHAR(100),
@edition INT,
@bk_id INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		IF @book_title IS NULL or @book_title = ''
		BEGIN
			;THROW 99001, 'Provide book title', 1;
			RETURN
		END

		IF @edition IS NULL
		BEGIN
			;THROW 99001, 'Provide book edition', 1;
			RETURN
		END
		-- compare book title and edition
		-- title can be the same but different edition. therefore allow if edition is different
		IF EXISTS(SELECT book_title FROM BOOK WHERE book_title = @book_title) AND @edition = (SELECT edition FROM BOOK WHERE book_title = @book_title)
		BEGIN
			;THROW 99001, 'Book of this edition already exists', 1;
			RETURN
		END
	
		insert into BOOK(book_title, edition) values(@book_title, @edition)
		SET @bk_id = SCOPE_IDENTITY()
		SELECT @bk_id
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
	END CATCH;
END
GO
CREATE PROCEDURE spAddJournal
@journal_title VARCHAR(100),
@volume INT,
@journ_id INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY

		IF @journal_title IS NULL or @journal_title = ''
		BEGIN
			;THROW 99001, 'Provide journal title', 1;
			RETURN
		END

		IF @volume IS NULL
		BEGIN
			;THROW 99001, 'Provide journal volume', 1;
			RETURN
		END

		IF EXISTS(SELECT journal_title FROM JOURNAL WHERE journal_title = @journal_title) AND @volume = (SELECT volume FROM JOURNAL WHERE journal_title = @journal_title)
		BEGIN
			;THROW 99001, 'Journal of this volume already exists', 1;
			RETURN
		END
	
		insert into JOURNAL(journal_title, volume) values(@journal_title, @volume)
		SET @journ_id = SCOPE_IDENTITY()
		SELECT @journ_id
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
	END CATCH;
END

GO
CREATE PROCEDURE spAddFile
@file_path VARCHAR(100),
@file_id INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		IF @file_path IS NULL OR @file_path = ''
		BEGIN
			;THROW 99001, 'File path cannot be empty', 1;
			RETURN
		END
	
		insert into FILES(file_path) values(@file_path)
		SET @file_id = SCOPE_IDENTITY()
		SELECT @file_id
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
	END CATCH;
END
GO
-- Add publication (not to be confused with spAddPublisher)
CREATE PROCEDURE spAddPublication
@book_id INT = NULL,
@journal_id INT = NULL,
@conference_proceedings_id INT = NULL,
@city_id INT,
@publisher_id INT,
@file_path VARCHAR(200) = NULL,
@date_of_publication DATE,
@abstract VARCHAR(500) = NULL
AS
BEGIN
	BEGIN TRY
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
		
		DECLARE @out_id INT;
		EXEC spInternalGetPublicationID
			@book_id = @book_id,
			@journal_id = @journal_id,
			@conf_id = @conference_proceedings_id,
			@out_id = @out_id OUTPUT;
		SELECT @out_id
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
	END CATCH;
END
GO
CREATE PROCEDURE spInternalGetPublicationID
@book_id INT = NULL,
@journal_id INT = NULL,
@conf_id INT = NULL,
@out_id INT OUTPUT
AS
BEGIN
	BEGIN TRY
		IF @book_id IS NULL AND @journal_id IS NULL AND @conf_id IS NULL
		BEGIN
			;THROW 99001, 'No id supplied', 1;
			RETURN
		END
		IF @book_id IS NOT NULL
			SELECT @out_id = publication_id from PUBLICATION WHERE book_id = @book_id
		ELSE IF @journal_id IS NOT NULL
			SELECT @out_id = publication_id from PUBLICATION WHERE book_id = @journal_id
		ELSE IF @conf_id IS NOT NULL
			SELECT @out_id = publication_id from PUBLICATION WHERE conference_proceedings_id = @conf_id
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
CREATE PROCEDURE spCombineAuthorPublicationJunction
@author_id INT,
@publication_id INT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		IF @publication_id IS NULL OR @publication_id  = '' OR @author_id IS NULL OR @author_id = ''
		BEGIN
			;THROW 99001, 'Provide all information', 1;
			RETURN
		END
		IF NOT EXISTS(SELECT publication_id FROM PUBLICATION WHERE publication_id = @publication_id)
		BEGIN
			;THROW 99001, 'Publication not found', 1;
			RETURN
		END
		IF NOT EXISTS(SELECT author_id FROM AUTHOR WHERE author_id = @author_id)
		BEGIN
			;THROW 99001, 'Author not found', 1;
			RETURN
		END
		INSERT INTO Author_Publication_Junction_Table(author_id, publication_id) VALUES(@author_id, @publication_id)
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