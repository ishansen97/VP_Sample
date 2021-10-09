<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="DeleteSubscriptionSettings.ascx.cs" Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.DeleteSubscriptionSettings" %>
<style type="text/css">
	.style1
	{
		width: 240px;
	}
	.style2
	{
		width: 240px;
		height: 26px;
	}
	.style3
	{
		height: 26px;
	}
	.style4
	{
		width: 240px;
		height: 25px;
	}
	.style5
	{
		height: 25px;
	}
</style>
<table style="width:100%;">
	<tr>
		<td class="style1">
			Display Newsletter</td>
		<td>
			<asp:CheckBox ID="chkDisplayNewsletter" runat="server" />
			<asp:HiddenField ID="hdnDisplayNewsletter" runat="server" />
		</td>
	</tr>
	<tr>
		<td class="style1">
			Newsletter Prerequisite Field</td>
		<td>
			<asp:DropDownList ID="ddlNewsletterField" runat="server" >
			</asp:DropDownList>
			<asp:HiddenField ID="hdnNewsletterOptionId" runat="server" />
		</td>
	</tr>
	<tr>
		<td class="style4">
			Display Opt In</td>
		<td class="style5">
			<asp:CheckBox ID="chkDisplayOptin" runat="server" />
			<asp:HiddenField ID="hdnDisplayOptin" runat="server" />
		</td>
	</tr>
	<tr>
		<td class="style2">
			Opt In Prerequisite Field</td>
		<td class="style3">
			<asp:DropDownList ID="ddlOptinField" runat="server" >
			</asp:DropDownList>
			<asp:HiddenField ID="hdnOptinFieldId" runat="server" />
		</td>
	</tr>
	<tr>
		<td class="style2">
			Display Technology</td>
		<td class="style3">
			<asp:CheckBox ID="chkDisplayTechnology" runat="server" />
			<asp:HiddenField ID="hdnDisplayTechnology" runat="server" />
		</td>
	</tr>
	<tr>
		<td class="style1">
			Technology Prerequisite Field</td>
		<td>
			<asp:DropDownList ID="ddlTechnologyField" runat="server" >
			</asp:DropDownList>
			<asp:HiddenField ID="hdnTechnologyFieldId" runat="server" />
		</td>
	</tr>
</table>
