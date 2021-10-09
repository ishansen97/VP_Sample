<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AssociateVendors.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Category.AssociateVendors" %>
<%@ Register Src="../../Controls/ContentList.ascx" TagName="ContentList" TagPrefix="uc2" %>

	<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>
	
	<script src="../../Js/JQuery/jquery.pager.js" type="text/javascript"></script>

	<script src="../../Js/ContentPicker.js" type="text/javascript"></script>
	
	<script type="text/javascript">
		RegisterNamespace("VP.AssociateVendors");

		VP.AssociateVendors.Initialize = function() {
		$(document).ready(function() {
			var hdnVendorId ={contentId : "hdnVendorId"};
			var vendorNameOptions = { siteId: VP.SiteId, type: "Vendor", currentPage: "1", pageSize: "15", showName: "true", bindings : hdnVendorId };
				$("#PopupControl_txtVendorName").contentPicker(vendorNameOptions);
			});
		}

		VP.AssociateVendors.Initialize();
	</script>
<table width="400">
	<tr>
		<td width="40">
			Vendor
		</td>
		<td>
			<asp:TextBox ID = "txtVendorName" runat ="server" Width="150" /> 
			<asp:HiddenField ID="hdnVendorId" runat="server" />
		</td>
	</tr>
	<tr>
		<td colspan="2">
		<br />
			<asp:LinkButton ID="lbtnAdd" runat="server" onclick="lbtnAdd_Click" CssClass="common_text_button">Add</asp:LinkButton><br /></td>
	
	</tr>
	<tr>
		<td colspan="2">
			<asp:Label ID="lblMessage" runat="server"></asp:Label>
		</td>
	</tr>
	<tr>
		<td colspan="2">
		<br />
			<asp:GridView ID="gvVendors" runat="server" AutoGenerateColumns="False" OnRowCommand="gvVendors_RowCommand"
				OnRowDataBound="gvVendors_RowDataBound" CssClass="common_data_grid" style="width:400px">
				<Columns>
					<asp:TemplateField HeaderText="Vendor Name">
						<ItemTemplate>
							<asp:Literal ID="ltlVendorName" runat="server"></asp:Literal>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField ItemStyle-Width="30">
						<ItemTemplate>
							<asp:LinkButton ID="lbtnDelete" runat="server" Text="Delete" CommandName="DeleteVendor" CssClass="grid_icon_link delete" ToolTip="Delete"></asp:LinkButton>
						</ItemTemplate>
					</asp:TemplateField>
				</Columns>
			</asp:GridView>
		</td>
	</tr>
</table>
