USE SchoolProject
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
			ERROR_MESSAGE() AS ErrorMessage;
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
			ERROR_MESSAGE() AS ErrorMessage;
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
			ERROR_MESSAGE() AS ErrorMessage;
	END CATCH;
END

GO
CREATE PROCEDURE spAddPublisher
@publisher_name VARCHAR(100)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		IF @publisher_name IS NULL OR @publisher_name = ''
		BEGIN
			;THROW 99001, 'Publisher cannot be empty', 1;
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
			ERROR_MESSAGE() AS ErrorMessage;
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
			ERROR_MESSAGE() AS ErrorMessage;
	END CATCH;
END