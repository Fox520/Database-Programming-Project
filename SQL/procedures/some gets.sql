USE SchoolProject
GO
-- get all authors

CREATE PROCEDURE spGetAllAuthorsInformation
AS
BEGIN
	SET NOCOUNT ON;
	SELECT AUTHOR.author_id, AUTHOR.first_name, AFFILIATION.affiliation_id, AFFILIATION.affiliation_name, TITLE.title_id, TITLE.title from AUTHOR
			JOIN AFFILIATION ON AUTHOR.affiliation_id = AFFILIATION.affiliation_id
			JOIN TITLE ON AUTHOR.title_id = TITLE.title_id
			WHERE AFFILIATION.affiliation_id = AUTHOR.affiliation_id AND TITLE.title_id = AUTHOR.title_id
			
	FOR XML RAW('author'), ROOT('authors'), ELEMENTS
END
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
BEGIN
	SET NOCOUNT ON;
	SELECT

		PUBLICATION.publication_id,
		CITY.city_name,
		FILES.file_path,
		PUBLISHER.publisher_name,
		BOOK.book_title,
		BOOK.edition,
		CONF.conference_proceedings_title,
		JOURNAL.journal_title,
		JOURNAL.volume,
		PUBLICATION.abstract,
		PUBLICATION.date_of_publication

	FROM Publication
	FULL JOIN PUBLISHER ON PUBLICATION.publisher_id = PUBLISHER.publisher_id
	FULL JOIN CITY ON PUBLICATION.city_id = CITY.city_id
	FULL JOIN FILES ON PUBLICATION.file_path_id = FILES.file_path_id
	FULL JOIN JOURNAL ON PUBLICATION.journal_id = JOURNAL.journal_id
	FULL JOIN BOOK ON PUBLICATION.book_id = BOOK.book_id
	FULL JOIN CONFERENCE_PROCEEDING CONF ON PUBLICATION.conference_proceedings_id = CONF.conference_proceedings_id

	FOR XML RAW('publication'), ROOT('publications'), ELEMENTS
END
GO
-- get authors for a certain publication

CREATE PROCEDURE getAuthorsForPublication
@publication_id INT
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		IF @publication_id IS NULL OR @publication_id = ''
		BEGIN
		;THROW 99001, 'Please provide publication', 1;
			RETURN
		END
	SELECT
		AUTHOR.author_id,
		AUTHOR.affiliation_id,
		AUTHOR.title_id,
		AUTHOR.first_name,
		AUTHOR.last_name
	FROM Author_Publication_Junction_Table AP
	JOIN AUTHOR ON AUTHOR.author_id = AP.author_id
	WHERE AP.publication_id = @publication_id

	FOR XML RAW('author_publication'), ROOT('author_publications'), ELEMENTS
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

-- get publications from certain city

CREATE PROCEDURE getAllPublicationsForCity
@city_id int
AS
BEGIN
	SET NOCOUNT ON;
	SELECT

		PUBLICATION.publication_id,
		CITY.city_name,
		FILES.file_path,
		PUBLISHER.publisher_name,
		BOOK.book_id,
		BOOK.book_title,
		BOOK.edition,
		CONF.conference_proceedings_id,
		CONF.conference_proceedings_title,
		JOURNAL.journal_id,
		JOURNAL.journal_title,
		JOURNAL.volume,
		PUBLICATION.abstract,
		PUBLICATION.date_of_publication

	FROM Publication
	JOIN PUBLISHER ON PUBLICATION.publisher_id = PUBLISHER.publisher_id
	JOIN CITY ON PUBLICATION.city_id = CITY.city_id
	JOIN FILES ON PUBLICATION.file_path_id = FILES.file_path_id
	JOIN JOURNAL ON PUBLICATION.journal_id = JOURNAL.journal_id
	JOIN BOOK ON PUBLICATION.book_id = BOOK.book_id
	JOIN CONFERENCE_PROCEEDING CONF ON PUBLICATION.conference_proceedings_id = CONF.conference_proceedings_id
	WHERE CITY.city_id = @city_id

	FOR XML RAW('publication_city'), ROOT('publication_cities'), ELEMENTS
END
GO

-- get publications from certain publishers

CREATE PROCEDURE getPublicationsForPublisher
@publisher_id int
AS
BEGIN
	BEGIN TRY
	SET NOCOUNT ON;
	IF @publisher_id IS NULL OR @publisher_id = ''
		BEGIN
		;THROW 99001, 'Please provide publisher', 1;
			RETURN
		END
	IF NOT EXISTS(SELECT publisher_id FROM PUBLISHER WHERE publisher_id = @publisher_id)
		BEGIN
			;THROW 99001, 'Publisher not found', 1;
			RETURN
		END
	
	SELECT
		PUBLICATION.publication_id,
		CITY.city_name,
		FILES.file_path,
		PUBLISHER.publisher_name,
		BOOK.book_title,
		BOOK.edition,
		CONF.conference_proceedings_title,
		JOURNAL.journal_title,
		JOURNAL.volume,
		PUBLICATION.abstract,
		PUBLICATION.date_of_publication

	FROM Publication
	FULL JOIN PUBLISHER ON PUBLICATION.publisher_id = PUBLISHER.publisher_id
	FULL JOIN CITY ON PUBLICATION.city_id = CITY.city_id
	FULL JOIN FILES ON PUBLICATION.file_path_id = FILES.file_path_id
	FULL JOIN JOURNAL ON PUBLICATION.journal_id = JOURNAL.journal_id
	FULL JOIN BOOK ON PUBLICATION.book_id = BOOK.book_id
	FULL JOIN CONFERENCE_PROCEEDING CONF ON PUBLICATION.conference_proceedings_id = CONF.conference_proceedings_id
	WHERE PUBLISHER.publisher_id = @publisher_id

	FOR XML RAW('publication_publisher'), ROOT('publication_publishers'), ELEMENTS
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