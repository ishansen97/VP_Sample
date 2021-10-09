<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ReviewFormSettings.ascx.cs" Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.ReviewFormSettings" %>

<style type="text/css">
		.form-horizontal .control-group{margin-bottom:5px;}
</style>

<div class="form-horizontal">

    <div class="control-group">
		<label class="control-label">Create User For Author</label>
        <div class="controls">
            <span class="checkbox inline"><asp:CheckBox ID="createUserForAuthorCheckbox" Checked="false" runat="server"/></span>
			<asp:HiddenField ID="hiddenCreateUserForAuthor" runat="server" />
        </div>
	</div>
 
</div>