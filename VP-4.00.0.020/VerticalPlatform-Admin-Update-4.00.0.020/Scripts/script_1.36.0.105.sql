IF NOT EXISTS 
(
	SELECT [name] FROM syscolumns where [name] = 'additional_parameters' AND id = 
		(SELECT object_id FROM sys.objects 
		WHERE object_id = OBJECT_ID(N'[dbo].search_performance') AND type in (N'U'))
)
	
BEGIN
	ALTER TABLE [search_performance]
	ADD additional_parameters VARCHAR(max)
END

GO
-------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_AddSearchPerformance'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_AddSearchPerformance
	@timestamp smalldatetime,
	@allProductsQueryTime int,
	@featuredProductsQueryTime int,
	@allProductsRequestTime int,
	@featuredProductsRequestTime int,
	@allProductsQuery varchar(max),
	@featuredProductsQuery varchar(max),
	@totalRenderingTime int,
	@additionalParameters varchar(max),
	@enabled bit,
	@id int output,
	@created smalldatetime output
AS
-- ==========================================================================
-- $Author: Dilshan $ 
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @created = GETDATE()

	INSERT INTO search_performance(timestamp, all_products_query_time, featured_products_query_time, all_products_request_time,
		featured_products_request_time, all_products_query, featured_products_query, total_rendering_time, additional_parameters,
		enabled, created, modified)
	VALUES (@timestamp, @allProductsQueryTime, @featuredProductsQueryTime, @allProductsRequestTime,
		@featuredProductsRequestTime, @allProductsQuery, @featuredProductsQuery, @totalRenderingTime, @additionalParameters,
		@enabled, @created, @created)

	SET @id = SCOPE_IDENTITY()

END
GO

GRANT EXECUTE ON dbo.adminSearch_AddSearchPerformance TO VpWebApp 
GO

GO

----------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_GetSearchPerformanceDetail'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_GetSearchPerformanceDetail
	@id int
AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT search_performance_id AS id, timestamp, all_products_query_time, featured_products_query_time, all_products_request_time,
		featured_products_request_time, all_products_query, featured_products_query, total_rendering_time, additional_parameters,
		created, enabled, modified
	FROM search_performance
	WHERE search_performance_id = @id

END
GO

GRANT EXECUTE ON dbo.adminSearch_GetSearchPerformanceDetail TO VpWebApp 
GO

----------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminSearch_UpdateSearchPerformance'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminSearch_UpdateSearchPerformance
	@id int,
	@timestamp smalldatetime,
	@allProductsQueryTime int,
	@featuredProductsQueryTime int,
	@allProductsRequestTime int,
	@featuredProductsRequestTime int,
	@allProductsQuery varchar(max),
	@featuredProductsQuery varchar(max),
	@totalRenderingTime int,
	@additionalParameters varchar(max),
	@enabled bit,
	@modified smalldatetime output

AS
-- ==========================================================================
-- $Author: Dilshan $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	SET @modified = GETDATE()

	UPDATE search_performance
	SET timestamp = @timestamp, 
	all_products_query_time = @allProductsQueryTime, 
	featured_products_query_time = @featuredProductsQueryTime, 
	all_products_request_time = @allProductsRequestTime, 
	featured_products_request_time = @featuredProductsRequestTime, 
	all_products_query = @allProductsQuery, 
	featured_products_query = @featuredProductsQuery, 
	total_rendering_time = @totalRenderingTime, 
	additional_parameters = @additionalParameters,
	enabled = @enabled,
	modified = @modified
	WHERE search_performance_id = @id

END
GO

GRANT EXECUTE ON dbo.adminSearch_UpdateSearchPerformance TO VpWebApp 
GO

----------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminBulkEmail_GetSegmentsBySiteAndTypeList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminBulkEmail_GetSegmentsBySiteAndTypeList
	@siteId int,
	@segmentType int,
	@campaignStatus int
AS
-- ==========================================================================
-- $Author: Yasodha $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;
	
	IF @campaignStatus < 0
	BEGIN
	SELECT s.segment_id AS id, s.site_id, s.[name], s.segment_type, s.[created], s.[enabled], s.[modified], s.capped_applicable
	FROM segment s 
	WHERE s.site_id = @siteId AND s.segment_type = @segmentType 
	ORDER BY s.[name] ASC
	END
	
	ELSE IF @campaignStatus = 1
	BEGIN
	SELECT DISTINCT s.segment_id AS id, s.site_id, s.[name], s.segment_type, s.[created], s.[enabled], s.[modified], s.capped_applicable
	FROM segment s 
		LEFT JOIN campaign_segment cs
		ON s.segment_id = cs.segment_id
		LEFT JOIN campaign c
		ON c.campaign_id = cs.campaign_id
	WHERE s.site_id = @siteId AND s.segment_type = @segmentType 
		  AND (c.status IN (1, 2, 3, 4, 5, 6) OR cs.campaign_segment_id IS NULL)
	ORDER BY s.[name] ASC
	END
	
	ELSE 
	BEGIN
	SELECT DISTINCT s.segment_id AS id, s.site_id, s.[name], s.segment_type, s.[created], s.[enabled], s.[modified], s.capped_applicable
	INTO #ActiveSegments
	FROM segment s 
		LEFT JOIN campaign_segment cs
		ON s.segment_id = cs.segment_id
		LEFT JOIN campaign c
		ON c.campaign_id = cs.campaign_id
	WHERE s.site_id = @siteId AND s.segment_type = @segmentType 
		  AND (c.status IN (1, 2, 3, 4, 5, 6) OR cs.campaign_segment_id IS NULL)
		
	SELECT DISTINCT s.segment_id AS id, s.site_id, s.[name], s.segment_type, s.[created], s.[enabled], s.[modified], s.capped_applicable
	FROM segment s 
		INNER JOIN campaign_segment cs
		ON s.segment_id = cs.segment_id
		INNER JOIN campaign c
		ON c.campaign_id = cs.campaign_id
	WHERE s.site_id = @siteId AND s.segment_type = @segmentType 
		  AND c.status IN (7, 8, 9, 10) AND s.segment_id NOT IN (SELECT #ActiveSegments.id
																 FROM #ActiveSegments)
	ORDER BY s.[name] ASC
	END

END
GO

GRANT EXECUTE ON dbo.adminBulkEmail_GetSegmentsBySiteAndTypeList TO VpWebApp 
GO

-----------------------------------------------------------------------------------------------------------------

EXEC dbo.global_DropStoredProcedure 'dbo.adminBulkEmail_GetSegmentsBySiteIdFilteringAndPageingList'

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.adminBulkEmail_GetSegmentsBySiteIdFilteringAndPageingList
	@siteId int,
	@startIndex int,
	@endIndex int,
	@segmentName varchar(200),
	@segmentTypeId int,
	@sortBy varchar(20),
	@sortOrder varchar(20),
	@campaignStatus int,
	@totalCount int output
AS
-- ==========================================================================
-- $Author: Yasodha $
-- ==========================================================================
BEGIN
	
	SET NOCOUNT ON;

	IF @campaignStatus < 0
	BEGIN

	WITH temp_segments(idAsc, idDesc, nameAsc, nameDesc, typeAsc, typeDesc, createdAsc, createdDesc, modifiedAsc, modifiedDesc,
		segment_id, site_id, [name], segment_type, [created], [enabled], [modified], capped_applicable) AS
	(
		SELECT
			ROW_NUMBER() OVER (ORDER BY segment_id) AS idAsc, 
			ROW_NUMBER() OVER (ORDER BY segment_id DESC) AS idDesc, 
			ROW_NUMBER() OVER (ORDER BY name) AS nameAsc, 
			ROW_NUMBER() OVER (ORDER BY name DESC) AS nameDesc,
			ROW_NUMBER() OVER (ORDER BY segment_type) AS typeAsc, 
			ROW_NUMBER() OVER (ORDER BY segment_type DESC) AS typeDesc,
			ROW_NUMBER() OVER (ORDER BY created) AS createdAsc, 
			ROW_NUMBER() OVER (ORDER BY created DESC) AS createdDesc,
			ROW_NUMBER() OVER (ORDER BY modified) AS modifiedAsc, 
			ROW_NUMBER() OVER (ORDER BY modified DESC) AS modifiedDesc,
			segment_id, site_id, [name], segment_type, [created], [enabled], [modified], capped_applicable
		FROM segment
		WHERE site_id = @siteId 
			AND (@segmentTypeId IS NULL OR segment_type = @segmentTypeId)
			AND (@segmentName = '' OR ([name] like  '%' + @segmentName + '%'))
	)

	SELECT segment_id AS id, site_id, [name], segment_type, [created], [enabled], [modified], capped_applicable
	FROM temp_segments
	WHERE 
		(@sortBy = 'id' AND @sortOrder = 'asc' AND idAsc BETWEEN @startIndex AND @endIndex) OR 
		(@sortBy = 'name' AND @sortOrder = 'asc' AND nameAsc BETWEEN @startIndex AND @endIndex) OR 
		(@sortBy = 'type' AND @sortOrder = 'asc' AND typeAsc BETWEEN @startIndex AND @endIndex) OR 
		(@sortBy = 'created' AND @sortOrder = 'asc' AND nameAsc BETWEEN @startIndex AND @endIndex) OR 
		(@sortBy = 'modified' AND @sortOrder = 'asc' AND typeAsc BETWEEN @startIndex AND @endIndex) OR 
		(@sortBy = 'id' AND @sortOrder = 'desc' AND idDesc BETWEEN @startIndex AND @endIndex) OR 
		(@sortBy = 'name' AND @sortOrder = 'desc' AND nameDesc BETWEEN @startIndex AND @endIndex) OR 
		(@sortBy = 'type' AND @sortOrder = 'desc' AND typeDesc BETWEEN @startIndex AND @endIndex) OR
		(@sortBy = 'created' AND @sortOrder = 'desc' AND nameDesc BETWEEN @startIndex AND @endIndex) OR 
		(@sortBy = 'modified' AND @sortOrder = 'desc' AND typeDesc BETWEEN @startIndex AND @endIndex)
	ORDER BY
		CASE 
			WHEN @sortBy = 'id' AND @sortOrder = 'asc' THEN idAsc 
			WHEN @sortBy = 'name' AND @sortOrder = 'asc' THEN nameAsc
			WHEN @sortBy = 'type' AND @sortOrder = 'asc' THEN typeAsc
			WHEN @sortBy = 'created' AND @sortOrder = 'asc' THEN createdAsc
			WHEN @sortBy = 'modified' AND @sortOrder = 'asc' THEN modifiedAsc
			WHEN @sortBy = 'id' AND @sortOrder = 'desc' THEN idDesc 
			WHEN @sortBy = 'name' AND @sortOrder = 'desc' THEN nameDesc
			WHEN @sortBy = 'type' AND @sortOrder = 'desc' THEN typeDesc
			WHEN @sortBy = 'created' AND @sortOrder = 'desc' THEN createdDesc
			WHEN @sortBy = 'modified' AND @sortOrder = 'desc' THEN modifiedDesc
		END
	
	SELECT @totalCount = COUNT(*)
		FROM segment
		WHERE site_id = @siteId 
			AND (@segmentTypeId IS NULL OR segment_type = @segmentTypeId)
			AND (@segmentName = '' OR ([name] like  '%' + @segmentName + '%'))
			
	END
	
	ELSE IF @campaignStatus = 1
	BEGIN	
	
	SELECT DISTINCT s.segment_id, s.site_id, s.[name], s.segment_type, s.[created], s.[enabled], s.[modified], s.capped_applicable
	INTO #temp_campaign_status1
	FROM segment s 
		LEFT JOIN campaign_segment cs
		ON s.segment_id = cs.segment_id
		LEFT JOIN campaign c
		ON c.campaign_id = cs.campaign_id
	WHERE s.site_id = @siteId 
		AND ((c.status = 1 OR c.status = 2 OR c.status = 3 OR c.status = 4 OR c.status = 5 OR c.status = 6) OR cs.campaign_segment_id IS NULL);
			
		
	WITH temp_segments1(idAsc, idDesc, nameAsc, nameDesc, typeAsc, typeDesc, createdAsc, createdDesc, modifiedAsc, modifiedDesc,
		segment_id, site_id, [name], segment_type, [created], [enabled], [modified], capped_applicable) AS
	(
		SELECT
			ROW_NUMBER() OVER (ORDER BY segment_id) AS idAsc, 
			ROW_NUMBER() OVER (ORDER BY segment_id DESC) AS idDesc, 
			ROW_NUMBER() OVER (ORDER BY name) AS nameAsc, 
			ROW_NUMBER() OVER (ORDER BY name DESC) AS nameDesc,
			ROW_NUMBER() OVER (ORDER BY segment_type) AS typeAsc, 
			ROW_NUMBER() OVER (ORDER BY segment_type DESC) AS typeDesc,
			ROW_NUMBER() OVER (ORDER BY created) AS createdAsc, 
			ROW_NUMBER() OVER (ORDER BY created DESC) AS createdDesc,
			ROW_NUMBER() OVER (ORDER BY modified) AS modifiedAsc, 
			ROW_NUMBER() OVER (ORDER BY modified DESC) AS modifiedDesc,
			segment_id, site_id, [name], segment_type, [created], [enabled], [modified], capped_applicable
		FROM #temp_campaign_status1
		WHERE site_id = @siteId 
			AND (@segmentTypeId IS NULL OR segment_type = @segmentTypeId)
			AND (@segmentName = '' OR ([name] like  '%' + @segmentName + '%'))
	)

	SELECT segment_id AS id, site_id, [name], segment_type, [created], [enabled], [modified], capped_applicable
	FROM temp_segments1
	WHERE 
		(@sortBy = 'id' AND @sortOrder = 'asc' AND idAsc BETWEEN @startIndex AND @endIndex) OR 
		(@sortBy = 'name' AND @sortOrder = 'asc' AND nameAsc BETWEEN @startIndex AND @endIndex) OR 
		(@sortBy = 'type' AND @sortOrder = 'asc' AND typeAsc BETWEEN @startIndex AND @endIndex) OR 
		(@sortBy = 'created' AND @sortOrder = 'asc' AND nameAsc BETWEEN @startIndex AND @endIndex) OR 
		(@sortBy = 'modified' AND @sortOrder = 'asc' AND typeAsc BETWEEN @startIndex AND @endIndex) OR 
		(@sortBy = 'id' AND @sortOrder = 'desc' AND idDesc BETWEEN @startIndex AND @endIndex) OR 
		(@sortBy = 'name' AND @sortOrder = 'desc' AND nameDesc BETWEEN @startIndex AND @endIndex) OR 
		(@sortBy = 'type' AND @sortOrder = 'desc' AND typeDesc BETWEEN @startIndex AND @endIndex) OR
		(@sortBy = 'created' AND @sortOrder = 'desc' AND nameDesc BETWEEN @startIndex AND @endIndex) OR 
		(@sortBy = 'modified' AND @sortOrder = 'desc' AND typeDesc BETWEEN @startIndex AND @endIndex)
	ORDER BY
		CASE 
			WHEN @sortBy = 'id' AND @sortOrder = 'asc' THEN idAsc 
			WHEN @sortBy = 'name' AND @sortOrder = 'asc' THEN nameAsc
			WHEN @sortBy = 'type' AND @sortOrder = 'asc' THEN typeAsc
			WHEN @sortBy = 'created' AND @sortOrder = 'asc' THEN createdAsc
			WHEN @sortBy = 'modified' AND @sortOrder = 'asc' THEN modifiedAsc
			WHEN @sortBy = 'id' AND @sortOrder = 'desc' THEN idDesc 
			WHEN @sortBy = 'name' AND @sortOrder = 'desc' THEN nameDesc
			WHEN @sortBy = 'type' AND @sortOrder = 'desc' THEN typeDesc
			WHEN @sortBy = 'created' AND @sortOrder = 'desc' THEN createdDesc
			WHEN @sortBy = 'modified' AND @sortOrder = 'desc' THEN modifiedDesc
		END
	
		SELECT @totalCount = COUNT(*)
		FROM segment s
			INNER JOIN #temp_campaign_status1
			ON #temp_campaign_status1.segment_id = s.segment_id
		WHERE s.site_id = @siteId 
			AND (@segmentTypeId IS NULL OR s.segment_type = @segmentTypeId)
			AND (@segmentName = '' OR (s.[name] like  '%' + @segmentName + '%'))
		
	END
	
	ELSE
	BEGIN
	
	SELECT DISTINCT s.segment_id, s.site_id, s.[name], s.segment_type, s.[created], s.[enabled], s.[modified], s.capped_applicable
	INTO #temp_campaign_statusActive
	FROM segment s 
		LEFT JOIN campaign_segment cs
		ON s.segment_id = cs.segment_id
		LEFT JOIN campaign c
		ON c.campaign_id = cs.campaign_id
	WHERE s.site_id = @siteId 
		AND ((c.status = 1 OR c.status = 2 OR c.status = 3 OR c.status = 4 OR c.status = 5 OR c.status = 6) OR cs.campaign_segment_id IS NULL);
	
	SELECT DISTINCT s.segment_id, s.site_id, s.[name], s.segment_type, s.[created], s.[enabled], s.[modified], s.capped_applicable
	INTO #temp_campaign_status2
		FROM segment s 
		INNER JOIN campaign_segment cs
		ON s.segment_id = cs.segment_id
		INNER JOIN campaign c
		ON c.campaign_id = cs.campaign_id
	WHERE c.status = 7 OR c.status = 8 OR c.status = 9 OR c.status = 10 AND s.site_id = @siteId
		
	SELECT DISTINCT s.segment_id, s.site_id, s.[name], s.segment_type, s.[created], s.[enabled], s.[modified], s.capped_applicable
	INTO #temp_inactive_segments
	FROM #temp_campaign_status2	s
	WHERE s.segment_id NOT IN (SELECT #temp_campaign_statusActive.segment_id
							   FROM #temp_campaign_statusActive);
	
	WITH temp_segments2(idAsc, idDesc, nameAsc, nameDesc, typeAsc, typeDesc, createdAsc, createdDesc, modifiedAsc, modifiedDesc,
		segment_id, site_id, [name], segment_type, [created], [enabled], [modified], capped_applicable) AS
	(
		SELECT
			ROW_NUMBER() OVER (ORDER BY segment_id) AS idAsc, 
			ROW_NUMBER() OVER (ORDER BY segment_id DESC) AS idDesc, 
			ROW_NUMBER() OVER (ORDER BY name) AS nameAsc, 
			ROW_NUMBER() OVER (ORDER BY name DESC) AS nameDesc,
			ROW_NUMBER() OVER (ORDER BY segment_type) AS typeAsc, 
			ROW_NUMBER() OVER (ORDER BY segment_type DESC) AS typeDesc,
			ROW_NUMBER() OVER (ORDER BY created) AS createdAsc, 
			ROW_NUMBER() OVER (ORDER BY created DESC) AS createdDesc,
			ROW_NUMBER() OVER (ORDER BY modified) AS modifiedAsc, 
			ROW_NUMBER() OVER (ORDER BY modified DESC) AS modifiedDesc,
			segment_id, site_id, [name], segment_type, [created], [enabled], [modified], capped_applicable
		FROM #temp_inactive_segments
		WHERE site_id = @siteId 
			AND (@segmentTypeId IS NULL OR segment_type = @segmentTypeId)
			AND (@segmentName = '' OR ([name] like  '%' + @segmentName + '%'))
	)
	
	SELECT segment_id AS id, site_id, [name], segment_type, [created], [enabled], [modified], capped_applicable
	FROM temp_segments2
	WHERE 
		(@sortBy = 'id' AND @sortOrder = 'asc' AND idAsc BETWEEN @startIndex AND @endIndex) OR 
		(@sortBy = 'name' AND @sortOrder = 'asc' AND nameAsc BETWEEN @startIndex AND @endIndex) OR 
		(@sortBy = 'type' AND @sortOrder = 'asc' AND typeAsc BETWEEN @startIndex AND @endIndex) OR 
		(@sortBy = 'created' AND @sortOrder = 'asc' AND nameAsc BETWEEN @startIndex AND @endIndex) OR 
		(@sortBy = 'modified' AND @sortOrder = 'asc' AND typeAsc BETWEEN @startIndex AND @endIndex) OR 
		(@sortBy = 'id' AND @sortOrder = 'desc' AND idDesc BETWEEN @startIndex AND @endIndex) OR 
		(@sortBy = 'name' AND @sortOrder = 'desc' AND nameDesc BETWEEN @startIndex AND @endIndex) OR 
		(@sortBy = 'type' AND @sortOrder = 'desc' AND typeDesc BETWEEN @startIndex AND @endIndex) OR
		(@sortBy = 'created' AND @sortOrder = 'desc' AND nameDesc BETWEEN @startIndex AND @endIndex) OR 
		(@sortBy = 'modified' AND @sortOrder = 'desc' AND typeDesc BETWEEN @startIndex AND @endIndex)
	ORDER BY
		CASE 
			WHEN @sortBy = 'id' AND @sortOrder = 'asc' THEN idAsc 
			WHEN @sortBy = 'name' AND @sortOrder = 'asc' THEN nameAsc
			WHEN @sortBy = 'type' AND @sortOrder = 'asc' THEN typeAsc
			WHEN @sortBy = 'created' AND @sortOrder = 'asc' THEN createdAsc
			WHEN @sortBy = 'modified' AND @sortOrder = 'asc' THEN modifiedAsc
			WHEN @sortBy = 'id' AND @sortOrder = 'desc' THEN idDesc 
			WHEN @sortBy = 'name' AND @sortOrder = 'desc' THEN nameDesc
			WHEN @sortBy = 'type' AND @sortOrder = 'desc' THEN typeDesc
			WHEN @sortBy = 'created' AND @sortOrder = 'desc' THEN createdDesc
			WHEN @sortBy = 'modified' AND @sortOrder = 'desc' THEN modifiedDesc
		END
	
		SELECT @totalCount = COUNT(*)
		FROM segment s
			INNER JOIN #temp_inactive_segments
			ON #temp_inactive_segments.segment_id = s.segment_id
		WHERE s.site_id = @siteId 
			AND (@segmentTypeId IS NULL OR s.segment_type = @segmentTypeId)
			AND (@segmentName = '' OR (s.[name] like  '%' + @segmentName + '%'))
		
	END
	
	
END
GO

GRANT EXECUTE ON dbo.adminBulkEmail_GetSegmentsBySiteIdFilteringAndPageingList TO VpWebApp 
GO

-----------------------------------------------------------------------------------------------------------