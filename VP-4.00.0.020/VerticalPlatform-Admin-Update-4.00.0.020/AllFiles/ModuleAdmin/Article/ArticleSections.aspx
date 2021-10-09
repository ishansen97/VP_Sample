<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="ArticleSections.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Articles.ArticleSections"
	Title="Untitled Page" %>
	
<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">

	<script src="../../js/JQuery/jquery.json-1.3.min.js" type="text/javascript"></script>

	<script src="../../js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>

	<script src="../../js/JQuery/jquery.tree.js" type="text/javascript"></script>

	<script src="../../js/JQuery/jquery.modal.js" type="text/javascript"></script>

	<script src="../../Js/JQuery/jquery.pager.js" type="text/javascript"></script>

	<script src="../../Js/JQuery/fileuploader.js" type="text/javascript"></script>

	<script src="../../Js/ArticleEditor/TagPicker.js" type="text/javascript"></script>

	<script src="../../Js/ContentPicker.js" type="text/javascript"></script>

	<script src="../../js/ArticleEditor/tinymce/jquery.tinymce.js" type="text/javascript"></script>
	
	<script src="../../js/ArticleEditor/tinymce/PluginManager.js" type="text/javascript"></script>	
	
	<script src="../../js/ArticleEditor/tinymce/CustomPlugins.js" type="text/javascript"></script>

	<script src="../../Js/ArticleEditor/ArticleSectionUploader.js" type="text/javascript"></script>

	<script src="../../Js/ArticleEditor/ArticleSectionManager.js" type="text/javascript"></script>

	<script src="../../js/ArticleEditor/ArticleSectionValidater.js" type="text/javascript"></script>

	<script src="../../js/ArticleEditor/SectionEditor.js" type="text/javascript"></script>

	<script src="../../js/ArticleEditor/ResourceEditor.js" type="text/javascript"></script>

	<script src="../../js/ArticleEditor/VideoResourceEditor.js" type="text/javascript"></script>

	<script src="../../Js/ArticleEditor/MetaDataResourceEditor.js" type="text/javascript"></script>

	<script src="../../Js/ArticleEditor/ArticleToolsResourceEditor.js" type="text/javascript"></script>

	<script src="../../js/ArticleEditor/LinkResourceEditor.js" type="text/javascript"></script>

	<script src="../../Js/ArticleEditor/EmbededCodeResourceEditor.js" type="text/javascript"></script>

	<script src="../../Js/ArticleEditor/FlashResourceEditor.js" type="text/javascript"></script>

	<script src="../../Js/ArticleEditor/ImageResourceEditor.js" type="text/javascript"></script>

	<script src="../../Js/ArticleEditor/LeadFormResourceEditor.js" type="text/javascript"></script>

	<script src="../../Js/ArticleEditor/RelatedCategoryResourceEditor.js" type="text/javascript"></script>

	<script src="../../Js/ArticleEditor/RelatedVendorResourceEditor.js" type="text/javascript"></script>

	<script src="../../Js/ArticleEditor/RelatedProductsResourceEditor.js" type="text/javascript"></script>

	<script src="../../Js/ArticleEditor/TextResourceEditor.js" type="text/javascript"></script>

	<script src="../../Js/ArticleEditor/SectionSettingEditor.js" type="text/javascript"></script>

	<script src="../../Js/ArticleEditor/ResourceSettingEditor.js" type="text/javascript"></script>

	<script src="../../Js/ArticleEditor/TextResourceSettingEditor.js" type="text/javascript"></script>

	<script src="../../Js/ArticleEditor/ExhibitionVendorSpecialResourceEditor.js" type="text/javascript"></script>

	<script src="../../Js/ArticleEditor/AdvertisementResourceEditor.js" type="text/javascript"></script>

	<script src="../../Js/ArticleEditor/ArticleListResourceEditor.js" type="text/javascript"></script>

	<script src="../../Js/ArticleEditor/HorizontalMatrixResourceEditor.js" type="text/javascript"></script>

	<script src="../../Js/ArticleEditor/MultimediaGalleryResourceEditor.js" type="text/javascript"></script>

	<script src="../../Js/ArticleEditor/RatingResourceEditor.js" type="text/javascript"></script>

	<script type="text/javascript">
		$(document).ready(function() {
			var mediaUrl = $("input[id$='hdnMediaUrl']").val();
			var siteId = $("input[id$='hdnSiteId']").val();
			var articleSectionManager = new VP.ArticleEditor.ArticleSectionManager(mediaUrl, siteId);
			var articleSectionUploder = new VP.ArticleEditor.ArticleSectionUploader(siteId);

			var id = $("input[id$='hdnArticleId']").val();
			articleSectionManager.LoadArticle(id);

			$("#closeDialogBtn").click(function() {
				$("#PluginPropertyDialog").jqmHide();
			});
		});
			
	</script>

	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>
				<asp:Label ID="lblHeader" runat="server" BackColor="Transparent"> Add/ Edit Article Sections</asp:Label></h3>
		</div>
		<div class="AdminPanelContent">
			<asp:ScriptManagerProxy ID="smScript" runat="server">
				<Services>
					<asp:ServiceReference InlineScript="true" Path="~/Services/ArticleEditorService.asmx" />
				</Services>
			</asp:ScriptManagerProxy>
			<asp:HiddenField ID="hdnArticleId" runat="server" />
			<asp:HiddenField ID="hdnMediaUrl" runat="server" />
			<asp:HiddenField ID="hdnArticleSpecificCssClasses" runat="server" />
			<asp:HiddenField ID="hdnSiteId" runat="server" />
			<asp:HiddenField ID="hdnApplicationName" runat="server" />
			<asp:HiddenField ID="hdnCategoryList" runat="server" />
			<asp:HiddenField ID="hdnArticleTypeList" runat="server" />
			<asp:HiddenField ID="hdnIsTemplate" runat="server" Value="false" />
			<div id="ArticleEditor">
				<div class="ArticleEditPane">
					<div class="ArticleEditButtons">
						<ul>
							<li><span id="PageButton" class="ArticleEditToolBarButton">
								<img src="../../App_Themes/Default/Images/ArticleEditor/page_add.png" alt="Add Page"
									title="Add Page" /></span></li>
							<li><span id="ContainerButton" class="ArticleEditToolBarButton">
								<img src="../../App_Themes/Default/Images/ArticleEditor/add_section.png" alt="Add Section"
									title="Add Section" /></span></li>
							<li><span class="Seperater"></span></li>
							<li><span id="ArticleToolButton" class="ArticleEditToolBarButton">
								<img src="../../App_Themes/Default/Images/ArticleEditor/wrench.png" alt="Add Article Tool"
									title="Add Article Tool" /></span></li>
							<li><span id="EmbeddedCodeButton" class="ArticleEditToolBarButton">
								<img src="../../App_Themes/Default/Images/ArticleEditor/add_codel.png" alt="Add Embedded Code"
									title="Add Embedded Code" /></span></li>
							<li><span id="FlashButton" class="ArticleEditToolBarButton">
								<img src="../../App_Themes/Default/Images/ArticleEditor/add_flash.png" alt="Add Flash"
									title="Add Flash" /></span></li>
							<li><span id="ImageButton" class="ArticleEditToolBarButton">
								<img src="../../App_Themes/Default/Images/ArticleEditor/picture_add.png" alt="Add Image"
									title="Add Image" /></span></li>
							<li><span id="LeadFormButton" class="ArticleEditToolBarButton">
								<img src="../../App_Themes/Default/Images/ArticleEditor/add_lead.png" alt="Add Lead Form"
									title="Add Lead Form" /></span></li>
							<li><span id="LinkButton" class="ArticleEditToolBarButton">
								<img src="../../App_Themes/Default/Images/ArticleEditor/world_link.png" alt="Add Link"
									title="Add Link" /></span></li>
							<li><span id="MetaDataButton" class="ArticleEditToolBarButton">
								<img src="../../App_Themes/Default/Images/ArticleEditor/add_metadata.png" alt="Add Meta Data"
									title="Add Meta Data" /></span></li>
							<li><span id="RelatedProductButton" class="ArticleEditToolBarButton">
								<img src="../../App_Themes/Default/Images/ArticleEditor/add_product1.png" alt="Add Related Products"
									title="Add Related Products" /></span></li>
							<li><span id="RelatedCategoryButton" class="ArticleEditToolBarButton">
								<img src="../../App_Themes/Default/Images/ArticleEditor/add_category.png" alt="Add Related Category"
									title="Add Related Category" /></span></li>
							<li><span id="TextButton" class="ArticleEditToolBarButton">
								<img src="../../App_Themes/Default/Images/ArticleEditor/add_text.png" alt="Add Text"
									title="Add Text" /></span></li>
							<li><span id="VideoButton" class="ArticleEditToolBarButton">
								<img src="../../App_Themes/Default/Images/ArticleEditor/add_video.png" alt="Add Video"
									title="Add Video" /></span></li>
							<li><span id="ExhibitionVendorSpecial" class="ArticleEditToolBarButton">
								<img src="../../App_Themes/Default/Images/ArticleEditor/add_specials.jpg" alt="Add Exhibition Vendor Special"
									title="Add Exhibition Vendor Special" /></span></li>
							<li><span id="Advertisement" class="ArticleEditToolBarButton">
								<img src="../../App_Themes/Default/Images/ArticleEditor/ad.png" alt="Add Advertisement"
									title="Add Advertisement" /></span></li>
							<li><span id="ArticleList" class="ArticleEditToolBarButton">
								<img src="../../App_Themes/Default/Images/ArticleEditor/add_articleList.png" alt="Add Article List"
									title="Add Article List" /></span></li>
							<li><span id="HorizontalMatrix" class="ArticleEditToolBarButton">
								<img src="../../App_Themes/Default/Images/ArticleEditor/add_matrix.png" alt="Add Horizontal Matrix"
									title="Add Horizontal Matrix" /></span></li>
							<li><span id="RelatedVendor" class="ArticleEditToolBarButton">
								<img src="../../App_Themes/Default/Images/ArticleEditor/vendor.png" alt="Add Related Vendor"
									title="Add Related Vendor" /></span></li>
							<li><span id="MultimediaGallery" class="ArticleEditToolBarButton">
								<img src="../../App_Themes/Default/Images/ArticleEditor/add_multimedia.png" alt="Add Multimedia Gallery"
									title="Add Multimedia Gallery" /></span></li>
							<li><span id="Rating" class="ArticleEditToolBarButton">
								<img src="../../App_Themes/Default/Images/ArticleEditor/rating.png" alt="Add Rating"
								title="Add Rating" /></span></li>
						</ul>
					</div>
					<div class="ArticleEditButtonFooter">
						<hr />
					</div>
					<div class="TreeStructure">
						<div class="SectionTree" id="articleTree" style="float: left;">
							<ul class="articleTreeRoot">
							</ul>
						</div>
					</div>
					<div class="ContentEditPane">
						<div class="ArticleContentEdit">
							<p class="ContentMessage">
								Please select a content to edit..</p>
						</div>
						<ul class="EditorErrors">
						</ul>
					</div>
				</div>
				<div class="SectionSaveButtonPanel">
					<input id="btnPreview" type="button" value="Preview" class="common_text_button" />
					<input id="btnSaveSections" type="button" value="Save Changes" class="common_text_button" />
					<input id="btnCancel" type="button" value="Cancel" class="common_text_button" />
				</div>
			</div>
			<div id="PluginPropertyDialog" class="jqmWindow PluginPropertyDialog plugin_property_contents">
				<div class="dialog_container">
					<div class="dialog_header clearfix">
						<h2>
						</h2>
						<div id="closeDialogBtn" class="dialog_close">
							x
						</div>
					</div>
					<div class="dialog_content">
						<div id="PluginPropertyDialogPane" class="PluginPropertyDialogPane">
						</div>
						<div>
							<ul id="PluginPropertyDialogErrors">
							</ul>
						</div>
						<div id="PluginPropertyDialogCommands">
							<div class="dialog_buttons">
								<input type="button" id="btnSaveProperties" value="Save" class="common_text_button" />
								<input type="button" id="btnCancelPropertes" value="Cancel" class="common_text_button" />
							</div>
						</div>
					</div>
					<div class="dialog_footer">
					</div>
				</div>
			</div>
			<div id="PluginPropertyDialogTemplates" class="PluginPropertyDialogTemplates">
				<div id="TagsSelectorDialog">
					<h2>
						Tags Selector</h2>
					<ul>
						<li>
							<label>
								Select Tag</label>
							<asp:DropDownList ID="ddlTags" class="ddlTags" runat="server">
							</asp:DropDownList>
						</li>
					</ul>
				</div>
				<div id="LinkPropertyDialog">
					<h2>
						Link Properties</h2>
					<ul>
						<li>
							<label>
								Internal Link</label>
							<input type="checkbox" id="chkIsInternalLink" />
						</li>
						<li>
							<label>
								Url</label>
							<input type="text" id="txtUrl" onblur="VP.ArticleEditor.LinkPlugin.GetFixedUrlId()" />
						</li>
						<li>
							<label>
								Text</label>
							<input type="text" id="txtText" />
						</li>
						<li>
							<label>
								Title</label>
							<input type="text" id="txtTitle" />
						</li>
						<li>
							<label>
								Open In New Window</label>
							<input type="checkbox" id="chkIsOpenInNewWindow" />
						</li>
						<li>
							<label>
								Custom Css</label>
							<input type="text" id="txtCustomCss" />
							<asp:DropDownList ID="ddlLinkPluginCssClass" class="ddlLinkPluginCssClass" runat="server">
							</asp:DropDownList>
						</li>
						<li>
							<label>
								Image</label>
							<input type="text" id="txtLinkImage" />
						</li>
					</ul>
				</div>
				<div id="FlashPropertyDialog">
					<h2>
						Flash Properties</h2>
					<ul>
						<li id="dFlashUrl">
							<label>
								Flash Url</label>
							<input type="text" id="txtTextFlashUrl" />
						</li>
						<li id="dFlashWidth">
							<label>
								Width</label>
							<input type="text" id="txtTextFlashWidth" />
						</li>
						<li id="dFlashHeight">
							<label>
								Height</label>
							<input type="text" id="txtTextFlashHeight" />
						</li>
						<li id="dFlashVars">
							<label>
								Flash Vars</label>
							<input type="text" id="txtTextFlashVars" />
						</li>
					</ul>
				</div>
				<div id="EmbeddedCodePropertyDialog">
					<h2>
						Embedded Code Properties</h2>
					<ul class="float_ul clearfix">
						<li>
							<label>
								Embedded Code</label>
						</li>
						<li>
							<textarea id="txtEmbeddedCode" style="height: 75px; width: 200px;"></textarea>
						</li>
					</ul>
				</div>
				<div id="ImagePropertyDialog">
					<h2>
						Image Properties</h2>
					<ul>
						<li>
							<label>
								Image Name</label>
							<input type="text" id="txtImageName" />
						</li>
						<li>
							<label>
								Image Height</label>
							<input type="text" id="txtImageHeight" />
						</li>
						<li>
							<label>
								Image Width</label>
							<input type="text" id="txtImageWidth" />
						</li>
						<li>
							<label>
								Image 'alt' tag value</label>
							<input type="text" id="txtImageAltTag" />
						</li>
						<li id="Li1">
							<label>
								Custom Css</label>
							<input type="text" id="txtImageCustomCss" />
							<asp:DropDownList ID="ddlImagePluginCssClass" class="ddlImagePluginCssClass" runat="server">
							</asp:DropDownList>
						</li>
					</ul>
				</div>
				<div id="VideoPropertyDialog">
					<h2>
						Video Properties</h2>
					<ul class="ResourcePropertyEditPane">
						<li id="dVideoPlaylist">
							<label>
								Playlist</label>
							<input type="checkbox" id="chkIsVideoListing" />
						</li>
						<li id="dVideoId">
							<label>
								Video Id(s) (comma separated)</label>
							<input type="text" id="txtVideoId" />
						</li>
						<li id="dVideoLength">
							<label>
								Length (hh:mm)</label>
							<input type="text" id="txtVideoLength" />
						</li>
						<li id="dVideoWidth">
							<label>
								Width</label>
							<input type="text" id="txtVideoWidth" />
						</li>
						<li id="dVideoHeight">
							<label>
								Height</label>
							<input type="text" id="txtVideoHeight" />
						</li>
						<li id="dVideoPlayerId">
							<label>
								Player Id</label>
							<input type="text" id="txtVideoPlayerId" />
						</li>
						<li id="dAutoPlay">
							<label>
								Autoplay</label>
							<input type="checkbox" id="chkAutoPlay" />
						</li>
					</ul>
				</div>
			</div>
			<div id="SectionProperties" class="SectionProperties">
				<div id="SectionPropertyEntry">
					<ul>
						<li id="sectionName">
							<label>Section Name</label>
							<input type="text" class="txtSectionName" />
						</li>
						<li id="lblSectionTitle">
							<label>
								Section Title</label>
							<input type="text" class="txtSectionTitle" />
						</li>
						<li id="lblIsPopup">
							<label>
								Is popup</label>
							<input type="checkbox" class="chkIsPopup" />
						</li>
						<li id="lblPreviewImageCode">
							<label>
								Preview Image</label>
							<input type="text" class="txtPreviewImageCode" />
						</li>
						<li id="lblPreviewImageTitle">
							<label>
								Preview Image Title</label>
							<input type="text" class="txtPreviewImageTitle" />
						</li>
						<li id="lblToggleSection">
							<label>
								Toggle Section</label>
							<input type="checkbox" class="chkToggleSection" />
						</li>
						<li id="lblToggleText">
							<label>
								Toggle Text</label>
							<input type="text" class="txtToggleText" />
						</li>
						<li id="lblCssClass">
							<label>
								CSS Class</label>
							<input type="text" class="txtCssClass" />
							<asp:DropDownList ID="ddlCssClass" class="ddlCssClass" runat="server">
							</asp:DropDownList>
						</li>
						<li id="hideWhenEmpty">
							<label>Hide When Empty</label>
							<input type="checkbox" class="hideWhenEmptyToggle" />
						</li>
					</ul>
				</div>
				<div id="ContentButtonPanel">
					<br />
					<input id="btnApply" type="button" value="Apply" class="common_text_button" />
					<input id="btnRemove" type="button" value="Remove" class="common_text_button" />
					<input id="btnCancel" type="button" value="Cancel" class="common_text_button" />
					<input id="btnSettings" type="button" value="Settings" class="common_text_button" />
				</div>
			</div>
			<div id="TemplateSettings" class="TemplateSettings">
				<div id="SectionSettings">
					<ul>
						<li id="lblSectionTitleOptional">
							<label>
								Section Title Optional</label>
							<input type="checkbox" class="chkSectionTitleOptional" />
						</li>
						<li id="lblRestricted">
							<label>
								Locked</label>
							<input type="checkbox" class="chkLocked" />
						</li>
						<li id="lblItemReorder">
							<label>
								Enable item reorder</label>
							<input type="checkbox" class="chkItemReorder" />
						</li>
						<li id="lblChangeCss">
							<label>
								Allow change css class</label>
							<input type="checkbox" class="chkChangeCss" />
						</li>
						<li id="lblRestrictedItems">
							<br />
							<label class="RestrictedItems">
								Restricted Resource types</label>
							<asp:CheckBoxList ID="chklItemRestricted" runat="server" CssClass="chklItemRestricted"
								RepeatColumns="3" RepeatDirection="Horizontal">
							</asp:CheckBoxList>
						</li>
					</ul>
				</div>
				<div id="TextResourceSettings">
					<ul>
						<li id="lblTextPlugin">
							<label>
								Restricted plugin types</label>
							<asp:CheckBoxList ID="chklPluginTypes" runat="server" CssClass="chklPluginTypes"
								RepeatColumns="3" RepeatDirection="Horizontal">
							</asp:CheckBoxList>
						</li>
					</ul>
				</div>
				<div id="TemplateSettingsButtonPanel">
					<input id="btnApplySettings" type="button" value="Apply" />
					<input id="btnBack" type="button" value="Back" />
				</div>
			</div>
			<div id="SectionEditorTemplates" class="SectionEditorTemplates">
				<div id="TextResourceEditorTemplate">
					<textarea class="TextResourceEditor" rows="20" cols="50"></textarea>
				</div>
				<div id="RelatedVedndorResourceEditorTemplate">
				<ul>
						<li>
							<label>
								Display Vendor Logo</label>
							<input type="checkbox" class="DisplayVendorLogo" />
						</li>
					</ul>
				</div>
				<div id="ImageResourceEditorTemplate">
					<ul>
						<li id="ImageName">
							<label>
								Image Name</label>
							<input type="text" class="txtImageName" />
						</li>
						<li id="ImageHeight">
							<label>
								Image Height</label>
							<input type="text" class="txtImageHeight" />
						</li>
						<li id="ImageWidth">
							<label>
								Image Width</label>
							<input type="text" class="txtImageWidth" />
						</li>
						<li id="ImageAlt">
							<label>
								Image 'alt' tag value</label>
							<input type="text" class="txtImageAltTag" />
						</li>
                        <li id="ImageCustomCss">
							<label>
								Custom Css</label>
							<input type="text" class="imageCustomCssText" />
						</li>
						<li id="ImageFigure">
							<label>
								Image Figure</label>
							<input type="checkbox" class="chkImageFigure" />
						</li>
						<li id="ImageZoom">
							<label>
								Image Zoom</label>
							<input type="checkbox" class="chkImageZoom" />
						</li>
					</ul>
				</div>
				<div id="EmbeddedCodeResourceEditorTemplate">
					<ul>
						<li>
							<label>
								Embedded Code</label></li>
						<li id="Code">
							<textarea class="txtEmbeddedCode" rows="10" cols="50"> </textarea>
						</li>
					</ul>
				</div>
				<div id="AdvertisementResourceEditorTemplate">
					<ul>
						<li id="Position">
							<label>
								Position</label><input type="text" class="txtPosition" />
						</li>
					</ul>
				</div>
				<div id="RelatedProductsResourceEditorTemplate">
					<ul>
						<li id="NavigationUrl">
							<label>
								Navigation Url</label>
							<input type="radio" name="rdoNavigationUrl" class="rdoProductDetails" value="Product details page" /><label>Product
								Details</label>
							<input type="radio" name="rdoNavigationUrl" class="rdoLeadForm" value="Lead form page" /><label>Default
								Action</label>
						</li>
						<li id="ProductSpecificationLength">
							<label>
								Product Specification Length</label>
							<input type="text" class="txtLength" />
						</li>
						<li>
							<label>Hide "Learn More" Text</label>
							<input type="checkbox" class="learnMoreCheckbox" />
						</li>
						<li id="ProducTitleDisplayLength">
							<label>
								Product Title Display Length</label>
							<input type="text" class="txtLengthProductTitle" />
						</li>
						<li id="DisplayItems">
							<label>
								Product List Display Settings</label>
							<asp:DropDownList ID="ddlProductListDisplayItems" runat="server" CssClass="ddlProductListDisplayItems">
							</asp:DropDownList>
							<input type="button" class="btnAddItem" value="Add" />
						</li>
						<li>
							<label>
								&nbsp;
							</label>
							<asp:ListBox ID="lstDisplayItems" CssClass="lstDisplayItems" runat="server" Width="300">
							</asp:ListBox>
						</li>
						<li>
							<label>
							</label>
							<input type="button" class="btnMoveUp" value="Move up" />
							<input type="button" class="btnMoveDown" value="Move down" />
							<input type="button" class="btnRemoveItem" value="Remove" />
						</li>
						<li>
							<label>Show Default Action as "Get Info" Link</label>
							<input type="checkbox" class="getInfoLinkTextBox" />
						</li>
						<li id="Randomization">
							<label>
								Enable Randomization</label>
							<input type="checkbox" class="chkEnableRandomization" />
						</li>
						<li id="TotalSlots">
							<label>
								Total Display Slots</label>
							<input type="text" class="txtTotalSlots" value="10" />
						</li>
						<li id="AssociatedSlots">
							<label>
								Slots allocated for Associated Products</label>
							<input type="text" class="txtAssociatedSlots" />
						</li>
						<li id="CompareProductsButton">
							<label>
								Enable Compare Button</label>
							<input type="checkbox" class="chkEnableCompareButton" />
						</li>
						<li id="EnableCustomText">
							<label>
								Enable Custom Text for Compare Button</label>
							<input type="checkbox" class="chkCustomTextCompareButton" />
						</li>
						<li id="CompareButtonCustomText">
							<label>
								Custom Text</label>
							<input type="text" class="txtCompareButtonCustomText" />
						</li>
					</ul>
				</div>
				<div id="RelatedCategoryResourceEditorTemplate">
					<ul>
						<li id="CategoryDescriptionLength">
							<label>
								Category Description Truncate Length</label>
							<input type="text" class="txtLength" />
						</li>
						<li id="DisplayCategoryShortName">
							<label>
								Display Category Short Name</label>
							<input type="checkbox" class="chkDisplayShortName" />
						</li>
						<li id="MaximumNumberOfCategories">
							<label>
								Maximum Number of Categories</label>
							<input type="text" class="txtMax" />
						</li>
						<li id="hideCategoryDescription">
							<label>
								Hide Category Description</label>
							<input type="checkbox" class="hideCategoryDescriptionCheckbox" />
						</li>
						<li id="DisplayCategoryImage">
							<label>
								Display Category Image</label>
							<input type="checkbox" class="DisplayCategoryImageCheckbox" style = "margin-right: 20px" />
							<asp:DropDownList ID="ddlThumbSize" runat="server" CssClass="ImageSize">
								<asp:ListItem Text="Extra Large Image – 400 x 300" Value="1"></asp:ListItem>
								<asp:ListItem Text="Featured Image – 187 x 140" Value="2"></asp:ListItem>
								<asp:ListItem Text="Thumbnail Image – 134 x 100" Value="3"  Selected = "True"></asp:ListItem>
								<asp:ListItem Text="Micro Image – 52 x 39" Value="4"></asp:ListItem>
							</asp:DropDownList>
						</li>
					</ul>
				</div>
				<div id="FlashResourceEditorTemplate">
					<ul>
						<li id="FlashFileUrl">
							<label>
								Url</label>
							<input type="text" class="txtUrl" />
						</li>
						<li id="FlashVideoWidth">
							<label>
								Width</label>
							<input type="text" class="txtWidth" />
						</li>
						<li id="FlashVideoHeight">
							<label>
								Height</label>
							<input type="text" class="txtHeight" />
						</li>
						<li id="FlashVars">
							<label>
								Flash Vars</label>
							<input type="text" class="txtFlashVars" />
						</li>
					</ul>
				</div>
				<div id="ExhibitionVendorSpecialResourceEditorTemplate">
					<ul>
						<li>
							<p>
								This resource has no properties.</p>
						</li>
					</ul>
				</div>
				<div id="LinkResourceEditorTemplate">
					<ul>
						<li id="IsInternalLink">
							<label>
								Internal Link</label>
							<input type="checkbox" class="chkIsInternalLink" />
						</li>
						<li id="LinkUrl">
							<label>
								Url</label>
							<input type="text" class="txtUrl" />
						</li>
						<li id="LinkText">
							<label>
								Text</label>
							<input type="text" class="txtText" />
						</li>
						<li id="Title">
							<label>
								Title</label>
							<input type="text" class="txtTitle" />
						</li>
						<li id="IsOpenInNewWindow">
							<label>
								Open In New Window</label>
							<input type="checkbox" class="chkIsOpenInNewWindow" />
						</li>
						<li id="CustomCss">
							<label>
								Custom Css</label>
							<input type="text" class="txtCustomCss" />
							<asp:DropDownList ID="ddlLinkResourceCssClass" class="ddlLinkResourceCssClass" runat="server">
							</asp:DropDownList>
						</li>
						<li>
							<label>
								Image</label>
							<input type="text" class="txtLinkImage" />
						</li>
						<li>
							<label>NoFollow Link</label>
							<input type="checkbox" class="nofollowCheck" />
						</li>
					</ul>
				</div>
				<div id="VideoResourceEditorTemplate">
					<ul class="ResourcePropertyEditPane">
						<li id="IsVideoListing">
							<label class="sectionLable">
								Playlist</label>
							<input type="checkbox" class="chkIsVideoListing" />
						</li>
						<li id="VideoId">
							<label class="sectionLable">
								Video Id(s) (comma separated)</label>
							<input type="text" class="txtVideoId" />
						</li>
						<li id="VideoLength">
							<label>
								Length (hh:mm)</label>
							<input type="text" class="txtVideoLength" />
						</li>
						<li id="VideoWidth">
							<label class="sectionLable">
								Width</label>
							<input type="text" class="txtWidth" />
						</li>
						<li id="VideoHeight">
							<label class="sectionLable">
								Height</label>
							<input type="text" class="txtHeight" />
						</li>
						<li id="PlayerId">
							<label class="sectionLable">
								Player Id</label>
							<input type="text" class="txtPlayerId" />
						</li>
						<li id="AutoPlay">
							<label class="sectionLable">
								Autoplay</label>
							<input type="checkbox" class="chkAutoPlay" />
						</li>
					</ul>
				</div>
				<div id="LeadFormResourceEditorTemplate">
					<ul>
						<li id="CategoryId">
							<label>
								Category</label>
							<input type="text" class="txtCategory" id="txtCategory" />
							<input type="text" class="txtCategoryId" id="txtCategoryId" maxlength="5" style="width: 40px" />
						</li>
						<li id="ContentIds">
							<label>
								Product</label>
							<input type="text" class="txtContent" id="txtContent" />
							<input type="text" class="txtContentId" id="txtContentId" maxlength="5" style="width: 40px" />
						</li>
						<li id="LeadTypeId">
							<label>
								Lead Type Id</label>
							<asp:DropDownList ID="ddlLeadType" CssClass="ddlLeadType" runat="server">
							</asp:DropDownList>
						</li>
						<li id="Paging">
							<label>
								Paging in client side</label>
							<input type="checkbox" id="chkPaging" class="chkPaging" />
						</li>
						<li id="UserRegistration">
							<label>
								User registration is required to submit lead</label>
							<input type="checkbox" id="chkUserRegistration" class="chkUserRegistration" />
						</li>
						<li id="RedirectUrl">
							<label>
								Redirect url after submitting the lead</label>
							<input type="text" id="txtRedirectUrl" class="txtRedirectUrl" />
						</li>
						<li>
							<label>
								Send confirmation e mail</label>
							<input type="checkbox" id="chkSendEmail" class="chkSendEmail" />
						</li>
					    <li>
					        <label>
					            Enable Overlay-form </label>
					        <input type="checkbox" id="chkEnableOverlay" class="chkEnableOverlay" />
					    </li>
					    <li>
					        <label>
					            Time Delay (seconds) for Overlay-form</label>
					        <input type="text" id="txtTimeDelayForOverlay" class="txtTimeDelayForOverlay" />
					    </li>
					    <li>
					        <label>
					            Scroll Height for Overlay-form</label>
					        <input type="text" id="txtScrollHeightForOverlay" class="txtScrollHeightForOverlay" />
					    </li>
						<li>
					        <label>
					            Enable Webinar Overlay-form Button </label>
					        <input type="checkbox" id="chkEnableOverlayPopupButton" class="chkEnableOverlayPopupButton" />
							<input type="text" id="txtOverlayPopupButtonText" class="txtOverlayPopupButtonText" disabled/>
					  </li>
                        <li id="DownloadContentUrl">
							<label>Url for downloadable content</label>
							<input type="text" id="txtDownloadContentUrl" class="txtDownloadContentUrl" />
						</li>
                        <li id="DownloadContentLinkText">
							<label>Download Content Link Text</label>
							<input type="text" id="txtDownloadContentLinkText" class="txtDownloadContentLinkText" />
						</li>
					</ul>
				</div>
				<div id="MetadataResourceEditorTemplate">
					<ul>
						<li id="IsShowArticleTitle">
							<label>
								Show article title</label>
							<input type="checkbox" class="chkIsShowArticleTitle" id="chkIsShowArticleTitle" checked="checked" />
						</li>
						<li id="IsShowArticleSubTitle">
							<label>
								Show article sub title</label>
							<input type="checkbox" class="chkIsShowArticleSubTitle" id="chkIsShowArticleSubTitle" checked="checked" />
						</li>
						<li id="IsShowAuthorDetails">
							<label>
								Show author details</label>
							<input type="checkbox" class="chkIsShowAuthorDetails" id="chkIsShowAuthorDetails"
								checked="checked" />
						</li>
						<li id="IsShowDatePublished">
							<label>
								Show date published</label>
							<input type="checkbox" class="chkIsShowDatePublished" id="chkIsShowDatePublished"
								checked="checked" />
						</li>
						<li id="IsShowArticleType">
							<label>
								Show ArticleType</label>
							<input type="checkbox" class="chkIsShowArticleType" id="chkIsShowArticleType" checked="checked" />
						</li>
					</ul>
				</div>
				<div id="ArticleToolsResourceEditorTemplate">
					<ul>
						<li id="IsShowEmailToFriend">
							<label>
								Show email to friend</label>
							<input type="checkbox" class="chkIsShowEmailToFriend" id="chkIsShowEmailToFriend"
								checked="checked" />
						</li>
						<li id="IsShowPrint">
							<label>
								Show print</label>
							<input type="checkbox" class="chkIsShowPrint" id="chkIsShowPrint" checked="checked" />
						</li>
						<li id="IsShowBookmark">
							<label>
								Show bookmark</label>
							<input type="checkbox" class="chkIsShowBookmark" id="chkIsShowBookmark" checked="checked" />
						</li>
						<li id="IsShowShareThisPage">
							<label>
								Show share this page</label>
							<input type="checkbox" class="chkIsShowShareThisPage" id="chkIsShowShareThisPage"
								checked="checked" />
						</li>
					</ul>
				</div>
				<div id="ArticleListResourceEditorTemplate">
					<ul>
						<li>
							<label>
								Article</label>
							<input type="text" class="txtArticle" style="width: 130px; margin-right: 5px;" />
							<input type="button" class="btnAddArticle" value="Add" />
						</li>
						<li>
							<label>
								&nbsp;
							</label>
							<asp:ListBox CssClass="lstArticles" ID="lstArticles" runat="server" Width="300">
							</asp:ListBox>
						</li>
						<li>
							<label>
								&nbsp;
							</label>
							<input type="button" class="btnArticleMoveUp" value="Move up" />
							<input type="button" class="btnArticleMoveDown" value="Move down" />
							<input type="button" class="btnArticleRemoveItem" value="Remove" />
						</li>
						<li>
							<label>
								Article List Display Settings</label>
							<asp:DropDownList runat="server" CssClass="ddlArticleListDisplayItems" ID="ddlArticleListDisplayItems"
								Style="width: 140px; padding: 4px; margin-right: 5px;">
							</asp:DropDownList>
							<input type="button" class="btnAddDisplayItem" value="Add" />
						</li>
						<li>
							<label>
								&nbsp;
							</label>
							<asp:ListBox CssClass="lstArticleListDisplayItems" ID="lstArticleListDisplayItems"
								runat="server" Width="300"></asp:ListBox>
						</li>
						<li>
							<label>
								&nbsp;
							</label>
							<input type="button" class="btnDisplayItemMoveUp" value="Move up" />
							<input type="button" class="btnDisplayItemMoveDown" value="Move down" />
							<input type="button" class="btnDisplayItemRemoveItem" value="Remove" />
						</li>
						<li>
							<label>
								Synopsis Length
							</label>
							<input type="text" class="txtSynopsisLength" />
						</li>
						<li>
							<label>
								Show Read More Link
							</label>
							<input type="checkbox" class="chkReadMore" />
						</li>
                        <li>
							<label>
								CSS Class
							</label>
							<input type="text" class="txtCssClass" />
						</li>
                        <li>
							<label>
								Article Thumbnail Size</label>
							<asp:DropDownList ID="ddlArticleThumbnailSize" CssClass="ddlArticleThumbnailSize" runat="server">
							</asp:DropDownList>
						</li>
					</ul>
				</div>
				<div id="HorizontalMatrixResourceEditorTemplate">
					<ul>
						<li>
							<label>
								Category</label>
							<input type="text" class="txtCategory" id="txtCategory" />
						</li>
						
						<li>
							<label>
								Product</label>
							<input type="text" class="txtProduct" /><input type="button" class="btnAddProduct" value="Add" style="margin-left:5px" />
						</li>
						<li>
							<label>
								&nbsp;
							</label>
							<asp:ListBox CssClass="lstProducts" ID="lstProducts" runat="server" Width="300" Height="80">
							</asp:ListBox>
						</li>
						<li>
							<label>
								&nbsp;
							</label>
							<input type="button" class="btnProductMoveUp" value="Move up" />
							<input type="button" class="btnProductMoveDown" value="Move down" />
							<input type="button" class="btnProductRemoveItem" value="Remove" />
						</li>
						<li>
							<label>
								Description Truncation Length</label>
							<input type="text" class="txtTruncationLength" />
						</li>
						<li>
							<label>
								Hide Product Description</label>
							<input type="checkbox" class="cbHideProductDescription" />
						</li>
						<li>
							<label>
								Display Catalog Number</label>
							<input type="checkbox" class="cbDisplayCatalogNumber" />
						</li>
						<li>
							<label>
								Display Category Description</label>
							<input type="checkbox" class="cbDisplayCategoryText" />
						</li>
					</ul>
				</div>
				<div id="MultimediaGalleryResourceEditorTemplate">
					<ul>
						<li>
							<label>Gallery Type</label>
							<asp:DropDownList ID="mediaGalleryType" CssClass="mediaGalleryType" runat="server"></asp:DropDownList>
						</li>
						<li>
							<label>
								Product</label>
							<input type="text" id="txtProductName" class="txtProductName" />
							<input type="text" id="txtProductId" class="txtProductId" style="width:80px" />
						</li>
						<li>
							<label>
								Custom Css</label>
							<input type="text" class="txtGalleryCss" />
							<asp:DropDownList class="ddlGalleryCssClass" runat="server">
							</asp:DropDownList>
						</li>
					</ul>
				</div>
				<div id="RatingResourceEditorTemplate">
					<ul>
						<li><label>Rating Field Name</label>
							<asp:CheckBoxList ID="chklratingCustomProperties" class="ratingCustomPropertiesCssClass" runat="server">
							</asp:CheckBoxList>
						</li>
					</ul>
				</div>
			</div>
		</div>
		<div id="ImageUploader">
			<noscript>
				<p>
					Please enable JavaScript to use file uploader.
				</p>
			</noscript>
		</div>
	</div>
</asp:Content>
