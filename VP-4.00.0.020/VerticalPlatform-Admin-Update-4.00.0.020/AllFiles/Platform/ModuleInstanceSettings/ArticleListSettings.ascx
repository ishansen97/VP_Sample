<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ArticleListSettings.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.ArticleListSettings" %>
<%@ Register Src="../../Controls/PopupDialogSmartScroller.ascx" TagName="SmartScroller"
	TagPrefix="uc2" %>
<style type="text/css">
	*:first-child + html .ui-tabs-nav
	{
		width: auto;
		float: none;
		margin-left: -5px;
		position: static;
	}
	*:first-child + html .ui-tabs .ui-tabs-nav li
	{
		position: static;
	}
	.ui-widget input, .ui-widget select, .ui-widget textarea, .ui-widget button
	{
		font-size: 10px;
	}
</style>
<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>
<script src="../../Js/ContentPicker.js" type="text/javascript"></script>

<script language="javascript" type="text/javascript">
	$(document).ready(function () {
		RegisterNamespace("VP.ArticleList");
		var articleTypeFilterOptions = { siteId: VP.SiteId, type: "Article Type", currentPage: "1", pageSize: "15", showName: "true" };
		var categoryFilterOptions = { siteId: VP.SiteId, type: "Category", currentPage: "1", pageSize: "15", displaySites: true };
		var manualArticlesOptions = { siteId: VP.SiteId, type: "Article", currentPage: "1", pageSize: "15", displaySites: true };
		var manualSearchOptions = { siteId: VP.SiteId, type: "Search Option", currentPage: "1", pageSize: "15", displaySearchGroups: true };

		var tabIndex = $("[id*=hdnTabIndex]").val();
		var $tabs = $('#tabs').tabs();
		$('#tabs').tabs("select", tabIndex);

		function showHide() {
			if (document.getElementById('chkVideoList').checked) {
				document.getElementById('dvShowVideoThumb').style.visibility = 'visible';
			}
			else {
				document.getElementById('dvShowVideoThumb').style.visibility = 'hidden';
			}
		}

		$("input[type=text][id*=txtArticleTypeFilter]").contentPicker(articleTypeFilterOptions);
		$("input[type=text][id*=txtProductCategory]").contentPicker(categoryFilterOptions);
		$("input[type=text][id*=txtManualArticles]").contentPicker(manualArticlesOptions);
		$("input[type=text][id*=txtManualSearchOptions]").contentPicker(manualSearchOptions);

		$("input[type=checkbox][id*=chkFeaturedLevelAll]").click(function () {
			VP.ArticleList.SetFeaturedLevels($(this));
		});

		var chkDisplayFilter = $("input[type=checkbox][id*=chkDisplayFilter]");
		var chkCategory = $("input[type=checkbox][id*=dynamicFilterCategoryCheck]");
		var chkVendor = $("input[type=checkbox][id*=dynamicFilterVendorCheck]");
		if (!chkDisplayFilter.attr('checked')) {
			chkCategory.removeAttr('checked').attr('disabled', 'disabled');
			chkVendor.removeAttr('checked').attr('disabled', 'disabled');
		}

		chkDisplayFilter.click(function () {
			if (chkDisplayFilter.attr('checked')) {
				chkCategory.removeAttr('disabled');
				chkVendor.removeAttr('disabled');
			}
			else {
				chkCategory.removeAttr('checked').attr('disabled', 'disabled');
				chkVendor.removeAttr('checked').attr('disabled', 'disabled');
			}
		});


		var recentArticles = $("input[type=checkbox][id*=recentArticlesCheck]");
		var recentArticlesFrom = $("input[id$='recentArticlesFromInput']");
		if (!recentArticles.attr('checked')) {
			recentArticlesFrom.attr('disabled', 'disabled');
		}
		else {
			recentArticlesFrom.removeAttr('disabled');
		}

		recentArticles.click(function () {
			if (!recentArticles.attr('checked')) {
				recentArticlesFrom.attr('disabled', 'disabled');
			}
			else {
				recentArticlesFrom.removeAttr('disabled');
			}
		});

		VP.ArticleList.SetFeaturedLevels = function (chkFeaturedLevelAll) {
			if (chkFeaturedLevelAll.attr('checked')) {
				$("input[type=checkbox][id*=chkFeaturedLevelNone]").removeAttr('checked').attr('disabled', 'disabled');
				$("input[type=checkbox][id*=chkFeaturedLevelOne]").removeAttr('checked').attr('disabled', 'disabled');
				$("input[type=checkbox][id*=chkFeaturedLevelTwo]").removeAttr('checked').attr('disabled', 'disabled');
				$("input[type=checkbox][id*=chkFeaturedLevelThree]").removeAttr('checked').attr('disabled', 'disabled');
			}
			else {
				$("input[type=checkbox][id*=chkFeaturedLevelNone]").removeAttr('disabled').parent('span').removeAttr('disabled');
				$("input[type=checkbox][id*=chkFeaturedLevelOne]").removeAttr('disabled').parent('span').removeAttr('disabled');
				$("input[type=checkbox][id*=chkFeaturedLevelTwo]").removeAttr('disabled').parent('span').removeAttr('disabled');
				$("input[type=checkbox][id*=chkFeaturedLevelThree]").removeAttr('disabled').parent('span').removeAttr('disabled');
			}
		};

		$("input[id$='txtDatePublished']").datepicker(
		{
			changeYear: true
		});

	    //removing sort by associated content if automatic filtering not selected
		$("#autoFilterOptionsDiv").click(function () {
		    VP.ArticleList.SetAssocaiteSortOrder();
		});

	    VP.ArticleList.SetAssocaiteSortOrder = function () {
	        var sortDdls = $("select[id$=ddlDefaultSort],select[id$=ddlArticleSorting]");
	        if ($("#autoFilterOptionsDiv").find("input[type=checkbox]:checked").length > 0) {
	            (sortDdls).each(function () {
	                $(this).find("option[value='9']").show();
	            });
	        } else {
	            (sortDdls).each(function () {
	                $(this).find("option[value='9']").hide();
	                if ($(this).val() == 9)
	                    $(this).val("");
	            });
	        }
	    };

	    VP.ArticleList.SetAssocaiteSortOrder();

	    $("[id*=txtViewMoreLink]").change(function () {
	    	VP.ArticleList.changeCategoryVM();
	    });

	    VP.ArticleList.changeCategoryVM = function () {
	    	var categoryViewMoreFilter = $("input[type=checkbox][id*=chkCategoryVMFilter]");
	    	var viewMoreLink = $("input[type=text][id*=txtViewMoreLink]");
	    	var trimmedViewMoreLink = jQuery.trim(viewMoreLink.val());

	    	if (trimmedViewMoreLink.length > 0) {
	    		categoryViewMoreFilter.removeAttr('disabled');
	    	}
	    	else {
	    		categoryViewMoreFilter.attr('checked', false);
	    		categoryViewMoreFilter.attr('disabled', true);
	    	}
	    }

	    VP.ArticleList.changeCategoryVM();
	});

	$(function() {
		$("#tabs").tabs({
			select: function(event, ui) {
				$("[id*=hdnTabIndex]").val(ui.index + 1);
			}
		});
	});
</script>

<div id="tabs" style="width: 650px">
	<ul>
		<li><a href="#tabs-1">Display Lists</a></li>
		<li><a href="#tabs-2">Settings</a></li>
		<li><a href="#tabs-3">Subhomes</a></li>
		<li><a href="#tabs-4">Filtering/Sorting</a></li>
		<li><a href="#tabs-5">Randomization</a></li>
		<li><a href="#tabs-6">Dependency</a></li>
	</ul>
	<div id="tabs-1">
		<ul class="common_form_area">
			<li class="common_form_row clearfix group_row">
				<div class="common_form_row_lable">
					Article List Display Settings
				</div>
				<div class="common_form_row_data">
					<asp:DropDownList ID="ddlArticleListDisplaySetting" runat="server" Height="20px"
						Width="144px">
					</asp:DropDownList>
					<asp:Button ID="btnAddDisplaySettings" runat="server" OnClick="btnAddDisplaySettings_Click"
						Text="Add" CssClass="common_text_button" CausesValidation="False" />
					<div class="common_form_row_div clearfix">
						<asp:ListBox ID="lstArticleListDisplaySetting" runat="server" Width="247px"></asp:ListBox>
					</div>
					<div class="common_form_row_div clearfix">
						<asp:Button ID="btnMoveUp" runat="server" OnClick="btnMoveUp_Click" Text="Move Up"
							CssClass="common_text_button" CausesValidation="False" />
						<asp:Button ID="btnMoveDown" runat="server" Text="Move Down" OnClick="btnMoveDown_Click"
							CssClass="common_text_button" CausesValidation="False" />
						<asp:Button ID="btnRemove" runat="server" OnClick="btnRemove_Click" Text="Remove"
							CssClass="common_text_button" CausesValidation="False" />
						<asp:HiddenField ID="hdnArticleDisplaySettingsValue" runat="server" />
					</div>
				</div>
			</li>
			<li class="common_form_row clearfix group_row">
				<div class="common_form_row_lable">
					Manual Article Listing
				</div>
				<div class="common_form_row_data">
					<div class="ProductCategoryList">
						<asp:TextBox ID="txtManualArticles" runat="server"></asp:TextBox>
					</div>
					<asp:Button ID="btnAddArticle" runat="server" Text="Add" OnClick="btnAddArticle_Click"
						CausesValidation="false" CssClass="common_text_button" />
					<div class="common_form_row_div clearfix" style="clear:both">
						<asp:ListBox ID="lstArticle" runat="server" Height="70px" Width="220px"></asp:ListBox>
					</div>
					<div class="common_form_row_div clearfix">
						<asp:Button ID="btnRemoveArticle" runat="server" OnClick="btnRemoveArticle_Click"
							Text="Remove" CssClass="common_text_button" />
						<asp:Button ID="btnUp" runat="server" OnClick="btnUp_Click" Text="Move Up" CssClass="common_text_button" />
						<asp:Button ID="btnDown" runat="server" OnClick="btnDown_Click" Text="Move Down"
							CssClass="common_text_button" />
						<asp:HiddenField ID="hdnManualListing" runat="server" />
					</div>
				</div>
			</li>
			<li class="common_form_row clearfix">
				<div class="common_form_row_lable">
					Video List</div>
				<div class="common_form_row_data">
					<asp:HiddenField ID="hdnVideoList" runat="server" />
					<asp:CheckBox ID="chkVideoList" runat="server" AutoPostBack="true" 
						oncheckedchanged="chkVideoList_CheckedChanged" />
				</div>
			</li>
			<li class="common_form_row clearfix">
				<div visible="false" id="dvShowVideoThumb" runat="server">
					<div class="common_form_row_lable">
						Show Video Thumbnail</div>
					<div class="common_form_row_data">
						<asp:HiddenField ID="hdnShowVideoThumbnail" runat="server" />
						<asp:CheckBox ID="chkShowVideoThumbnail" runat="server" />
					</div>
				</div>
			</li>
			<li class="common_form_row clearfix">
				<div visible="false" id="dvVideoPlayerId" runat="server">
					<div class="common_form_row_lable">
						Video Player Id</div>
					<div class="common_form_row_data">
						<asp:HiddenField ID="hdnVideoPlayerId" runat="server" />
						<asp:TextBox ID="txtVideoPlayerId" runat="server" />
					</div>
				</div>
			</li>
			<li class="common_form_row clearfix">
				<div visible="false" id="playFirstVideo" runat="server">
					<div class="common_form_row_lable">
						Play First Video Automatically</div>
					<div class="common_form_row_data">
						<asp:HiddenField ID="playAutoHidden" runat="server" />
						<asp:CheckBox ID="playAutoCheck" runat="server" />
					</div>
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Author's Article List
				</div>
				<div class="common_form_row_data">
					<asp:HiddenField ID="hdnAuthorsList" runat="server" />
					<asp:CheckBox ID="chkAuthorsList" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Unpublished Article List
				</div>
				<div class="common_form_row_data">
					<asp:HiddenField ID="hdnUnpublishedList" runat="server" />
					<asp:CheckBox ID="chkUnpublishedList" runat="server" AutoPostBack="true"
					oncheckedchanged="chkUnpublishedList_CheckedChanged" />
				</div>
			</li>
			<li class="common_form_row clearfix">
				<div visible="false" id="dvDatePublished" runat="server">
					<div class="common_form_row_lable">
						Show Articles After This Date</div>
					<div class="common_form_row_data">
						<asp:HiddenField ID="hdnDatePublished" runat="server" />
						<asp:TextBox ID="txtDatePublished" runat="server" />
					</div>
				</div>
			</li>
			<li class="common_form_row clearfix group_row">
				<div class="common_form_row_lable">
					Article Types
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtArticleTypeFilter" runat="server" Style="width: 210px" />
					<asp:Button ID="btnAddArticleType" runat="server" Text="Add" OnClick="btnAddArticleType_Click"
						CausesValidation="false" CssClass="common_text_button" />
					<div class="common_form_row_div clearfix">
						<asp:ListBox ID="lstArticleType" runat="server" Width="220px" Height="54px" Style="float: left;">
						</asp:ListBox>
						&nbsp;
						<asp:Button ID="btnRemoveArticleType" Text="Remove" runat="server" OnClick="btnRemoveArticleType_Click"
							CssClass="common_text_button" CausesValidation="False" />
					</div>
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Product Categories
				</div>
				<div class="common_form_row_data">
					<div class="ProductCategoryList">
						<asp:TextBox ID="txtProductCategory" runat="server"></asp:TextBox>
					</div>
					<asp:Button ID="btnAddCategory" Text="Add" runat="server" OnClick="btnAddCategory_Click"
						CausesValidation="false" CssClass="common_text_button" />
					<div class="common_form_row_div clearfix" style="clear:both">
						<asp:ListBox ID="lstCategory" runat="server" Width="220px" Height="49px" Style="float: left;">
						</asp:ListBox>
						&nbsp;
						<asp:Button ID="btnRemoveCategory" Text="Remove" runat="server" OnClick="btnRemoveCategory_Click"
							CssClass="common_text_button" CausesValidation="False" />
					</div>
				</div>
			</li>
            <li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Search Options
				</div>
				<div class="common_form_row_data">
					<div class="ProductCategoryList">
						<asp:TextBox ID="txtManualSearchOptions" runat="server"></asp:TextBox>
					</div>
					<asp:Button ID="btnAddManualSearchOptions" Text="Add" runat="server" OnClick="btnAddManualSearchOptions_Click"
						CausesValidation="false" CssClass="common_text_button" />
					<div class="common_form_row_div clearfix" style="clear:both">
						<asp:ListBox ID="lstManualSearchOptions" runat="server" Width="220px" Height="49px" Style="float: left;">
						</asp:ListBox>
						&nbsp;
						<asp:Button ID="btnRemoveManualSearchOptions" Text="Remove" runat="server" OnClick="btnRemoveManualSearchOptions_Click"
							CssClass="common_text_button" CausesValidation="False" />
                        <asp:HiddenField ID="hdnFilterElements" runat="server" />
					</div>
				</div>
			</li>
		</ul>
	</div>
	<div id="tabs-2">
		<ul class="common_form_area">
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Default Title Prefix
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtDefaultTitlePrefix" runat="server" Width="220px"></asp:TextBox>
					<asp:HiddenField ID="hdnDefaultTitlePrefix" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
				</div>
				<div class="common_form_row_data">
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Number of Articles Per Page
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtNumberOfArticlesPerPage" runat="server" Width="220px"></asp:TextBox>
					<asp:HiddenField ID="hdnNoOfArticlesPerPage" runat="server" />
					<asp:CompareValidator ID="cpvNumberOfArticlesPerPage" runat="server" ErrorMessage="Please enter a numeric value for  'Number of articles per page'."
						ControlToValidate="txtNumberOfArticlesPerPage" Type="Integer" Operator="DataTypeCheck"
						SetFocusOnError="True">*</asp:CompareValidator>
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Max Number of Articles
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtMaxArticles" runat="server" Width="220px"></asp:TextBox>
					<asp:HiddenField ID="hdnMaxArticles" runat="server" />
					<asp:CompareValidator ID="cpvMaxArticles" runat="server" ErrorMessage="Please enter a numeric value for  'Max number of articles'."
						ControlToValidate="txtMaxArticles" Type="Integer" Operator="DataTypeCheck" SetFocusOnError="True">*</asp:CompareValidator>
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;" runat="server" id="liTotalNoOfSlots" visible="false">
				<div class="common_form_row_lable">
					Total no of articles to randomized
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtTotalNoOfSlots" runat="server" Width="220px"></asp:TextBox>
					<asp:HiddenField ID="hdnTotalNoOfSlots" runat="server" />
					<asp:CompareValidator ID="cpvTotalNoOfSlots" runat="server" ErrorMessage="Please enter a numeric value for  'Total no of articles to randomized'."
						ControlToValidate="txtTotalNoOfSlots" Type="Integer" Operator="DataTypeCheck" SetFocusOnError="True">*</asp:CompareValidator>
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Enable Paging
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="chkEnablePaging" runat="server" />
					<asp:HiddenField ID="hdnEnablePaging" runat="server" />
				</div>
			</li>
            <li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Enable Elasticsearch Data Manager
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="chkEnableElasticsearchManager" runat="server" />
					<asp:HiddenField ID="hdnEnableElasticsearchManager" runat="server" />
				</div>
			</li>
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
					CSS Class
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtCssClass" runat="server" Width="150"></asp:TextBox>
					<asp:DropDownList ID="ddlCssClasses" runat="server" OnSelectedIndexChanged="ddlCssClasses_SelectedIndexChanged"
						AutoPostBack="true" Width="150">
					</asp:DropDownList>
					<asp:HiddenField ID="hdnCssClasses" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Always Show Read more Link
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="chkShowReadMoreLink" runat="server" /><asp:HiddenField ID="hdnShowReadMoreLink"
						runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					View More Link Text
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtViewMoreText" runat="server" Width="220px"></asp:TextBox>
					<asp:HiddenField ID="hdnViewMoreText" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					View More Link
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtViewMoreLink" runat="server" MaxLength="254" Width="220px"></asp:TextBox>
					<asp:HiddenField ID="hdnViewMoreLink" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix">
				<div class="common_form_row_lable">
					Filter By Category On View More Link
				</div>
				<div id="viewMoreFilterParameters" class="common_form_row_data">
					<asp:CheckBox ID="chkCategoryVMFilter" runat="server" />
					<asp:HiddenField ID="hdnViewMoreFilterParameters" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Display Short Title
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="chkShortTitle" runat="server" />
					<asp:HiddenField ID="hdnShortTitle" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					External RSS Article URL
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtExternalRssUrl" runat="server" MaxLength="254" Width="220px"></asp:TextBox>
					<asp:HiddenField ID="hdnRSSArticleUrl" runat="server" />
					<asp:RegularExpressionValidator ID="revExternalUrl" runat="server" ControlToValidate="txtExternalRssUrl"
						ErrorMessage="Please enter a valid URL." ValidationExpression="http(s)?://([\w-]+\.)+[\w-]+(/[\w- ./?%&amp;=]*)?">*</asp:RegularExpressionValidator>
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Article Synopsis Display Length
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtSynopsisLength" runat="server" MaxLength="4" Width="220px" /><asp:HiddenField
						ID="hdnSynopsisLength" runat="server" />
					<asp:CompareValidator ID="cpvSynopsisLength" runat="server" ErrorMessage="Please enter a numeric value for 'Article synopsis display length'"
						ControlToValidate="txtSynopsisLength" Type="Integer" Operator="DataTypeCheck"
						SetFocusOnError="True">*</asp:CompareValidator>
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Article Title Display Length
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtTitleDisplayLength" runat="server" MaxLength="4" Width="220px" /><asp:HiddenField
						ID="hdnTitleDisplayLength" runat="server" />
					<asp:CompareValidator ID="cpvTitleDisplayLength" runat="server" ErrorMessage="Please enter a numeric value for 'Article title display length'"
						ControlToValidate="txtTitleDisplayLength" Type="Integer" Operator="DataTypeCheck"
						SetFocusOnError="True">*</asp:CompareValidator>
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Synopsis Read more Link Text
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtSynopsisReadMoreLinkText" runat="server" MaxLength="100" Width="220px" /><asp:HiddenField
						ID="hdnSynopsisReadMoreLinkText" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Custom Article Thumbnail Size
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtCustomThumbSize" runat="server" Width="220px"></asp:TextBox>
					<asp:HiddenField ID="hdnCustomThumbSize" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Article Thumbnail Size
				</div>
				<div class="common_form_row_data">
					<asp:DropDownList ID="ddlThumbSize" runat="server">
						<asp:ListItem Text="Extra Large Image – 400 x 300" Value="1"></asp:ListItem>
						<asp:ListItem Text="Featured Image – 187 x 140" Value="2"></asp:ListItem>
						<asp:ListItem Text="Thumbnail Image – 134 x 100" Value="3"></asp:ListItem>
						<asp:ListItem Text="Micro Image – 52 x 39" Value="4"></asp:ListItem>
					</asp:DropDownList>
					<asp:HiddenField ID="hdnThumbSize" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Hide Module When Empty
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="chkHideWhenEmpty" runat="server" />
					<asp:HiddenField ID="hdnHideWhenEmpty" runat="server" />
				</div>
			</li> 
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					No of Web Analytic Enabled Articles
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="noOfwebAnalyticEnabledArticlesTextBox" runat="server" Width="220px"></asp:TextBox>
					<asp:HiddenField ID="noOfwebAnalyticEnabledArticlesHidden" runat="server" />
					<asp:CompareValidator ID="noOfwebAnalyticEnabledArticlesValidator" runat="server" ErrorMessage="Please enter a numeric value for  'No of web analytic enabled articles'."
						ControlToValidate="noOfwebAnalyticEnabledArticlesTextBox" Type="Integer" Operator="DataTypeCheck" SetFocusOnError="True">*</asp:CompareValidator>
				</div>
			</li>
            <li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Open In New Window
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="openInNewWindowCheckBox" runat="server" />
					<asp:HiddenField ID="hdnOpenInNewWindow" runat="server" />
				</div>
			</li>
            <li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Load Default Articles When Empty
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="loadDefaultArticlesWhenEmptyCheckBox" runat="server" Checked="true"/>
					<asp:HiddenField ID="loadDefaultArticlesWhenEmptyHidden" runat="server" />
				</div>
			</li>
		</ul>
	</div>
	<div id="tabs-3">
		<ul class="common_form_area">
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Enable Subhome Filtering
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="chkSubHomeFiltering" runat="server" />
					<asp:HiddenField ID="hdnSubHomeFiltering" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Display Only Directly Related Articles In Subhome
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="chkSubHomeDisplay" runat="server" />
					<asp:HiddenField ID="hdnSubHomeDisplay" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Display Subhome Title Prefix
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="chkSubhomeTitle" runat="server" />
					<asp:HiddenField ID="hdnSubhomeTitle" runat="server" />
				</div>
			</li>
		</ul>
	</div>
	<div id="tabs-4">
		<ul class="common_form_area">
			<li class="common_form_row clearfix group_row">
				<div class="common_form_row_lable">
					Automatic Filtering
				</div>
				<div id="autoFilterOptionsDiv" class="common_form_row_data">
					<asp:CheckBox ID="chkCategory" runat="server" Text="Category" />
					<asp:CheckBox ID="chkVendor" runat="server" Text="Vendor" />
					<asp:CheckBox ID="chkProduct" runat="server" Text="Product" />
					<asp:CheckBox ID="chkArticle" runat="server" Text="Article" />
					<asp:CheckBox ID="chkSearchOption" runat="server" Text="Search Option" />
					<asp:HiddenField ID="hdnAutoFilter" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix group_row">
				<div class="common_form_row_lable">
					Automatic Filter Type
				</div>
				<div class="common_form_row_data">
					<asp:RadioButtonList ID="filterTypes" runat="server" RepeatDirection="Horizontal"
						CellPadding="0" CellSpacing="0" CssClass="radio_table"></asp:RadioButtonList>
					<asp:HiddenField ID="hdnFilterTypes" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix group_row">
				<div class="common_form_row_lable">
					Filter(Featured Identifier)
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="chkFeaturedLevelAll" runat="server" Text="All" Checked="true" />
					<asp:CheckBox ID="chkFeaturedLevelNone" runat="server" Text="None" />
					<asp:CheckBox ID="chkFeaturedLevelOne" runat="server" Text="Level 1" />
					<asp:CheckBox ID="chkFeaturedLevelTwo" runat="server" Text="Level 2" />
					<asp:CheckBox ID="chkFeaturedLevelThree" runat="server" Text="Level 3" />
				</div>
			</li>
			<li class="common_form_row clearfix group_row">
				<div class="common_form_row_lable">
					Filter by Recent Articles 
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="recentArticlesCheck" runat="server" />
					<asp:HiddenField ID="recentArticlesHidden" runat="server" />
					<asp:TextBox ID="recentArticlesFromInput" runat="server" Width="220px">1
					</asp:TextBox> Month(s)
					<asp:HiddenField ID="recentArticlesFromHidden" runat="server" />
					<asp:CompareValidator ID="recentArticlesCompareValidator" runat="server" ErrorMessage="Please enter a numeric value for  'Filter by Recent Articles'."
						ControlToValidate="recentArticlesFromInput" Type="Integer" Operator="DataTypeCheck" SetFocusOnError="True">*</asp:CompareValidator>
				</div>
			</li>
			<li class="common_form_row clearfix group_row">
				<div class="common_form_row_lable">
					Filter By Site
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="filterBySite" runat="server" />
					<asp:HiddenField ID="hdnFilterBySite" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix group_row">
				<div class="common_form_row_lable">
					Filter By Tags
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="chkFilterByTags" runat="server" />
					<asp:HiddenField ID="hdnFilterByTags" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Tag Names (',' Separated)
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtFilteringTags" runat="server" Width="220px"></asp:TextBox>
					<asp:HiddenField ID="hdnFilteringTags" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix group_row">
				<div class="common_form_row_lable">
					Default Sort By
				</div>
				<div class="common_form_row_data">
					<asp:DropDownList ID="ddlDefaultSort" runat="server" AutoPostBack="True" 
						onselectedindexchanged="ddlDefaultSort_SelectedIndexChanged" Width="200">
					</asp:DropDownList>
					<asp:DropDownList ID="ddlDefaultSortOrder" runat="server"  Width="200">
						<asp:ListItem Value="1">Ascending</asp:ListItem>
						<asp:ListItem Value="2">Descending</asp:ListItem>
					</asp:DropDownList>
					<asp:HiddenField ID="hdnDefaultSort" runat="server" />
				</div>
			</li>
			<li  class="common_form_row clearfix" id="liRelevancyDistance" runat="server">
				<div class="common_form_row_lable">
					Category Relevancy Distance <br />
					(Zero And Above, Zero For Direct Relationships)
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtRelevancyDistance" runat="server"></asp:TextBox>
					<asp:HiddenField ID="hdnRelevancyDistance" runat="server" />
					<asp:CompareValidator ID="cmpvRelevancyDistance" runat="server" ErrorMessage="Please enter a numeric value for  'Category Relevancy Distance'."
						ControlToValidate="txtRelevancyDistance" Type="Integer" Operator="DataTypeCheck"
						SetFocusOnError="True">*</asp:CompareValidator>
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Enable On-demand Sorting
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="chkEnableOnDemandSorting" runat="server" />
					<asp:HiddenField ID="hdnEnableOnDemandSorting" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Sorting Parameters
				</div>
				<div class="common_form_row_data">
					<asp:DropDownList ID="ddlArticleSorting" runat="server">
					</asp:DropDownList>
					<asp:Button ID="btnAddSortingParameter" runat="server" Text="Add" OnClick="btnAddSortingParameter_Click"
						CssClass="common_text_button" />
					<div class="common_form_row_div clearfix">
						<asp:ListBox ID="lstSortingParameters" runat="server" Width="247px" Style="float: left;">
						</asp:ListBox>
						&nbsp;
						<asp:Button ID="btnRemoveSortParameter" runat="server" Text="Remove" OnClick="btnRemoveSortParameter_Click"
							CssClass="common_text_button" />
						<asp:HiddenField ID="hdnSortParameters" runat="server" />
					</div>
				</div>
			</li>
			<li class="common_form_row clearfix group_row" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Display Filter
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="chkDisplayFilter" runat="server" />
					<asp:HiddenField ID="hdnDisplayFilter" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Filter Type
				</div>
				<div class="common_form_row_data">
					<asp:RadioButtonList ID="customFilterType" runat="server" RepeatDirection="Horizontal"
						CellPadding="0" CellSpacing="0" CssClass="radio_table"></asp:RadioButtonList>
					<asp:HiddenField ID="customFilterTypeHdn" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Category
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="dynamicFilterCategoryCheck" runat="server" />
					<asp:HiddenField ID="dynamicFilterCategoryHiddenField" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Vendor
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="dynamicFilterVendorCheck" runat="server" />
					<asp:HiddenField ID="dynamicFilterVendorHiddenField" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Custom Filter Parameters
				</div>
				<div class="common_form_row_data">
					<asp:DropDownList ID="ddlFilterParameters" runat="server">
					</asp:DropDownList>
					<asp:Button ID="btnAddFilterParameters" runat="server" Text="Add" OnClick="btnAddFilterParameters_Click"
						CssClass="common_text_button" CausesValidation="false" />
					<div class="common_form_row_div clearfix">
						<asp:ListBox ID="lstFilterParameters" runat="server" Width="247px" Style="float: left;">
						</asp:ListBox>
						&nbsp;
						<asp:Button ID="btnRemoveFilterParameters" runat="server" Text="Remove" OnClick="btnRemoveFilterParameters_Click"
							CssClass="common_text_button" CausesValidation="false" />
						<asp:HiddenField ID="hdnFilterParameters" runat="server" />
					</div>
				</div>
			</li>
			<li class="common_form_row clearfix group_row" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Default Filter By (Custom Parameter)
				</div>
				<div class="common_form_row_data">
					<asp:DropDownList ID="ddlCustomFilterParameters" runat="server" Height="20px" Width="144px">
					</asp:DropDownList>
					<asp:HiddenField ID="hdnFilterByCustomParameter" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Filter By Values (Pipeline (|) Separated)
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtCustomParameterValue" runat="server" Width="220px"></asp:TextBox>
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Display Group Heading
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="chkGroupHeading" runat="server" />
					<asp:HiddenField ID="hdnDisplayGroupHeading" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix group_row" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Group By
				</div>
				<div class="common_form_row_data">
					<asp:DropDownList ID="ddlGroupBy" runat="server" Height="20px" Width="144px">
					</asp:DropDownList>
					<asp:DropDownList ID="ddlGroupByOrder" runat="server">
						<asp:ListItem Value="1">Ascending</asp:ListItem>
						<asp:ListItem Value="2">Descending</asp:ListItem>
					</asp:DropDownList>
					<asp:HiddenField ID="hdnGroupById" runat="server" />
				</div>
			</li>
		</ul>
	</div>
	<div id="tabs-5">
		<ul class="common_form_area">
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Enable Randomization
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="chkRandomization" runat="server" OnCheckedChanged="chkRandomization_CheckedChanged"
						AutoPostBack="true" />
					<asp:HiddenField ID="hdnRandomization" runat="server" />
				</div>
			</li>
		</ul>
	</div>
	<div id="tabs-6">
		<ul class="common_form_area">
			<li class="common_form_row clearfix group_row" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Dependent Module
				</div>
				<div class="common_form_row_data">
					<asp:DropDownList ID="pageModuleList" runat="server" Width="220px" style="vertical-align:top;"></asp:DropDownList>
					<asp:HiddenField ID="hdnPageModuleList" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Dependency Type
				</div>
				<div class="common_form_row_data">
					<asp:DropDownList ID="providerConditionType" runat="server" Width="220px" style="vertical-align:top;"></asp:DropDownList>
					<asp:HiddenField ID="hdnProviderConditionType" runat="server" />
				</div>
			</li> 
		</ul>
	</div>
</div>
<p>
	&nbsp;</p>
<uc2:SmartScroller ID="SmartScroller1" runat="server" />
<asp:HiddenField ID="hdnTabIndex" runat="server" />
