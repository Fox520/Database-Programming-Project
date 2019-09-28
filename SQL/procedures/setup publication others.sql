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
		UPDATE CITY
		SET city_name = @city_name
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
CREATE PROCEDURE spUpdatePublisher
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
		UPDATE PUBLISHER
		SET publisher_name = @publisher_name
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
		DELETE FROM PUBLISHER
		WHERE publisher_name = @city_name
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