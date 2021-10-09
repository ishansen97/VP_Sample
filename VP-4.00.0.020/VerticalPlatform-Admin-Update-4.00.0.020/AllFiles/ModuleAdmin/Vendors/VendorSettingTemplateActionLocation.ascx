<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="VendorSettingTemplateActionLocation.ascx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Vendors.VendorSettingTemplateActionLocation" %>

<div>
	<asp:GridView ID="leadActionsGrid" runat="server" AutoGenerateColumns="False" OnRowDataBound="leadActionsGrid_RowDataBound"
		CssClass="common_data_grid table table-bordered" Style="width: 400px;">
		<Columns>
			<asp:TemplateField HeaderText="Lead Type" ItemStyle-Width="130">
				<ItemTemplate>
					<asp:Literal ID="actionTitleLiteral" runat="server"></asp:Literal>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField HeaderText="Locations">
				<ItemTemplate>
					<div id="locations" runat="server" visible = "false">
						<strong>
							<asp:Label id="locationsString" runat ="server"></asp:Label>
						</strong>
						<asp:HyperLink ID="editLink" CssClass="aDialog grid_icon_link no_float edit_content" runat="server" 
								Text="Edit" ToolTip="Edit"></asp:HyperLink>
					</div>
					<div id="noLocations" runat="server" visible = "false">
						<asp:HyperLink ID="addLocationsLink" runat="server" CssClass="aDialog" Text = "Add Locations"></asp:HyperLink>
					</div>
				</ItemTemplate>
			</asp:TemplateField>
		</Columns>
		<EmptyDataTemplate>No Lead actions found.</EmptyDataTemplate>
	</asp:GridView>
</div>
