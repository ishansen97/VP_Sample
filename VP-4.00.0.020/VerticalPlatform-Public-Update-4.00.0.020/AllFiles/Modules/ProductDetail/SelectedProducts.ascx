<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SelectedProducts.ascx.cs" Inherits="VerticalPlatformWeb.Modules.ProductDetail.SelectedProducts" %>
<div id="selectedProducts">
  <div class="inner">
    <h5>Selected Products<span id="productCount"></span></h5>
    <div class="holder">
      <div class="noProductMessage">
        <span class="find">You haven't selected any products. <a href="#" class="find" title="Find Products">Find products</a>.</span>
        <span id="promptSpan" runat="server" class="select"></span>
      </div>
      <ul></ul>
      <div class="buttonSet">
        <asp:HyperLink ID="lnkSelProAction" runat="server" class="button">Get Quote</asp:HyperLink>
        <asp:HyperLink ID="lnkSelProCompare" runat="server" class="button">Compare</asp:HyperLink>
        <asp:HyperLink ID="clearSelectedProducts" runat="server" class="button" onclick="VP.SelectedProducts.ClearAll()">Clear All</asp:HyperLink>
        <asp:HiddenField ID="hdnCategoryId" runat="server" />
      </div>
    </div>
  </div>
</div>
<div class="selectedDivider"></div>
