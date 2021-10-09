<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="RegistrationEmailDesigner.aspx.cs" Inherits="VerticalPlatformAdminWeb.Platform.Site.RegistrationEmailDesigner" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
	<script src="../../ModuleAdmin/../js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>

	<script type="text/javascript">
		$(document).ready(function () {
			$("#contentAccordion").accordion({
				autoHeight: false
			});
		});
	</script>

	<div class="AdminPanelHeader">
		<h3>Registration Confirmation Email Designer</h3>
	</div>
	<div class="campaign_content_editor_div clearfix">
		<div id="emailDesigner">
			<div class="left">
				<asp:TextBox id="emailTemplate" Rows="20" Columns="50" runat="server" CssClass="wymCampaignContentPaneEditor" TextMode="MultiLine"></asp:TextBox>
				<asp:Button ID="saveButton" CssClass="btn" runat="server" OnClick="saveButton_OnClick" Text="Save" />
				<asp:Button ID="cancelButton" CssClass="btn" runat="server" OnClick="cancelButton_OnClick" Text="Cancel" />
			</div>
			<div class="right">
				<strong>Supported properties</strong>
				<div id="contentAccordion">
					<h3>
						<a href="#">Site</a>
					</h3>
					<div>
						<span>siteDetail.Site.Id</span>
						<span>siteDetail.Site.Name</span>
						<span>siteDetail.ImageUrl</span>
						<span>siteDetail.NavigationUrl</span>
						<span>siteDetail.EmailLogoUrl</span>
						<span>siteDetail.SiteCopyrightMessage</span>
						<span>siteDetail.SiteSignature</span>
					</div>
					<h3>
						<a href="#">User</a>
					</h3>
					<div>
						<span>userDetail.Id</span>
						<span>userDetail.FirstName</span>
						<span>userDetail.LastName</span>
						<span>userDetail.FullName</span>
						<span>userDetail.Email</span>
						<span>userDetail.Password</span>
						<span>userDetail.ProfileUrl</span>
					</div>
					<h3>
						<a href="#">Utility Methods</a>
					</h3>
					<div>
						<span>util.StripHtml(text)</span>
					</div>
				</div>
			</div>
		</div>
	</div>
</asp:Content>