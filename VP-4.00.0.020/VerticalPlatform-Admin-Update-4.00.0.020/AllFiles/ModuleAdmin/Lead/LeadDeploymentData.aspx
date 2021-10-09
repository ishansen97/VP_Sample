<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="LeadDeploymentData.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Lead.LeadDeploymentData"
	Title="Untitled Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
<div class="AdminPanelHeader">
			<h3>Lead Deploy Data</h3>
</div>
<div class="form-horizontal">
    <div class="control-group">
        <label class="control-label">From Name</label>
        <div class="controls">
            <asp:TextBox ID="txtFromName" runat="server" Width="200px"></asp:TextBox>
				<asp:RequiredFieldValidator ID="rfvFromName" runat="server" 
					ControlToValidate="txtFromName" ErrorMessage="Please enter name">*</asp:RequiredFieldValidator>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">From Email</label>
        <div class="controls">
            <asp:TextBox ID="txtFromEmail" runat="server" Width="200px"></asp:TextBox>
			<asp:CustomValidator ID="emailAddressValidator" runat="server" ControlToValidate="txtFromEmail" ValidateEmptyText="true"
				ErrorMessage="Please enter a valid email address." ClientValidationFunction="VP.ValidateEmail">*</asp:CustomValidator>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">Subject</label>
        <div class="controls">
            <asp:TextBox ID="txtSubject" runat="server" Width="200px"></asp:TextBox>
				<asp:RequiredFieldValidator ID="rfvSubject" runat="server" 
					ControlToValidate="txtSubject" ErrorMessage="Please enter subject">*</asp:RequiredFieldValidator>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">Body</label>
        <div class="controls">
            <asp:TextBox ID="txtBody" runat="server" Height="100px" TextMode="MultiLine" 
					Width="300px"  style="padding:5px;"></asp:TextBox>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">Smtp Server</label>
        <div class="controls">
            <asp:TextBox ID="txtSmtpServer" runat="server" Width="200px"></asp:TextBox>
				<asp:RequiredFieldValidator ID="rfvSmtpServer" runat="server" 
					ControlToValidate="txtSmtpServer" ErrorMessage="Please enter smtp server">*</asp:RequiredFieldValidator>
        </div>
    </div>
    <div class="control-group">
        <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" CssClass="btn" />
				<asp:HiddenField ID="hdnLeadDeployDataId" runat="server" />
    </div>
</div>

</asp:Content>
