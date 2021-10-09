<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="StaticHtmlSettings.ascx.cs"
 Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.StaticHtmlSettings" %>

<table>
	<tr>
		<td>
			<asp:Label ID="lblHtml" runat="server" Text="Html"></asp:Label>
		</td>
		<td>
			<asp:TextBox ID="txtHtml" runat="server" Width="407px" Height="213px" 
				TextMode="MultiLine"></asp:TextBox>
			<asp:HiddenField ID="hdnHtml" runat="server" />
		</td>
	</tr>
</table>
