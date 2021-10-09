--Update is with regard to VP-8741
UPDATE category_parameter 
SET category_parameter_value = '' 
WHERE parameter_type_id IN (153,177) AND category_parameter_value = 'False'

UPDATE category_parameter 
SET category_parameter_value = 'IncludeInTitleAndDesc,IncludeInHeadingTag' 
WHERE parameter_type_id IN (153,177) AND category_parameter_value = 'True'
-------------------------------------------------------------------------------------------
--Update is with regard to VP-8705
INSERT INTO parameter_type
VALUES (182, 'EnableNoFollowInTextResource', 1, GETDATE(), GETDATE())

-------------------------------------------------------------------------------------------
--VP-8663
UPDATE [specification]
SET [display_options] = 15
WHERE [display_options] = 7

UPDATE [specification]
SET [display_options] = 9
WHERE [display_options] = 1 AND [content_type_id] = 6

UPDATE [specification]
SET [display_options] = 12
WHERE [display_options] = 4 AND [content_type_id] = 6

UPDATE [specification]
SET [display_options] = 13
WHERE [display_options] = 5 AND [content_type_id] = 6
-------------------------------------------------------------------------------------------