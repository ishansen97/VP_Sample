EXEC dbo.global_DropStoredProcedure 'dbo.adminPage_ValidatePageRelationship';

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE PROCEDURE dbo.adminPage_ValidatePageRelationship
    @parentPageId INT,
    @pageId INT,
    @isChildPage BIT OUT
AS
-- ==========================================================================
-- $Author: Chinthaka $
-- ==========================================================================
BEGIN

    SET NOCOUNT ON;

    --recursive CTE
    ;WITH cte_pages (pageId, parentPageId)
    AS (SELECT pg.page_id,
               pg.parent_page_id
        FROM.page AS pg
        WHERE pg.parent_page_id = @parentPageId
        UNION ALL
        SELECT pg.page_id,
               pg.parent_page_id
        FROM.page pg
            INNER JOIN cte_pages cte
                ON cte.pageId = pg.parent_page_id)
    SELECT *
    INTO #tmp_child_pages
    FROM cte_pages;


    SELECT @isChildPage = CASE WHEN ISNULL(COUNT(1),0) > 0 THEN 1 ELSE 0 end	
    FROM #tmp_child_pages
    WHERE pageId = @pageId;

END;
GO

GRANT EXECUTE ON adminPage_ValidatePageRelationship TO VpWebApp;
GO