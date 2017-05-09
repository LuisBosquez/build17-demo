USE master;
GO

IF(OBJECT_ID('numbers') IS NULL)
	SELECT TOP(1000000)
		ROW_NUMBER() OVER (ORDER BY (SELECT NUll)) AS number 
	INTO numbers
	FROM sys.messages AS m1
	CROSS JOIN sys.messages AS m2;
GO

IF(OBJECT_ID('words') IS NULL)
	SELECT *
	INTO dbo.words
	FROM (VALUES
	('cannaceous'),
	('asymbolia'),
	('centesimal'),
	('antefebrile'),
	('ambisinister'),
	('antiexporting'),
	('anthropomorphitical'),
	('animadversional'),
	('aristocratical'),
	('cawney'),
	('amirship'),
	('abdominales'),
	('ankus'),
	('breastband'),
	('carouse'),
	('carragheenin'),
	('amputative'),
	('antinucleon'),
	('accompli'),
	('approvance'),
	('anemopathy'),
	('bustiest'),
	('acron'),
	('anomalism'),
	('aestival'),
	('antiscion'),
	('airplanist'),
	('amalgamators'),
	('appalled'),
	('adance'),
	('capitalizes'),
	('cass'),
	('catapleiite'),
	('arthropody'),
	('anicca'),
	('causelessly'),
	('buzzier'),
	('adieus'),
	('acronical'),
	('astrally'),
	('ateuchus'),
	('acquist'),
	('agadic'),
	('almagra'),
	('asphyxied'),
	('appliqueing'),
	('anapeiratic'),
	('anthracia'),
	('affixable'),
	('apodema'),
	('allotropes'),
	('achievements'),
	('acrobystitis'),
	('brothier'),
	('arises'),
	('altars'),
	('aquaphobia'),
	('androcracy'),
	('agomphosis'),
	('antilacrosse'),
	('angulous'),
	('accept'),
	('areologic'),
	('antimaniac'),
	('alibies'),
	('brecham'),
	('anthroropolith'),
	('antiprotease'),
	('alantolic'),
	('assisa'),
	('amasthenic'),
	('anaematosis'),
	('anemious'),
	('appendicitis'),
	('adiaphonon'),
	('aquicultural'),
	('antisiphonal'),
	('airer'),
	('bums'),
	('catty'),
	('agnosis'),
	('cakemaking'),
	('abrege'),
	('broiled'),
	('angiographic'),
	('antidotical'),
	('alterate'),
	('brawliest'),
	('acanthosis'),
	('anthropometrical'),
	('cathood'),
	('arcuses'),
	('anemometrical'),
	('antievolutionist'),
	('cavaleros'),
	('anchylosis'),
	('antiferment'),
	('accretionary'),
	('cantaliver'),
	('assentator')
	) AS a (word);
GO

IF(DB_ID('SQL2017BuildDemo_Production') IS NOT NULL)
	BEGIN		
		ALTER DATABASE SQL2017BuildDemo_Production SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
		DROP DATABASE SQL2017BuildDemo_Production;
	END
GO

CREATE DATABASE SQL2017BuildDemo_Production;
ALTER DATABASE SQL2017BuildDemo_Production MODIFY FILE (NAME = 'SQL2017BuildDemo_Production', NEWNAME = 'SQL2017BuildDemo_Data');
ALTER DATABASE SQL2017BuildDemo_Production MODIFY FILE (NAME = 'SQL2017BuildDemo_Production_log', NEWNAME = 'SQL2017BuildDemo_Log');
GO

ALTER DATABASE SQL2017BuildDemo_Production SET RECOVERY SIMPLE;
GO

USE SQL2017BuildDemo_Production;
GO

CREATE TABLE dbo.Comments
(
	CommentId INT IDENTITY(1,1) PRIMARY KEY,
	Author NVARCHAR(100) NULL,
	Text NVARCHAR(MAX) NULL,
);
GO

INSERT dbo.Comments (Author, Text)
	SELECT TOP(1000000)
		CASE 
			WHEN CAST(CAST(NEWID() AS BINARY(1)) AS TINYINT) < 85 THEN 'Tobias'
			WHEN CAST(CAST(NEWID() AS BINARY(1)) AS TINYINT) < 170 THEN 'Travis'
			ELSE 'Luis'
		END AS Author
		,(SELECT TOP(10) w.word + ' ' AS '*' 
			FROM master.dbo.words AS w
			WHERE n.number > LEN(w.word) - 10000
			ORDER BY NEWID() 
			FOR XML PATH('')
		) AS Text
	FROM master.dbo.numbers AS n;
GO

-- Compact and shrink.
DBCC SHRINKFILE('SQL2017BuildDemo_Data', 1);
DBCC SHRINKFILE('SQL2017BuildDemo_Log', 1);
GO

--sp_helpdb 'SQL2017BuildDemo_Production'

