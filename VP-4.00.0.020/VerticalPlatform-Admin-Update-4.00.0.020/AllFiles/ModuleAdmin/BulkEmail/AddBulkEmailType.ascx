<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddBulkEmailType.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.BulkEmail.AddBulkEmailType" %>
<div class="AdminPanelContent">
	<ul class="common_form_area">
		<li class="common_form_row clearfix"><span class="label_span">Name</span> <span>
			<asp:TextBox ID="txtName" runat="server" Width="200px"></asp:TextBox></span>
			<asp:RequiredFieldValidator ID="rfvName" runat="server" ErrorMessage="Please enter name."
				ControlToValidate="txtName">*</asp:RequiredFieldValidator>
		</li>
		<li class="common_form_row clearfix"><span class="label_span">Vendor Specific</span>
			<span>
				<asp:CheckBox ID="chkVendorSpecific" runat="server" /></span> </li>
		<li class="common_form_row clearfix"><span class="label_span">Site Content Driven</span>
			<span>
				<asp:CheckBox ID="chkSiteContentDriven" runat="server" /></span> </li>
		<li class="common_form_row clearfix"><span class="label_span">Recurring</span> <span>
			<asp:CheckBox ID="chkRecuring" runat="server" /></span> </li>
		<li class="common_form_row clearfix"><span class="label_span">Unique per User</span>
			<span>
				<asp:CheckBox ID="chkUnique" runat="server" /></span> </li>
		<li class="common_form_row clearfix"><span class="label_span">Emails per User per Day</span>
			<span>
				<asp:TextBox ID="txtEmailsPerUser" runat="server" Width="200px"></asp:TextBox></span>
			<asp:CompareValidator ID="cvEmailsPerUser" runat="server" ErrorMessage="Emails per User per Day should be an integer."
				Type="Integer" ControlToValidate="txtEmailsPerUser" Operator="DataTypeCheck">*</asp:CompareValidator>
		</li>
		<li class="common_form_row clearfix"><span class="label_span">Email Provider</span>
			<span>
				<asp:DropDownList ID="ddlEmailProvider" runat="server">
				</asp:DropDownList></span>
		</li>
		<li class="common_form_row clearfix"><span class="label_span">Enabled</span> <span>
			<asp:CheckBox ID="chkEnabled" runat="server" /></span> 
		</li>
	</ul>
</div>
