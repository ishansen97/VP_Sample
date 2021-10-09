<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="HorizontalSearchCategoryPanel.ascx.cs"
Inherits="VerticalPlatformWeb.Modules.ContentSearch.HorizontalSearchCategoryPanel" %>
<h3><asp:Literal ID="ltlSearchCategoryTitle" runat="server"></asp:Literal></h3>
<div id="divSearchPanel" class="tools horizontal">
	<div class="well refine tab-pane">
		<div class="searchRow textSearch">
			<div class="search">
				<input id="txtSearch" class="span2" type="text" />
				<asp:Literal ID="ltlCategoryInfo" runat="server"></asp:Literal>
			</div>
			<div class="selected-options">
			</div>
			<div class="inline-inputs">
				<asp:Literal ID="ltlSearchAspects" runat="server"></asp:Literal>
			</div>
			<input id="btnProductSearch" class="button search" type="button" value="Search"/> 
			<div class="buttonGroup">
				<a id="btnReset" class="reset" href="#" title="Reset the Search Values" name="btnReset">Clear</a>
			</div>
		</div>
		<asp:Literal ID="ltlSearchOptions" runat="server"></asp:Literal>
		<asp:Literal ID="ltlVendorFilter" runat="server"></asp:Literal>
		<div class="guided-options">
		</div>
	</div>
</div>
