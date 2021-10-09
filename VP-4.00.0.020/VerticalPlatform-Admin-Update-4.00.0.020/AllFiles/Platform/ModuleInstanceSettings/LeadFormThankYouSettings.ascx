<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="LeadFormThankYouSettings.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.LeadFormThankYouSettings" %>
<table>
	<tr>
		<td valign="top">
			Custom Text
		</td>
		<td>
			<asp:TextBox ID="txtCustomText" runat="server" Height="200px" TextMode="MultiLine"
				Width="500px"></asp:TextBox>
			<asp:HiddenField ID="hdnCustomText" runat="server" />
		</td>
	</tr>
	<tr><td valign="top">Confirmation Email</td></tr>
	<tr>
		<td valign="top">
			Subject
		</td>
		<td>
			<asp:TextBox ID="txtSubject" runat="server" Width="500px"></asp:TextBox>
			<asp:HiddenField ID="hdnSubject" runat="server" />	
		</td>
	</tr>
	<tr>
		<td valign="top">
			Body
		</td>
		<td>
			<asp:TextBox ID="txtBody" runat="server" Height="200px" TextMode="MultiLine"
				Width="500px"></asp:TextBox>
				<asp:HiddenField ID="hdnBody" runat="server" />	
		</td>
	</tr>
</table>
