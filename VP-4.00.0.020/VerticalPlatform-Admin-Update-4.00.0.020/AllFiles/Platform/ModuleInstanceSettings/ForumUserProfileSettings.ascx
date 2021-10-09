<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ForumUserProfileSettings.ascx.cs" 
Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.ForumUserProfileSettings" %>

<div>
	<ul class="common_form_area">
		<li class="common_form_row clearfix" style="padding-top: 10px;">
			<div class="common_form_row_lable">
				Enable Paging on Top
			</div>
			<div class="common_form_row_data">
				<asp:CheckBox ID="chkEnablePagingOnTop" runat="server" />
				<asp:HiddenField ID="hdnEnablePagingOnTop" runat="server" />
			</div>
		</li>
		<li class="common_form_row clearfix" style="padding-top: 10px;">
			<div class="common_form_row_lable">
				Number of Posts Per Page
			</div>
			<div class="common_form_row_data">
				<asp:TextBox ID="txtNumberOfPostsPerPage" runat="server" Width="220px"></asp:TextBox>
				<asp:HiddenField ID="hdnNoOfPostsPerPage" runat="server" />
				<asp:CompareValidator ID="cpvNumberOfPostsPerPage" runat="server" ErrorMessage="Please enter a numeric value for  'Number of threads per page'."
					ControlToValidate="txtNumberOfPostsPerPage" Type="Integer" Operator="DataTypeCheck"
					SetFocusOnError="True">*</asp:CompareValidator>
			</div>
		</li>
	</ul>
</div>
	

