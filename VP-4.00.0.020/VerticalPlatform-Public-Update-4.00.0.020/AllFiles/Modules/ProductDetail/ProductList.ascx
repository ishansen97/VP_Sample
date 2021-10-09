<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ProductList.ascx.cs" 
Inherits="VerticalPlatformWeb.Modules.ProductDetail.ProductList" %>
<%@ Register Src="../../Controls/Pager.ascx" TagName="Pager" TagPrefix="uc1" %>
<div class="module productListModule">
	<div class = "pageAndSort module">
		<uc1:Pager ID="pagerTop" runat="server" />
		<asp:Literal ID = "ltlSortSectionTop" runat="server"></asp:Literal>
	</div>
		
	<div class="productList">
		<asp:Literal ID="ltlProductList" runat="server"></asp:Literal>
	</div>
	
	<div class="actionHolder bottom module">
		<div class = "pageAndSort module">
			<uc1:Pager ID="pagerBottom" runat="server" />
		</div>
	</div>
</div>
