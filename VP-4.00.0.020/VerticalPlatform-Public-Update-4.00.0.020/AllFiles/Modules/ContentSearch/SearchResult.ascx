<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SearchResult.ascx.cs"
	Inherits="VerticalPlatformWeb.Modules.ContentSearch.SearchResult" %>
<div class="searchResultsModule">
	<asp:Literal ID="bookmarkLink" runat="server"></asp:Literal>
	<div class="searchResultGroup module">
		<asp:Literal ID="ltlSearchResults" runat="server"></asp:Literal>
		<input type="button" id="btnViewAll" value="More..." class="button viewAll" runat="server"
			visible="false" />
		<div id="moreResultContent" style="display: none" class="moreResults" runat="server">
			<asp:Literal ID="ltlMoreSearchResult" runat="server"></asp:Literal>
		</div>
	</div>
</div>
