<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ProductListTab.ascx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Product.ProductListTab" %>
<%@ Register Src="../Pager.ascx" TagName="Pager" TagPrefix="uc1" %>

<asp:Label ID="lblTitle" runat="server"></asp:Label>

<div class="AdminPanelContent">
	<div class="author_srh_btn hide_icon">
		Filter</div>
	<br />
	<div id="divSearchPane" class="author_srh_pane" style="display: block;">
		<div class="form-horizontal">
			<div class="control-group">
				<label class="control-label"><asp:Literal ID="ltlProductName" runat="server" Text="Product Name"></asp:Literal></label>
				<div class="controls"><asp:TextBox ID="txtProductName" runat="server" MaxLength="255" Width="400px"></asp:TextBox></div>
			</div>
			<div class="control-group">
				<label class="control-label"><asp:Literal ID="ltlProductId" runat="server" Text="Product ID"></asp:Literal></label>
				<div class="controls"><asp:TextBox ID="txtProductId" runat="server" Width="192px"></asp:TextBox>
					<asp:RegularExpressionValidator ID="revProductId" runat="server" ControlToValidate="txtProductId"
						ErrorMessage="*" ValidationExpression="(\+)?[1-9][0-9]*" ValidationGroup="searchGroup"></asp:RegularExpressionValidator>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label"><asp:Literal ID="ltlCatalogNumber" runat="server" Text="Catalog Number"></asp:Literal></label>
				<div class="controls"><asp:TextBox ID="txtCatalogNumber" runat="server" MaxLength="255" Width="192px"></asp:TextBox></div>
			</div>
			<div class="control-group">
				<label class="control-label"><asp:Literal ID="ltlCategory" runat="server" Text="Category"></asp:Literal></label>
				<div class="controls"><asp:TextBox ID="txtCategoryId" runat="server" Width="192px"></asp:TextBox></div>
			</div>
			<div class="control-group">
				<label class="control-label"><asp:Literal ID="ltlVendor" runat="server" Text="Vendor"></asp:Literal></label>
				<div class="controls"><asp:TextBox runat="server" ID="txtVendorId" Width="192px"></asp:TextBox></div>
			</div>
			<div class="form-actions">
				<asp:Button ID="btnSearch0" runat="server" OnClick="btnSearch_Click" Text="Apply" ValidationGroup="searchGroup" CssClass="btn" />
				<asp:Button ID="btnShowAll" runat="server" OnClick="btnShowAll_Click" Text="Reset Filter" ValidationGroup="searchGroup" CssClass="btn" />
			</div>
		</div>
	</div>
	<br />
	<asp:Button ID="btnAddProduct" runat="server" OnClick="btnAddProduct_Click" Text="Add Product"
		Width="105px" CssClass="btn" />
	<br />
	<br />
	<asp:GridView ID="gvProducts" runat="server" AutoGenerateColumns="False" OnRowDataBound="gvProducts_RowDataBound"
		AllowSorting="True" OnSorting="gvProducts_Sorting" CssClass="common_data_grid table table-bordered" style="width:auto">
		<SelectedRowStyle HorizontalAlign="Left" />
		<AlternatingRowStyle CssClass="DataTableRowAlternate" />
		<RowStyle CssClass="DataTableRow" />
		<Columns>
			<asp:TemplateField>
				<ItemTemplate>
					<asp:ImageButton ID="ibtnProductEnable" runat="server" OnClick="ibtnProductEnable_Click"
						CssClass="enable_disable_button" />
				</ItemTemplate>
			</asp:TemplateField>
			<asp:BoundField HeaderText="Product Id" DataField="Id" SortExpression="Id"/>
			<asp:BoundField HeaderText="Catalog Number" DataField="CatalogNumber" SortExpression="CatalogNumber"/>
			<asp:TemplateField HeaderText="Quantity">
				<ItemTemplate>
					<asp:Literal runat="server" ID="ltlQuantity"></asp:Literal>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:BoundField HeaderText="Product Name" DataField="Name" SortExpression="Name"/>
			<asp:TemplateField HeaderText="Vendor Id">
				<ItemTemplate>
					<asp:Literal ID="ltlVendorId" runat="server" ></asp:Literal>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField HeaderText="Vendor Name">
				<ItemTemplate>
					<asp:Literal ID="ltlVendorName" runat="server"></asp:Literal>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:BoundField HeaderText="Created" DataField="Created" SortExpression="Created"  DataFormatString="{0:d}"/>
			<asp:BoundField HeaderText="Modified" DataField="Modified" SortExpression="Modified"  DataFormatString="{0:d}"/>
			<asp:TemplateField>
				<ItemTemplate>
					<asp:HyperLink ID="lnkMultimediaItem" runat="server" CssClass="aDialog">Multimedia</asp:HyperLink>
				</ItemTemplate>
				<ItemStyle/>
			</asp:TemplateField>
			<asp:TemplateField ItemStyle-Width="50">
				<ItemTemplate>
					<asp:HyperLink ID="lnkLeadForm" runat="server" CssClass="grid_icon_link form" ToolTip="Lead Form">Lead&nbsp;Form</asp:HyperLink>
					<asp:HyperLink ID="lnkEdit" runat="server" CssClass="grid_icon_link edit" ToolTip="Edit">Edit</asp:HyperLink>
				</ItemTemplate>
			</asp:TemplateField>
		</Columns>
		<EmptyDataTemplate>
			No Products Found.</EmptyDataTemplate>
	</asp:GridView>
	<br />
	<uc1:Pager ID="Pager1" runat="server"/>
	<br />
</div>