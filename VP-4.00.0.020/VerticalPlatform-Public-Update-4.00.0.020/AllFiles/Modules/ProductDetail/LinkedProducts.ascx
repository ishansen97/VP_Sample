<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="LinkedProducts.ascx.cs" Inherits="VerticalPlatformWeb.Modules.ProductDetail.LinkedProducts" %>
<div id = divLinkedProducts class="linkedProducts module">
    <asp:Literal ID="ltlLinkedProductHeader" runat="server"></asp:Literal>
    <asp:Table ID="tblLinkedProducts" CssClass="productDetailTable"
        runat="server">
    </asp:Table>
</div>
