<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SearchCategoryPanel.ascx.cs" 
Inherits="VerticalPlatformWeb.Modules.ContentSearch.SearchCategoryPanel" %>
<h3><asp:Literal ID="ltlSearchCategoryTitle" runat="server"></asp:Literal></h3>
<div id="divSearchPanel" class="tools vertical">
	<div class="well refine tab-pane">
		<div class="searchRow textSearch">
			<div class="search">
				<input id="txtSearch" runat="server" class="span2 txtSearch" type="text" />
				<asp:Literal ID="ltlCategoryInfo" runat="server"></asp:Literal>
				<input id="btnProductSearch" runat="server" class="button search btnProductSearch" type="button" value="Search"/>
			    <div class="buttonGroup">
			        <a id="btnReset" class="reset btnReset" runat="server" href="#" title="Reset the Search Values" name="btnReset">Clear</a>
			    </div>
			</div>
			<div class="selected-options">
			</div>
			<div class="inline-inputs">
				<asp:Literal ID="ltlSearchAspects" runat="server"></asp:Literal>
			</div>
		</div>
		<asp:Literal ID="ltlAppliedFilters" runat="server"></asp:Literal>
		<asp:Literal ID="ltlSearchOptions" runat="server"></asp:Literal>
		<asp:Literal ID="ltlVendorFilter" runat="server"></asp:Literal>
		<input id="btnProductSearchBottom" runat="server" class="button search btnProductSearchBottom" type="button" value="Search"/> 
		<div class="guided-options">
		</div>
	</div>
</div>
