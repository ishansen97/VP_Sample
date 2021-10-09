<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="OasAdvertisementSettings.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.OasAdvertisementSettings" %>
<table>
	<tr>
		<td>
			<asp:Literal ID="ltlPosition" runat="server" Text="Position"></asp:Literal>
		</td>
		<td>
			<asp:TextBox ID="txtPosition" runat="server"></asp:TextBox>
			<asp:HiddenField ID="hdnPosition" runat="server" />
		</td>
	</tr>
</table>
