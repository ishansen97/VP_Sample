<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddCampaignType.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.BulkEmail.AddCampaignType" %>
<div class="AdminPanelContent">
	<ul class="common_form_area">
		<li class="common_form_row clearfix"><span class="label_span2">Bulk Email Type</span>
			<span>
				<asp:DropDownList ID="ddlBulkEmailType" runat="server" AppendDataBoundItems="true"
					OnSelectedIndexChanged="ddlBulkEmailType_SelectedIndexChanged" Width="210px">
					<asp:ListItem Text="-Select-" Value=""></asp:ListItem>
				</asp:DropDownList>
				<asp:RequiredFieldValidator ID="rfvBulkEmailType" runat="server" ErrorMessage="Please select bulk email type."
					ControlToValidate="ddlBulkEmailType">*</asp:RequiredFieldValidator>
			</span></li>
		<li class="common_form_row clearfix"><span class="label_span2">Campaign Type</span>
			<span>
				<asp:TextBox ID="txtCampaignType" runat="server" Width="200px"></asp:TextBox>
				<asp:RequiredFieldValidator ID="revEmailPerUser" runat="server" ControlToValidate="txtCampaignType"
					ErrorMessage="Please enter campaign type">*</asp:RequiredFieldValidator>
				<asp:HiddenField ID="hdnCampaignTypeName" runat="server" />
			</span></li>
		<li class="common_form_row clearfix"><span class="label_span2">Email Provider </span>
			<span>
				<asp:DropDownList ID="ddlEmailProvider" runat="server" Width="210px">
				</asp:DropDownList>
			</span></li>
		<li class="common_form_row clearfix"><span class="label_span2">From </span><span>
			<asp:TextBox ID="txtFromName" runat="server" Width="200px"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvFromName" runat="server" ControlToValidate="txtFromName"
				ErrorMessage="Please enter from name.">*</asp:RequiredFieldValidator></span>
			</li>
		<li class="common_form_row clearfix"><span class="label_span2">From Email</span> <span>
			<asp:TextBox ID="txtFromEmail" runat="server" Width="200px"></asp:TextBox>
			<asp:CustomValidator ID="emailAddressValidator" runat="server" ControlToValidate="txtFromEmail" ValidateEmptyText="true"
				ErrorMessage="Please enter a valid email address." ClientValidationFunction="VP.ValidateEmail">*</asp:CustomValidator>
		</span></li>
		<li class="common_form_row clearfix"><span class="label_span2">Subject Line</span> <span>
			<asp:TextBox ID="txtSubjectLine" runat="server" Width="200px"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvSubjectLine" runat="server" ControlToValidate="txtSubjectLine"
				ErrorMessage="Please enter subject line.">*</asp:RequiredFieldValidator></span>
		</li>
		<li class="common_form_row clearfix"><span class="label_span2">Emails per User per Day
		</span><span>
			<asp:TextBox ID="txtEmailPerUser" runat="server" Width="200px"></asp:TextBox>
			<asp:CompareValidator ID="cvEmailPerUser" runat="server" ControlToValidate="txtEmailPerUser"
				ErrorMessage="Please enter a valid number" Operator="DataTypeCheck" Type="Integer">*</asp:CompareValidator>
		</span></li>
		<li class="common_form_row clearfix"><span class="label_span2">Site Content Driven</span>
			<asp:CheckBox ID="chkSiteContentDriven" runat="server" />
		</li>
		<li class="common_form_row clearfix"><span class="label_span2">Unique per User</span>
			<asp:CheckBox ID="chkUniquePerUser" runat="server" Text=" " />
		</li>
		<li class="common_form_row clearfix"><span class="label_span2">Recurring</span>
			<asp:CheckBox ID="chkRecurring" runat="server" />
		</li>
		<li class="common_form_row clearfix"><span class="label_span2">Vendor Specific</span>
			<asp:CheckBox ID="chkVendorSpecific" runat="server" />
		</li>
		<li class="common_form_row clearfix"><span class="label_span2">Limit Recepients</span>
			<asp:CheckBox ID="chkEnabledRecipientCapped" runat="server" />
		</li>
		<li class="common_form_row clearfix"><span class="label_span2">Enabled</span> <span>
			<asp:CheckBox ID="chkEnable" runat="server" Checked="true" /></span> </li>
		<asp:HiddenField ID="hdnScheduleId" runat="server" />
	</ul>
</div>
