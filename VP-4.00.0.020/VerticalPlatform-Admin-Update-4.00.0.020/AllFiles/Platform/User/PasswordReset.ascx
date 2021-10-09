<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="PasswordReset.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.User.PasswordReset" %>
<table>
	<tr>
		<td>
			Password
		</td>
		<td>
			<asp:TextBox ID="txtPassword" runat="server" TextMode="Password"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvPassword" runat="server" ErrorMessage="Please enter password." ControlToValidate="txtPassword">*</asp:RequiredFieldValidator>
			<asp:RegularExpressionValidator ID="passwordComplexityValidator" runat="server" ControlToValidate="txtPassword"
				ErrorMessage="Invalid password. Password must meet at least four of the following requirements.<br/> &nbsp;&nbsp;1. Minimum 8 characters <br/> &nbsp;&nbsp;2. Uppercase letters <br/> &nbsp;&nbsp;3. Lowercase letters <br/> &nbsp;&nbsp;4. Base 10 digits <br/> &nbsp;&nbsp;5. Special characters" 
				ValidationExpression="(?=^.{8,255}$)((?=.*\d)(?=.*[A-Z])(?=.*[a-z])|(?=.*\d)(?=.*[^A-Za-z0-9])(?=.*[a-z])|(?=.*[^A-Za-z0-9])(?=.*[A-Z])(?=.*[a-z])|(?=.*\d)(?=.*[A-Z])(?=.*[^A-Za-z0-9]))^.*" >*</asp:RegularExpressionValidator>
		</td>
	</tr>
	<tr>
		<td>
			Confirm Password
		</td>
		<td>
			<asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password"></asp:TextBox>
			<asp:CompareValidator ID="cvPassword" runat="server" ErrorMessage="Passwords mismatch."
				ControlToCompare="txtPassword" ControlToValidate="txtConfirmPassword" ValidationGroup="pwdConfirm" Display="Dynamic">*</asp:CompareValidator>
			<asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server"  ErrorMessage="Please enter confirm password."
				ControlToValidate="txtConfirmPassword">*</asp:RequiredFieldValidator>
		</td>
	</tr>
</table>