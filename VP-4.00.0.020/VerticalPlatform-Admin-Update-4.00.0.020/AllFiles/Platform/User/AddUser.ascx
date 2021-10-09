<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddUser.ascx.cs" 
Inherits="VerticalPlatformAdminWeb.Platform.User.AddUser" %>

<script type="text/javascript">
	function ValidateCheckBoxList(src, args) {
		if ($("input[type=checkbox][id*=chkRoles]:checked").length > 0) {
			args.IsValid = true;
		}
		else {
			args.IsValid = false;
		}
	}
</script>

<table style="margin: 10px;">
	<tr>
		<td valign="top">
			Username
		</td>
		<td>
			<asp:TextBox ID="txtUsername" runat="server" Width="200"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvUserName" runat="server" ErrorMessage="Please enter user name."
				ControlToValidate="txtUsername">*</asp:RequiredFieldValidator>
			<asp:RegularExpressionValidator ID="revUserName" runat="server" ErrorMessage="Username should be atleast 6 characters long."
				ValidationExpression=".{6,}" ControlToValidate="txtUsername" Display="Dynamic">*</asp:RegularExpressionValidator>
		</td>
	</tr>
	<tr>
		<td valign="top">
			Password
		</td>
		<td>
			<asp:TextBox ID="txtPassword" runat="server" TextMode="Password"  Width="200"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvPassword" runat="server" ErrorMessage="Please enter password."
				ControlToValidate="txtPassword">*</asp:RequiredFieldValidator>
			<asp:RegularExpressionValidator ID="passwordComplexityValidator" runat="server" ControlToValidate="txtConfirmPassword"
				ErrorMessage="Invalid password. Password must meet at least three of the following requirements.<br/> &nbsp;&nbsp;1. Minimum 8 characters <br/> &nbsp;&nbsp;2. Uppercase letters <br/> &nbsp;&nbsp;3. Lowercase letters <br/> &nbsp;&nbsp;4. Base 10 digits <br/> &nbsp;&nbsp;5. Special characters" 
				ValidationExpression="(?=^.{8,255}$)((?=.*\d)(?=.*[A-Z])(?=.*[a-z])|(?=.*\d)(?=.*[^A-Za-z0-9])(?=.*[a-z])|(?=.*[^A-Za-z0-9])(?=.*[A-Z])(?=.*[a-z])|(?=.*\d)(?=.*[A-Z])(?=.*[^A-Za-z0-9]))^.*" >*</asp:RegularExpressionValidator>
		</td>
	</tr>
	<tr>
		<td>
			Confirm Password
		</td>
		<td>
			<asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password"  Width="200"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server" ErrorMessage="Please enter confirm password."
				ControlToValidate="txtConfirmPassword">*</asp:RequiredFieldValidator>
			<asp:CompareValidator ID="cvConfirmPassword" runat="server" ErrorMessage="Passwords mismatch."
				ControlToCompare="txtPassword" ControlToValidate="txtConfirmPassword" Display="Dynamic">*</asp:CompareValidator>
		</td>
	</tr>
	<tr>
		<td>
			Salutation
		</td>
		<td>
			<asp:DropDownList ID="ddlSalutation" runat="server" AppendDataBoundItems="true" Width="212">
				<asp:ListItem Text="" Value=""></asp:ListItem>
			</asp:DropDownList>
			<asp:RequiredFieldValidator ID="rfvSalutation" runat="server" ErrorMessage="Please select salutation."
				ControlToValidate="ddlSalutation">*</asp:RequiredFieldValidator>
		</td>
	</tr>
	<tr>
		<td>
			First Name
		</td>
		<td>
			<asp:TextBox ID="txtFirstName" runat="server" Width="200"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvFirstName" runat="server" ErrorMessage="Please enter first name."
				ControlToValidate="txtFirstName">*</asp:RequiredFieldValidator>
		</td>
	</tr>
	<tr>
		<td>
			Last Name
		</td>
		<td>
			<asp:TextBox ID="txtLastName" runat="server"  Width="200"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvLastName" runat="server" ErrorMessage="Please enter last name."
				ControlToValidate="txtLastName">*</asp:RequiredFieldValidator>
		</td>
	</tr>
	<tr>
		<td>
			Email
		</td>
		<td>
			<asp:TextBox ID="txtEmail" runat="server" Width="200"></asp:TextBox>
			<asp:CustomValidator ID="emailAddressValidator" runat="server" ControlToValidate="txtEmail" 
				ErrorMessage="Invalid email address." ValidateEmptyText="true" 
				ClientValidationFunction="VP.ValidateEmail">*</asp:CustomValidator>
			<br />
		</td>
	</tr>
	<tr>
		<td>
			Country
		</td>
		<td>
			<asp:DropDownList ID="ddlCountry" runat="server" AppendDataBoundItems="true">
				<asp:ListItem Text="" Value=""></asp:ListItem>
			</asp:DropDownList>
			<asp:RequiredFieldValidator ID="rfvCountry" runat="server" ErrorMessage="Please select country."
				ControlToValidate="ddlCountry">*</asp:RequiredFieldValidator>
		</td>
	</tr>
	<tr id="trRole" runat="server">
		<td>
			Roles
		</td>
		<td>
			<asp:CheckBoxList ID="chkRoles" runat="server" RepeatColumns="3" CellPadding="0"
				CellSpacing="0" CssClass="radio_table">
			</asp:CheckBoxList>
			<asp:CustomValidator ID="cvRoles" runat="server" ErrorMessage="Please select roles."
				ClientValidationFunction="ValidateCheckBoxList">*</asp:CustomValidator>
		</td>
	</tr>
</table>
