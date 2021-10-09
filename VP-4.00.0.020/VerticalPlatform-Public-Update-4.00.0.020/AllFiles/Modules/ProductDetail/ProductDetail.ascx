<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ProductDetail.ascx.cs"
	Inherits="VerticalPlatformWeb.Modules.ProductDetail.ProductDetail" %>
<%@ Register Src="../../Controls/Tags.ascx" TagName="Tags" TagPrefix="uc1" %>
<%@ Register src="../Article/ContentArticleList.ascx" tagname="ContentArticleList" tagprefix="uc2" %>
<div class="productDetailModule module">
	<div class="productDetailHeader">
		<span class="productDetailHeaderImage" id="spanProductDetailHeaderImage" runat="server">
			<asp:Image id="imgProduct" runat="server" CssClass="productImage" />
			<asp:Literal ID="ltlRating" runat="server"></asp:Literal>
			<asp:HyperLink id="lnkCompanyProductPage" runat="server" Visible="False"><span class="productDetailHeaderImage">[lnkCompanyProductPage]</span></asp:HyperLink>
		</span>
	</div>
	<div id="requestInfoTop" runat="server">
	</div>
	<div id="relatedContent" class="relatedContent" runat="server">
		<asp:Literal ID="ltlRelatedContent" runat="server"></asp:Literal>
	</div>
	<asp:Table id="tblSpecification" CellSpacing="0" CellPadding="0" CssClass="productDetailTable"
		runat="server">
	</asp:Table>
	<div Id="productDetailCompare">
		<a class="button">Add To Compare List</a>
	</div>
	<uc1:Tags id="tagProduct" runat="server" />
	<uc2:ContentArticleList ID="productArticleList" runat="server" />
</div>
