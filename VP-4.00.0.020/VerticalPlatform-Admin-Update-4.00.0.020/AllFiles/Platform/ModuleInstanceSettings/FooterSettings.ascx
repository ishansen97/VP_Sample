<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="FooterSettings.ascx.cs" Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.FooterSettings" %>
<table border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td style="width:100px;" valign="top">
			Footer Text
		</td>
		<td>
			<asp:TextBox ID="txtFooterText" runat="server" Width="500px" Height="179px" 
				TextMode="MultiLine"></asp:TextBox>
				<asp:HiddenField ID="hdnFooterText" runat="server" />
		</td>
	</tr>
</table>
