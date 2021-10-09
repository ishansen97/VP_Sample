<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CampaignContentEditor.aspx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.BulkEmail.CampaignContentEditor"
	MasterPageFile="~/MasterPage.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">

	<script src="../../js/JQuery/jquery.json-1.3.min.js" type="text/javascript"></script>

	<script src="../../js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>

	<script src="../../js/JQuery/jquery.modal.js" type="text/javascript"></script>

	<script src="../../Js/JQuery/jquery-impromptu.3.1.min.js" type="text/javascript"></script>
	
	<script src="../../js/ArticleEditor/tinymce/tiny_mce.js" type="text/javascript"></script>
	
	<script src="../../js/ArticleEditor/tinymce/jquery.tinymce.js" type="text/javascript"></script>

	<script src="../../Js/ArticleEditor/tinymce/Scripting/ScriptingContext.js" type="text/javascript"></script>

	<script src="../../Js/ArticleEditor/tinymce/Scripting/BaseScript.js" type="text/javascript"></script>

	<script src="../../Js/ArticleEditor/tinymce/Scripting/GroupSnippet.js" type="text/javascript"></script>

	<script src="../../Js/ArticleEditor/tinymce/Scripting/ScriptManager.js" type="text/javascript"></script>

	<script src="../../Js/ArticleEditor/tinymce/Scripting/Snippet.js" type="text/javascript"></script>

	<script type="text/javascript">
		$(document).ready(function() {
			var element = $("#CampaignContentEditor");
			var manager = new VP.Scripting.ScriptManager();
			if (manager) {
				manager.LockButtons();
			}

			$("#contentAccordion").accordion({
				autoHeight: false
			});
		});
	</script>

	<asp:ScriptManagerProxy ID="ScriptManagerProxy" runat="server">
		<Services>
			<asp:ServiceReference Path="~/Services/BulkEmailWebService.asmx" />
		</Services>
	</asp:ScriptManagerProxy>
	<asp:HiddenField ID="hdnArticleSpecificCssClasses" runat="server" />
	<div class="AdminPanelHeader">
		<h3>
			<asp:Label ID="lblTitle" runat="server" Text=""></asp:Label>
		</h3>
	</div>
	<div class="AdminPanelContent">
		<div class="inline-form-container" style="margin-bottom:10px;">
			<span class="title">Pane</span>
			<asp:DropDownList ID="ddlPane" runat="server" AppendDataBoundItems="true">
				<asp:ListItem Text="-Select-" Value=""></asp:ListItem>
			</asp:DropDownList>
		</div>
		<div class="campaign_content_editor_div clearfix">
			<div class="left">
				<div id="CampaignContentEditor" class="campaign_content_editor">
					<div id="CampaignContentEditorTemplate">
						<h4 class="content_editor_message">
							Please select template pane.</h4>
					</div>
				</div>
				<div class="PluginPropertyDialog PluginPropertyWindow">
				</div>
				<div id="PluginPropertyDialogTemplates" class="PluginPropertyDialogTemplates">
					<div id="TagsSelectorDialog">
						<ul>
							<li>
								<label>
									Code Snippet</label>
								<asp:DropDownList ID="ddlCodeSnippets" class="ddlTags" runat="server">
								</asp:DropDownList>
							</li>
						</ul>
					</div>
				</div>
				<div class="IE7ButtonStyls">
					<input type="button" id="btnSave" value="Save" class="btn" />
					<asp:HyperLink ID="lnkBack" runat="server" CssClass="btn"></asp:HyperLink>
				</div>
			</div>
			<div class="right">
				<strong>Supported properties</strong>
				<div id="contentAccordion">
					<h3>
						<a href="#">Site</a></h3>
					<div>
						<span>site.Site.Id</span><span>site.Site.Name</span><span>site.ImageUrl</span><span>site.NavigationUrl</span>
					</div>
					<h3>
						<a href="#">Campaign</a></h3>
					<div>
						<span>campaign.Campaign.Id</span>
						<span>campaign.Campaign.Name</span>
						<span>DatePublished('format')</span>
					</div>
					<h3>
						<a href="#">Article</a></h3>
					<div>
						<span>Article.Id</span><span>Article.Summary</span><span>Article.ShortTitle</span>
						<span>Article.Title</span><span>Article.SubTitle</span><span>Article.IsExternal</span> <span>ImageUrl</span>
						<span>GetImageUrl('imageSize')</span><span>NavigationUrl</span>
						<span>DatePublished('format')</span><span>GetRelatedVendors()</span> <span>GetRelatedCategories()</span>
						<span>GetRelatedProducts()</span><span>GetSection(index)</span>
						<span>GetCustomPropertyById(customPropertyId)</span>
						<span>GetCustomPropertyByName(customPropertyName)</span>
						<span>AuthorName(index)</span>
						<span>AuthorNames()</span>
						<span>AuthorDetails()</span>
						<span>GetArticleTypeName(isUppercase)</span>
					</div>
					<h3>
						<a href="#">Category</a></h3>
					<div>
						<span>Category.Id</span><span>Category.Name</span><span>Category.Description</span><span>NavigationUrl</span>
					</div>
					<h3>
						<a href="#">Product</a></h3>
					<div>
						<span>Product.Id</span> <span>Product.Name</span> <span>Product.CatalogNumber</span>
						<span>ImageUrl</span> <span>NavigationUrl</span> <span>Description</span><span>Manufacture</span>
						<span>GetImageUrl('imageSize')</span></div>
					<h3>
						<a href="#">Vendor</a></h3>
					<div>
						<span>Vendor.Id</span><span>Vendor.Name</span><span>ImageUrl</span><span>NavigationUrl</span>
					</div>
					<h3><a href="#">Utility Methods</a></h3>
					<div>
						<span>util.StripHtml(text)</span>
						<span>util.FormatDate(date, format)</span>
					</div>
				</div>
			</div>
		</div>
		<br />
		<%--<asp:HyperLink ID="lnkCampaignList" runat="server" CssClass="common_text_button">Campaign List</asp:HyperLink>--%>
		<asp:HiddenField ID="hdnPaneContent" runat="server" />
	</div>
	<div class="jqmWindow" id="propertyDialog">
		<div class="dialog_container">
			<div class="dialog_header clearfix">
				<h2>
					Properties
				</h2>
			</div>
			<div class="dialog_content1" style="padding: 10px 5px;">
				<div id="custom">
				</div>
				<div class="clear">
				</div>
				<div class="dialog_buttons" style="padding: 5px 5px 5px 5px;">
					<input type="button" id="propertySave" value="Ok" class="common_text_button" />
					<input type="button" id="propertyCancel" value="Cancel" class="common_text_button" />
				</div>
			</div>
			<div class="dialog_footer">
			</div>
		</div>
	</div>
</asp:Content>
