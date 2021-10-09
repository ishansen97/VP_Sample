IF NOT EXISTS(
  SELECT *
  FROM INFORMATION_SCHEMA.COLUMNS
  WHERE 
    [TABLE_NAME] = 'article_to_author'
    AND [COLUMN_NAME] = 'verified')
    
BEGIN
  ALTER TABLE dbo.article_to_author
  ADD verified bit NOT NULL default 1
END

