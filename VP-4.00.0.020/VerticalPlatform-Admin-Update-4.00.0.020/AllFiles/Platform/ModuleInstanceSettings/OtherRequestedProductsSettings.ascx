<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="OtherRequestedProductsSettings.ascx.cs" Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.OtherRequestedProductsSettings" %>
<table>
	<tr>
		<td>
			Enable Product Display Limitation
		</td>
		<td>
			<asp:CheckBox ID="chkProductLimitation" runat="server" />
			<asp:HiddenField ID="hdnProductLimitation" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Max Product Limit
		</td>
		<td>
			<asp:TextBox ID="txtProductLimit" runat="server" Style="margin-left: 0px"
				Width="75px"></asp:TextBox>
			<asp:HiddenField ID="hdnProductLimit" runat="server" />
			<asp:RegularExpressionValidator ID="revProductLimit" runat="server" ControlToValidate="txtProductLimit"
				ErrorMessage="Page size should be a number." ValidationExpression="^[0-9]*$">*</asp:RegularExpressionValidator>
		</td>
	</tr>
	<tr>
		<td>
			Title Display Length
		</td>
		<td>
			<asp:TextBox ID="txtTitleDisplayLength" runat="server" Style="margin-left: 0px"
				Width="75px"></asp:TextBox>
			<asp:HiddenField ID="hdnTitleDisplayLength" runat="server" />
			<asp:RegularExpressionValidator ID="revTitleDisplayLength" runat="server" ControlToValidate="txtTitleDisplayLength"
				ErrorMessage="Title display length should be a number." ValidationExpression="^[0-9]*$">*</asp:RegularExpressionValidator>
		</td>
	</tr>
</table>