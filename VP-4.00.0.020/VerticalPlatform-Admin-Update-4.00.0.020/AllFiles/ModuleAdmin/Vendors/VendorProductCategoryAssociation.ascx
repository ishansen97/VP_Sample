<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="VendorProductCategoryAssociation.ascx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Vendors.VendorProductCategoryAssociation" %>
<script language="javascript" type="text/javascript">

	function GetQueryStringParams(sParam) { 
		var sPageURL = window.location.search.substring(1);
		var sURLVariables = sPageURL.split('&');
		for (var i = 0; i < sURLVariables.length; i++) 
		{
			var sParameterName = sURLVariables[i].split('=');
			if (sParameterName[0] == sParam) 
			{
				return sParameterName[1];
			}
		}
		return null;
	}

	$(document).ready(function () {
		RegisterNamespace("VP.VendorProductCategory");
		var vendorId = GetQueryStringParams('vid');
		var categoryFilterOptions = { siteId: VP.SiteId, type: "Category", currentPage: "1", pageSize: "15", vendorId: vendorId };
		$("input[type=text][id*=associatedCategoryId]").contentPicker(categoryFilterOptions);
	});
</script>

<div class="form-horizontal">
	<div class="control-group">
		<label class="control-label">Category Id</label>
		<div class="controls">
			<asp:TextBox runat="server" ID="associatedCategoryId"></asp:TextBox>
			<asp:RequiredFieldValidator ID="associatedCategoryIdValidator" runat="server" ErrorMessage="Please enter a category id."
					ControlToValidate="associatedCategoryId" SetFocusOnError="true" >*</asp:RequiredFieldValidator>
			<asp:CompareValidator ID="associatedCategoryIdCompareValidator" runat="server" Operator="DataTypeCheck" Type="Integer" 
					ControlToValidate="associatedCategoryId" ErrorMessage="Category ID must be a number." 
					SetFocusOnError="true" >*</asp:CompareValidator>
		</div>
	</div>
	 <div class="control-group">
		<label class="control-label">Sort Order</label>
		<div class="controls">
			<asp:TextBox runat="server" ID="sortOrderInput"></asp:TextBox>
			<asp:RequiredFieldValidator ID="sortOrderValidator" runat="server" ErrorMessage="Please enter a sort order."
					ControlToValidate="sortOrderInput">*</asp:RequiredFieldValidator>
			<asp:CompareValidator ID="sortOrderCompareValidator" runat="server" ControlToValidate="sortOrderInput" 
					Operator="GreaterThanEqual" Type="Integer" SetFocusOnError="true" ValueToCompare="0" 
					ErrorMessage="Invalid Sort Order.">*</asp:CompareValidator>
		</div>
	</div>
</div>