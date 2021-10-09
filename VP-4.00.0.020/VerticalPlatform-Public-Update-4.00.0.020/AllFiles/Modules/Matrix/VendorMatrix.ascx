<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="VendorMatrix.ascx.cs"
	Inherits="VerticalPlatformWeb.Modules.Matrix.VendorMatrix" %>
<div class="matrixModule">
	<div class="vendorMatrixModule module">
		<asp:GridView id="gvVendors" runat="server" AutoGenerateColumns="False" OnRowDataBound="gvVendors_RowDataBound"
			CssClass="dataGrid">
			<Columns>
				<asp:TemplateField HeaderText="Name">
					<ItemTemplate>
						<asp:Literal id="ltlVendorNames" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"Vendor.Name") %>'></asp:Literal>
					</ItemTemplate>
					<HeaderTemplate>
						<asp:HyperLink id="lnkVendorName" runat="server" CssClass="dataGridHeaderLinkText">Name</asp:HyperLink>
					</HeaderTemplate>
					<HeaderStyle CssClass="dataGridHeader" />
					<ItemStyle CssClass="nameColumn" />
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Address">
					<ItemTemplate>
						<asp:Literal id="ltlVendorAddress" runat="server"></asp:Literal>
					</ItemTemplate>
					<HeaderStyle CssClass="dataGridHeader" />
					<ItemStyle CssClass="addressColumn" />
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Phone">
					<ItemTemplate>
						<asp:Literal id="ltlVendorPhone" runat="server"></asp:Literal>
					</ItemTemplate>
					<HeaderStyle CssClass="dataGridHeader" />
					<ItemStyle CssClass="phoneColumn" />
				</asp:TemplateField>
			</Columns>
		</asp:GridView>
	</div>
</div>
