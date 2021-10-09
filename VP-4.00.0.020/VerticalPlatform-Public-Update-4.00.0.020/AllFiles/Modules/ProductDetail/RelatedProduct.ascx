<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="RelatedProduct.ascx.cs" Inherits="VerticalPlatformWeb.Modules.RelatedProduct.RelatedProduct" %>
<%@ Register Src="../../Controls/Pager.ascx" TagName="Pager" TagPrefix="uc1" %>
<div id="divRelatedProduct" class="relatedProductModule module" runat="server">
<asp:Literal ID="ltlRelatedProduct" runat="server"></asp:Literal>
<div class = "pager module">
	<uc1:Pager ID="pgrRelatedProduct" runat="server" />
</div>
</div>