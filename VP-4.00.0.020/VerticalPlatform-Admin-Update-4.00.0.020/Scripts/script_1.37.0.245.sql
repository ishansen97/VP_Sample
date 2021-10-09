IF NOT EXISTS (SELECT * FROM contact_type 
               WHERE contact_type = 'LinkedIn')
BEGIN
	INSERT INTO contact_type
	(
		contact_type_id,
		contact_type,
		contact_usage,
		sort_order,
		[enabled],
		modified,
		created
	)
	VALUES
	(
		20,
		'LinkedIn',
		'website',
		1,
		1,
		GETDATE(),
		GETDATE()
	)
END

IF NOT EXISTS (SELECT * FROM contact_type 
               WHERE contact_type = 'GooglePlus')
BEGIN
	INSERT INTO contact_type
	(
		contact_type_id,
		contact_type,
		contact_usage,
		sort_order,
		[enabled],
		modified,
		created
	)
	VALUES
	(
		21,
		'GooglePlus',
		'website',
		1,
		1,
		GETDATE(),
		GETDATE()
	)
END

IF NOT EXISTS (SELECT * FROM contact_type 
               WHERE contact_type = 'YouTube')
BEGIN
	INSERT INTO contact_type
	(
		contact_type_id,
		contact_type,
		contact_usage,
		sort_order,
		[enabled],
		modified,
		created
	)
	VALUES
	(
		22,
		'YouTube',
		'website',
		1,
		1,
		GETDATE(),
		GETDATE()
	)
END