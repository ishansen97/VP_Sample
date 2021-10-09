<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SearchOptionSettings.ascx.cs" 
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Search.SearchOptionSettings" %>

<table>
	<tr>
		<td valign="top">
			<span class="label_span">Child Option</span>
		</td>
		<td>
			<asp:DropDownList ID="childOptionsDropDown" runat="server" style="padding:3px;"  Width="150"></asp:DropDownList>
		</td>
		<td valign="top">
			<asp:Button ID="addOptionMappingButton" runat="server" Text="Add" OnClick="addOptionMappingButton_Click" Width="50"
				CssClass="common_text_button" />
		</td>
	</tr>
	<tr>
		<td valign="top">
			<span class="label_span">Child Options</span>
		</td>
		<td>
			<asp:ListBox ID="childOptionsListBox" runat="server" style="padding:3px;"  Width="150" SelectionMode="Single"></asp:ListBox>
		</td>
		<td valign="top">
			<asp:Button ID="deleteOptionMappingButton" runat="server" Text="Delete" OnClick="deleteOptionMappingButton_Click" Width="50"
				CssClass="common_text_button" />
		</td>
	</tr>
</table>
