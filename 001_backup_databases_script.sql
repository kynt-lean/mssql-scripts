set nocount on
declare @dbBackupFile nvarchar(1000), @backupPath nvarchar(128), @currdate smalldatetime, @c varchar(14)
select @currdate = getdate(), @backupPath = '/home/app/backup/'
set @c = convert(varchar, @currdate, 112) + replace(convert(varchar, @currdate, 108), ':', '')
declare @db as table (id int identity(1, 1), name sysname)
insert into @db select name from sys.databases where database_id > 4 and state = 0 order by name
declare @i int, @n int, @query nvarchar(4000)
select @i = MIN(id), @n = MAX(id) from @db
while (@i <= @n) begin
	select @dbBackupFile = @backupPath + RTRIM(name) + '_' + @c + '.bak' ,
		@query = 'backup database [' + rtrim(name) + '] to disk = ''' + @dbBackupFile + ''''
	from @db where id = @i	
	exec ( @query )
	set @i = @i + 1
end
