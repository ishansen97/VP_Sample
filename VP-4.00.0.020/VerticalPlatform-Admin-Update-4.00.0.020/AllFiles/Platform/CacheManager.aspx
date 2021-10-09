<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="CacheManager.aspx.cs" Inherits="VerticalPlatformAdminWeb.Platform.CacheManager" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
	<div class="AdminPanelHeader">
		<h3>
			Cache Management</h3>
	</div>
	<div class="clearfix">
	<div class="clear_cache_block clearfix">
		<p>Frequently accessed data items are cached in memory. If data is changed by directly modifying the VerticalPlatform database 
		 without going through the admin application, you may have to clear the cache to make sure that updated data is fetched.</p>
		<asp:Button ID="btnClearCache" runat="server" OnClick="btnClearCache_Click" Text="Clear cache"
			CssClass="btn" />
	</div>
	<div class="clear_cache_block clearfix">
		<p>When the script optimizer is enabled it caches the optimized script in memory to improve performance. Clear the optimizer cache to 
		ensure all JavaScript and CSS files are read from disk.</p>
		<asp:Button ID="btnClearMinifierOutputCache" runat="server" OnClick="btnClearMinifierOutputCache_Click"
			Text="Clear script optimizer cache" CssClass="btn" />
	</div>
	</div>
	<div class="clear_cache_block clearfix">
		<p>Deletes the temporary files created when uploading images.</p>
		<asp:Button ID="btnClearTemporaryFolder" runat="server" Text="Clear temporary folder"
			OnClick="btnClearTemporaryFolder_Click" CssClass="btn" />
	</div>
	<div class="clear_cache_block clearfix">
		<p>Script optimizer adds a predefined key to all script and CSS requests. By changing this key you can invalidate any cached script or CSS the end users browser cache. </p>
		<asp:Button ID="btnRegenerate" runat="server" CssClass="btn" 
			Text="Regenerate script optimizer key" onclick="btnRegenerate_Click" />
	</div>
	<div class="clear_cache_block clearfix">
		<p>Removes the public application sitemap for the current site. This will result in recreating the sitemap in subsequent requests.
		When page details are updated through admin site, public application sitemap needs to be removed from application cache to recreate with 
		modified data. This is done when page details are updated. This process can be done  manually by clicking this button. </p>
		<asp:Button ID="btnRemoveSiteMapBuilder" runat="server" CssClass="btn" 
			Text="Remove site map for current site" onclick="btnRemoveSiteMapBuilder_Click" />
	</div>
	<div class="clear_cache_block clearfix">
		<p>Removes the public application sitemaps for all the sites. This will result in recreating the sitemaps for each site in subsequent requests.</p>
		<asp:Button ID="btnClearSiteMapBuilders" runat="server" CssClass="btn" 
			Text="Remove all site maps" onclick="btnClearSiteMapBuilders_Click" />
	</div>
</asp:Content>
