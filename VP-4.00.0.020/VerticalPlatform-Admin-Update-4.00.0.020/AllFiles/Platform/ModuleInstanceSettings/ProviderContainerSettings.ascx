<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ProviderContainerSettings.ascx.cs" Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.ProviderContainerSettings" %>
   <table>
	<tr>
		<td>
			Display Title
		</td>
		<td>
			<asp:CheckBox ID="chkDisplayTitle" runat="server" />
			<asp:HiddenField ID="hdnDisplayTitle" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Display Containers First Available Module Title as the Container Title
		</td>
		<td>
			<asp:CheckBox ID="chkDisplayFirstModuleTitle" runat="server" />
			<asp:HiddenField ID="hdnDisplayFirstModuleTitle" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Persist Selected Item
		</td>
		<td>
			<asp:CheckBox ID="chkPersistItem" runat="server" />
			<asp:HiddenField ID="hdnPersistItem" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Analytic Provider Container
		</td>
		<td>
			<asp:CheckBox ID="isAnalyticsProviderContainerCheckBox" runat="server" />
			<asp:HiddenField ID="isAnalyticsProviderHiddenField" runat="server" />
		</td>
	</tr> 
	<tr>
		<td>
			Title Provider Container
		</td>
		<td>
			<asp:CheckBox ID="isTitleProviderContainerCheckBox" runat="server" />
			<asp:HiddenField ID="isTitleProviderContainerHiddenField" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Schema Type
		</td>
		<td>
			<asp:DropDownList ID="schemaType" runat="server"></asp:DropDownList>
			<asp:HiddenField ID="schemaTypeHidden" runat="server" />
		</td>
	</tr>
</table>