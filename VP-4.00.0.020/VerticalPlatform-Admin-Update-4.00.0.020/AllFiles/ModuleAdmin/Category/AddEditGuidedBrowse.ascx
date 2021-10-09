<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddEditGuidedBrowse.ascx.cs"
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Category.AddEditGuidedBrowse" %>
<style type="text/css">
	.form-horizontal  .control-group{margin-bottom:5px;}
</style>
<div class="form-horizontal">
	<div class="control-group">
		<label class="control-label">Guided Browse Name</label>
		<div class="controls">
			<asp:TextBox ID="txtGuidedBrowseName" runat="server" ></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvGuidedBrowseName" runat="server" ErrorMessage="Please enter guided browse name."
				ControlToValidate="txtGuidedBrowseName">*</asp:RequiredFieldValidator>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">Guided Browse Prefix</label>
		<div class="controls">
			<asp:TextBox ID="txtGuidedBrowsePrefix" runat="server"></asp:TextBox>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">Guided Browse Suffix</label>
		<div class="controls">
			<asp:TextBox ID="txtGuidedBrowseSuffix" runat="server" ></asp:TextBox>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">Naming Rule</label>
		<div class="controls">
			<asp:TextBox ID="txtGuidedBrowseNamingRule" runat="server"></asp:TextBox>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">Page Size</label>
		<div class="controls">
			<asp:TextBox ID="txtGuidedBrowsePageSize" runat="server"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvGuidedBrowsePageSize" runat="server" ErrorMessage="Please enter page size."
				ControlToValidate="txtGuidedBrowsePageSize">*</asp:RequiredFieldValidator>
				<asp:CompareValidator ID="cvNumberOfResultsPerPageGreater" ControlToValidate="txtGuidedBrowsePageSize" Operator="GreaterThan" Type="Integer" ValueToCompare="1" runat="server" ErrorMessage="You must enter a number greater than 1">*</asp:CompareValidator>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">Sort Order</label>
		<div class="controls">
			<asp:TextBox ID="txtGuidedBrowseSortOrder" runat="server"></asp:TextBox>
			<asp:RegularExpressionValidator ControlToValidate="txtGuidedBrowseSortOrder" ValidationExpression="^\d+$"
					ID="revGuidedBrowseSortOrder" runat="server" ErrorMessage="Please enter a numeric value for Sort Order.">*</asp:RegularExpressionValidator>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">Starting Method</label>
		<div class="controls">
			<asp:DropDownList ID="ddlStartingMethod" runat="server"></asp:DropDownList>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">Include in Sitemap</label>
		<div class="controls">
			<asp:CheckBox ID="chkIncludeInSitemap" runat="server" Checked="true"/>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">Enabled</label>
		<div class="controls">
			<asp:CheckBox ID="chkEnabled" runat="server" Checked="true"/>
		</div>
	</div>
</div>
