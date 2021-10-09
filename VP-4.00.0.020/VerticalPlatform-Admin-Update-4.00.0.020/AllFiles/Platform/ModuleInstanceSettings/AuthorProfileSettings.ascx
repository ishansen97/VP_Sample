<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AuthorProfileSettings.ascx.cs"
    Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.AuthorProfileSettings" %>
<table>
    <tr>
        <td>Redirect url if author not found
        </td>
        <td>
            <asp:TextBox ID="txtRedirectUrl" runat="server" Width="328px"></asp:TextBox>
            <asp:HiddenField ID="hdnredirectUrl" runat="server" />
        </td>
    </tr>
    <tr>
        <td>Max words for description
        </td>
        <td>
            <asp:TextBox ID="txtDescMaxChars" runat="server" Text="50" />
            <asp:HiddenField ID="hdnDescMaxChars" runat="server" />
            <asp:CompareValidator runat="server" Operator="DataTypeCheck" 
                Type="Integer" 
                ControlToValidate="txtDescMaxChars" 
                ErrorMessage="Max word count must be numeric value.">*</asp:CompareValidator>
        </td>
    </tr>    
    <tr>
        <td>Profile Image size
        </td>
        <td>
            <asp:DropDownList ID="thumbnailSizeDropdown" runat="server"></asp:DropDownList>
            <asp:HiddenField ID="thumbnailSizeHidden" runat="server" />
        </td>
    </tr>
	<tr>
		<td colspan="2">
			<table border="0">
				<tr>
					<td  width="157">
						Author Display Settings
					</td>
					<td>
						<asp:DropDownList ID="ddlAuthorDisplaySetting" runat="server" Width="144px" Height="30px">
						</asp:DropDownList>
						<asp:Button ID="btnAddDisplaySettings" runat="server" OnClick="btnAddDisplaySettings_Click"
							Text="Add" CssClass="common_text_button" />
					</td>
				</tr>
				<tr>
					<td  width="157">
						&nbsp;
					</td>
					<td>
						<asp:ListBox ID="lstAuthorDisplaySetting" runat="server" Width="247px"></asp:ListBox>
					</td>
				</tr>
				<tr>
					<td  width="157">
						&nbsp;
					</td>
					<td><br />
						<asp:Button ID="btnMoveUp" runat="server" OnClick="btnMoveUp_Click" Text="Move Up" CssClass="common_text_button" />
						<asp:Button ID="btnMoveDown" runat="server" Text="Move Down" OnClick="btnMoveDown_Click" CssClass="common_text_button" />
						<asp:Button ID="btnRemove" runat="server" OnClick="btnRemove_Click" Text="Remove" CssClass="common_text_button" />
					</td>
				</tr>
				<tr><td><asp:HiddenField ID="authorDisplaySettingHidden" runat="server" /></td></tr>
			</table>
		</td>
	</tr>
</table>
