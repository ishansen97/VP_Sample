<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ProductImageGallerySettings.ascx.cs"
		Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.ProductImageGallerySettings" %>
<table>
	<tr>
		<td>
			Show Product Image as First Image<br /> when Multimedia Items Exist
		</td>
		<td>
			<asp:CheckBox ID="chkValue" runat="server" />
			<asp:HiddenField ID="hdnValue" runat="server" />
		</td>
	</tr>
    <tr>
		<td>
			Show Vendor Image When There's No Product Image
		</td>
		<td>
			<asp:CheckBox ID="showVendorCheck" runat="server" />
			<asp:HiddenField ID="showVendorHidden" runat="server" />
		</td>
	</tr>
</table>