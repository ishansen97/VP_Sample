<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SelectSiteDialog.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.SelectSiteDialog" %>
<style type="text/css">
	.select_site_panel_outer
	{
		background: #ffffff;
		-moz-border-radius: 5px;
		-webkit-border-radius: 5px;
		padding: 5px;
	}
	.dialog_container
	{
		width: 380px;
		margin: 100px auto 0px auto;
		background: transparent;
		padding-top: 0px;
	}
	.dialog_header
	{
		display: none;
	}
	.dialog_content
	{
		height: auto;
		border: none;
		-moz-border-radius: 5px;
		-webkit-border-radius: 5px;
		background: #ffffff url(App_themes/Default/Images/bodyBg.jpg);;
		padding: 30px 5px 70px 5px;
	}
	.select_site_outer
	{
		width: 260px;
		margin: 0 auto;
	}
	.select_site_panel
	{
		width: 250px;
		height: 80px;
	}
	.dialog_content_inner
	{
		float: none;
		padding-bottom: 0px !important;
	}
	.dialog_buttons
	{
		width: 319px !important;
		margin:-70px auto 0px 46px !important;
		text-align: right;
		border-top: none;
		padding: 0px !important;
		position:absolute !important;
		top: auto !important;
		background: none !important;
	}
	.dialog_buttons.main
	{
		border-top: none !important;
	}
	.dialog_buttons_inner
	{
		border-top: none !important;
		padding: 0px 0px 0px 0px;
	}
	.dialog_buttons_inner .btn
	{
	}
	.dialog_footer
	{
		display: none;
	}
	.select_site_panel_outer
	{
		border: none;
	}
	.select_site_panel_outer .dialog_content_outer
	{
		border: none;
		padding-top: 1px;
		padding-bottom: 1px;
	}
	.select_site_panel_outer .dialog_content, .select_site_panel_outer .dialog_content1
	{
		border: none;
	}
	
	#show_progress_div{display:none !important;}
</style>
<div class="logiin-container" style="margin-top:20px; height:auto;">
        <div class="brand"><asp:Label ID="lblSite" runat="server" AssociatedControlID="ddlSite" Text="Label" style="font-size:1em;font-weight:bold;">Select Site</asp:Label></div>
		<div id="loginPanel" style="text-align:center;">
			<asp:DropDownList ID="ddlSite" runat="server" Style="width: 240px">
			</asp:DropDownList>
			<asp:RequiredFieldValidator ID="rfvSite" runat="server" ControlToValidate="ddlSite"
				ErrorMessage="Please select a site.">*</asp:RequiredFieldValidator>
		</div>
</div>
