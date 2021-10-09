<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ContentSharingSettings.ascx.cs" Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.ContentSharingSettings" %>

<script type="text/javascript">
	$(document).ready(function () {
		if ($(".contentTypes").val() === "7") {
			$('.getCurrentUrlCheckBox > input').removeAttr('disabled');
		} else {
			$('.getCurrentUrlCheckBox > input').attr('disabled', 'disabled');
		}
		
		$(".contentTypes").change(function () {
			if ($(".contentTypes").val() === "7") {
				$('.getCurrentUrlCheckBox > input').removeAttr('disabled');
			} else {
				$('.getCurrentUrlCheckBox > input').attr('disabled', 'disabled');
			}
		});
	});
</script>

<style type="text/css">
		.form-horizontal .control-group{margin-bottom:5px;}
</style>

<div class="form-horizontal">
	<div class="control-group">
		<label class="control-label">Sharing Content Type</label>
		<div class="controls">
			<span class="checkbox inline">
				<asp:DropDownList ID="contentTypesList" CssClass="contentTypes" runat="server"></asp:DropDownList>
			</span>
			<asp:HiddenField ID="contentTypeListHidden" runat="server" />
		</div>
	</div>

	<div class="control-group">
		<label class="control-label">Use Current URL</label>
        <div class="controls">
			<span class="checkbox inline"><asp:CheckBox ID="enableGetCurrentUrl" class="getCurrentUrlCheckBox" Checked="false" runat="server"/></span>
			<asp:HiddenField ID="hiddenEnableGetCurrentUrl" runat="server" />
        </div>
	</div>


    <div class="control-group">
		<label class="control-label">Enable Print</label>
        <div class="controls">
            <span class="checkbox inline"><asp:CheckBox ID="enablePrint" Checked="false" runat="server"/></span>
			<asp:HiddenField ID="hiddenEnablePrint" runat="server" />
        </div>
	</div>
    <div class="control-group">
		<label class="control-label">Enable Comment</label>
        <div class="controls">
            <span class="checkbox inline"><asp:CheckBox ID="enableComment" Checked="false" runat="server"/></span>
			<asp:HiddenField ID="hiddenEnableComment" runat="server" />
        </div>
	</div>
	<div class="control-group">
		<label class="control-label">Share via Email</label>
        <div class="controls">
            <span class="checkbox inline"><asp:CheckBox ID="shareViaEmail" Checked="false" runat="server"/></span>
			<asp:HiddenField ID="hiddenShareViaEmail" runat="server" />
        </div>
	</div>
    <div class="control-group">
		<label class="control-label">Share on Linkedin</label>
        <div class="controls">
            <span class="checkbox inline"><asp:CheckBox ID="shareOnLinkedin" Checked="false" runat="server"/></span>
			<asp:HiddenField ID="hiddenShareOnLinkedin" runat="server" />
        </div>
	</div>
	<div class="control-group">
		<label class="control-label">Share on Twitter</label>
        <div class="controls">
            <span class="checkbox inline"><asp:CheckBox ID="shareOnTwitter" Checked="false" runat="server"/></span>
			<asp:HiddenField ID="hiddenShareOnTwitter" runat="server" />
        </div>
	</div>
	<div class="control-group">
		<label class="control-label">Share on Facebook</label>
        <div class="controls">
            <span class="checkbox inline"><asp:CheckBox ID="shareOnFacebook" Checked="false" runat="server"/></span>
			<asp:HiddenField ID="hiddenShareOnFacebook" runat="server" />
        </div>
	</div>
    <div class="control-group">
		<label class="control-label">Like it on Facebook</label>
        <div class="controls">
            <span class="checkbox inline"><asp:CheckBox ID="likeOnFacebook" Checked="false" runat="server"/></span>
			<asp:HiddenField ID="hiddenLikeOnFacebook" runat="server" />
        </div>
	</div>
	<div class="control-group">
        <label class="control-label">Content Share Text</label>
        <div class="controls">
            <asp:TextBox ID="contextShareTextValue" runat="server" Style="margin-left: 0px" Width="250px"></asp:TextBox>
			<asp:HiddenField ID="hiddenContextShareText" runat="server" />
        </div>
    </div>
</div>