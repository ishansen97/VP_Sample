<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CampaignArchivesListSettings.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.CampaignArchivesListSettings" %>
<table>
	<tr>
		<td>
			<span class="label_span">Site</span>
		</td>
		<td>
			<asp:DropDownList ID="ddlSites" OnSelectedIndexChanged="ddlSites_SelectedIndexChange" AutoPostBack="true" runat="server" Style="padding: 3px;">
			</asp:DropDownList>
		</td>
	</tr>
	<tr>
		<td>
			<span class="label_span">Bulk email type</span>
		</td>
		<td>
			<asp:DropDownList ID="ddlBulkEmailTypes" runat="server" Style="padding: 3px;">
			</asp:DropDownList>
		</td>
		<td>
			<asp:Button ID="btnAddBulkEmailType" runat="server" Text="Add" OnClick="btnAddBulkEmailType_Click"
				CssClass="common_text_button" />
		</td>
	</tr>
	<tr>
		<td>
			&nbsp;
		</td>
		<td>
			<asp:ListBox ID="lbBulkEmailTypes" runat="server" SelectionMode="Single" Width="170px">
			</asp:ListBox>
		</td>
		<td valign="top">
			<asp:Button ID="btnDeleteBulkEmailType" runat="server" Text="Delete" OnClick="btnDeleteBulkEmailType_Click"
				CssClass="common_text_button" />
		</td>
	</tr>
	<tr>
		<td colspan="3">
			Show campaigns of current user only
			<asp:HiddenField ID="hdnBulkEmailTypesSettingId" runat="server" />
			<asp:HiddenField ID="hdnIsUserSpecificSettingId" runat="server" />
			<asp:CheckBox ID="chkIsUserSpecific" runat="server" />
		</td>
	</tr>
	<tr>
		<td colspan="3">
			Enable sorting
			<asp:HiddenField ID="hdnEnableSorting" runat="server" />
			<asp:CheckBox ID="chkEnableSorting" runat="server" />
		</td>
	</tr>
	<tr>
		<td colspan="3">
			Enable filtering
			<asp:HiddenField ID="hdnEnableFiltering" runat="server" />
			<asp:CheckBox ID="chkEnableFiltering" runat="server" />
		</td>
	</tr>
	<tr>
		<td colspan="3">
			Number of campaign per page
			<asp:TextBox runat="server" ID="txtPageSize"></asp:TextBox>
			<asp:HiddenField ID="hdnPageSize" runat="server" />
			<asp:CompareValidator ID="cpvPageSize" runat="server" ErrorMessage="Please enter a numeric value for 'Number of campaign per page'."
				ControlToValidate="txtPageSize" Type="Integer" Operator="DataTypeCheck"
				SetFocusOnError="True">*</asp:CompareValidator>
			<asp:RequiredFieldValidator ID="rfvPageSize" ControlToValidate="txtPageSize"
				runat="server" ErrorMessage="Please enter 'Number of campaign per page'.">*</asp:RequiredFieldValidator>
		</td>
	</tr>
</table>
<br />
