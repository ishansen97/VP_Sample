<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ExhibitionManagement.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Exhibition.ExhibitionManagement" %>

<script type="text/javascript">
	(function() {
		$(document).ready(function() {
		$("input[type=text][id*=txtStartDate]").datepicker({ changeYear: true});
		$("input[type=text][id*=txtEndDate]").datepicker({ changeYear: true });

		var optionProduct = { siteId: VP.SiteId, type: "Article", currentPage: "1", pageSize: "10"};
		$("input[type=text][id*=txtArticleId]").contentPicker(optionProduct);
			
		});
		
	})();
</script>

<div class="AdminPanelHeader">
	<h3>
		Exhibition Hall Preview
	</h3>
</div>
<div class="AdminPanelContent">
	<ul class="common_form_area">
		<li class="common_form_row clearfix">Exhibition Name </li>
		<li class="common_form_row clearfix">
			<asp:TextBox ID="txtName" runat="server" Width="300px" MaxLength="200"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvName" runat="server" ErrorMessage="Please enter exhibition name." ControlToValidate="txtName">*</asp:RequiredFieldValidator>
		</li>
		<li class="common_form_row clearfix" style="padding-top: 10px;">Exhibition Title </li>
		<li class="common_form_row clearfix">
			<asp:TextBox ID="txtTitle" runat="server" TextMode="MultiLine" Width="300px" Height="50px" MaxLength="200"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvTitle" runat="server" ErrorMessage="Please enter exhibition title." ControlToValidate="txtTitle">*</asp:RequiredFieldValidator>
		</li>
		<li class="common_form_row clearfix" style="padding-top: 10px;">Exhibition Landing Page URL </li>
		<li class="common_form_row clearfix">
			<asp:TextBox ID="txtFixedUrl" runat="server" Width="300px"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvFixedUrl" runat="server" ErrorMessage="Please enter exhibition landing page url."
				ControlToValidate="txtFixedUrl" Display="Dynamic">*</asp:RequiredFieldValidator>
			<asp:RegularExpressionValidator ID="revFixedUrl" runat="server" ControlToValidate="txtFixedUrl"
				ErrorMessage="Invalid exhibition landing page url." ValidationExpression="^((?:\/[a-zA-Z0-9]+(?:_[a-zA-Z0-9]+)*(?:\-[a-zA-Z0-9]+)*)+)/$">*</asp:RegularExpressionValidator>
		</li>
		<li class="common_form_row clearfix" style="padding-top: 10px;">Description </li>
		<li class="common_form_row clearfix">
			<asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Width="400px"
				Height="100px" MaxLength="1000"></asp:TextBox>
		</li>
		<li class="common_form_row clearfix" style="padding-top: 10px;">Article</li>
		<li class="common_form_row clearfix">
			<asp:TextBox ID="txtArticleId" runat="server"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvArticle" runat="server" ErrorMessage="Please enter article."
				ControlToValidate="txtArticleId">*</asp:RequiredFieldValidator>
		</li>
		<li class="common_form_row clearfix" style="padding-top: 10px;">Start&nbsp;Date </li>
		<li class="common_form_row clearfix">
			<asp:TextBox ID="txtStartDate" runat="server" Width="300px"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvStartDate" runat="server" ErrorMessage="Please enter start date."
				ControlToValidate="txtStartDate">*</asp:RequiredFieldValidator>
		</li>
		<li class="common_form_row clearfix" style="padding-top: 10px;">End&nbsp;Date </li>
		<li class="common_form_row clearfix">
			<asp:TextBox ID="txtEndDate" runat="server" Width="300px"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvEndDate" runat="server" ErrorMessage="Please enter end date."
				ControlToValidate="txtEndDate">*</asp:RequiredFieldValidator>
		</li>
		<li class="common_form_row clearfix" style="padding-top: 10px;">Enabled </li>
		<li class="common_form_row clearfix">
			<asp:CheckBox ID="chkEnabled" runat="server" Checked="True" />
		</li>
		<li class="common_form_row clearfix" style="padding-top: 10px;">Image </li>
		<li class="common_form_row clearfix">
			<div class="add_site_image" style="margin-right: 10px;">
				<asp:Image ID="imgLogo" runat="server" />
			</div>
			<div class="common_form_content">
				<asp:FileUpload ID="fuLogo" runat="server" />
				<asp:RequiredFieldValidator ID="rfvLogo" runat="server" ErrorMessage="Please add Image." ControlToValidate="fuLogo">*</asp:RequiredFieldValidator>
			</div>
		</li>
	</ul>
</div>
<asp:ValidationSummary ID="vsExhibition" runat="server" HeaderText="Please enter the below" ShowSummary="true" ShowMessageBox="false"/>
