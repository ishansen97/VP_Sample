<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SendReviewPayment.ascx.cs" 
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Reviews.SendReviewPayment" %>

<table>
	<tr>
		<td class="common_form_label">Amazon Gift Code</td> 
		<td class="common_form_content">
			<asp:TextBox ID="giftCard" runat="server"></asp:TextBox>
			<asp:RequiredFieldValidator ControlToValidate="giftCard" ID="giftCardRequired" runat="server" 
			ErrorMessage="Please Enter Gift Voucher Details.">*</asp:RequiredFieldValidator>
		</td>
	</tr>
</table>
