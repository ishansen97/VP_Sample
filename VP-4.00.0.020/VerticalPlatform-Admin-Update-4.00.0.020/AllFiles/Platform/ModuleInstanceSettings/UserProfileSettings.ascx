<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="UserProfileSettings.ascx.cs" 
Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.UserProfileSettings" %>

<table>
	<tr>
		<td>
			<span class="label_span">User Field</span>
		</td>
		<td>
			<asp:DropDownList ID="ddlUserFields" runat="server" style="padding:3px;">
			</asp:DropDownList>
			<asp:HiddenField ID="hdnUserFieldsSettingId" runat="server" />
		</td>
		<td>
			<asp:Button ID="btnAddUserField" runat="server" Text="Add" 
					OnClick="btnAddUserField_Click" CssClass="common_text_button" />
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td><asp:ListBox ID="lbUserFields" runat="server" SelectionMode="Single" width="170px"></asp:ListBox></td>
		<td valign="top">
			<asp:Button ID="btnDeleteUserField" runat="server" Text="Delete" 
				OnClick="btnDeleteUserField_Click" CssClass="common_text_button" />
		</td>
	</tr>
</table>