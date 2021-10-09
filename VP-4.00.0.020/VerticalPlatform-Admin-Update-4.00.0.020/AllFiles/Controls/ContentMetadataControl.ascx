<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ContentMetadataControl.ascx.cs" Inherits="VerticalPlatformAdminWeb.Controls.ContentMetadataControl" %>
<style type="text/css">
	.style1
	{
		width: 220px;
	}
</style>
<table style="width:100%;">
	<tr>
		<td class="style1">
			<b>Metadata</b></td>
		<td>
			&nbsp;</td>
	</tr>
	<tr>
		<td class="style1">
			Title</td>
		<td>
			<asp:TextBox ID="txtTitle" runat="server" Width="250px"></asp:TextBox>
		</td>
	</tr>
	<tr>
		<td class="style1" >
			Keywords (Comma Seperated)</td>
		<td>
			<asp:TextBox ID="txtKeywords" runat="server" Width="250px"></asp:TextBox>
			<asp:RegularExpressionValidator ID="revKeywords" runat="server" 
				ControlToValidate="txtKeywords" 
				ErrorMessage="Accepts only a comma seperated list" 
				ValidationExpression="^([a-zA-Z0-9]+(\s)*(,(\s)*([a-zA-Z0-9])+(\s)*)*)$"></asp:RegularExpressionValidator>
		</td>
	</tr>
	<tr>
		<td class="style1" >
			Description</td>
		<td>
			<asp:TextBox ID="txtDescription" runat="server" Width="250px"></asp:TextBox>
		</td>
	</tr>
</table>
