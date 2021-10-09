<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ArticleDetail.ascx.cs"
	Inherits="VerticalPlatformWeb.Modules.Articles.ArticleDetail" %>
<%@ Register Src="~/Controls/Pager.ascx" TagName="Pager" TagPrefix="uc2" %>
<div id="divArticleDetail" class="articleModule module" runat="server">	
	<div id="schemaData" class="schemaData" runat="server">
		<asp:PlaceHolder ID="phSchemaDataHolder" runat="server"></asp:PlaceHolder>
	</div>
	<div id="divArticleModule" class="articleModule module" runat="server">
	</div>
	<div id="divPaging" class="paging" runat="server">
	<uc2:Pager ID="PagerArticleDetail" runat="server"/>
	</div> 
	<div id="divComments" runat="server">
	</div>
</div>
