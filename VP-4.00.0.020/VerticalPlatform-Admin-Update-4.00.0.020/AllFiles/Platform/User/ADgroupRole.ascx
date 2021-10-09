<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ADGroupRole.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.User.ADGroupRole" %>
<style type="text/css">
    .form-horizontal .control-group{margin-bottom:10px;}
    .form-horizontal .control-group .control-label{width:110px;}
    .form-horizontal .control-group .controls{margin-left:130px;} 
</style>
<div class="form-horizontal">
    <asp:HiddenField ID="hdnADgroupRoleId" runat="server" />
    <div class="control-group">
        <label class="control-label">Role</label>
        <div class="controls">
            <asp:DropDownList ID="ddlRole" runat="server">
			</asp:DropDownList>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">Site</label>
        <div class="controls">
            <asp:DropDownList ID="ddlSite" runat="server">
			</asp:DropDownList>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">Domain User Group</label>
        <div class="controls">
            <asp:DropDownList ID="ddlDomainUserGroup" runat="server" >
			</asp:DropDownList>
			<asp:RequiredFieldValidator ID="rfvDomainUserGroup" ErrorMessage="Please select active directory group."
				ControlToValidate="ddlDomainUserGroup" runat="server" >*</asp:RequiredFieldValidator>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">Enabled</label>
        <div class="controls"><asp:CheckBox ID="chkEnabled" runat="server" /></div>
    </div>
</div>

