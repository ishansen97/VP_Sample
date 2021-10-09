<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="LeadSummaryControl.ascx.cs" 
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Vendors.LeadSummaryControl" %>

<div>
	<asp:GridView ID="gvLeadSummary" runat="server" AutoGenerateColumns="False" 
		CssClass="common_data_grid table table-bordered" onrowdatabound="gvLeadSummary_RowDataBound" style="width:auto;">
		<Columns>
			<asp:BoundField HeaderText="Action Id" DataField="ActionId" />
			<asp:BoundField HeaderText="Action Name" DataField="ActionName" />
			<asp:BoundField HeaderText="Number of Leads" DataField="LeadCount" />
			<asp:TemplateField ShowHeader="False">
				<ItemTemplate>
					<asp:HyperLink ID="lnkVendorLeads" runat="server">Leads</asp:HyperLink>
				</ItemTemplate>
				<ItemStyle HorizontalAlign="Left" />
			</asp:TemplateField>
		</Columns>
		<EmptyDataTemplate>
			No Leads found for vendor.
		</EmptyDataTemplate>
	</asp:GridView>
</div>