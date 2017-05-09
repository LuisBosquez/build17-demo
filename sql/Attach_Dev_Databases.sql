-- Create small dev database.
USE master;

EXEC sp_attach_db 'SQL2017BuildDemo_DevBig', '/var/opt/mssql/data/SQL2017BuildDemo.mdf', '/var/opt/mssql/data/SQL2017BuildDemo.ldf';
EXEC sp_attach_db 'SQL2017BuildDemo_DevSmall', '/var/opt/mssql/data/SQL2017BuildDemoSmall.mdf', '/var/opt/mssql/data/SQL2017BuildDemoSmall.ldf';
GO


