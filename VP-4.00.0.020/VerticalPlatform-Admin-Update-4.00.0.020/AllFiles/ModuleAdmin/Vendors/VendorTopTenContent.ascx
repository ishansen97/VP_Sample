<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="VendorTopTenContent.ascx.cs" 
		Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Vendors.VendorTopTenContent" %>

<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>
<script src="../../Js/JQuery/jquery.pager.js" type="text/javascript"></script>
<script src="../../Js/ContentPicker.js" type="text/javascript"></script>

<script type="text/javascript" language="javascript">

	function GetQueryStringParamsForVendor(sParam) {
		var sPageURL = window.location.search.substring(1);
		var sURLVariables = sPageURL.split('&');
		for (var i = 0; i < sURLVariables.length; i++) {
			var sParameterName = sURLVariables[i].split('=');
			if (sParameterName[0] == sParam) {
				return sParameterName[1];
			}
		}
		return null;
	}

	$(document).ready(function () {
		RegisterNamespace("VP.VendorTop10Management");
		var vendorIdValue = GetQueryStringParamsForVendor('vid');
		var element = $("#<%=contentTypeddl.ClientID %>");
		var options = { siteId: VP.SiteId, currentPage: "1", pageSize: "10", getFixUrl: "false", externalType: "true", typeElement: element, vendorId: vendorIdValue };
		$("input[type=text][id*=contentIdText]").contentPicker(options);
	});
</script>

<div>
	<div class="form-horizontal">
		<div class="control-group">
			<label class="control-label">Content Type</label>
				<div class="controls">
					<asp:DropDownList ID="contentTypeddl" runat="server" Width="145">
					</asp:DropDownList>
				</div>
		</div>
		<div class="control-group">
			<label class="control-label">Content Id</label>
			<div class="controls">
				<asp:TextBox ID="contentIdText" runat="server" Width="145"></asp:TextBox>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">Sort Order</label>
			<div class="controls">
				<asp:TextBox ID="sortOrderText" runat="server" Width="145"></asp:TextBox>
				<asp:RequiredFieldValidator ID="vendorTopContentSortOrderRequired" runat="server" ControlToValidate="sortOrderText" ErrorMessage="Please enter a value for sort order." ValidationGroup="AssociateContent">*</asp:RequiredFieldValidator>
				<asp:CompareValidator ID="vendorTopContentSortOrderNumberValidation" runat="server" ErrorMessage="Sort order should be a numeric value."
					ControlToValidate="sortOrderText" Type="Integer" Operator="DataTypeCheck" Display="Dynamic">*</asp:CompareValidator>
			</div>
		</div>
	</div>
</div>


