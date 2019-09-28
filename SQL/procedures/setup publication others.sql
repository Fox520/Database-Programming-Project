-- testing
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