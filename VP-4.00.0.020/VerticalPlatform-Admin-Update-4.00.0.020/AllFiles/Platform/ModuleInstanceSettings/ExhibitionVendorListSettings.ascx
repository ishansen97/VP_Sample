<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ExhibitionVendorListSettings.ascx.cs" Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.ExhibitionVendorListSettings" %>
<table>
	<tr>
		<td>
			Override Published Date Sorting and use Custom Sorting
		</td>
		<td>
			<asp:CheckBox ID="chkCustomSorting" runat="server" /><asp:HiddenField ID="hdnCustomSorting"
				runat="server" />
		</td>
	</tr>
</table>