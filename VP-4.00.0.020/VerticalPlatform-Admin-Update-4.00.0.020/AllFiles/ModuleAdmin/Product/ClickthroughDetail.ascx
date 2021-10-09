<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ClickthroughDetail.ascx.cs"
    Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Product.ClickthroughDetail" %>
<div>
    <asp:GridView ID="gvClickthrough" runat="server" AutoGenerateColumns="False" OnRowDataBound="gvClickthrough_RowDataBound"
        CssClass="common_data_grid clickthrough_details table table-bordered" Style="width: 400px;"
        OnRowCommand="gvClickthrough_RowCommand">
        <Columns>
            <asp:TemplateField HeaderText="Clickthrough Type" ItemStyle-Width="130">
                <ItemTemplate>
                    <asp:Literal ID="ltlActionTitle" runat="server"></asp:Literal>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Clickthrough Url">
                <ItemTemplate>
                    <asp:HyperLink ID="lnkAddLocation" runat="server" CssClass="aDialog">Add Clickthrough URL</asp:HyperLink>
                    <asp:PlaceHolder ID="phUrlLocations" runat="server"></asp:PlaceHolder>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
        <EmptyDataTemplate>
            No Clickthrough actions found.</EmptyDataTemplate>
    </asp:GridView>
</div>
