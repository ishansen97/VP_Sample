<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="MetadataPopupControl.ascx.cs"
Inherits="VerticalPlatformAdminWeb.Controls.MetadataPopupControl" %>

<table>
	<tr>
		<td>
			Title
		</td>
		<td>
			<asp:TextBox ID="txtTitle" runat="server" Width="250px"></asp:TextBox>
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
</table>
