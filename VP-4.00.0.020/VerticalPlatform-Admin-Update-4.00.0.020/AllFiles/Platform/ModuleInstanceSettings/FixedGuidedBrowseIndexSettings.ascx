<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="FixedGuidedBrowseIndexSettings.ascx.cs"
Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.FixedGuidedBrowseIndexSettings" %>

<table>
	<tr>
		<td>
			<asp:Literal ID="ltlGroupByType" runat="server" Text="Display Inconsistent Fixed Guided Browses " ></asp:Literal>
		</td>
		<td>
			<asp:CheckBox ID="displayAll" runat="server" />
			<asp:HiddenField ID="hdnDisplayAll" runat="server" />
		</td>
	</tr>
</table>
