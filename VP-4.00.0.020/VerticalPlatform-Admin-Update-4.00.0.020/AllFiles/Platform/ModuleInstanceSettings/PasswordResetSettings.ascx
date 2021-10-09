<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="PasswordResetSettings.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.PasswordResetSettings" %>
<table>
	<tr>
		<td>
			No of dates to Expire Password Reset
		</td>
		<td>
			<asp:TextBox ID="txtNoOfDates" runat="server" Style="margin-left: 0px"></asp:TextBox>
			<asp:HiddenField ID="hdnNoOfDates" runat="server" />
		</td>
	</tr>
    <tr>
		<td>
			Keywords (Comma Seperated)
		</td>
		<td>
			<asp:TextBox ID="txtKeywords" runat="server" Width="250px"></asp:TextBox>
			<asp:RegularExpressionValidator ID="revKeywords" runat="server" 
				ControlToValidate="txtKeywords" 
				ErrorMessage="Accepts only a comma seperated list" 
				ValidationExpression="^([a-zA-Z0-9]+(\s)*(,(\s)*([a-zA-Z0-9])+(\s)*)*)$">*</asp:RegularExpressionValidator>
		</td>
	</tr>
	<tr>
		<td>
			Description
		</td>
		<td>
			<asp:TextBox ID="txtDescription" runat="server" Width="250px"></asp:TextBox>
		</td>
	</tr>
    <tr>
        <td>
			Page Referrel Policy
		</td>
        <td>
            <asp:DropDownList ID="ddlReferrelPolicy" runat="server"></asp:DropDownList>
        </td>
    </tr>
</table>
