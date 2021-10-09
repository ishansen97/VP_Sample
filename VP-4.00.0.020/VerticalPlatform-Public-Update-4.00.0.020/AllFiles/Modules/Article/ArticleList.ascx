<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ArticleList.ascx.cs"
	Inherits="VerticalPlatformWeb.Modules.Articles.ArticleList" %>
<%@ Register Src="../../Controls/Pager.ascx" TagName="Pager" TagPrefix="uc1" %>
<div class="articleModule" id="divArticleModule" runat="server">
	<a id="lnkScrollPosition" runat="server"></a>
	<div class="filter module" id="divArticleFilter" runat="server">
		<h4>Filter</h4>
		<a id="filterHeader" class="filterHeader">Hide Filter</a>
		<div id="filterBody" class="filterBody">
			<div class="categories" id="categoryFilterDiv" runat="server">
				<asp:DropDownList ID="ddlCategory" runat="server" CssClass="dropdownList">
				</asp:DropDownList>
			</div>
			<div class="vendors" id="vendorFilterDiv" runat="server">
				<asp:DropDownList ID="ddlVendors" runat="server" CssClass="dropdownList">
				</asp:DropDownList>
			</div>
			<div class="custom" id="divCustomPropertyFilter" runat="server">
			
			</div>
			<div class="filterButtons">
				<input type="button" id="btnFilter" class="button" value="Filter" />
				<input type="button" id="btnReset" class="button" value="Reset" />
			</div>
		</div>
	</div>
	<div class="sorting module" id="divArticleSorting" runat="server">
	<h4>Sort</h4>
		
	</div>
	<uc1:Pager ID="PagerArticleListTop" runat="server" />
	<div class="articleList module">
		<asp:Label ID="lblMessage" runat="server" CssClass="errorMessage"></asp:Label>
		<asp:PlaceHolder ID="phArticle" runat="server"></asp:PlaceHolder>
	</div>
	<div class="viewMoreLink" id="divViewMoreLink" runat="server">
	</div>
	<uc1:Pager ID="PagerArticleList" runat="server" />
</div>
