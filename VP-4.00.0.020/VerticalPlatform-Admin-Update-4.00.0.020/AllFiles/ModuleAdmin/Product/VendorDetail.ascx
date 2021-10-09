<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="VendorDetail.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Product.VendorDetail" %>
<h4>Add Vendors to the Product</h4>
<div class="add-button-container">
    <asp:HyperLink ID="lnkAddVendor" runat="server" CssClass="aDialog btn">Add Vendor</asp:HyperLink>
</div>
		<asp:GridView ID="gvVendors" runat="server" AutoGenerateColumns="False" 
			Width="100%" OnRowDataBound="gvVendors_RowDataBound" CssClass="common_data_grid vender_details table table-bordered"
			EnableViewState="false" onrowcommand="gvVendors_RowCommand">
			<Columns>
			    <asp:TemplateField HeaderText="Vendor Id">
					<ItemTemplate>
						<asp:Literal ID="ltlVendorId" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"Vendor.Id") %>'></asp:Literal>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Vendor Name">
					<ItemTemplate>
						<asp:Literal ID="ltlVendor" runat="server"></asp:Literal>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Manufacturer" ItemStyle-HorizontalAlign="Center">
					<ItemTemplate>
						<asp:CheckBox ID="chkManufacturer" runat="server" Checked='<%# DataBinder.Eval(Container.DataItem,"ProductVendor.IsManufacturer") %>'
							Enabled="False" />
					</ItemTemplate>
					<ItemStyle HorizontalAlign="Center"></ItemStyle>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Seller" ItemStyle-HorizontalAlign="Center">
					<ItemTemplate>
						<asp:CheckBox ID="chkSeller" runat="server" Checked='<%# DataBinder.Eval(Container.DataItem,"ProductVendor.IsSeller") %>'
							Enabled="False" />
					</ItemTemplate>
					<ItemStyle HorizontalAlign="Center"></ItemStyle>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Price" ItemStyle-CssClass="price">
					<ItemTemplate>
						<asp:HyperLink ID="lnkAddPrice" runat="server" CssClass="aDialog">Add Price</asp:HyperLink>
						<asp:PlaceHolder ID="phPrice" runat="server"></asp:PlaceHolder>
					</ItemTemplate>
					<ItemStyle HorizontalAlign="Right" />
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Lead Enabled" ItemStyle-HorizontalAlign="Center">
					<ItemTemplate>
						<asp:CheckBox ID="chkLeadEnabled" runat="server" Checked='<%# DataBinder.Eval(Container.DataItem,"ProductVendor.LeadEnabled") %>'
							Enabled="False" />
					</ItemTemplate>
					<ItemStyle HorizontalAlign="Center"></ItemStyle>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Show Secondary Lead Button" ItemStyle-HorizontalAlign="Center">
					<ItemTemplate>
						<asp:CheckBox ID="chkShowGetQuote0" runat="server" Checked='<%# DataBinder.Eval(Container.DataItem,"ProductVendor.ShowGetQuote") %>'
							Enabled="False" />
					</ItemTemplate>
					<ItemStyle HorizontalAlign="Center"></ItemStyle>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Enabled" ItemStyle-HorizontalAlign="Center">
					<ItemTemplate>
						<asp:CheckBox ID="chkEnabled" runat="server" Checked='<%# DataBinder.Eval(Container.DataItem,"ProductVendor.Enabled") %>'
							Enabled="False" />
					</ItemTemplate>
					<ItemStyle Width="60px" />
				</asp:TemplateField>
				<asp:TemplateField ShowHeader="False" ItemStyle-Width="50">
					<ItemTemplate>
						<asp:HyperLink ID="lnkEdit" runat="server" CssClass="aDialog grid_icon_link edit" ToolTip="Edit">Edit</asp:HyperLink>
						<asp:LinkButton ID="lbtnRemove" runat="server" CausesValidation="False" CommandName="DeleteVendorAssociation"
							OnClientClick="return confirm(&quot;Are you sure you want to remove this vendor&quot;);"
							Text="Remove" CssClass="grid_icon_link delete" ToolTip="Remove"></asp:LinkButton>
					</ItemTemplate>
				</asp:TemplateField>
			</Columns>
			<HeaderStyle HorizontalAlign="Center" />
		</asp:GridView>
		
