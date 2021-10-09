<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddVanityUrl.ascx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.VanityUrls.AddVanityUrl" %>
<div>
	<table>
		<tr>
			<td>
				<asp:Literal ID="ltlShortUrl" runat="server" Text="Short url"></asp:Literal>
			</td>
			<td>
				<asp:TextBox ID="txtShortUrl" runat="server" Width="200px">
				</asp:TextBox>
				<asp:RequiredFieldValidator ID="rfvShortUrl" runat="server" ErrorMessage="Please enter short url."
				ControlToValidate="txtShortUrl">*</asp:RequiredFieldValidator>
				<asp:RegularExpressionValidator  ID="RegularExpressionValidator1" runat="server" 
				ControlToValidate="txtShortUrl" ErrorMessage="Short url should only contain alpha numeric characters."
				ValidationExpression="^[-a-zA-Z0-9_/]*$">*</asp:RegularExpressionValidator>
			</td>
		</tr>
		
		<tr>
			<td>
				<asp:Literal ID="ltlRedirectUrl" runat="server" Text="Redirect url"></asp:Literal>
			</td>
			<td>
				<asp:TextBox ID="txtRedirectUrl" runat="server" Width="200px">
				</asp:TextBox>
				<asp:RequiredFieldValidator ID="rfvRedirectUrl" runat="server" ErrorMessage="Please enter redirect url."
				ControlToValidate="txtRedirectUrl">*</asp:RequiredFieldValidator>
				<asp:RegularExpressionValidator  ID="revRedirectUrl" runat="server" 
				ControlToValidate="txtRedirectUrl" ErrorMessage="Please enter a valid url for redirect url."
				ValidationExpression="^http(s?)\:\/\/[0-9a-zA-Z]([-.\w]*[0-9a-zA-Z])*(:(0-9)*)*(\/?)([a-zA-Z0-9\-\.\=\?\,\'\/\\\+&amp;%\$#_]*)?$">*</asp:RegularExpressionValidator>
			</td>
		</tr>
		
		<tr>
			<td>
				<asp:Label ID="lblEnable" runat="server" Text="Enabled"></asp:Label>
			</td>
			<td>
				<asp:CheckBox ID="chkEnabled" runat="server" Checked="True" Text=" " />
			</td>
		</tr>
	</table>
	<asp:HiddenField ID="hdnVanityUrlId" runat="server" />
	<asp:Label ID="lblMessage" runat="server"></asp:Label>
</div>
