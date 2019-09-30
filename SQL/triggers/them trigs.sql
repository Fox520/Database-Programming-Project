USE SchoolProject
GO
ALTER TRIGGER tr_tblPublication
ON PUBLICATION
AFTER INSERT, DELETE
AS
BEGIN
	IF(EXISTS(select * from inserted))
	BEGIN
		insert into AUDIT_Publication(publication_id, dateChange, userResponsible, actionPerformed)
		select publication_id, SYSDATETIME(), USER_NAME(), 'new addition' from inserted
		RETURN;
	END
	insert into AUDIT_Publication(publication_id, dateChange, userResponsible, actionPerformed)
	select publication_id, SYSDATETIME(), USER_NAME(), 'deleted' from inserted
END
GO
ALTER TRIGGER tr_tblAuthor
ON AUTHOR
AFTER INSERT, DELETE
AS
BEGIN
	IF(EXISTS(select * from inserted))
	BEGIN
		insert into AUDIT_Author(author_id, dateChange, userResponsible, actionPerformed)
		select author_id, GETDATE(), SUSER_NAME(), 'new addition' from inserted
		RETURN;
	END
	insert into AUDIT_Author(author_id, dateChange, userResponsible, actionPerformed)
	select author_id, GETDATE(), SUSER_NAME(), 'author deleted' from inserted
END