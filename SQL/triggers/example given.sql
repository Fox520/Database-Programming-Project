
create table tblOrders(
	orderID int identity(1,1) primary key,
	orderApprovalDate datetime,
	orderStatus varchar(20)
)

create table tblOrdersAudit(
	orderAuditID int identity(1,1) primary key,
	orderID int,
	orderApprovalDateTime datetime,
	orderStatus varchar(20),
	updatedBy nvarchar(128),
	updatedOn datetime
)
go
create trigger trgTblOrders on tblOrders
after update, insert -- , -> or
as
begin
	insert into tblOrdersAudit(orderID, orderApprovalDateTime, orderStatus, updatedBy, updatedOn)
	select i.orderID, i.orderApprovalDate, i.orderStatus, SUSER_NAME(), GETDATE()
	from tblOrders t
	JOIN inserted i on t.orderID = i.orderID
end

insert into tblOrders(orderApprovalDate, orderStatus) values (NULL, 'compleeete')

select * from tblOrders
select * from tblOrdersAudit

UPDATE tblOrders
SET orderStatus = 'Cancelled'
WHERE orderID = 1