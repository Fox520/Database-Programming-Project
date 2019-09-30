USE SchoolProject
GO
create trigger trgTblAffiliation on AFFILIATION
after insert
as
begin
	insert into AUDIT_AFFILIATION(affiliation_id, affiliation_name, dateChange, userResponsible, actionPerformed)
	select affiliation_id, inserted.affiliation_name, GETDATE(), SUSER_NAME(), 'affiliation inserted' from inserted
end
GO
create trigger trgTblCity on CITY
after insert
as
begin
	insert into AUDIT_CITY(city_id, city_name, dateChange, userResponsible, actionPerformed)
	select city_id, inserted.city_name, GETDATE(), SUSER_NAME(), 'city created' from inserted
end