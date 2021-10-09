<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ExhibitionCategoryListSettings.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.ExhibitionCategoryListSettings" %>
<table>
	<tr>
		<td>
			Override Alphabetical Sorting and use Custom Sorting
		</td>
		<td>
			<asp:CheckBox ID="chkCustomSorting" runat="server" /><asp:HiddenField ID="hdnCustomSorting"
				runat="server" />
		</td>
	</tr>
</table>
