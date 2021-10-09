<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddEmailTemplate.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.BulkEmail.AddEmailTemplate" %>
<div class="AdminPanelContent">
	<ul class="common_form_area">
		<li class="common_form_row clearfix"><span class="label_span" style="width:100px;">Template Name</span>
			<span>
				<asp:TextBox ID="txtTemplateName" runat="server"></asp:TextBox>
			</span>
			<asp:RequiredFieldValidator ID="rfvTemplateName" runat="server" ErrorMessage="Please enter template name." ControlToValidate="txtTemplateName">*</asp:RequiredFieldValidator>
		</li>
		<li class="common_form_row clearfix" id="liTemplate" runat="server"><span class="label_span" style="width:100px;">Template</span>
			<span>
				<asp:TextBox ID="txtTemplate" runat="server" Height="200px" 
				TextMode="MultiLine" Width="350px"></asp:TextBox>
			</span>
			<asp:RequiredFieldValidator ID="rfvTemplate" runat="server" ErrorMessage="Please enter template." ControlToValidate="txtTemplate">*</asp:RequiredFieldValidator>
		</li>
		<li class="common_form_row clearfix"><span class="label_span" style="width:100px;">Enabled</span>
			<span>
				<asp:CheckBox ID="chkEnabled" runat="server" Checked="true" />
			</span>
		</li>
	</ul>
</div>
