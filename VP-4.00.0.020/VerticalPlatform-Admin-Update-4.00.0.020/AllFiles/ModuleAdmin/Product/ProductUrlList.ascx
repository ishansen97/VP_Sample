<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ProductUrlList.ascx.cs"
    Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Product.ProductUrlList" %>
<h4>
    Product Urls</h4>
<div class="add-button-container">
    <asp:HyperLink ID="lnkAddUrl" runat="server" CssClass="aDialog btn">Add Product Url</asp:HyperLink></div>
<asp:GridView ID="gvProductUrl" runat="server" AutoGenerateColumns="false" OnRowCommand="gvProductUrl_RowCommand"
    OnRowDataBound="gvProductUrl_RowDataBound" EnableViewState="false" CssClass="common_data_grid table table-bordered"
    Style="width: auto;">
    <Columns>
        <asp:TemplateField HeaderText="Location">
            <ItemTemplate>
                <asp:PlaceHolder ID="phProductUrlLocation" runat="server"></asp:PlaceHolder>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Display Text">
            <ItemTemplate>
                <asp:Label ID="lblUrlDisplayText" runat="server"></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField HeaderText="Url">
            <ItemTemplate>
                <asp:Label ID="lblUrl" runat="server"></asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
        <asp:TemplateField ItemStyle-Width="50">
            <ItemTemplate>
                <asp:HyperLink ID="lnkEdit" runat="server" CssClass="aDialog grid_icon_link edit"
                    ToolTip="Edit">Edit</asp:HyperLink>
                <asp:LinkButton ID="lbtnDelete" runat="server" CommandName="DeleteUrl" CssClass="grid_icon_link delete"
                    ToolTip="Delete">Delete</asp:LinkButton>
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
    <EmptyDataTemplate>
        No urls found for the product.
    </EmptyDataTemplate>
</asp:GridView>
