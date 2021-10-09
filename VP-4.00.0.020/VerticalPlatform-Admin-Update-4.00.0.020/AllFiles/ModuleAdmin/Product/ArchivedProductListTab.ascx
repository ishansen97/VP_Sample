<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ArchivedProductListTab.ascx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Product.ArchivedProductListTab" %>
<%@ Register Src="../Pager.ascx" TagName="Pager" TagPrefix="uc1" %>

<asp:Label ID="lblTitle" runat="server"></asp:Label>

<div class="AdminPanelContent">
    <div class="author_srh_btn hide_icon">
        Filter
    </div>
    <br />
    <div id="divSearchPane" class="author_srh_pane" style="display: block;">
        <div class="form-horizontal">
            <div class="control-group">
                <label class="control-label">
                    <asp:Literal ID="ltlProductName" runat="server" Text="Product Name"></asp:Literal></label>
                <div class="controls">
                    <asp:TextBox ID="txtArchivedProductName" runat="server" MaxLength="255" Width="400px"></asp:TextBox>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">
                    <asp:Literal ID="ltlProductId" runat="server" Text="Product Id"></asp:Literal></label>
                <div class="controls">
                    <asp:TextBox ID="txtProductId" runat="server" Width="192px"></asp:TextBox>
                    <asp:RegularExpressionValidator ID="revProductId" runat="server" ControlToValidate="txtProductId"
                        ErrorMessage="*" ValidationExpression="(\+)?[1-9][0-9]*" ValidationGroup="searchGroup"></asp:RegularExpressionValidator>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">
                    <asp:Literal ID="ltlCatelogNumber" runat="server" Text="Catalog Number"></asp:Literal></label>
                <div class="controls">
                    <asp:TextBox ID="txtCatelogNumber" runat="server" Width="192px"></asp:TextBox>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">
                    <asp:Literal ID="ltlVendor" runat="server" Text="Vendor ID"></asp:Literal></label>
                <div class="controls">
                    <asp:TextBox runat="server" ID="txtVendorId" Width="192px"></asp:TextBox>
                    <asp:RegularExpressionValidator ID="revVendorId" runat="server" ControlToValidate="txtVendorId"
                        ErrorMessage="*" ValidationExpression="(\+)?[1-9][0-9]*" ValidationGroup="searchGroup"></asp:RegularExpressionValidator>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">
                    <asp:Literal ID="ltlCategory" runat="server" Text="Category"></asp:Literal></label>
                <div class="controls">
                    <asp:TextBox ID="txtCategoryId" runat="server" Width="192px"></asp:TextBox>
                </div>
            </div>
            <div class="form-actions">
                <asp:Button ID="btnfilter" runat="server" OnClick="btnArchiveSearch_Click" Text="Apply" ValidationGroup="searchGroup" CssClass="btn" />
                <asp:Button ID="btnReset" runat="server" OnClick="btnResetAll_Click" Text="Reset" CssClass="btn" />
            </div>
        </div>
    </div>
    <br />
    <asp:GridView ID="gvProducts" runat="server" AutoGenerateColumns="False" AllowSorting="False" 
		DataKeyNames="Id" CssClass="common_data_grid table table-bordered" Style="width: 100%" OnRowDataBound="gvProducts_RowDataBound">
        <SelectedRowStyle HorizontalAlign="Left" />
        <AlternatingRowStyle CssClass="DataTableRowAlternate" />
        <RowStyle CssClass="DataTableRow" />
        <Columns>
            <asp:BoundField HeaderText="Product ID" DataField="ProductId" SortExpression="ProductId" />
            <asp:BoundField HeaderText="Catalog Number" DataField="CatalogNumber" SortExpression="CatalogNumber" />
            <asp:TemplateField HeaderText="Quantity">
				<ItemTemplate>
					<asp:Literal runat="server" ID="ltlQuantity"></asp:Literal>
				</ItemTemplate>
			</asp:TemplateField>
            <asp:BoundField HeaderText="Product Name" DataField="ProductName" SortExpression="ProductName" />
			<asp:BoundField HeaderText="Vendor ID" DataField="VendorId" SortExpression="VendorId" />
			<asp:TemplateField HeaderText="Restore As a Hidden Product">
                <ItemTemplate>
                    <asp:CheckBox ID="chkRestoreHidden" runat="server" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Restore">
                <ItemTemplate>
                    <asp:ImageButton ID="btnProductRestore" runat="server" OnClick="btnRestore_Click" CssClass="enable_disable_button" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    <br />
    <uc1:Pager ID="ArchiveListPager" runat="server" />
    <br />
</div>
