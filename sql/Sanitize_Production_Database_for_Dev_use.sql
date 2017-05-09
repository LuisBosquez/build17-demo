USE SQL2017BuildDemo_DevBig;

-- Sanitize production data for development use.
-- Use Norwegian encryption.
UPDATE dbo.Comments SET
	Author = REVERSE(Author)
	,Text = REVERSE(Text);

