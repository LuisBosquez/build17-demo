USE SQL2017BuildDemo_DevSmall;

DELETE TOP(999990) dbo.Comments;

-- Compact and shrink.
DBCC SHRINKFILE('SQL2017BuildDemo_Data', 1);
DBCC SHRINKFILE('SQL2017BuildDemo_Log', 1);
