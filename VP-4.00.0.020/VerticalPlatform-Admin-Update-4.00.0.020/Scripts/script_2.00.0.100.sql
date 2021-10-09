IF NOT EXISTS (SELECT 1 FROM module WHERE module_id = 6031)
BEGIN
	INSERT INTO dbo.module
	(
	    module_name,
	    usercontrol_name,
	    enabled,
	    modified,
	    created,
	    is_container
	)
	VALUES
	(   'VideoPlayList',                    -- module_name - varchar(50)
	    '~/Modules/Article/VideoPlayList.ascx',                    -- usercontrol_name - varchar(100)
	    1,                  -- enabled - bit
	    GETDATE(), -- modified - smalldatetime
	    GETDATE(), -- created - smalldatetime
	    0                   -- is_container - bit
	    )
END

