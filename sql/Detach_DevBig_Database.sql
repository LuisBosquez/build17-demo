-- Create small dev database.
USE master;

ALTER DATABASE SQL2017BuildDemo_DevBig SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

EXEC sp_detach_db 'SQL2017BuildDemo_DevBig';
GO


