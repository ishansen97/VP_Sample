---------------------------------------------------------------------------------
IF NOT EXISTS(SELECT * FROM parameter_type WHERE parameter_type = 'AuthenticationCookieExpirationPeriod')
BEGIN
	INSERT INTO parameter_type (parameter_type_id, parameter_type, enabled, created, modified)
		VALUES(163, 'AuthenticationCookieExpirationPeriod', 1, GETDATE(), GETDATE())
END
