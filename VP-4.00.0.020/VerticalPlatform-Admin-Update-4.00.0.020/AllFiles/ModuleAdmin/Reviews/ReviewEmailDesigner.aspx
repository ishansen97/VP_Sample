<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" 
CodeBehind="ReviewEmailDesigner.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Reviews.ReviewEmailDesigner" %>

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
				<asp:TextBox id="emailTemplate" Rows="20" Columns="50" runat="server" CssClass="wymCampaignContentPaneEditor" TextMode="MultiLine"></asp:TextBox>
				<asp:Button ID="saveButton" CssClass="btn" runat="server" OnClick="saveButton_Click" Text="Save" />
				<asp:Button ID="cancelButton" CssClass="btn" runat="server" OnClick="cancelButton_Click" Text="Cancel" />
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
						<a href="#">Review Type</a>
					</h3>
					<div>
						<span>context.ReviewType.Name</span>
						<span>context.ReviewType.Title</span>
						<span>context.ReviewType.Description</span>
						<span>context.GetImageUrl()</span>
					</div>
					<h3>
						<a href="#">Article</a>
					</h3>
					<div>
						<span>context.ArticleDetail.Article.Id</span>
						<span>context.ArticleDetail.Article.Summary</span>
						<span>context.ArticleDetail.Article.ShortTitle</span>
						<span>context.ArticleDetail.Article.Title</span>
						<span>context.ArticleDetail.Article.IsExternal</span>
						<span>context.ArticleDetail.GetImageUrl('imageSize')</span>
						<span>context.ArticleDetail.NavigationUrl</span>
						<span>context.ArticleDetail.GetDatePublished('format')</span>
						<span>context.GetDateCreated('format')</span>
						<span>context.ArticleDetail.GetRelatedVendors()</span>
						<span>context.ArticleDetail.GetRelatedProducts()</span>
						<span>context.ArticleDetail.AuthorName(index)</span>
						<span>context.ArticleDetail.AuthorNames()</span>
						<span>context.ArticleDetail.AuthorDetails()</span>
						<span>context.GiftCardId</span>
						<span>context.ArticlePreviewUrl</span>
						<span>context.ArticleVerificationUrl</span>
					</div>
					<h3>
						<a href="#">Product</a>
					</h3>
					<div>
						<span>context.ArticleDetail.GetRelatedProducts()[index].Product.Id</span>
						<span>context.ArticleDetail.GetRelatedProducts()[index].Product.Name</span>
						<span>context.ArticleDetail.GetRelatedProducts()[index].Product.CatalogNumber</span>
						<span>context.ArticleDetail.GetRelatedProducts()[index].Product.Type</span>
						<span>context.ArticleDetail.GetRelatedProducts()[index].ImageUrl</span>
						<span>context.ArticleDetail.GetRelatedProducts()[index].NavigationUrl</span>
						<span>context.ArticleDetail.GetRelatedProducts()[index].Description</span>
					</div>
					<h3>
						<a href="#">Review Product</a>
					</h3>
					<div>
						<span><i><b>For products that are not in the system.</b></i></span>
						<span>context.GetReviewProducts()[index].Id</span>
						<span>context.GetReviewProducts()[index].Name</span>
					</div>
					<h3>
						<a href="#">Vendor</a>
					</h3>
					<div>
						<span>context.ArticleDetail.GetRelatedVendors()[index].Vendor.Id</span>
						<span>context.ArticleDetail.GetRelatedVendors()[index].Vendor.Name</span>
						<span>context.ArticleDetail.GetRelatedVendors()[index].ImageUrl</span>
						<span>context.ArticleDetail.GetRelatedVendors()[index].NavigationUrl</span>
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
