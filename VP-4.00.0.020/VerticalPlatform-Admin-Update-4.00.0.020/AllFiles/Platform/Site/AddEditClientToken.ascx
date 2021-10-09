<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddEditClientToken.ascx.cs" Inherits="VerticalPlatformAdminWeb.Platform.Site.AddEditClientToken" %>
<div class="controlList">
	<div class="form-horizontal">
		<div class="control-group">
			<label class="control-label">Name</label>
			<div class="controls">
				<asp:TextBox ID="clientName" runat="server" CssClass="common_text_box" MaxLength="50"></asp:TextBox>
				<asp:RequiredFieldValidator ID="clientNameRequiredValidator" runat="server" 
					ControlToValidate="clientName" ErrorMessage="Please enter the client name.">*</asp:RequiredFieldValidator>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">Email</label>
			<div class="controls">
				<asp:TextBox ID="clientEmail" runat="server" CssClass="common_text_box" MaxLength="50"></asp:TextBox>
				<asp:RequiredFieldValidator ID="clientEmailRequiredValidator" runat="server" 
						ControlToValidate="clientEmail" ErrorMessage="Please enter the client email.">*</asp:RequiredFieldValidator>
				<asp:CustomValidator ID="clientEmailValidator" runat="server" ControlToValidate="clientEmail" 
						ErrorMessage="Invalid email address." ValidateEmptyText="true" 
						ClientValidationFunction="VP.ValidateEmail">*</asp:CustomValidator>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">Token</label>
			<div class="controls">
				<asp:TextBox ID="clientToken" runat="server" CssClass="common_text_box" MaxLength="50" Enabled="false"></asp:TextBox>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">Enabled</label>
			<div class="controls">
				<asp:CheckBox ID="clientEnabled" runat="server" CssClass="common_check_box" AutoPostBack="false"/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">Site Logo</label>
			<div class="controls">
				<asp:CheckBox ID="siteLogo" runat="server" CssClass="common_check_box" AutoPostBack="false"/>
			</div>
		</div>
	</div>
</div>
