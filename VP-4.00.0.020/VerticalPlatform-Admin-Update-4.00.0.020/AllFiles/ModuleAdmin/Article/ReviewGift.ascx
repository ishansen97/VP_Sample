<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ReviewGift.ascx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Articles.ReviewGift" %>
<table>
<tr>
	<td class="common_form_label">Author Name </td>
	<td class="common_form_content"><asp:Label ID="authorName" runat="server"></asp:Label></td>
</tr>
<tr>
<td class="common_form_label">Gift </td> 
<td class="common_form_content"><asp:TextBox ID="giftCard" runat="server"></asp:TextBox><asp:RequiredFieldValidator ControlToValidate="giftCard"
		ID="giftCardRequired" runat="server" ErrorMessage="Please Enter Gift Voucher Details."></asp:RequiredFieldValidator></td>
</tr>
</table>

