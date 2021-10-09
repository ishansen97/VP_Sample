<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CloneReviewForm.ascx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Reviews.CloneReviewForm" %>

<style type="text/css">
    .form-horizontal .control-group{margin-bottom:5px;}
</style>	
<div class="form-horizontal">
	<div class="control-group">
		<label class="control-label">Review Type</label>
		<div class="controls">
			<asp:DropDownList runat="server" ID="reviewTypeList">
			</asp:DropDownList>
		</div>
	</div>
</div>