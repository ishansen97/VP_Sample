<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ProductRatingSettings.ascx.cs"
Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.ProductRatingSettings" %>

<table>
	<tr>
		<td>
			Display Empty Product Rating Module
		</td>
		<td>
			<asp:CheckBox ID="displayProductRating" runat="server"></asp:CheckBox>
			<asp:HiddenField ID="hdnDisplayProductRating" runat="server" />
		</td>
	</tr>
    <tr>
		<td>
			Display Citation Count Link
		</td>
		<td>
			<asp:CheckBox ID="citationCountCheck" runat="server"></asp:CheckBox>
			<asp:HiddenField ID="citationCountHidden" runat="server" />
		</td>
	</tr>
</table>
