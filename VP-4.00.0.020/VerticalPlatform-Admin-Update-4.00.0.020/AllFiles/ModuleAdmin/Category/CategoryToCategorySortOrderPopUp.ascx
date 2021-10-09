<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CategoryToCategorySortOrderPopUp.ascx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Category.CategoryToCategorySortOrder" %>
<style type="text/css">
	.form-horizontal .control-group{margin-bottom:5px;}
</style>
<div class="inline-form-container">
	<div class="control-group">
		<label class="control-label">Sort Order</label>
		<asp:TextBox ID="sortOrder" runat="server" MaxLength="5"></asp:TextBox>
		<asp:CompareValidator ID="sortOrderValidator" ControlToValidate="sortOrder" ValueToCompare="0" Operator="GreaterThanEqual"
				Type="Integer" runat="server" Display="Dynamic" ErrorMessage="Sort Order value should be 0 or above">*</asp:CompareValidator>
		<asp:RequiredFieldValidator ID="sortOrderNullValidator" ControlToValidate="sortOrder" runat="server" Display="Dynamic" 
				ErrorMessage="Sort Order cannot be null">*</asp:RequiredFieldValidator>
	</div>
</div>

