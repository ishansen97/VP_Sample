<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ProductParameterDetail.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Product.ProductParameterDetail" %>
<%@ Register Src="~/ModuleAdmin/Product/MatrixElementDisplaySelector.ascx" TagName="MatrixElementDisplaySelector"
	TagPrefix="uc2" %>

<style type="text/css">
	.form-horizontal .control-group .control-label{width:200px;}
	.form-horizontal .control-group .controls{margin-left:220px;}
</style>

<script src="../../Js/JQuery/jquery-ui-timepicker-addon.js" type="text/javascript"></script>
<script type="text/javascript">
	$(document).ready(function () {
		$("input[type=text][id*=startDate]").datetimepicker();
		$("input[type=text][id*=endDate]").datetimepicker();
	});
</script>

<h4>Product Parameters</h4>
<div class="form-horizontal">
	<div class="control-group">
		<label class="control-label"><asp:Literal ID="ltlShowImage" runat="server" Text="Show Image in Compare Page"></asp:Literal></label>
		<div class="controls">
			<uc2:MatrixElementDisplaySelector ID="medsImage" runat="server" HideInheritedStatus="False" Enabled="True" /> 
		</div>
	</div>
	<div class="control-group">
		<label class="control-label" id="Show Image"><asp:Literal ID="ltlShowPrice" runat="server" Text="Show Price Information"></asp:Literal></label>
		<div class="controls">
			<uc2:MatrixElementDisplaySelector ID="medsPrice" runat="server" HideInheritedStatus="False" Enabled="True" /> 
		</div>
	</div>
	<div class="control-group">
		<label class="control-label"><asp:Label ID="lblShowRequestInformationLink" runat="server" Text="Show Request Information Link"></asp:Label></label>
		<div class="controls">
			<uc2:MatrixElementDisplaySelector ID="medsRequestInformationLink" runat="server" HideInheritedStatus="False" Enabled="True" /> 
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">Disable All Actions</label>
		<div class="controls">
			<uc2:MatrixElementDisplaySelector ID="medsDisableActionProduct" runat="server" Enabled="true" HideInheritedStatus="true" CurrentStatus="False" /> 
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">Permanantly Disabled</label>
		<div class="controls">
			<uc2:MatrixElementDisplaySelector ID="medsPermanantlyDisabledProduct" runat="server" Enabled="true" HideInheritedStatus="true" CurrentStatus="False" /> 
		</div>
	</div>
</div>
<h4>Enabled Date Range</h4>
<div class="form-horizontal">
	<div class="control-group">
		<label class="control-label">Start Date</label>
		<div class="controls">
			<asp:TextBox ID="startDate" runat="server"></asp:TextBox>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">End Date</label>
		<div class="controls">
			<asp:TextBox ID="endDate" runat="server"></asp:TextBox>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">Disabled Date</label>
		<div class="controls">
			<asp:TextBox ID="disabledDate" runat="server" Enabled="false"></asp:TextBox>
		</div>
	</div>
</div>
