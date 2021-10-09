<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="migrate.aspx.cs" Inherits="VerticalPlatformWeb.migrate" %>

<%@ Import Namespace="VerticalPlatform.Core.Data" %>
<%@ Import Namespace="VerticalPlatform.Core.Data.Entities" %>
<%@ Import Namespace="VerticalPlatform.Core.Data.Dao.Implementations" %>
<%@ Import Namespace="Microsoft.Practices.EnterpriseLibrary.Data" %>
<%@ Import Namespace="System.Data.Common" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
	<title></title>

	<script language="CS" runat="server">
		
		//Site ID s
		const int OwebSiteId = 27;
		const int DCSiteId = 25;

		int vpSiteId = -1;
		int legacyContentId = -1;
		int vpContentTypeId = -1;
		int legacyContentTypeId = -1;
		string pageType = string.Empty;
		string defaultPage = string.Empty;
		string legacyTable = string.Empty;
		int vpContentId = -1;
		bool externalArticle = false;
		int legacySubhomeId = -1;
		string vpSubhomeDisplayName = string.Empty;
		string vpSubhomeSitePrefix = string.Empty;
		string defaultUrl = string.Empty;
		string url = string.Empty;

		SiteDao siteDao = new SiteDao();
		Site site = null;
		
		HttpAliasDao httpAliasDao = new HttpAliasDao();
		HttpAlias httpAlias = null;
		
		ArticleDao articleDao = new ArticleDao();
		Article article = null;
		
		UrlDao urlDao = new UrlDao();
		Url externalUrl = null;
		
		FixedUrlDao fixedUrlDao = new FixedUrlDao();
		FixedUrl VpPageFixedUrl = null;

		SubHomeDao subhomeDao = new SubHomeDao();
		SubHome VpSubhome = null;
		
		void Page_Load(object sender, System.EventArgs e)
		{
			PopulateQueryStringParameters();
			
			vpContentTypeId = GetVpContentTypeId(pageType, vpContentTypeId);
			
			site = siteDao.GetById(vpSiteId);
			
			if ((site != null) && (site.Id == DCSiteId))
			{
				httpAlias = httpAliasDao.GetPrimaryHttpAlias(site.Id);
				defaultUrl = "http://" + httpAlias.HttpAliasName + "/" + defaultPage + "/";
				
				// News and Event Redirecting to external url
				if (pageType != string.Empty && pageType == "article" && legacyTable != string.Empty &&
						(legacyContentTypeId == 3 || legacyContentTypeId == 11))
				{
					vpContentId = GetVpContentId(vpSiteId, vpContentTypeId, legacyContentTypeId, legacyContentId,
							false, legacyTable, "");
					
					article = articleDao.GetById(vpContentId);

					if (article != null && article.Enabled && article.IsExternal &&
							article.ExternalUrlId.HasValue && IsActiveArticle(article.Id))
					{
						externalUrl = urlDao.GetById(article.ExternalUrlId.Value);

						if (externalUrl != null)
						{
							RedirectPage(externalUrl.UrlText);
							externalArticle = true;
						}
					}
					else if (!string.IsNullOrEmpty(defaultPage))
					{
						RedirectPage(defaultUrl);
					}
				}

				if (!externalArticle)
				{
					if (pageType != string.Empty && pageType == "showcase" && legacyTable != string.Empty)
					{
						string productFlag = " product_flag=3";
						vpContentId = GetVpContentId(vpSiteId, vpContentTypeId, legacyContentTypeId, legacyContentId,
							true, legacyTable, productFlag);
					}
					else if (pageType != string.Empty && pageType != "newproduct" && legacyTable != string.Empty)
					{
						vpContentId = GetVpContentId(vpSiteId, vpContentTypeId, legacyContentTypeId, legacyContentId,
							false, legacyTable, "");
					}
					else if (pageType != string.Empty && legacyTable != string.Empty)
					{
						string productFlag = " product_flag in (1,2)";
						vpContentId = GetVpContentId(vpSiteId, vpContentTypeId, legacyContentTypeId, legacyContentId,
							true, legacyTable, productFlag);
					}

					if (vpContentId != -1)
					{
						ContentType vpContentType = (ContentType)vpContentTypeId;
						VpPageFixedUrl = fixedUrlDao.GetFixedUrl(vpContentType, vpContentId);
						url = "http://" + httpAlias.HttpAliasName + VpPageFixedUrl.Url;
						
						if (isContentEnabled(vpContentId, vpContentTypeId))
						{
							RedirectPage(url);
						}
						else if (!string.IsNullOrEmpty(defaultPage))
						{
							RedirectPage(defaultUrl);
						}
					}
					else if (!string.IsNullOrEmpty(defaultPage))
					{
						RedirectPage(defaultUrl);
					}
				}
			}
			else if ((site != null) && (site.Id == OwebSiteId))
			{
				int vpSubhomeId = -1;
				
				httpAlias = httpAliasDao.GetPrimaryHttpAlias(site.Id);
				
				defaultUrl = "http://" + httpAlias.HttpAliasName + "/" + defaultPage + "/";

				// if is an external article
				if (pageType != string.Empty && pageType == "article" && legacyTable != string.Empty)
				{
					vpContentId = GetVpContentId(vpSiteId, vpContentTypeId, legacyContentTypeId, legacyContentId,
							false, legacyTable, "");
					
					article = articleDao.GetById(vpContentId);

					if (article != null && article.Enabled && article.IsExternal &&
							article.ExternalUrlId.HasValue && IsActiveArticle(article.Id))
					{
						externalUrl = urlDao.GetById(article.ExternalUrlId.Value);

						if (externalUrl != null)
						{
							RedirectPage(externalUrl.UrlText);
							externalArticle = true;
						}
					}
				}

				if (!externalArticle)
				{
					if (pageType != string.Empty && pageType == "showcase" && legacyTable != string.Empty)
					{
						string productFlag = " product_flag=3";
						vpContentId = GetVpContentId(vpSiteId, vpContentTypeId, legacyContentTypeId, legacyContentId,
							true, legacyTable, productFlag);
					}
					else if (pageType != string.Empty && legacyTable != string.Empty && pageType == "newproduct")
					{
						string productFlag = " product_flag in (1,2)";
						vpContentId = GetVpContentId(vpSiteId, vpContentTypeId, legacyContentTypeId, legacyContentId,
							true, legacyTable, productFlag);
					}
					else if (pageType != string.Empty && legacyTable != string.Empty && pageType != "showcase")
					{
						vpContentId = GetVpContentId(vpSiteId, vpContentTypeId, legacyContentTypeId, legacyContentId,
							false, legacyTable, "");
					}

					if (legacySubhomeId != -1)
					{
						vpSubhomeSitePrefix = GetVPSubhomeSitePrefix(vpSiteId);
						GetVPSubhome(vpSiteId, legacySubhomeId);
					}
					
					if (vpContentId != -1)
					{
						FixedUrlDao dao = new FixedUrlDao();
						ContentType vpContentType = (ContentType)vpContentTypeId;
						FixedUrl VpPageFixedUrl = dao.GetFixedUrl(vpContentType, vpContentId);
						
						if (VpSubhome != null)
						{
							url = "http://" + httpAlias.HttpAliasName + "/" + vpSubhomeSitePrefix + "/" +
									VpSubhome.DisplayName + VpPageFixedUrl.Url;
						}
						else
						{
							url = "http://" + httpAlias.HttpAliasName + VpPageFixedUrl.Url;
						}

						if (isContentEnabled(vpContentId, vpContentTypeId))
						{
							try
							{
								RedirectPage(url);
							}
							catch (Exception ex)
							{
								RedirectPage(defaultUrl);
							}
						}
						else if (!string.IsNullOrEmpty(defaultUrl))
						{
							RedirectPage(defaultUrl);
						}
					}
					else
					{
						RedirectPage(defaultUrl);
					}
				}
			}
			else if (!string.IsNullOrEmpty(defaultPage))
			{
				RedirectPage(defaultPage);
			}
		}

		void PopulateQueryStringParameters()
		{
			if (!string.IsNullOrEmpty(Request["vppt"]))
			{
				pageType = Request["vppt"].ToLowerInvariant();
			}

			if (!string.IsNullOrEmpty(Request["cid"]))
			{
				int.TryParse(Request["cid"], out legacyContentId);
			}

			if (!string.IsNullOrEmpty(Request["ctid"]))
			{
				int.TryParse(Request["ctid"], out legacyContentTypeId);
			}

			if (!string.IsNullOrEmpty(Request["dp"]))
			{
				defaultPage = Request["dp"].ToLowerInvariant();
			}

			if (!string.IsNullOrEmpty(Request["lt"]))
			{
				legacyTable = Request["lt"].ToLowerInvariant();
			}

			if (!string.IsNullOrEmpty(Request["vpsid"]))
			{
				int.TryParse(Request["vpsid"], out vpSiteId);
			}

			if (!string.IsNullOrEmpty(Request["spid"]))
			{
				int.TryParse(Request["spid"], out legacySubhomeId);
			}
		}
	
		int GetVpContentId(int vpSiteId, int vpContentTypeId, int legacyContentTypeId, int legacyContentId,
			bool isNewProduct, string legacyTable, string productFlag)
		{
			int vpCotentId = -1;
			string commandText;
			Database db = DatabaseFactory.CreateDatabase();
			DbCommand command;

			if (isNewProduct)
			{
				legacyContentId = GetProductId(vpSiteId, legacyContentId, productFlag);
			}

			if (vpSiteId == DCSiteId)
			{
				if (legacyContentTypeId != -1)
				{
					commandText = "SELECT vp_id FROM legacy_content WHERE " +
							"site_id=@siteId AND " +
							"legacy_table=@legacyTable AND " +
							"content_type_id=@vpContentTypeId AND " +
							"legacy_content_type_id=@legacyContentTypeId AND " +
							"legacy_id=@legacyContentId";

					command = db.GetSqlStringCommand(commandText);
					db.AddInParameter(command, "legacyContentTypeId", System.Data.DbType.Int32, legacyContentTypeId);
				}
				else
				{
					commandText = "SELECT vp_id FROM legacy_content WHERE " +
							"site_id=@siteId AND " +
							"legacy_table=@legacyTable AND " +
							"content_type_id=@vpContentTypeId AND " +
							"legacy_id=@legacyContentId AND " +
							"legacy_content_type_id IS NULL";

					command = db.GetSqlStringCommand(commandText);
				}

				db.AddInParameter(command, "siteId", System.Data.DbType.Int32, vpSiteId);
				db.AddInParameter(command, "vpContentTypeId", System.Data.DbType.Int32, vpContentTypeId);
				db.AddInParameter(command, "legacyContentId", System.Data.DbType.Int32, legacyContentId);
				db.AddInParameter(command, "legacyTable", System.Data.DbType.String, legacyTable);

				using (NullableDataReader reader = new NullableDataReader(db.ExecuteReader(command)))
				{
					if (reader.Read())
					{
						vpCotentId = reader.GetInt32("vp_id");
					}
				}
			}
			else if (vpSiteId == OwebSiteId)
			{
				if (legacyTable == "videos")
				{
					legacyContentId = GetMCVideoId(vpSiteId, legacyContentId);
				}
				
				if (legacyContentTypeId != -1)
				{
					commandText = "SELECT content_id FROM vp_oweb_content_map WHERE " +
							"site_id=@siteId AND " +
							"legacy_table=@legacyTable AND " +
							"content_type_id=@vpContentTypeId AND " +
							"legacy_content_type_id=@legacyContentTypeId AND " +
							"legacy_content_id=@legacyContentId";

					command = db.GetSqlStringCommand(commandText);
					db.AddInParameter(command, "legacyContentTypeId", System.Data.DbType.Int32, legacyContentTypeId);
				}
				else
				{
					commandText = "SELECT content_id FROM vp_oweb_content_map WHERE " +
							"site_id=@siteId AND " +
							"legacy_table=@legacyTable AND " +
							"content_type_id=@vpContentTypeId AND " +
							"legacy_content_id=@legacyContentId";

					command = db.GetSqlStringCommand(commandText);
				}

				db.AddInParameter(command, "siteId", System.Data.DbType.Int32, vpSiteId);
				db.AddInParameter(command, "vpContentTypeId", System.Data.DbType.Int32, vpContentTypeId);
				db.AddInParameter(command, "legacyContentId", System.Data.DbType.Int32, legacyContentId);
				db.AddInParameter(command, "legacyTable", System.Data.DbType.String, legacyTable);

				using (NullableDataReader reader = new NullableDataReader(db.ExecuteReader(command)))
				{
					if (reader.Read())
					{
						vpCotentId = reader.GetInt32("content_id");
					}
				}
			}

			return vpCotentId;
		}

		int GetProductId(int vpSiteId, int legacyId, string productFlag)
		{
			int productId = -1;

			Database db = DatabaseFactory.CreateDatabase();
			DbCommand command;
			string commandText = "SELECT item_id FROM legacy_new_featured_product_mapping " +
								"WHERE new_product_id = @newProductId " +
								"AND site_id=@siteId" +
								" AND " + productFlag;


			command = db.GetSqlStringCommand(commandText);
			db.AddInParameter(command, "newProductId", System.Data.DbType.Int32, legacyId);
			db.AddInParameter(command, "siteId", System.Data.DbType.Int32, vpSiteId);

			using (NullableDataReader reader = new NullableDataReader(db.ExecuteReader(command)))
			{
				if (reader.Read())
				{
					productId = reader.GetInt32("item_id");
				}
			}
			
			return productId;
		}

		int GetMCVideoId(int vpSiteId, int cnpgVideoId)
		{
			int productId = -1;

			Database db = DatabaseFactory.CreateDatabase();
			DbCommand command;
			string commandText = "SELECT mc_video_id FROM vp_legacy_video_map " +
								"WHERE cnpg_video_id = @cnpgVideoId " +
								"AND site_id=@siteId";


			command = db.GetSqlStringCommand(commandText);
			db.AddInParameter(command, "cnpgVideoId", System.Data.DbType.Int32, cnpgVideoId);
			db.AddInParameter(command, "siteId", System.Data.DbType.Int32, vpSiteId);

			using (NullableDataReader reader = new NullableDataReader(db.ExecuteReader(command)))
			{
				if (reader.Read())
				{
					productId = reader.GetInt32("mc_video_id");
				}
			}

			return productId;
		}

		void RedirectPage(string url)
		{
			Response.Clear();
			Response.Status = "301 Moved Permanently";
			Response.AddHeader("Location", url);
			Response.Flush();
			Response.End();
		}

		bool IsActiveArticle(int articleId)
		{
			bool isActive = true;
			string endDateCustomProperty = "End date";
			foreach (ArticleCustomProperty articleCustomProperty in new ArticleCustomPropertyDao().
					GetArticleCustomProperty(articleId))
			{
				CustomProperty customProperty = new CustomPropertyDao().GetById(
						articleCustomProperty.CustomPropertyId);
				if (customProperty.PropertyName == endDateCustomProperty)
				{
					DateTime endDate = DateTime.MaxValue;
					DateTime.TryParse(articleCustomProperty.CustomPropertyValue, out endDate);
					if (DateTime.Compare(DateTime.Now, endDate) > 0)
					{
						isActive = false;
						break;
					}
				}
			}
			return isActive;
		}

		string GetVPSubhomeSitePrefix(int vpSiteId)
		{
			int vpSubhomeId = -1;
			string commandText;
			Database db = DatabaseFactory.CreateDatabase();
			DbCommand command;
			
			string siteSubhomePrefix = string.Empty;

			SiteParameterDao siteParameterDao = new SiteParameterDao();
			VerticalPlatform.Core.Data.Entities.Parameters.SiteParameter siteSubhomeParameter = 
					siteParameterDao.GetSiteParameter(vpSiteId, ParameterType.SubHomePrefix);
			
			return siteSubhomeParameter.ParameterValue;
		}

		int GetVPSubhomeCategoryId(int vpSiteId, int legacySubhomeId)
		{
			int vpSubhomeCategoryId = -1;
			string commandText;
			Database db = DatabaseFactory.CreateDatabase();
			DbCommand command;

			commandText = "SELECT content_id FROM vp_oweb_content_map WHERE " +
							"site_id=@siteId AND " +
							"content_type_id=@vpContentTypeId AND " +
							"legacy_table=@legacyTable AND " +
							"legacy_content_id=@legacyContentId";

			command = db.GetSqlStringCommand(commandText);


			db.AddInParameter(command, "siteId", System.Data.DbType.Int32, vpSiteId);
			db.AddInParameter(command, "vpContentTypeId", System.Data.DbType.Int32, 1);
			db.AddInParameter(command, "legacyTable", System.Data.DbType.String, "header");
			db.AddInParameter(command, "legacyContentId", System.Data.DbType.Int32, legacySubhomeId);

			using (NullableDataReader reader = new NullableDataReader(db.ExecuteReader(command)))
			{
				if (reader.Read())
				{
					vpSubhomeCategoryId = reader.GetInt32("content_id");
				}
			}

			return vpSubhomeCategoryId;
		}

		void GetVPSubhome(int vpSiteId, int legacySubhomeId)
		{
			int vpSubhomeCategoryId = -1;
			string commandText;
			Database db = DatabaseFactory.CreateDatabase();
			DbCommand command;

			vpSubhomeCategoryId = GetVPSubhomeCategoryId(vpSiteId, legacySubhomeId);

			VerticalPlatform.Core.Data.Collections.SubHomeCollection subhomeCollection = 
					subhomeDao.GetSubHomesBySiteId(vpSiteId);

			foreach (SubHome subhome in subhomeCollection)
			{
				if (subhome.CategoryId == vpSubhomeCategoryId)
				{
					VpSubhome = subhome;
					break;
				}
			}
		}

		int GetVpContentTypeId(string pageType, int vpContentTypeId)
		{
			switch (pageType)
			{
				case "category":
					vpContentTypeId = 1;
					break;
				case "product":
					vpContentTypeId = 2;
					break;
				case "article":
					vpContentTypeId = 4;
					break;
				case "vendor":
					vpContentTypeId = 6;
					break;
				case "authorprofile":
					vpContentTypeId = 19;
					break;
				case "newproduct":
					vpContentTypeId = 2;
					break;
				case "showcase":
					vpContentTypeId = 2;
					break;
			}

			return vpContentTypeId;
		}

		bool isContentEnabled(int vpContentId, int vpContentTypeId)
		{
			bool isEnabled = false;
			switch (vpContentTypeId)
			{
				case 1:
					isEnabled = new CategoryDao().GetById(vpContentId).Enabled;
					break;
				case 2:
					isEnabled = new ProductDao().GetById(vpContentId).Enabled;
					break;
				case 4:
					isEnabled = new ArticleDao().GetById(vpContentId).Enabled;
					if (isEnabled)
					{
						isEnabled = IsActiveArticle(vpContentId);
					}
					break;
				case 6:
					isEnabled = new VendorDao().GetById(vpContentId).Enabled;
					break;
				case 19:
					isEnabled = new AuthorDao().GetById(vpContentId).Enabled;
					break;
			}

			return isEnabled;
		}
	
	</script>

</head>
<body>
	Wait while redirecting....
</body>
</html>
