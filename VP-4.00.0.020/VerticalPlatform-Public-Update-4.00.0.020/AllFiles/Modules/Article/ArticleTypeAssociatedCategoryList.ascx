<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ArticleTypeAssociatedCategoryList.ascx.cs"
Inherits="VerticalPlatformWeb.Modules.Article.ArticleTypeAssociatedCategoryList" %>
<%@ Register Src="../../Controls/Pager.ascx" TagName="Pager" TagPrefix="uc1" %>
	<div class="module articleTypeAssociatedCategoryModule">
	<div class="pageAndSort module">
		<uc1:Pager ID="pagerTop" runat="server" />
		<asp:Literal ID="sortSectionTopLiteral" runat="server"></asp:Literal>
	</div>
	<div class="categoryList">
		<asp:Literal ID="categoryListLiteral" runat="server"></asp:Literal>
	</div>
	<div class="pageAndSort module">
		<uc1:Pager ID="pagerBottom" runat="server" />
	</div>
</div>
