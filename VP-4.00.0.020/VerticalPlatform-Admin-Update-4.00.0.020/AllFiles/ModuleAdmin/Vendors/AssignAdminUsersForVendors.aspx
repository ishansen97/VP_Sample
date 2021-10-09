<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" 
	CodeBehind="AssignAdminUsersForVendors.aspx.cs" 
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Vendors.AssignAdminUsersForVendors" %>

	<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
	
	<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>
	<script src="../../Js/JQuery/jquery.pager.js" type="text/javascript"></script>
	<script src="../../Js/ContentPicker.js" type="text/javascript"></script>

	<script type="text/javascript">
		$(document).ready(function() {
			var txtVendor = {contentId:"txtVendor"};
			var vendorNames = {siteId: VP.SiteId, type: "Vendor", currentPage: "1", pageSize: "15",
			showName: "true", enabled: "true", bindings: txtVendor};
			$("input[type=text][id*=txtVendor]").contentPicker(vendorNames);

		});
	</script>

	<div class="AdminPanel">	
		<div class="AdminPanelContent">
			<div class="AdminPanelHeader">
				<h3>Assign Vendors to Media Coordinators and Sales Persons</h3>
			</div>
				<div class="AdminPanelContent">
				<table width="900">
					<%--<tr>
						<td colspan="2" style="width:450;">
							Admin Users (Media Coordinators / Sales Persons)
							
						</td>
						<td colspan="2" style="padding-left:20px;width:450;">
							Vendors
						</td>
					</tr>--%>
					<tr>
						<td>
							Admin Users :
						</td>
						<td colspan="2">
							<asp:DropDownList ID="ddlAdminUsers" runat="server" AutoPostBack="true"
								onselectedindexchanged="ddlAdminUsers_SelectedIndexChanged" Width="250px"></asp:DropDownList>
							<asp:HiddenField ID="hdnAdminUser" runat="server" />
						</td>
						<td>
							Vendors :
						</td>
						<td >
							<asp:TextBox ID="txtVendor" runat="server" Width="255px"></asp:TextBox>
							<asp:HiddenField ID="hdnVendor" runat="server" />
						</td>
						<td>
							<asp:Button ID="btnAddVendor" runat="server" Text="Add Vendor"
								CssClass="btn" onclick="btnAddVendor_Click"/>
						</td>
					</tr>
					<tr>
						<td>
							Role Name(s) :
						</td>
						<td colspan="2">
							<asp:Literal ID="ltlSelectedAdminUsersRole" runat="server"></asp:Literal>
						</td>
						<td>
							
						</td>
						<td>
							<asp:ListBox ID="lstbSelectedVendors" runat="server" Width="270px"></asp:ListBox>
							<asp:HiddenField ID="hdnSelectedVendors" runat="server" />
							<asp:HiddenField ID="hdnRemovedVendors" runat="server" />
						</td>
						<td>
							<asp:Button ID="btnRemove" runat="server" Text="Remove" Width="100" 
								CssClass="btn" onclick="btnRemove_Click" />
						</td>
					</tr>
					<%--<tr>
						<td colspan="3"></td>
						<td colspan="3">
							<asp:Button ID="btnRemove" runat="server" Text="Remove" 
								CssClass="common_text_button" onclick="btnRemove_Click" />
						</td>
					</tr>--%>
					<tr>
						<td colspan="6">
							<asp:Button ID="btnSave" runat="server" Text="Save" 
								CssClass="btn" onclick="btnSave_Click" Width="100" />
							<asp:Button ID="btnClear" runat="server" Text="Clear" 
								CssClass="btn" onclick="btnClear_Click" Width="100" />
						</td>
					</tr>
				</table>
			</div>
			
		</div>
	</div>
</asp:Content>
