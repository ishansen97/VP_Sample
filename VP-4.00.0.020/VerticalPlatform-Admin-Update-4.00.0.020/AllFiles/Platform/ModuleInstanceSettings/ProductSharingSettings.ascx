<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ProductSharingSettings.ascx.cs" Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.ProductSharingSettings" %>

<script type="text/javascript">
	$(document).ready(function () {
		$("input[id$='ShareOnFacebook']").change(function () {
			if (this.checked === false) {
				$("input[id$='FacebookAppIdValue']").val("");
			}
		});
	});
</script>

<style type="text/css">
		.form-horizontal .control-group{margin-bottom:5px;}
</style>

<div class="form-horizontal">
	<div class="control-group">
		<label class="control-label">Share via Email</label>
        <div class="controls">
            <span class="checkbox inline"><asp:CheckBox ID="ShareViaEmail" Checked="true" runat="server"/></span>
			<asp:HiddenField ID="hiddenShareViaEmail" runat="server" />
        </div>
	</div>
	<div class="control-group">
		<label class="control-label">Share on Twitter</label>
        <div class="controls">
            <span class="checkbox inline"><asp:CheckBox ID="ShareOnTwitter" Checked="true" runat="server"/></span>
			<asp:HiddenField ID="hiddenShareOnTwitter" runat="server" />
        </div>
	</div>
	<div class="control-group">
		<label class="control-label">Share on Facebook</label>
        <div class="controls">
            <span class="checkbox inline"><asp:CheckBox ID="ShareOnFacebook" Checked="true" runat="server"/></span>
			<asp:HiddenField ID="hiddenShareOnFacebook" runat="server" />
        </div>
	</div>
	<div class="control-group">
        <label class="control-label">Facebook AppId</label>
        <div class="controls">
            <asp:TextBox ID="FacebookAppIdValue" runat="server" Style="margin-left: 0px" Width="250px"></asp:TextBox>
			<asp:HiddenField ID="hiddenFacebookAppId" runat="server" />
        </div>
    </div>
</div>