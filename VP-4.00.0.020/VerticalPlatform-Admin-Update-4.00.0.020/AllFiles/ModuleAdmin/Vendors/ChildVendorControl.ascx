<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ChildVendorControl.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Vendors.ChildVendorControl" %>
<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>
<script src="../../Js/JQuery/jquery.pager.js" type="text/javascript"></script>
<script src="../../Js/ContentPicker.js" type="text/javascript"></script>
<script language="javascript" type="text/javascript">
	$(document).ready(function () {
		var txtChildVendors = { contentId: "txtChildVendors" };
		var vendorNameOptions = { siteId: VP.SiteId, type: "Vendor", currentPage: "1", pageSize: "15",
			showName: "true", enabled: "true", bindings: txtChildVendors, parentVendorOnly: "true"
		};
		$("input[type=text][id*=txtChildVendors]").contentPicker(vendorNameOptions);
	});
</script>
<h4>
	Child Vendor Associations</h4>
<div id="divChildVendorsData" runat="server">
	<div class="inline-form-content bottom-space">
		<div class="form-inline">
			<div>
				<div class="inline-form-container">
					<label>
						Child Vendor</label>
					<asp:TextBox ID="txtChildVendors" runat="server"></asp:TextBox>
					<asp:Button ID="btnAddChildVendors" runat="server" Text="Add" CssClass="btn" OnClick="btnAddChildVendors_Click" />
				</div>
			</div>
		</div>
	</div>
</div>
<br />
<asp:GridView ID="gvChildVendorList" runat="server" AutoGenerateColumns="false" CssClass="common_data_grid table table-bordered"
	OnRowCommand="gvChildVendorList_RowCommand" OnRowDataBound="gvChildVendorList_RowDataBound"
	Style="width: auto">
	<Columns>
		<asp:BoundField HeaderText="Id" SortExpression="Id" DataField="Id" ItemStyle-HorizontalAlign="Right" />
		<asp:TemplateField HeaderText="Vendor Name">
			<ItemTemplate>
				<asp:Label ID="lblVendorName" runat="server"></asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField ItemStyle-Width="30">
			<ItemTemplate>
				<asp:LinkButton ID="lbtnRemove" runat="server" CommandName="RemoveChildVendor" CssClass="deleteChild grid_icon_link delete"
					ToolTip="Remove" OnClientClick="return confirm('Are you sure to remove the child vendor?');">Remove</asp:LinkButton>
			</ItemTemplate>
		</asp:TemplateField>
	</Columns>
	<EmptyDataTemplate>
		No child vendors found.
	</EmptyDataTemplate>
</asp:GridView>
<br />
