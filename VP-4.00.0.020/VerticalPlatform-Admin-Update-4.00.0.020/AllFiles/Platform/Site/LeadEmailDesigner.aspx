<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage.Master" 
	CodeBehind="LeadEmailDesigner.aspx.cs" Inherits="VerticalPlatformAdminWeb.Platform.Site.LeadEmailDesigner" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">

	<script src="../../js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>

	<script type="text/javascript">
		$(document).ready(function () {
			$("#contentAccordion").accordion({
				autoHeight: false
			});
		});
	</script>

	<div class="AdminPanelHeader">
		<h3><asp:Label ID="headerLabel" runat="server"></asp:Label></h3>
	</div>
	<div class="campaign_content_editor_div clearfix">
		<div id="emailDesigner">
			<div class="left">
				<div class="emailSubject">
					<asp:Label ID="emailSubject" runat="server"></asp:Label>
				</div>
				<div class="emailBody">
					<asp:TextBox id="emailTemplate" Rows="20" Columns="50" runat="server" CssClass="wymCampaignContentPaneEditor" TextMode="MultiLine"></asp:TextBox>
					<asp:Button ID="saveButton" CssClass="btn" runat="server" OnClick="saveButton_Click" Text="Save" />
					<asp:Button ID="cancelButton" CssClass="btn" runat="server" OnClick="cancelButton_Click" Text="Cancel" />
				</div>
			</div>
			<div class="right">
				<strong>Supported properties</strong>
				<div id="contentAccordion">
					<h3>
						<a href="#">Site</a>
					</h3>
					<div>
						<span>context.SiteDetail.Site.Id</span>
						<span>context.SiteDetail.Site.Name</span>
						<span>context.SiteDetail.ImageUrl</span>
						<span>context.SiteDetail.NavigationUrl</span>
						<span>context.EmailLogoUrl</span>
						<span>context.SiteCopyrightMessage</span>
						<span>context.SiteSignature</span>
					</div>
					<h3>
						<a href="#">Lead</a>
					</h3>
					<div>
						<span>context.DeployedLeads</span>
						<span>context.DeployedLeads[<i>index</i>].Lead.Created</span>
						<span>context.DeployedLeads[<i>index</i>].ItemContentType</span>
					</div>
					<h3>
						<a href="#">Lead Product</a>
					</h3>
					<div>
						<span>context.DeployedLeads[<i>index</i>].LeadItem.Id</span>
						<span>context.DeployedLeads[<i>index</i>].LeadItem.Name</span>
						<span>context.DeployedLeads[<i>index</i>].LeadItem.Rank</span>
						<span>context.DeployedLeads[<i>index</i>].LeadItem.CatalogNumber</span>
						<span>context.DeployedLeads[<i>index</i>].ItemVendor.Id</span>
						<span>context.DeployedLeads[<i>index</i>].ItemVendor.Name</span>
						<span>context.DeployedLeads[<i>index</i>].ItemVendor.Rank</span>
						<span>context.DeployedLeads[<i>index</i>].ItemVendor.Description</span>
					</div>
					<h3>
						<a href="#">Lead Vendor</a>
					</h3>
					<div>
						<span>context.DeployedLeads[<i>index</i>].LeadItem.Id</span>
						<span>context.DeployedLeads[<i>index</i>].LeadItem.Name</span>
						<span>context.DeployedLeads[<i>index</i>].LeadItem.Rank</span>
						<span>context.DeployedLeads[<i>index</i>].LeadItem.Description</span>
						<span>context.DeployedLeads[<i>index</i>].ItemVendor</span>
					</div>
					<h3>
						<a href="#">Lead Category</a>
					</h3>
					<div>
						<span>context.DeployedLeads[<i>index</i>].LeadItem.Id</span>
						<span>context.DeployedLeads[<i>index</i>].LeadItem.Name</span>
						<span>context.DeployedLeads[<i>index</i>].LeadItem.Description</span>
					</div>
					<h3>
						<a href="#">Lead User</a>
					</h3>
					<div>
						<span>context.User.Id</span>
						<span>context.User.EmailOptOut</span>
						<span>context.UserProfile.GetName()</span>
						<span>context.UserProfile.Salutation</span>
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
