
--==== adminArticle_GetArchivingArticleIdsList

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArchivingArticleIdsList'



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArchivingArticleIdsList
@limit INT = 10,
@lastProcessedArticleId INT
AS
-- ==========================================================================
-- Author : Chinthaka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT	DISTINCT top(@limit) art.article_id AS [id]
	FROM	dbo.article art
			LEFT JOIN review_type rt ON rt.article_type_id = art.article_type_id
			LEFT JOIN dbo.content_parameter cp ON cp.content_id = art.article_id AND cp.content_type_id = 4 
					AND cp.content_parameter_type = 'MM/dd/yyyy' --disabled date parameter type
			LEFT JOIN dbo.article_type_parameter atp ON atp.article_type_id = art.article_type_id 
					AND atp.parameter_type_id = 63 --ArticleTypeDefaultArticleId
					AND CAST(atp.article_type_parameter_value AS int) = art.article_id 
			--campaign content data
			LEFT JOIN campaign_content_data ccd ON ccd.content_id = art.article_id
			LEFT JOIN campaign_type_content_group ctcg ON ctcg.campaign_type_content_group_id = ccd.campaign_type_content_group_id 
				AND ctcg.content_type_id = 4 --article
			LEFT JOIN dbo.campaign camp ON camp.campaign_id = ccd.campaign_id
			LEFT JOIN exhibition exb ON exb.article_id = art.article_id
			LEFT JOIN exhibition_vendor exbv ON exbv.article_id = art.article_id
	WHERE	art.search_content_modified = 0 --elastic search processed
			AND art.enabled = 0
			AND	art.published = 0
			AND art.archived = 1 
			AND art.article_id > @lastProcessedArticleId
			AND	exb.exhibition_id IS NULL --non exhibition related articles
			AND	exbv.exhibition_vendor_id IS NULL --non exhibition related articles
			AND
			(
				art.deleted = 1 
				OR (
					rt.review_type_id IS NULL --non review type
					AND atp.article_type_parameter_id IS NULL --non default articles
					AND art.is_article_template = 0	--non default article
					AND ( art.end_date IS NULL OR art.end_date < GETDATE()) --no future end date
					AND (cp.content_parameter_id IS NOT NULL OR art.created < '2020-01-01') --disabled date parameter type
					AND	(camp.campaign_id IS NULL) --no campaignes
					AND art.article_type_id <> 267 --contextual paraggraphs
				)
			)
	ORDER BY art.article_id


END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArchivingArticleIdsList TO VpWebApp
GO


--==== adminArticle_UpdateArticleArchiveStatus

EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_UpdateArticleArchiveStatus'


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_UpdateArticleArchiveStatus
@articleId INT
AS
-- ==========================================================================
-- Author : Chinthaka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	UPDATE dbo.article SET archived = 0 WHERE article_id = @articleId
	
	UPDATE	art
	SET		art.archived = 1
	FROM	article art
			LEFT JOIN review_type rt ON rt.article_type_id = art.article_type_id
			LEFT JOIN dbo.content_parameter cp ON cp.content_id = art.article_id AND cp.content_type_id = 4 
					AND cp.content_parameter_type = 'MM/dd/yyyy' --disabled date parameter type
			LEFT JOIN dbo.article_type_parameter atp ON atp.article_type_id = art.article_type_id 
					AND atp.parameter_type_id = 63 --ArticleTypeDefaultArticleId
					AND CAST(atp.article_type_parameter_value AS int) = art.article_id 
			--campaign content data
			LEFT JOIN campaign_content_data ccd ON ccd.content_id = art.article_id
			LEFT JOIN campaign_type_content_group ctcg ON ctcg.campaign_type_content_group_id = ccd.campaign_type_content_group_id 
				AND ctcg.content_type_id = 4 --article
			LEFT JOIN dbo.campaign camp ON camp.campaign_id = ccd.campaign_id
			LEFT JOIN exhibition exb ON exb.article_id = art.article_id
			LEFT JOIN exhibition_vendor exbv ON exbv.article_id = art.article_id
	 WHERE	art.article_id = @articleId
			AND art.enabled = 0
			AND art.published = 0
			AND art.archived = 0
			AND	exb.exhibition_id IS NULL --non exhibition related articles
			AND	exbv.exhibition_vendor_id IS NULL --non exhibition related articles
			AND
			(
				art.deleted = 1
				OR
				(
					rt.review_type_id IS NULL --non review type
					AND atp.article_type_parameter_id IS NULL --non default articles
					AND art.is_article_template = 0 --non default article
					AND ( art.end_date IS NULL OR art.end_date < GETDATE()) --no future end date
					AND cp.content_parameter_id IS NOT NULL --disabled date parameter type
					AND (camp.campaign_id IS NULL) --no campaignes
					AND art.article_type_id <> 267 --contextual paraggraphs
				)
			)

END
GO

GRANT EXECUTE ON dbo.adminArticle_UpdateArticleArchiveStatus TO VpWebApp
GO

--===== adminScheduler_AddTaskHistory

EXEC dbo.global_DropStoredProcedure 'dbo.adminScheduler_AddTaskHistory'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminScheduler_AddTaskHistory
	@taskId int,
	@triggerId int,
	@startTime smalldatetime,
	@endTime smalldatetime,
	@status varchar(70),
	@statusMessage varchar(1000),
	@statusCode int,
	@enabled bit,
	@created smalldatetime output,
	@id int output
AS
-- ==========================================================================
-- $Date: 2020-06-10 
-- $Dulip $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO task_history(task_id, trigger_id, start_time, end_time, [status], status_message, status_code
			, [enabled], modified, created)
	VALUES(@taskId, @triggerId, @startTime, @endTime, @status, @statusMessage, @statusCode, @enabled, @created, @created)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminScheduler_AddTaskHistory TO VpWebApp 
GO


--==== adminArticle_GetArchivingArticleIdsList


EXEC dbo.global_DropStoredProcedure 'dbo.adminArticle_GetArchivingArticleIdsList'



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminArticle_GetArchivingArticleIdsList
@limit INT = 10,
@lastProcessedArticleId INT
AS
-- ==========================================================================
-- Author : Chinthaka
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT	DISTINCT top(@limit) art.article_id AS [id]
	FROM	dbo.article art
			LEFT JOIN review_type rt ON rt.article_type_id = art.article_type_id
			LEFT JOIN dbo.content_parameter cp ON cp.content_id = art.article_id AND cp.content_type_id = 4 
					AND cp.content_parameter_type = 'MM/dd/yyyy' --disabled date parameter type
			LEFT JOIN dbo.article_type_parameter atp ON atp.article_type_id = art.article_type_id 
					AND atp.parameter_type_id = 63 --ArticleTypeDefaultArticleId
					AND CAST(atp.article_type_parameter_value AS int) = art.article_id 
			--campaign content data
			LEFT JOIN campaign_content_data ccd ON ccd.content_id = art.article_id
			LEFT JOIN campaign_type_content_group ctcg ON ctcg.campaign_type_content_group_id = ccd.campaign_type_content_group_id 
				AND ctcg.content_type_id = 4 --article
			LEFT JOIN dbo.campaign camp ON camp.campaign_id = ccd.campaign_id
			LEFT JOIN exhibition exb ON exb.article_id = art.article_id
			LEFT JOIN exhibition_vendor exbv ON exbv.article_id = art.article_id
	WHERE	art.search_content_modified = 0 --elastic search processed
			AND art.enabled = 0
			AND	art.published = 0
			AND art.archived = 1 
			AND art.article_id > @lastProcessedArticleId
			AND	exb.exhibition_id IS NULL --non exhibition related articles
			AND	exbv.exhibition_vendor_id IS NULL --non exhibition related articles
			AND
			(
				art.deleted = 1 
				OR (
					rt.review_type_id IS NULL --non review type
					AND atp.article_type_parameter_id IS NULL --non default articles
					AND art.is_article_template = 0	--non default article
					AND ( art.end_date IS NULL OR art.end_date < GETDATE()) --no future end date
					AND (cp.content_parameter_id IS NOT NULL OR art.created < '2020-01-01') --disabled date parameter type
					AND	(camp.campaign_id IS NULL) --no campaignes
					AND art.article_type_id <> 267 --contextual paraggraphs
					AND	art.created < DATEADD(MONTH,-3,GETDATE()) --articles created before 3 months
				)
			)
	ORDER BY art.article_id


END
GO

GRANT EXECUTE ON dbo.adminArticle_GetArchivingArticleIdsList TO VpWebApp
GO




