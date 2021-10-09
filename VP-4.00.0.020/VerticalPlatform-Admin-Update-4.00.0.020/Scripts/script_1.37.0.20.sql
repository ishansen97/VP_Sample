IF NOT EXISTS (SELECT * FROM dbo.parameter_type WHERE parameter_type_id = 178)
BEGIN

DECLARE @now DATETIME
SET @now = GETDATE()

	INSERT dbo.parameter_type
			( parameter_type_id ,
			  parameter_type ,
			  enabled ,
			  modified ,
			  created
			)
	VALUES	( 178 , -- parameter_type_id - int
			  'DisplayRegistrationFormInModal' , -- parameter_type - varchar(50)
			  1 , -- enabled - bit
			  @now , -- modified - smalldatetime
			  @now  -- created - smalldatetime
			)
END
GO

IF NOT EXISTS (SELECT * FROM dbo.parameter_type WHERE parameter_type_id = 180)
BEGIN

DECLARE @now DATETIME
SET @now = GETDATE()

	INSERT dbo.parameter_type
			( parameter_type_id ,
			  parameter_type ,
			  enabled ,
			  modified ,
			  created
			)
	VALUES	( 180 , -- parameter_type_id - int
			  'FeaturedProductsHeaderText' , -- parameter_type - varchar(50)
			  1 , -- enabled - bit
			  @now , -- modified - smalldatetime
			  @now  -- created - smalldatetime
			)
END
