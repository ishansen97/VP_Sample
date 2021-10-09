UPDATE  dbo.content_type
SET     content_type = 'ProductCompressionGroup'
WHERE   content_type_id = 33 

UPDATE  dbo.content_type
SET     content_type = 'VendorSettingsTemplate'
WHERE   content_type_id = 34 

INSERT  dbo.content_type
        ( content_type_id ,
          content_type ,
          enabled
        )
        SELECT  35 ,
                'VendorSettingsTemplateCurrency' ,
                1
        WHERE   NOT EXISTS ( SELECT 1
                             FROM   dbo.content_type
                             WHERE  content_type_id = 35 )         
                
