<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="RelatedProductSettings.ascx.cs" Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.RelatedProductSettings" %>
<table>
	<tr>
		<td>
			Page Size
		</td>
		<td>
			<asp:TextBox ID="txtPageSize" runat="server" Style="margin-left: 0px"
				Width="75px"></asp:TextBox>
			<asp:HiddenField ID="hdnPageSize" runat="server" />
			<asp:RegularExpressionValidator ID="revPageSize" runat="server" ControlToValidate="txtPageSize"
				ErrorMessage="Page size should be a number." ValidationExpression="^[0-9]*$">*</asp:RegularExpressionValidator>
		</td>
	</tr>
	<tr>
		<td>
			Image Size Extension
		</td>
		<td>
			<asp:DropDownList ID="ddlSizeExtension" runat="server"></asp:DropDownList>
			<asp:HiddenField ID="hdnSizeExtension" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			No of Items to Compare
		</td>
		<td>
			<asp:TextBox ID="txtCompareItems" runat="server" Style="margin-left: 0px"
				Width="75px"></asp:TextBox>
			<asp:HiddenField ID="hdnCompareItems" runat="server" />
			<asp:RegularExpressionValidator ID="revCompareItems" runat="server" ControlToValidate="txtCompareItems"
				ErrorMessage="No of items to compare should be a number." ValidationExpression="^[0-9]*$">*</asp:RegularExpressionValidator>
		</td>
	</tr>
	<tr>
		<td>
			Hide Module when empty
		</td>
		<td>
			<asp:CheckBox ID="chkHideWhenEmpty" runat="server" />
			<asp:HiddenField ID="hdnHideWhenEmpty" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Disable Paging
		</td>
		<td>
			<asp:CheckBox ID="chkDisablePaging" runat="server" />
			<asp:HiddenField ID="hdnDisablePaging" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Hide module when navigated from search category
		</td>
		<td>
			<asp:CheckBox ID="chkHideWhenNavigatedFromSearch" runat="server" />
			<asp:HiddenField ID="hdnHideWhenNavigatedFromSearch" runat="server" />
		</td>
	</tr>
</table>