<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddApplicationMessage.ascx.cs" 
Inherits="VerticalPlatformAdminWeb.Platform.AddApplicationMessage" %>
<script type="text/javascript">
	$(document).ready(function () {
		$("input[id*=txtStartDate]").datepicker({ changeYear: true, dateFormat: 'mm/dd/yy' });
		$("input[id*=txtEndDate]").datepicker({ changeYear: true, dateFormat: 'mm/dd/yy' });
	});
</script>
<style type="text/css">
    .form-horizontal .control-group .control-label{width:110px;}
    .form-horizontal .control-group{margin-bottom:10px;}
    .form-horizontal .control-group .controls{margin-left:120px;}
    .form-horizontal .control-group .controls .show-check input{margin-top:9px;}
</style>
<div class="AdminPanelContent">
    <div class="form-horizontal">
        <div class="control-group">
            <label class="control-label">Site</label>
            <div class="controls">
                <asp:DropDownList ID="ddlSites" runat="server"></asp:DropDownList>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">Application Type</label>
            <div class="controls">
                <asp:DropDownList ID="ddlApplicationTypes" runat="server"></asp:DropDownList>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">Message Type</label>
            <div class="controls">
                <asp:DropDownList ID="ddlMessageTypes" runat="server"></asp:DropDownList>
            </div>
        </div>
         <div class="control-group">
            <label class="control-label">Start Date </label>
            <div class="controls">
                <asp:TextBox ID="txtStartDate" runat="server"/>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">End Date</label>
            <div class="controls">
                <asp:TextBox ID="txtEndDate" runat="server" />
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">Message </label>
            <div class="controls">
                <asp:TextBox ID="txtMessage" runat="server" MaxLength="5000" TextMode="MultiLine"></asp:TextBox>
            		<asp:RequiredFieldValidator ID="rfvMessage" runat="server"
					ErrorMessage="Please enter the message." ControlToValidate="txtMessage">*</asp:RequiredFieldValidator>
			</div>
        </div>
        <div class="control-group">
            <label class="control-label">Show Message</label>
            <div class="controls">
                <asp:CheckBox ID="chkShow" runat="server" Enabled="true" CssClass="show-check"/>
            </div>
        </div>
    </div>
</div>
