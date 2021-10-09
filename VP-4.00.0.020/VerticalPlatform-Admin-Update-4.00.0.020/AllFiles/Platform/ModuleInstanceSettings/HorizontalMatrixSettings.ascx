<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="HorizontalMatrixSettings.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.HorizontalMatrixSettings" %>
<table>
	<tr>
		<td>
			Product Description Truncate Length
		</td>
		<td>
			<asp:TextBox ID="txtTruncateLength" runat="server"></asp:TextBox>
			<asp:CompareValidator ID="cpvTruncateLength" runat="server" ErrorMessage="Numbers only"
				ControlToValidate="txtTruncateLength" Type="Integer" Operator="DataTypeCheck"
				SetFocusOnError="True"></asp:CompareValidator>
			<asp:HiddenField ID="hdnTruncateLength" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Display Catalog Number
		</td>
		<td>
			<asp:CheckBox ID="chkDisplayCatalogNumber" runat="server" /><asp:HiddenField ID="hdnDisplayCatalogNumber"
				runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Display Thumbnail Image Size
		</td>
		<td>
			<asp:DropDownList ID="ddlThumbnailImageSize" runat="server"/>
			<asp:HiddenField ID="hdnThumbnailImageSize" runat="server" />
		</td>
	</tr>
</table>
