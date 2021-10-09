<%@ Page MasterPageFile="~/MasterPage.Master" Language="C#" AutoEventWireup="true"
	CodeBehind="PublicUser.aspx.cs" Inherits="VerticalPlatformAdminWeb.Platform.PublicUser.PublicUser" %>
<asp:Content ID="cntPublicUser" ContentPlaceHolderID="cphContent" runat="server">
	<div class="AdminPanel">
	<div class="AdminPanelHeader">
		<h3>
			<asp:Label ID="lblPublicUser" runat="server" Font-Bold="True">Create public user</asp:Label></h3>
	</div>
	<div class="AdminPanelContent">
		<div class="form-horizontal">
			<div class="control-group">
				<label class="control-label">E Mail</label>
				<div class="controls">
					<asp:TextBox ID="txtEmail" runat="server"></asp:TextBox>
					<asp:CustomValidator ID="emailAddressValidator" runat="server" ControlToValidate="txtEmail" 
						ErrorMessage="Email not in correct format." ValidationGroup="groupOk" ValidateEmptyText="true" 
						ClientValidationFunction="VP.ValidateEmail">*</asp:CustomValidator>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">Password</label>
				<div class="controls">
					<asp:TextBox ID="txtPassword" runat="server" TextMode="Password"></asp:TextBox>
					<asp:RequiredFieldValidator ID="rfvPassword" runat="server" ErrorMessage="Please enter password." ControlToValidate="txtPassword"
						ValidationGroup="groupOk">*</asp:RequiredFieldValidator>
					<asp:RegularExpressionValidator ID="revPassword" runat="server" ErrorMessage="Password length should be atleast 6 characters long."
						ValidationExpression=".{6,}" ControlToValidate="txtPassword" Display="Dynamic"
						ValidationGroup="groupOk">*</asp:RegularExpressionValidator>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">Retype Password</label>
				<div class="controls">
					<asp:TextBox ID="txtPasswordConfirm" runat="server" TextMode="Password"></asp:TextBox>
					<asp:RequiredFieldValidator ID="rfvPasswordConfirm" runat="server" ErrorMessage="Please enter retype password."
						ControlToValidate="txtPasswordConfirm" ValidationGroup="groupOk">*</asp:RequiredFieldValidator>
					<asp:CompareValidator ID="cvConfirmPassword" runat="server" ErrorMessage="Passwords mismatch."
						ControlToValidate="txtPasswordConfirm" Display="Dynamic" ControlToCompare="txtPassword"
						ValidationGroup="groupOk">*</asp:CompareValidator>
				</div>
			</div>
			<div class="control-group">
				<div class="controls">
					<asp:Button ID="btnOk" runat="server" OnClick="btnOk_Click" Text="Add User" 
						ValidationGroup="groupOk" CssClass="btn" />
				</div>
			</div>
		</div>
		
	</div>
</div>
</asp:Content>
