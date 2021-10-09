<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SearchCategoryPanelSettings.ascx.cs"
Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.SearchCategoryPanelSettings" %>

<table>
	<tr>
		<td>
			Disable Localization for Vendor Filtering
		</td>
		<td>
			<asp:CheckBox ID="chkDisableLocalization" runat="server"></asp:CheckBox>
			<asp:HiddenField ID="hdnDisableLocalization" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Enable Progressive Search Option Filtering
		</td>
		<td>
			<asp:CheckBox ID="enableProgressive" runat="server"></asp:CheckBox>
			<asp:HiddenField ID="enableProgressiveHidden" runat="server" />
		</td>
	</tr>
		<tr>
		<td>
			Enable Applied Filters Section
		</td>
		<td>
			<asp:CheckBox ID="chkAppliedFilters" runat="server"></asp:CheckBox>
			<asp:HiddenField ID="hdnAppliedFilters" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Content Type
		</td>
		<td>
			<asp:DropDownList ID="contentTypeList" runat="server" 
				AppendDataBoundItems="True" Width="210">
				<asp:ListItem Text="--Select--" Value="-1"></asp:ListItem>
			</asp:DropDownList>
			<asp:RequiredFieldValidator 
                ID="contentTypeListValidator" 
                runat="server" 
                InitialValue="-1" 
                ErrorMessage="Please select content type" 
                ControlToValidate="contentTypeList">*
			</asp:RequiredFieldValidator>
			<asp:HiddenField ID="hdnContentType" runat="server" />
		</td>
	</tr>
</table>
