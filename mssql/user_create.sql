
/******* Run This code on the MASTER Database ******/

-- Create login,
CREATE LOGIN miyoshi_usr
 WITH PASSWORD = 'MysP@ssw0rd'
GO

-- Create user in master database (so the user can connect using ssms or ADS)
CREATE USER miyoshi_usr
 FOR LOGIN miyoshi_usr
 WITH DEFAULT_SCHEMA = dbo
GO

/******* Run This code on the Database you want to give the access ******/

-- The user database where you want to give the access

CREATE USER miyoshi_usr
 FOR LOGIN miyoshi_usr
 WITH DEFAULT_SCHEMA = dbo
GO

-- Add user to the database roles you want
EXEC sp_addrolemember N'db_owner', N'miyoshi_usr'
GO

----
EXEC sp_addrolemember N'db_datareader', N'miyoshi_usr'
GO
