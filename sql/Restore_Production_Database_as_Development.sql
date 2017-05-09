RESTORE DATABASE SQL2017BuildDemo_DevBig FROM DISK = '/azurebackups/SQL2017BuildDemo_Production.bak' WITH STATS = 1, MOVE 'SQL2017BuildDemo_Data' TO '/var/opt/mssql/data/SQL2017BuildDemo.mdf', MOVE 'SQL2017BuildDemo_Log' TO '/var/opt/mssql/data/SQL2017BuildDemo.ldf';

