IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'confirmation_email_template' AND Object_ID = OBJECT_ID(N'review_type')) 
BEGIN
	UPDATE review_type SET confirmation_email_template = '{#VPX Language="Ruby"#}  <html>  <body vlink="#2782D1" ' + 
	'alink="#2782D1" style="font-family:Arial, Helvetica, sans-serif; font-size:14px; color: #333333; background-color:#ffffff;">' +
	'  <div align="center">  <table width="600" border="0" cellspacing="0" cellpadding="0">  <tr>  <td style="border:1px' +
	' solid #cccccc;">  <table width="600" border="0" cellspacing="0" cellpadding="0">  <tr>  <td width="20">&nbsp;</td>  ' +
	'<td align="left" width="560" height="150" style="color:#503f34; border-bottom: 1px solid #cccccc;">  <img src="{=context.' +
	'EmailLogoUrl=}" width="252" height="98" alt="{=context.SiteDetail.Site.Name=}" border="0"/>  </td>  <td width="20">&nbsp;</td>  </tr>  ' +
	'<tr>  <td>&nbsp;</td>  <td align="left" style="font-family:Arial, Helvetica, sans-serif; font-size: 14px; line-height:18px; ' +
	'color:#333333; padding-top: 25px;">  <div style="margin-bottom: 32px; font-family:Arial, Helvetica, sans-serif; font-size:20px;' +
	' color:#333333;">  <strong>We received your  review!</strong>  </div>  <div>  <p>  Hi {=context.ArticleDetail.AuthorName(0)=},  </p>  <br/>  ' +
	'<p>  Thank you for submitting a {=context.ReviewType.Name=} review on {=context.SiteDetail.Site.Name=}.  To complete the {=context.ReviewType.Name=}' +
	' review submission please click on the link below so that we can verify your email address. This is important as we will be sending the' +
	' Amazon gift card via email (to those who submit an image with their review).  </p>  <p style="font-size:16px; font-weight:bold;">  ' +
	'Verification Link: {=context.ArticleVerificationUrl=}</p>  <p>We have included some details about your review below:<br/>  ' +
	'{=context.ReviewType.Name=}  Product Review Title: {=context.ArticleDetail.Article.Title=}  <br/>  Product: {~if context.ArticleDetail.GetRelatedProducts().Count() > 0~}\s{=context.GetRelatedProducts()[0].Product.Name=}\s{~end~}\s' +
	'  <br/>  </p>  <p>If you have questions about any of this please email us at <a href="mailto:review_questions@biocompare.com">review_questions' +
	'@biocompare.com</a></p>  </div>  <br/>  <br/>  <br/>  <br/>  <br/>  <div>  Regards,  <br/>  <br/>  <strong>{=context.SiteSignature=}</strong>  ' +
	'</div>  </td>  <td>&nbsp;</td>  </tr>  <tr>  <td width="20" height="100">&nbsp;</td>  <td width="560" height="100">&nbsp;</td>  <td width="20"' + 
	' height="100">&nbsp;</td>  </tr>  </table>  </td>  </tr>  </table>  <table width="590" border="0" cellspacing="0" cellpadding="0">  <tr>  ' +
	'<td width="300" height="30" align="left" style="font-family: Arial, Helvetica, sans-serif; color:#666666; text-align:left; font-size:11px;">' +
	'  {=context.SiteCopyrightMessage=}  </td>  <td width="290" height="30" align="right" style="font-family: Arial, Helvetica, sans-serif;' +
	' color:#666666; text-align:right; font-size:11px;">  <a href="{=context.SiteDetail.NavigationUrl=}" target="_blank" style="text-decoration: underline;' +
	' color:#2782D1" title="{=context.SiteDetail.Site.Name=}.com">{=context.SiteDetail.Site.Name=}.com</a>  </td>  </tr>  </table>  </div>  </body>  </html>' 
END
GO

IF EXISTS (SELECT * FROM sys.columns WHERE Name = N'published_email_template' AND Object_ID = OBJECT_ID(N'review_type')) 
BEGIN
	UPDATE review_type SET published_email_template = '{#VPX Language="Ruby"#}  <html>  <body vlink="#2782D1" alink="#2782D1" style="font-family:Arial' +
	', Helvetica, sans-serif; font-size:14px; color: #333333; background-color:#ffffff;">  <div align="center">  <table width="600" border="0" ' +
	'cellspacing="0" cellpadding="0">  <tr>  <td style="border:1px solid #cccccc;">  <table width="600" border="0" cellspacing="0" cellpadding="0">  ' +
	'<tr>  <td width="20">&nbsp;</td>  <td align= "left" width= "560" height= "150" style= "color:#503f34; border-bottom: 1px solid #cccccc;">  ' +
	'<img src="{=context.EmailLogoUrl=}" width= "252" height= "98" alt="{=context.SiteDetail.Site.Name=}" border= "0" />  </td>  <td width= "20">&nbsp;</td>' +
	'  </tr>  <tr>  <td>&nbsp;</td>  <td align="left" style= "font-family:Arial, Helvetica, sans-serif; font-size: 14px; line-height:18px; color:#333333;' +
	' padding-top: 25px;">  <div style= "margin-bottom: 32px; font-family:Arial, Helvetica, sans-serif; font-size:20px; color:#333333;">  <strong>Your' +
	' review has been published!</strong>  </div>  <div>  <p>  Hi {=context.ArticleDetail.AuthorName(0)=},  </p>  <br/>  <p>  Your review has been published on' +
	' {=context.SiteDetail.Site.Name=}.  </p>  <br/>  <p>  We have included some details about you review below:  <br/>  Product Review Title:' +
	' {=context.ArticleDetail.Article.Title=}  <br/>  Product: {~if context.GetRelatedProducts().Count() > 0~}\s{=context.GetRelatedProducts()[0].Name=}\s{~end~}\s  <br/>  Gift Card Number: {=context.GiftCardId=}  <br/>  ' +
	'Preview Link: {=context.ArticlePreviewUrl=}  </p>  </div>  <br/>  <br/>  <br/>  <br/>  <br/>  <div>  Regards,  <br/>  <br/>  <strong>' +
	'{=context.SiteSignature=}</strong>  </div>  </td>  <td>&nbsp;</td>  </tr>  <tr>  <td width= "20" height= "100">&nbsp;</td>  <td width= "560" height= ' +
	'"100">&nbsp;</td>  <td width= "20" height= "100">&nbsp;</td>  </tr>  </table>  </td>  </tr>  </table>  <table width= "590" border= "0" cellspacing=' +
	' "0" cellpadding= "0">  <tr>  <td width= "300" height= "30" align= "left" style= "font-family: Arial, Helvetica, sans-serif; color:#666666; ' +
	'text-align:left; font-size:11px;">  {=context.SiteCopyrightMessage=}  </td>  <td width="290" height="30" align="right" style="font-family: Arial, ' +
	'Helvetica, sans-serif; color:#666666; text-align:right; font-size:11px;">  <a href="{=context.SiteDetail.NavigationUrl=}" target="_blank" style="text-decoration: ' +
	'underline; color:#2782D1" title="{=context.SiteDetail.Site.Name=}.com">{=context.SiteDetail.Site.Name=}.com</a>  </td>  </tr>  </table>  </div>  </body>  </html>' 
END
GO