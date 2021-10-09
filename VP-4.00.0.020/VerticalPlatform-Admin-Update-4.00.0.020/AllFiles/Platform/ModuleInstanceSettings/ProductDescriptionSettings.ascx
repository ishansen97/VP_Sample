<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ProductDescriptionSettings.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.ProductDescriptionSettings" %>
<table>
	<tr>
		<td>
			Description Truncate Length
		</td>
		<td>
			<asp:TextBox ID="txtLength" runat="server" Style="margin-left: 0px"
				Width="75px"></asp:TextBox>
			<asp:HiddenField ID="hdnLength" runat="server" />
			<asp:RegularExpressionValidator ID="revLength" runat="server" ControlToValidate="txtLength"
				ErrorMessage="Description truncate length should be a number." ValidationExpression="^[0-9]*$">*</asp:RegularExpressionValidator>
		</td>
	</tr>
	<tr>
		<td>
			Hide module when empty
		</td>
		<td>
			<asp:CheckBox ID="chkHideWhenEmpty" runat="server"/>
			<asp:HiddenField ID="hdnHideWhenEmpty" runat="server" />
		</td>
	</tr>
</table>
