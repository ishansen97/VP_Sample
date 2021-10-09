<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AdvertisementSettings.ascx.cs" Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.AdvertisementSettings" %>
<table>
	<tr>
		<td>
			<asp:Literal ID="ltlAdvertisementType" runat="server" Text="Advertisement Type"></asp:Literal>
		</td>
		<td>
			<asp:DropDownList ID="ddlAdvertisementType" runat="server" 
				AppendDataBoundItems="True">
				<asp:ListItem Text="--Select--" Value="-1"></asp:ListItem>
			</asp:DropDownList>
			<asp:HiddenField ID="hdnAdvertisementType" runat="server" />
		</td>
	</tr>
</table>
