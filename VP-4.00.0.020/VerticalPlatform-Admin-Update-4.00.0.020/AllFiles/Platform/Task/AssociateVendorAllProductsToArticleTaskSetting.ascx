<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AssociateVendorAllProductsToArticleTaskSetting.ascx.cs"
Inherits="VerticalPlatformAdminWeb.Platform.Task.AssociateVendorAllProductsToArticleTaskSetting" %>
<ul class="common_form_area">
	<li class="common_form_row clearfix">
		<span class="label_span" style="width: 160px;"><label>
			Batch Size</label></span> <span>
		<asp:TextBox runat="server" ID="txtBatchSize" ToolTip="BatchSize" MaxLength="5"></asp:TextBox>
		<asp:RegularExpressionValidator ID="revBatchSize" runat="server" ValidationExpression="^[0-9]+$" 
				ErrorMessage="Please enter a numeric value for batch size." ControlToValidate="txtBatchSize">*</asp:RegularExpressionValidator>
		</span>
	</li>
</ul>
