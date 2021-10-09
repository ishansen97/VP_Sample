<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ModelProduct.ascx.cs" Inherits="VerticalPlatformWeb.Modules.ProductDetail.ModelProduct" %>
<%@ Register Src="../../Controls/Pager.ascx" TagName="Pager" TagPrefix="uc1" %>
<div id="divModelProduct" class="modelProductModule module" runat="server">
<asp:Literal ID="ltlModelProduct" runat="server"></asp:Literal>
    <asp:Table ID="tblModelProducts" CellSpacing="0" CellPadding="0" CssClass="productDetailTable"
        runat="server">
    </asp:Table>
</div>