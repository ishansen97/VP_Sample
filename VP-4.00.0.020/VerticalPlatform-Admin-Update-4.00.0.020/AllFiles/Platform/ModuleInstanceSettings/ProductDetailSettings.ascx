<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ProductDetailSettings.ascx.cs" Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.ProductDetailSettings" %>
<table>
<tr>
		<td>
			Enable Company Product page Links
		</td>
		<td>
			<asp:CheckBox ID="chkEnableLinks" runat="server" />
			<asp:HiddenField ID="hdnEnableLinks" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Open Links in Separate Window
		</td>
		<td>
			<asp:CheckBox ID="chkSeparateWindow" runat="server" />
			<asp:HiddenField ID="hdnSeparateWindow" runat="server" />
		</td>
	</tr>
</table>