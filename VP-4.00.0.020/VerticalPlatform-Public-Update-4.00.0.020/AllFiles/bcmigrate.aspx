<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="bcmigrate.aspx.cs" Inherits="VerticalPlatformWeb.bcmigrate" %>
<%@ Import Namespace="VerticalPlatform.Core.Data" %>
<%@ Import Namespace="VerticalPlatform.Core.Data.Entities" %>
<%@ Import Namespace="VerticalPlatform.Core.Data.Dao.Implementations" %>
<%@ Import Namespace="Microsoft.Practices.EnterpriseLibrary.Data" %>
<%@ Import Namespace="System.Data.Common" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
	<title></title>

	<script language="CS" runat="server">
		
		//Site ID.
		const int BCSiteId = 37;
		
		int vpSiteId = -1;
		int legacyContentId = -1;
		int vpContentTypeId = -1;
		int vpArticleTypeId = -1;
		int vpForumThreadId = -1;
		int vpForumThreadPostId = -1;
		int legacyContentTypeId = -1;
		int vpContentId = -1;
		int legacySubhomeId = -1;
		int pageId = -1;
		int legacyForumThreadPostId = -1;
		int legacyForumThreadId = -1;
		int afVendorId = -1;
		int afCategoryId = -1;
		int legacyOptionId = -1;
		int legacyGroupId = -1;
		int vpOptionId = -1;
		int vpGroupId = -1;
		
		string pageType = string.Empty;
		string defaultPage = string.Empty;
		string legacyTable = string.Empty;
		string vpSubhomeDisplayName = string.Empty;
		string vpSubhomeSitePrefix = string.Empty;
		string defaultUrl = string.Empty;
		string url = string.Empty;
		string productCompareIds = string.Empty;
		string keyword = string.Empty;
		string vpGuid = string.Empty;
		string SearchGroupOption = string.Empty;
		
		bool externalArticle = false;
		bool defaultRedirect = true;
		bool serverTransfer = false;
		bool leafCategory = false;
		
		SiteDao siteDao = new SiteDao();
		Site site = null;
		
		HttpAliasDao httpAliasDao = new HttpAliasDao();
		HttpAlias httpAlias = null;
		
		ArticleDao articleDao = new ArticleDao();
		Article article = null;

		CategoryDao categoryDao = new CategoryDao();
		Category category = null;
		
		UrlDao urlDao = new UrlDao();
		Url externalUrl = null;
		
		FixedUrlDao fixedUrlDao = new FixedUrlDao();
		FixedUrl VpPageFixedUrl = null;

		PageDao pageDao = new PageDao();

		SubHomeDao subhomeDao = new SubHomeDao();
		SubHome VpSubhome = null;

		/// <summary>
		/// Raises the <see cref="E:System.Web.UI.Control.Load"/> event.
		/// </summary>
		/// <param name="e">An <see cref="T:System.EventArgs"/> object that contains the event data.</param>
		void Page_Load(object sender, System.EventArgs e)
		{
			PopulateQueryStringParameters();
			vpContentTypeId = GetVpContentTypeId(pageType);
			site = siteDao.GetById(vpSiteId);

			if ((site != null) && (site.Id == BCSiteId))
			{
				httpAlias = httpAliasDao.GetPrimaryHttpAlias(site.Id);
				defaultUrl = "http://" + httpAlias.HttpAliasName + "/" + defaultPage + "/";

				if (vpContentTypeId == (int)VerticalPlatform.Core.Data.Entities.ContentType.Article)
				{
					vpContentId = getArticleId(site.Id, legacyContentId, vpArticleTypeId);

					article = articleDao.GetById(vpContentId);

					if (article != null && article.Enabled && IsActiveArticle(article.Id))
					{
						if (article.IsExternal && article.ExternalUrlId.HasValue)
						{
							externalUrl = urlDao.GetById(article.ExternalUrlId.Value);

							if (externalUrl != null)
							{
								RedirectPage(externalUrl.UrlText);
								externalArticle = true;
								defaultRedirect = false;
							}
						}
						else if (!article.IsExternal)
						{
							RedirectToFixedUrl(vpContentId, vpContentTypeId);
						}
					}
					else if (article == null)
					{
						serverTransfer = true;
					}
				}
				else if (vpContentTypeId == (int)VerticalPlatform.Core.Data.Entities.ContentType.Product)
				{
					vpContentId = GetProductId(vpSiteId, legacyContentId);
					RedirectToFixedUrl(vpContentId, vpContentTypeId);
				}
				else if (vpContentTypeId == (int)VerticalPlatform.Core.Data.Entities.ContentType.Category
						&& legacyTable != string.Empty)
				{
					if (legacyTable == "catid")
					{
						leafCategory = true;
					}
					else if (legacyTable == "header")
					{
						leafCategory = false;
					}

					vpContentId = GetCategoryId(vpSiteId, legacyContentId, leafCategory);
					category = categoryDao.GetById(vpContentId);
					if (category != null)
					{
						if (category.IsSearchCategory && keyword != string.Empty && SearchGroupOption == string.Empty)
						{
							RedirectToSearchCategoryUrl(vpContentId, keyword);
						}
						else if (category.IsSearchCategory && SearchGroupOption != string.Empty)
						{
							SeperateSearchGroupOptions(SearchGroupOption);
							if (legacyOptionId != -1 && legacyGroupId != -1)
							{
								vpGroupId = GetSearchGroupId(vpSiteId, legacyGroupId);
								vpOptionId = GetSearchOptionId(legacyGroupId, legacyOptionId, vpGroupId);
								RedirectToSearchCategoryOptionUrl(vpContentId, vpOptionId);
							}
							else if (!string.IsNullOrEmpty(keyword))
							{
								RedirectToSearchCategoryUrl(vpContentId, keyword);
							}
						}
						else
						{
							RedirectToFixedUrl(vpContentId, vpContentTypeId);
						}
					}
					else if (keyword != string.Empty)
					{
						url = "http://" + httpAlias.HttpAliasName + GetGeneralSearchUrl(vpSiteId, keyword);
						defaultRedirect = false;
						RedirectPage(url);
					}
					else
					{
						serverTransfer = true;
					}
					
				}
				else if (vpContentTypeId == (int)VerticalPlatform.Core.Data.Entities.ContentType.ForumTopic)
				{
					vpContentId = GetForumTopicId(vpSiteId, legacyContentId);
					RedirectToFixedUrl(vpContentId, vpContentTypeId);
				}
				else if (vpContentTypeId == (int)VerticalPlatform.Core.Data.Entities.ContentType.ForumThread)
				{
					vpContentId = GetForumThreadId(vpSiteId, legacyForumThreadId);
					RedirectToFixedUrl(vpContentId, vpContentTypeId);
				}
				else if (vpContentTypeId == (int)VerticalPlatform.Core.Data.Entities.ContentType.Vendor)
				{
					vpContentId = GetVendorId(vpSiteId, legacyContentId);
					RedirectToFixedUrl(vpContentId, vpContentTypeId);
				}
				else if (pageType == "horizontalmatrix")
				{
					string queryString = GetHorizontalMatrixPageUrl(vpSiteId);
					if (!defaultRedirect)
					{
						url = "http://" + httpAlias.HttpAliasName + queryString;
						RedirectPage(url);
					}
					else
					{
						serverTransfer = true;
					}
				}
				else if (pageType == "forumthreadpost")
				{
					if (legacyForumThreadId != -1)
					{
						vpForumThreadId = GetForumThreadId(vpSiteId, legacyForumThreadId);
						defaultRedirect = false;
					}

					if (legacyForumThreadPostId != -1)
					{
						vpForumThreadPostId = GetForumThreadPostId(vpSiteId, legacyForumThreadPostId);
					}

					if (!defaultRedirect)
					{
						url = "http://" + httpAlias.HttpAliasName +
								GetForumThreadPostPageUrl(vpSiteId, vpForumThreadId, vpForumThreadPostId);
						RedirectPage(url);
					}
					else
					{
						serverTransfer = true;
					}

				}
				else if (pageType == "leadform")
				{
					vpContentId = GetCategoryId(vpSiteId, legacyContentId, false);
					RedirectToFixedUrl(vpContentId,(int) VerticalPlatform.Core.Data.Entities.ContentType.Category);
				}
				else if (pageType == "forumuserprofile")
				{
					legacyContentId = GetLegacyContentIdByGUId(vpGuid);
					vpContentId = GetPublicUser(vpSiteId, legacyContentId);
					if (vpContentId != -1)
					{
						url = "http://" + httpAlias.HttpAliasName + GetForumUserProfilePageUrl(vpSiteId, vpContentId);
						defaultRedirect = false;
						RedirectPage(url);
					}
					else
					{
						serverTransfer = true;
					}
				}
				else if (pageType == "searchresults")
				{
					if (!string.IsNullOrEmpty(keyword))
					{
						url = "http://" + httpAlias.HttpAliasName + GetGeneralSearchUrl(vpSiteId, keyword);
						defaultRedirect = false;
						RedirectPage(url);
					}
					else
					{
						serverTransfer = true;
					}
				}
				else if (pageType == "browsecategory")
				{
					vpContentId = GetGuidedBrowseCategoryId(vpSiteId, legacyContentId);
					category = categoryDao.GetById(vpContentId);
					if (category != null)
					{
						url = "http://" + httpAlias.HttpAliasName +
								GetGuidedBrowsePageUrl(vpSiteId, vpContentId, keyword);
						defaultRedirect = false;
						RedirectPage(url);
					}
					else
					{
						serverTransfer = true;
					}
				}

				if (defaultRedirect)
				{
					if (serverTransfer)
					{
						Response.ContentType = "text/html";
						Response.StatusCode = 404;
						Response.WriteFile(Server.MapPath("~/BCPageNotFound.htm"));
					}
					else
					{
						RedirectPage(defaultUrl);
					}
				}
			}
		}

		/// <summary>
		/// Populates query string parameters.
		/// </summary>
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

			if (!string.IsNullOrEmpty(Request["cpids"]))
			{
				productCompareIds = Request["cpids"].ToLowerInvariant();
			}

			if (!string.IsNullOrEmpty(Request["guid"]))
			{
				vpGuid = Request["guid"];
			}
			
			if (!string.IsNullOrEmpty(Request["sgoids"]))
			{
				SearchGroupOption = Request["sgoids"];
			}

			if (!string.IsNullOrEmpty(Request["ftpid"]))
			{
				int.TryParse(Request["ftpid"], out legacyForumThreadPostId);
			}

			if (!string.IsNullOrEmpty(Request["fthid"]))
			{
				int.TryParse(Request["fthid"], out legacyForumThreadId);
			}

			if (!string.IsNullOrEmpty(Request["atid"]))
			{
				int.TryParse(Request["atid"], out vpArticleTypeId);
				//Featured articles maps to the editorial article
				// 178 and 179 are not available in the production DB.
				if (vpArticleTypeId == 178)
				{
					vpArticleTypeId = 174;
				}

				//NewTechnology articles redirects to the default page.
				if (vpArticleTypeId == 179)
				{
					vpArticleTypeId = -1;
				}
				
			}

			if (!string.IsNullOrEmpty(Request["afvid"]))
			{
				int.TryParse(Request["afvid"], out afVendorId);
			}

			if (!string.IsNullOrEmpty(Request["afcid"]))
			{
				int.TryParse(Request["afcid"], out afCategoryId);
			}

			if (!string.IsNullOrEmpty(Request["s"]))
			{
				keyword = Request["s"];
			}
			
		}

		/// <summary>
		/// Gets the product id.
		/// </summary>
		/// <param name="vpSiteId">The site id.</param>
		/// <param name="legacyContentId">The legacy content id.</param>
		/// <returns>The product id.</returns>
		int GetProductId(int vpSiteId, int legacyContentId)
		{
			int productId = -1;

			Database db = DatabaseFactory.CreateDatabase();
			DbCommand command;
			string commandText = "SELECT product_id FROM product " +
								"WHERE legacy_content_id = @legacyContentId " +
								"AND site_id=@siteId";

			command = db.GetSqlStringCommand(commandText);
			db.AddInParameter(command, "legacyContentId", System.Data.DbType.Int32, legacyContentId);
			db.AddInParameter(command, "siteId", System.Data.DbType.Int32, vpSiteId);

			using (NullableDataReader reader = new NullableDataReader(db.ExecuteReader(command)))
			{
				if (reader.Read())
				{
					productId = reader.GetInt32("product_id");
				}
			}

			return productId;
		}

		/// <summary>
		/// Gets the public user id.
		/// </summary>
		/// <param name="vpSiteId">The site id.</param>
		/// <param name="legacyContentId">The legacy content id.</param>
		/// <returns>The public user id.</returns>
		int GetPublicUser(int vpSiteId, int legacyContentId)
		{
			int publicUserId = -1;
			Database db = DatabaseFactory.CreateDatabase();
			DbCommand command;
			string commandText = "SELECT public_user_id FROM public_user " +
								"WHERE legacy_content_id = @legacyContentId " +
								"AND site_id=@siteId";

			command = db.GetSqlStringCommand(commandText);
			db.AddInParameter(command, "legacyContentId", System.Data.DbType.Int32, legacyContentId);
			db.AddInParameter(command, "siteId", System.Data.DbType.Int32, vpSiteId);

			using (NullableDataReader reader = new NullableDataReader(db.ExecuteReader(command)))
			{
				if (reader.Read())
				{
					publicUserId = reader.GetInt32("public_user_id");
				}
			}
			
			return publicUserId;
		}
		
		/// <summary>
		/// Gets the article id.
		/// </summary>
		/// <param name="vpSiteId">The site id.</param>
		/// <param name="legacyContentId">The legacy content id.</param>
		/// <param name="articleTypeId">The article type id.</param>
		/// <returns>The article id.</returns>
		int getArticleId(int vpSiteId, int legacyContentId, int articleTypeId)
		{
			int articleId = -1;
			Database db = DatabaseFactory.CreateDatabase();
			DbCommand command;
			string commandText = "SELECT article_id FROM article " +
								"WHERE legacy_content_id = @legacyContentId " +
								"AND site_id=@siteId " +
								"AND article_type_id = @articleTypeId";

			command = db.GetSqlStringCommand(commandText);
			db.AddInParameter(command, "legacyContentId", System.Data.DbType.Int32, legacyContentId);
			db.AddInParameter(command, "articleTypeId", System.Data.DbType.Int32, articleTypeId);
			db.AddInParameter(command, "siteId", System.Data.DbType.Int32, vpSiteId);

			using (NullableDataReader reader = new NullableDataReader(db.ExecuteReader(command)))
			{
				if (reader.Read())
				{
					articleId = reader.GetInt32("article_id");
				}
			}

			return articleId;
		}

		/// <summary>
		/// Gets the vendor id.
		/// </summary>
		/// <param name="vpSiteId">The site id.</param>
		/// <param name="legacyContentId">The legacy content id.</param>
		/// <returns>The vendor id.</returns>
		int GetVendorId(int vpSiteId, int legacyContentId)
		{
			int vendorId = -1;

			Database db = DatabaseFactory.CreateDatabase();
			DbCommand command;
			string commandText = "SELECT vendor_id FROM vendor " +
								"WHERE legacy_content_id = @legacyContentId " +
								"AND site_id=@siteId";

			command = db.GetSqlStringCommand(commandText);
			db.AddInParameter(command, "legacyContentId", System.Data.DbType.Int32, legacyContentId);
			db.AddInParameter(command, "siteId", System.Data.DbType.Int32, vpSiteId);

			using (NullableDataReader reader = new NullableDataReader(db.ExecuteReader(command)))
			{
				if (reader.Read())
				{
					vendorId = reader.GetInt32("vendor_id");
				}
			}

			return vendorId;
		}

		/// <summary>
		/// Gets the category id.
		/// </summary>
		/// <param name="vpSiteId">The site id.</param>
		/// <param name="legacyContentId">The legacy content id.</param>
		/// <param name="leafCategory">True if it is a leaf category else false.</param>
		/// <returns>The category id.</returns>
		int GetCategoryId(int vpSiteId, int legacyContentId, bool leafCategory)
		{
			int categoryId = -1;

			Database db = DatabaseFactory.CreateDatabase();
			DbCommand command;
			string commandText = string.Empty;
			if (leafCategory)
			{
				commandText = "SELECT category_id FROM category " +
								"WHERE legacy_content_id = @legacyContentId " +
								"AND site_id=@siteId AND category_type_id = 4";
			}
			else
			{
				commandText = "SELECT category_id FROM category " +
								"WHERE legacy_content_id = @legacyContentId " +
								"AND site_id=@siteId AND (category_type_id = 1 " +
								"OR category_type_id = 2)";
			}

			command = db.GetSqlStringCommand(commandText);
			db.AddInParameter(command, "legacyContentId", System.Data.DbType.Int32, legacyContentId);
			db.AddInParameter(command, "siteId", System.Data.DbType.Int32, vpSiteId);

			using (NullableDataReader reader = new NullableDataReader(db.ExecuteReader(command)))
			{
				if (reader.Read())
				{
					categoryId = reader.GetInt32("category_id");
				}
			}

			return categoryId;
		}

		/// <summary>
		/// Gets the guided browse category id.
		/// </summary>
		/// <param name="vpSiteId">The site id.</param>
		/// <param name="legacyContentId">The legacy content id.</param>
		/// <returns>The category id.</returns>
		int GetGuidedBrowseCategoryId(int vpSiteId, int legacyContentId)
		{
			int categoryId = -1;

			Database db = DatabaseFactory.CreateDatabase();
			DbCommand command;
			string commandText = string.Empty;
			commandText = "select cp.category_parameter_value from category_parameter cp inner join category c " +
						"on c.category_id = cp.category_id "+
						"where c.site_id = @siteId and c.legacy_content_id = @legacyContentId and cp.parameter_type_id = 114";
		

			command = db.GetSqlStringCommand(commandText);
			db.AddInParameter(command, "legacyContentId", System.Data.DbType.Int32, legacyContentId);
			db.AddInParameter(command, "siteId", System.Data.DbType.Int32, vpSiteId);

			using (NullableDataReader reader = new NullableDataReader(db.ExecuteReader(command)))
			{
				if (reader.Read())
				{
					categoryId = int.Parse(reader.GetString("category_parameter_value"));
				}
			}

			return categoryId;
		}

		/// <summary>
		/// Gets the forum topic id.
		/// </summary>
		/// <param name="vpSiteId">The site id.</param>
		/// <param name="legacyContentId">The legacy content id.</param>
		/// <returns>The forum topic id.</returns>
		int GetForumTopicId(int vpSiteId, int legacyContentId)
		{
			int forumTopicId = -1;

			Database db = DatabaseFactory.CreateDatabase();
			DbCommand command;
			string commandText = "SELECT forum_topic_id FROM forum_topic " +
								"WHERE legacy_content_id = @legacyContentId " +
								"AND site_id=@siteId";

			command = db.GetSqlStringCommand(commandText);
			db.AddInParameter(command, "legacyContentId", System.Data.DbType.Int32, legacyContentId);
			db.AddInParameter(command, "siteId", System.Data.DbType.Int32, vpSiteId);

			using (NullableDataReader reader = new NullableDataReader(db.ExecuteReader(command)))
			{
				if (reader.Read())
				{
					forumTopicId = reader.GetInt32("forum_topic_id");
				}
			}

			return forumTopicId;
		}

		/// <summary>
		/// Gets the forum thread id.
		/// </summary>
		/// <param name="vpSiteId">The site id.</param>
		/// <param name="legacyContentId">The legacy content id.</param>
		/// <returns>The forum thread id.</returns>
		int GetForumThreadId(int vpSiteId, int legacyContentId)
		{
			int forumThreadId = -1;

			Database db = DatabaseFactory.CreateDatabase();
			DbCommand command;
			string commandText = "SELECT forum_thread_id FROM forum_thread " +
								"WHERE legacy_content_id = @legacyContentId ";

			command = db.GetSqlStringCommand(commandText);
			db.AddInParameter(command, "legacyContentId", System.Data.DbType.Int32, legacyContentId);

			using (NullableDataReader reader = new NullableDataReader(db.ExecuteReader(command)))
			{
				if (reader.Read())
				{
					forumThreadId = reader.GetInt32("forum_thread_id");
				}
			}

			return forumThreadId;
		}

		/// <summary>
		/// Gets the forum thread post id.
		/// </summary>
		/// <param name="vpSiteId">The site id.</param>
		/// <param name="legacyContentId">The legacy content id.</param>
		/// <returns>The forum thread post id.</returns>
		int GetForumThreadPostId(int vpSiteId, int legacyContentId)
		{
			int forumThreadPostId = -1;

			Database db = DatabaseFactory.CreateDatabase();
			DbCommand command;
			string commandText = "SELECT forum_thread_post_id FROM forum_thread_post " +
								"WHERE legacy_content_id = @legacyContentId ";

			command = db.GetSqlStringCommand(commandText);
			db.AddInParameter(command, "legacyContentId", System.Data.DbType.Int32, legacyContentId);

			using (NullableDataReader reader = new NullableDataReader(db.ExecuteReader(command)))
			{
				if (reader.Read())
				{
					forumThreadPostId = reader.GetInt32("forum_thread_post_id");
				}
			}

			return forumThreadPostId;
		}

		/// <summary>
		/// Gets the search group id.
		/// </summary>
		/// <param name="vpSiteId">The site id.</param>
		/// <param name="legacyContentId">The legacy content id.</param>
		/// <returns>The search group id.</returns>
		int GetSearchGroupId(int vpSiteId, int legacyContentId)
		{
			int searchGroupId = -1;

			Database db = DatabaseFactory.CreateDatabase();
			DbCommand command;
			string commandText = "SELECT search_group_id FROM search_group " +
								"WHERE legacy_content_id = @legacyContentId ";

			command = db.GetSqlStringCommand(commandText);
			db.AddInParameter(command, "legacyContentId", System.Data.DbType.Int32, legacyContentId);

			using (NullableDataReader reader = new NullableDataReader(db.ExecuteReader(command)))
			{
				if (reader.Read())
				{
					searchGroupId = reader.GetInt32("search_group_id");
				}
			}

			return searchGroupId;
		}

		/// <summary>
		/// Gets the legacy user id by GUID.
		/// </summary>
		/// <param name="guid">The GUID.</param>
		/// <returns>The legacy content id.</returns>
		int GetLegacyContentIdByGUId(string guid)
		{
			int? legacyContentId = null;

			Database db = DatabaseFactory.CreateDatabase("CompareNetworks");
			DbCommand command;
			string commandText = "SELECT fu.[site_user_id] FROM [dbo].[forum_user] AS fu " +
								"INNER JOIN [dbo].[aspnet_Membership] AS am " +
								"ON fu.[UserId] = am.[UserId] " +
								"WHERE fu.[UserId] =@guid " +
								"AND fu.[site_id] = 17 ";

			command = db.GetSqlStringCommand(commandText);
			db.AddInParameter(command, "guid", System.Data.DbType.String, guid);

			using (NullableDataReader reader = new NullableDataReader(db.ExecuteReader(command)))
			{
				if (reader.Read())
				{
					legacyContentId = reader.GetNullableInt32("site_user_id");
				}
			}

			return (legacyContentId ?? -1);
		}

		/// <summary>
		/// Gets the vp search option id.
		/// </summary>
		/// <param name="legacyGroupId">The legacy group id.</param>
		/// <param name="legacyOptionId">The legacy option id.</param>
		/// <param name="vpGroupId">The vp group id.</param>
		/// <returns>The vp option id.</returns>
		int GetSearchOptionId(int legacyGroupId, int legacyOptionId, int vpGroupId)
		{
			int vpSearchOptionId = -1;

			Database db = DatabaseFactory.CreateDatabase();
			DbCommand command;
			string commandText = "SELECT Top 1 vp_updated_search_option_id FROM [10.10.10.107\\SQL2K5].biocompare.[dbo].[temp_legacy_to_vp_group_id_option_id_mappings] " +
								"WHERE legacy_search_group_id = @legacyGroupId " +
								"AND legacy_search_option_id = @legacyOptionId " +
								"AND vp_updated_search_group_id = @vpGroupId ";

			command = db.GetSqlStringCommand(commandText);
			db.AddInParameter(command, "legacyGroupId", System.Data.DbType.Int32, legacyGroupId);
			db.AddInParameter(command, "legacyOptionId", System.Data.DbType.Int32, legacyOptionId);
			db.AddInParameter(command, "vpGroupId", System.Data.DbType.Int32, vpGroupId);

			using (NullableDataReader reader = new NullableDataReader(db.ExecuteReader(command)))
			{
				if (reader.Read())
				{
					vpSearchOptionId = reader.GetInt32("vp_updated_search_option_id");
				}
			}

			return vpSearchOptionId;
		}

		/// <summary>
		/// Gets the horizontal matrix page URL.
		/// </summary>
		/// <param name="siteId">The site id.</param>
		/// <returns>The horizontal matrix page url.</returns>
		string GetHorizontalMatrixPageUrl(int siteId)
		{
			StringBuilder pageUrl = new StringBuilder();
			int pageId = pageDao.GetPageIdForSiteByName(siteId, "HorizontalMatrix");
			VpPageFixedUrl = fixedUrlDao.GetFixedUrl(VerticalPlatform.Core.Data.Entities.ContentType.Page, pageId);
			pageUrl.Append(VpPageFixedUrl.Url);
			pageUrl.Append("Compare/");

			if (productCompareIds != string.Empty)
			{
				pageUrl.Append("?compare=");
				string[] productIds = productCompareIds.Split(',');
				int index = 0;
				foreach (string legacyProductId in productIds)
				{
					int productId;
					if (int.TryParse(legacyProductId, out productId))
					{
						if (index > 0)
						{
							pageUrl.Append(",");
						}
						int vpProductId = GetProductId(siteId, productId);
						if (productId != -1)
						{
							pageUrl.Append(vpProductId.ToString());
							defaultRedirect = false;
						}

						index++;
					}
				}
			}

			return pageUrl.ToString();
		}

		/// <summary>
		/// Gets the general search result page URL.
		/// </summary>
		/// <param name="siteId">The site id.</param>
		/// <param name="keyword">The keyword.</param>
		/// <returns>The general search result page url.</returns>
		string GetGeneralSearchUrl(int siteId, string keyword)
		{
			StringBuilder pageUrl = new StringBuilder();
			int pageId = pageDao.GetPageIdForSiteByName(siteId, "SearchResults");
			VpPageFixedUrl = fixedUrlDao.GetFixedUrl(VerticalPlatform.Core.Data.Entities.ContentType.Page, pageId);
			pageUrl.Append(VpPageFixedUrl.Url);
			pageUrl.Append("?search=");
			pageUrl.Append(keyword);

			return pageUrl.ToString();
		}

		/// <summary>
		/// Gets the forum user profile page URL.
		/// </summary>
		/// <param name="siteId">The site id.</param>
		/// <param name="publicUserId">The public user id.</param>
		/// <returns>The forum user profile page url.</returns>
		string GetForumUserProfilePageUrl(int siteId, int publicUserId)
		{
			StringBuilder pageUrl = new StringBuilder();
			int pageId = pageDao.GetPageIdForSiteByName(siteId, "ForumUserProfile");
			VpPageFixedUrl = fixedUrlDao.GetFixedUrl(VerticalPlatform.Core.Data.Entities.ContentType.Page, pageId);
			pageUrl.Append(VpPageFixedUrl.Url);
			pageUrl.Append("?ui=");
			pageUrl.Append(publicUserId.ToString());
			return pageUrl.ToString();
		}

		/// <summary>
		/// Redirects to the search category result page url.
		/// </summary>
		/// <param name="vpContentId">The content id.</param>
		/// <param name="keyword">The search keyword.</param>
		void RedirectToSearchCategoryUrl(int vpContentId, string keyword)
		{
			if (vpContentId != -1)
			{
				VpPageFixedUrl =
						fixedUrlDao.GetFixedUrl(VerticalPlatform.Core.Data.Entities.ContentType.Category, vpContentId);
				url = "http://" + httpAlias.HttpAliasName + VpPageFixedUrl.Url + "?search=" + keyword;
				defaultRedirect = false;
				RedirectPage(url);
			}
		}

		/// <summary>
		/// Redirects to the search category option metrix page url.
		/// </summary>
		/// <param name="vpContentId">The content id.</param>
		/// <param name="searchOption">The search option.</param>
		void RedirectToSearchCategoryOptionUrl(int vpContentId, int searchOption)
		{
			if (vpContentId != -1 && searchOption != -1)
			{
				VpPageFixedUrl =
						fixedUrlDao.GetFixedUrl(VerticalPlatform.Core.Data.Entities.ContentType.Category, vpContentId);
				StringBuilder pageUrl = new StringBuilder();
				pageUrl.Append("http://");
				pageUrl.Append(httpAlias.HttpAliasName);
				pageUrl.Append(VpPageFixedUrl.Url);
				pageUrl.Append("?soids=");
				pageUrl.Append(searchOption);
				pageUrl.Append("&gb=true");
				if (!string.IsNullOrEmpty(keyword))
				{
					pageUrl.Append("&search=");
					pageUrl.Append(keyword);
				}

				defaultRedirect = false;
				RedirectPage(pageUrl.ToString());
			}
		}

		/// <summary>
		/// Gets the forum thread post page url.
		/// </summary>
		/// <param name="siteId">The site id.</param>
		/// <param name="threadId">The thread id.</param>
		/// <param name="postId">The post id.</param>
		/// <returns>The forum thread post page url.</returns>
		string GetForumThreadPostPageUrl(int siteId, int threadId, int postId)
		{
			StringBuilder pageUrl = new StringBuilder();
			int pageId = pageDao.GetPageIdForSiteByName(siteId, "ForumThreadPost");
			VpPageFixedUrl = fixedUrlDao.GetFixedUrl(VerticalPlatform.Core.Data.Entities.ContentType.Page, pageId);
			pageUrl.Append(VpPageFixedUrl.Url);

			pageUrl.Append("?irpl=False");
			if (threadId != -1)
			{
				pageUrl.Append("&fthid=" + threadId.ToString());
			}

			return pageUrl.ToString();
		}

		/// <summary>
		/// Redirect to the fixed url.
		/// </summary>
		/// <param name="vpContentId">The content id.</param>
		/// <param name="vpContentTypeId">The content type id.</param>
		void RedirectToFixedUrl(int vpContentId, int vpContentTypeId)
		{
			if (vpContentId != -1)
			{
				ContentType vpContentType = (ContentType)vpContentTypeId;
				VpPageFixedUrl = fixedUrlDao.GetFixedUrl(vpContentType, vpContentId);
				
				if(VpPageFixedUrl != null)
				{
					url = "http://" + httpAlias.HttpAliasName + VpPageFixedUrl.Url;

					if (isContentEnabled(vpContentId, vpContentTypeId))
					{
						defaultRedirect = false;
						RedirectPage(url);
					}
				}

			}
			else
			{
				serverTransfer = true;
			}
		}

		/// <summary>
		/// Gets the guided browse page url.
		/// </summary>
		/// <param name="siteId">The site id.</param>
		/// <param name="vpContentId">The content id.</param>
		/// <param name="keyword">The keyword.</param>
		/// <returns>The guided browse page url.</returns>
		string GetGuidedBrowsePageUrl(int siteId, int vpContentId, string keyword)
		{
			StringBuilder pageUrl = new StringBuilder();
			int pageId = pageDao.GetPageIdForSiteByName(siteId, "BrowseCategory");
			VpPageFixedUrl = fixedUrlDao.GetFixedUrl(VerticalPlatform.Core.Data.Entities.ContentType.Page, pageId);
			pageUrl.Append(VpPageFixedUrl.Url);

			pageUrl.Append("browse/");
			pageUrl.Append(vpContentId.ToString());
			pageUrl.Append("/");
			pageUrl.Append(keyword.ToString());

			return pageUrl.ToString();
		}

		/// <summary>
		/// Seperates legacy search group id and option id.
		/// </summary>
		/// <param name="searchGroupOptions">The search group option ids.</param>
		void SeperateSearchGroupOptions(string searchGroupOptions)
		{
			if (!string.IsNullOrEmpty(searchGroupOptions))
			{
				int index = searchGroupOptions.LastIndexOf('.');
				string groupOption = searchGroupOptions;
				if (index != -1)
				{
					groupOption = searchGroupOptions.Substring(++index);
				}

				string[] array = groupOption.Split('-');
				if (array != null && array.Length > 1)
				{
					int.TryParse(array[0].Trim(), out legacyGroupId);
					int.TryParse(array[1].Trim(), out legacyOptionId);
				}
				
			}
		}

		/// <summary>
		/// Redirects to the given url
		/// </summary>
		/// <param name="url"> The url</param>
		void RedirectPage(string url)
		{
			Response.Clear();
			Response.Status = "301 Moved Permanently";
			Response.AddHeader("Location", url);
			Response.Flush();
			Response.End();
		}

		/// <summary>
		/// Gets the content type id for given page type.
		/// </summary>
		/// <param name="pageType">The page type</param>
		/// <returns>The content type id.</returns>
		int GetVpContentTypeId(string pageType)
		{
			int vpContentTypeId = -1;
			switch (pageType)
			{
				case "product":
					vpContentTypeId = (int)VerticalPlatform.Core.Data.Entities.ContentType.Product;
					break;
				case "article":
					vpContentTypeId = (int)VerticalPlatform.Core.Data.Entities.ContentType.Article;
					break;
				case "category":
					vpContentTypeId = (int)VerticalPlatform.Core.Data.Entities.ContentType.Category;
					break;
				case "forumtopic":
					vpContentTypeId = (int)VerticalPlatform.Core.Data.Entities.ContentType.ForumTopic;
					break;
				case "forumthread":
					vpContentTypeId = (int)VerticalPlatform.Core.Data.Entities.ContentType.ForumThread;
					break;
				case "vendordetail":
					vpContentTypeId = (int)VerticalPlatform.Core.Data.Entities.ContentType.Vendor;
					break;
			}

			return vpContentTypeId;
		}

		/// <summary>
		/// Check whether content is an enabled content or not.
		/// </summary>
		/// <param name="vpContentId">The content id.</param>
		/// <param name="vpContentTypeId">The content type id.</param>
		/// <returns>True if content is enable else false.</returns>
		bool isContentEnabled(int vpContentId, int vpContentTypeId)
		{
			bool isEnabled = false;
			switch (vpContentTypeId)
			{
				case 2:
					isEnabled = new ProductDao().GetById(vpContentId).Enabled;
					break;
				case 4:
					isEnabled = new ArticleDao().GetById(vpContentId).Enabled;
					break;
				case 1:
					isEnabled = new CategoryDao().GetById(vpContentId).Enabled;
					break;
				case 28:
					isEnabled = new ForumTopicDao().GetById(vpContentId).Enabled;
					break;
				case 29:
					isEnabled = new ForumThreadDao().GetById(vpContentId).Enabled;
					break;
				case 6:
					isEnabled = new VendorDao().GetById(vpContentId).Enabled;
					break;
			}

			return isEnabled;
		}

		/// <summary>
		/// Check whether article is an active article or not.
		/// </summary>
		/// <param name="articleId">The article id.</param>
		/// <returns>True if aricle is active else false.</returns>
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
	</script>

</head>
<body>
	Wait while redirecting....
</body>
</html>