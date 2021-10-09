<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddCampaign.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.BulkEmail.AddCampaign" %>

<script type="text/javascript">
	(function() {
		RegisterNamespace("VP.BulkEmail");

		$(document).ready(function() {
			$("input[type=text][id*=txtCampaignScheduledDate]").datetimepicker();
			$("input[type=text][id*=txtCampaignDeployedDate]").datetimepicker();
		});
	})();
	</script>

<div class="AdminPanelContent">
	<ul class="common_form_area">
		<li class="common_form_row clearfix"><span class="label_span">Name</span> <span>
			<asp:TextBox ID="txtName" runat="server" Width="200px"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName"
				ErrorMessage="Please enter campaign name.">*</asp:RequiredFieldValidator></span>
		</li>
		<li class="common_form_row clearfix"><span class="label_span">Campaign Type</span> <span>
			<asp:DropDownList ID="ddlCampaignTypes" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlCampaignTypes_SelectedIndexChanged"
				AppendDataBoundItems="true" Width="210px">
				<asp:ListItem Text="--Select--" Value=""></asp:ListItem>
			</asp:DropDownList>
			<asp:RequiredFieldValidator ID="rfvCampaignTypes" runat="server" ControlToValidate="ddlCampaignTypes"
				ErrorMessage="Please select campaign type.">*</asp:RequiredFieldValidator>
		</span></li>
		<li class="common_form_row clearfix"><span class="label_span">Html Email Template</span>
			<span>
				<asp:DropDownList ID="ddlHtmlTemplate" runat="server" Width="210px">
				</asp:DropDownList>
				<asp:RequiredFieldValidator ID="rfvHtmlTemplate" runat="server" ControlToValidate="ddlHtmlTemplate"
					ErrorMessage="Please select html email template.">*</asp:RequiredFieldValidator>
			</span></li>
		<li class="common_form_row clearfix"><span class="label_span">Text Email Template</span>
			<span>
				<asp:DropDownList ID="ddlTextTemplate" runat="server" Width="210px">
				</asp:DropDownList>
			</span></li>
		<li class="common_form_row clearfix"><span class="label_span">Visible Only to Logged-in
			Recipients?</span> <span>
				<asp:RadioButtonList ID="rblPrivate" runat="server">
					<asp:ListItem Selected="True" Text="No" Value="0"></asp:ListItem>
					<asp:ListItem Selected="False" Text="Yes" Value="1"></asp:ListItem>
				</asp:RadioButtonList>
			</span></li>
		<li class="common_form_row clearfix"><span class="label_span">Vendor</span> <span>
			<asp:TextBox ID="txtVendorName" runat="server" Width="200px"></asp:TextBox>
			<asp:HiddenField ID="hdnVendorId" runat="server" /></li>
		<li class="common_form_row clearfix"><span class="label_span">From</span> <span>
			<asp:TextBox ID="txtFromName" runat="server" Width="200px"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvFromName" runat="server" ControlToValidate="txtFromName"
				ErrorMessage="Please enter from name.">*</asp:RequiredFieldValidator></span>
		</li>
		<li class="common_form_row clearfix"><span class="label_span">From Email</span> <span>
			<asp:TextBox ID="txtFromEmail" runat="server" Width="200px"></asp:TextBox>
			<asp:CustomValidator ID="emailAddressValidator" runat="server" ControlToValidate="txtFromEmail" ErrorMessage="Please enter a valid email address." 
				ValidateEmptyText="true" ClientValidationFunction="VP.ValidateEmail">*</asp:CustomValidator>
		</span></li>
		<li class="common_form_row clearfix"><span class="label_span">Subject Line</span> <span>
			<asp:TextBox ID="txtSubjectLine" runat="server" Width="200px"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvSubjectLine" runat="server" ControlToValidate="txtSubjectLine"
				ErrorMessage="Please enter subject line." Enabled="false">*</asp:RequiredFieldValidator></span>
		</li>
		<li class="common_form_row clearfix"><span class="label_span">Preheader Text</span> <span>
			<asp:TextBox ID="txtPreheaderText" runat="server" Width="200px"></asp:TextBox>			
			</span>
		</li>
		<li class="common_form_row clearfix"><span class="label_span">Campaign Scheduled Date</span>
			<span>
				<asp:TextBox ID="txtCampaignScheduledDate" runat="server" Width="121px"></asp:TextBox>
				<asp:RequiredFieldValidator ID="rfvCampaignScheduledDate" runat="server" ControlToValidate="txtCampaignScheduledDate"
					ErrorMessage="Please enter the scheduled date.">*</asp:RequiredFieldValidator>
				<asp:RegularExpressionValidator ID="revCampaignScheduleDate" runat="server" ControlToValidate="txtCampaignScheduledDate"
					ErrorMessage="Please enter valid schedule date" ValidationExpression="^[0,1]\d{1}\/(([0-2]\d{1})|([3][0,1]{1}))\/(([1]{1}[9]{1}[9]{1}\d{1})|([2-9]{1}\d{3})) [0,1,2]\d{1}:[0-5]\d{1}$">*</asp:RegularExpressionValidator>
			</span></li>
		<li class="common_form_row clearfix"><span class="label_span">Campaign Deployed Date</span>
			<span>
				<asp:TextBox ID="txtCampaignDeployedDate" runat="server" Enabled="false"></asp:TextBox>
			</span></li>
		<li class="common_form_row clearfix" id="statusPanel" runat="server"><span class="label_span">
			Status</span> <span>
				<asp:DropDownList ID="ddlStatus" runat="server">
				</asp:DropDownList>
				<asp:Label ID="lblStatus" runat="server" Visible="false"></asp:Label>
				<asp:HiddenField ID="hdnStatus" runat="server" />
			</span></li>
		<li class="common_form_row clearfix"><span class="label_span">Provider Campaign ID</span>
			<span>
				<asp:TextBox ID="txtProviderCampaignId" runat="server" Enabled="false"></asp:TextBox></span>
		</li>
		<li class="common_form_row clearfix"><span class="label_span">In error state</span>
			<span>
				<asp:CheckBox ID="errorState" runat="server"></asp:CheckBox></span>
		</li>
		<li class="common_form_row clearfix"><span class="label_span">Limit no of recipients to</span>
			<span>
				<asp:TextBox ID="txtRecipientCapped" runat="server" Width="150" MaxLength="10"></asp:TextBox>
				<asp:RegularExpressionValidator ID="revRecipientCapped" runat="server" ErrorMessage="Please enter a numeric value for 'Recipient Cappped'."
					ControlToValidate="txtRecipientCapped" ValidationExpression="^[0-9]*$">*</asp:RegularExpressionValidator>
			</span></li>
		<li class="common_form_row clearfix"><span class="label_span">Enabled</span> <span>
			<asp:CheckBox ID="chkEnabled" runat="server" Checked="true" /></span> </li>
		<li class="common_form_row clearfix"><span class="label_span">Special Comments</span>
			<span>
				<asp:TextBox ID="txtSpecialComments" runat="server" TextMode="MultiLine"></asp:TextBox></span>
		</li>
	</ul>
</div>
