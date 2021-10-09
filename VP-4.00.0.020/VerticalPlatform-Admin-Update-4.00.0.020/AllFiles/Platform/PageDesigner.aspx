<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="PageDesigner.aspx.cs" Inherits="VerticalPlatformAdminWeb.Platform.PageDesigner" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">

	<script src="../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>

	<script src="../Js/JQuery/jquery.json-1.3.min.js" type="text/javascript"></script>

	<script src="../Js/PageDesigner/PageDesigner.js" type="text/javascript"></script>

	<script src="../Js/PageDesigner/Canvas.js" type="text/javascript"></script>

	<script src="../Js/FormDesigner/Designer.js" type="text/javascript"></script>

	<script src="../Js/PageDesigner/Designer.js" type="text/javascript"></script>

	<script src="../Js/FormDesigner/Container.js" type="text/javascript"></script>

	<script src="../Js/PageDesigner/Container.js" type="text/javascript"></script>

	<script src="../Js/PageDesigner/ContainerModule.js" type="text/javascript"></script>

	<script src="../Js/PageDesigner/Template.js" type="text/javascript"></script>

	<script src="../Js/PageDesigner/Pane.js" type="text/javascript"></script>

	<script src="../Js/PageDesigner/Module.js" type="text/javascript"></script>

	<script src="../Js/JQuery/jquery.json-1.3.min.js" type="text/javascript"></script>
	
	<script type="text/javascript">
		$(document).ready(function() {
			
			var top = 100;
			$(window).scroll(function (event) {
				var y = $(this).scrollTop();
				if (y >= top) {
					$('#toolbox').addClass('toolBoxFixed');
				} else {
					$('#toolbox').removeClass('toolBoxFixed');
				}
		});
		$("#closeDialog").click(function () {
			$("#propertyDialog").jqmHide();
		});
	});

	</script>

	<asp:ScriptManagerProxy ID="ScriptManagerProxy" runat="server">
		<Services>
			<asp:ServiceReference Path="~/Services/PageDesignerService.asmx" />
		</Services>
	</asp:ScriptManagerProxy>
	<div class="AdminPanelHeader">
		<h3>
			<asp:Label ID="lblTitle" runat="server" /></h3>
	</div>
	<div class="container lead_form_container page_designer">
		<div class="leftColumn">
			<div id="toolbox">
				<div class="buttons_div clearfix">
					<asp:HyperLink ID="lnkBack" runat="server" class="btn">Back</asp:HyperLink>
					<input id="btnSave" type="button" value="Save" class="btn"/>
				</div>
				<div class="toolboxItems">
					<h3>
						<a href="#">Containers</a></h3>
					<div class="container">
						<div id="accordioncontainer" class="toolboxItem accordion">
							Accordion</div>
						<div id="defaultcontainer" class="toolboxItem default">
							Default</div>
						<div id="primarycontainer" class="toolboxItem primary">
							Primary</div>
						<div id="searchresultcontainer" class="toolboxItem searchResult">
							Search Result</div>
						<div id="slidercontainer" class="toolboxItem slider">
							Slider</div>
						<div id="tabcontainer" class="toolboxItem tab">
							Tab</div>
						<div id="providercontainer" class="toolboxItem provider">
							Provider</div>
                        <div id="anchorlinkcontainer" class="toolboxItem anchor">
							Anchor link container</div>
					</div>
					<h3>
						<a href="#">Common</a></h3>
					<div class="module" style="border-bottom: none;">
						<div id="advertisement" class="toolboxItem advertisement">
							Advertisement</div>
						<div id="breadcrumb" class="toolboxItem breadCrumb">
							Breadcrumb</div>  
						<div id="categoryquicklinks" class="toolboxItem categoryQuickLinks">
							Category Quick Links</div>
						<div id="feedback" class="toolboxItem feedback">
							Feedback</div>
						<div id="footer" class="toolboxItem footer">
							Footer</div>
						<div id="headerimage" class="toolboxItem headerImage">
							Header Image</div>
						<div id="login" class="toolboxItem login">
							Login</div>
						<div id="loginregister" class="toolboxItem loginRegister">
							Login/Register</div>
						<div id="navigationmenu" class="toolboxItem navigationMenu">
							Navigation Menu</div>
						<div id="officesetup" class="toolboxItem officeSetup">
							Office Setup</div>
						<div id="oasadvertisement" class="toolboxItem oasAdvertisement">
							Oas Advertisement</div>
						<div id="passwordreset" class="toolboxItem passwordReset">
							Password Reset</div>
						<div id="statichtml" class="toolboxItem staticHtml">
							Static Html</div>
						<div id="tagsearchresult" class="toolboxItem tagSearchResult">
							Tag Search Result</div>
						<div id="usermaintenance" class="toolboxItem userMaintenance">
							User Maintenance</div>
						<div id="userprofile" class="toolboxItem userProfile">
							User Profile</div>
						<div id="usersubscription" class="toolboxItem userSubscription">
							User Subscription</div>
						<div id="deletesubscription" class="toolboxItem deleteSubscription">
							Delete Subscription</div>
						<div id="subhomes" class="toolboxItem subhomes">
							Sub Homes</div>
						<div id="selectedproducts" class="toolboxItem selectedProducts">
						Selected Products</div>
						<div id="headertitle" class="toolboxItem headerTitle">
						Header Title</div>
						<div id="passwordprotected" class="toolboxItem passwordProtected">
						Password Protected</div>
            <div id="contentsharing" class="toolboxItem contentSharing">
						Content Sharing</div>
						<div id="producttracking" class="toolboxItem externalRedirect">
						Product Tracking Module</div>
					</div>
					<h3>
						<a href="#">Forum</a></h3>
					<div class="module forum">
						<div id="forumtopic" class="toolboxItem forumTopic">
							Topic</div>
						<div id="forumthread" class="toolboxItem forumThread">
							Thread</div>
						<div id="forumthreadpost" class="toolboxItem forumThreadPost">
							Thread Post</div>
						<div id="forumthreadpostdetail" class="toolboxItem forumThreadPostDetail">
							Thread Post Detail</div>
						<div id="forumthreadpostlist" class="toolboxItem forumThreadPostList">
							Thread Post List</div>
						<div id="forumuserprofile" class="toolboxItem forumUserProfile">
							Forum User Profile</div>
						<div id="recentforumthreads" class="toolboxItem recentforumthreads">
							Recent Forum Threads</div>
						<div id="forumthreadlist" class="toolboxItem forumthreadlist">
							Forum Thread List</div>
					</div>
					<h3>
						<a href="#">Product</a></h3>
					<div class="module product">
						<div id="categorymatrix" class="toolboxItem categoryMatrix">
							Category Matrix</div>
						<div id="directory" class="toolboxItem directory">
							Directory</div>
						<div id="horizontalmatrix" class="toolboxItem horizontalMatrix">
							Horizontal Matrix</div>
						<div id="leadform" class="toolboxItem leadForm">
							Lead Form</div>
						<div id="leadformthankyou" class="toolboxItem leadFormThankYou">
							LeadForm ThankYou</div>
						<div id="verticalmatrix" class="toolboxItem matrix">
							Vertical Matrix</div>
						<div id="productdetail" class="toolboxItem productDetail">
							ProductDetail</div>
						<div id="servicedetail" class="toolboxItem serviceDetail">
							Service Detail</div>
						<div id="productlist" class="toolboxItem productlist">
							Product List</div>
						<div id="relatedproduct" class="toolboxItem relatedProduct">
							Related Product</div>
						<div id="groupedproducts" class="toolboxItem groupedProducts">
							Grouped Products</div>
						<div id="linkedproducts" class="toolboxItem linkedProducts">
							Linked Products</div>
						<div id="requestinformation" class="toolboxItem requestInformation">
							Request Information</div>
						<div id="otherrequestedproducts" class="toolboxItem otherRequestedProducts">
							Other Requested Products</div>
						<div id="productimagegallery" class="toolboxItem productImageGallery">
							Product Image Gallery</div>
						<div id="productdetailspecification" class="toolboxItem productDetailSpecification">
							Product Detail Specification</div>
						<div id="productdescription" class="toolboxItem productDescription">
							Product Description</div>
						<div id="productcategorymatrixlink" class="toolboxItem ProductCategoryMatrixLink">
							Product Category Matrix Link</div>
						<div id="compressmodel" class="toolboxItem compressModel">
							Compress Model</div>
						<div id="productrating" class="toolboxItem productRating">
							Product Rating</div>
						<div id="productsharing" class="toolboxItem productSharing">
							Product Sharing</div>
						<div id="citations" class="toolboxItem citations">
							Citations</div>
                        <div id="stickyheader" class="toolboxItem stickyHeader">
							Sticky Headers</div>
						<div id="questionnaire" class="toolboxItem questionnaire">
							Questionnaire</div>
					</div>
					<h3>
						<a href="#">Vendor</a></h3>
					<div class="module vendor">
						<div id="vendorfilteringlist" class="toolboxItem vendorFilteringList">
							Vendor Filtering List</div>
						<div id="vendordetail" class="toolboxItem vendorDetail">
							Vendor Detail</div>
						<div id="vendormatrix" class="toolboxItem vendorMatrix">
							Vendor Matrix</div>
						<div id="productcontactinformation" class="toolboxItem productContactInformation">
							Product Contact Information</div>
						<div id="vendortopcontent" class="toolboxItem vendortopcontent">
							Vendor Top Content</div>
						<div id="vendorsummary" class="toolboxItem vendorsummary">
							Vendor Summary</div>
						<div id="vendorproductcategory" class="toolboxItem vendorproductcategory">
							Vendor Product Category</div>
						<div id="vendordetailspecification" class="toolboxItem vendordetailspecification">
							Vendor Detail Specification</div>
						<div id="vendorsearchbox" class="toolboxItem vendorsearchbox">
							Vendor Search Box</div>
						<div id="featuredvendors" class="toolboxItem featuredvendors">
							Featured Vendors</div>
						<div id="featuredvendorarticles" class="toolboxItem featuredvendorarticles">
							Featured Vendor Articles</div>
					</div>
					<h3>
						<a href="#">Article</a></h3>
					<div class="module article">
						<div id="articlecomment" class="toolboxItem articleComment">
							Article Comment</div>
						<div id="articlecommentlist" class="toolboxItem articleCommentList">
							Article Comment List</div>
						<div id="articledetail" class="toolboxItem articleDetail">
							Article Detail</div>
						<div id="articlelist" class="toolboxItem articleList">
							Article List</div>
						<div id="articlerelatedproducts" class="toolboxItem articleRelatedProducts">
							Article Related Products</div>
						<div id="authorprofile" class="toolboxItem authorProfile">
							Author Profile</div>
						<div id="categorybrowser" class="toolboxItem categoryBrowser">
							Category Browser</div>
						<div id="randomizedarticlelist" class="toolboxItem randomizedArticleList">
							Randomized Article List</div>
						<div id="disquscomment" class="toolboxItem disqusComment">
							Disqus Comment</div>
						<div id="reviewform" class="toolboxItem reviewForm">
							Review Form</div>
						<div id="reviewtypelist" class="toolboxItem reviewTypeList">
							Review Type List</div>
						<div id="reviewlist" class="toolboxItem reviewList">
							Review List</div>
						<div id="articlereviewconfirmation" class="toolboxItem articleReviewConfirmation">
							Article Review Confirmation</div>
						<div id="contextualarticle" class="toolboxItem contextualArticle">
							Contextual Article</div> 
						<div id="articletypeassociatedcategorylist" class="toolboxItem articleTypeAssociatedCategoryList">
							Article Type Associated Category List</div>
                        <div id="videoplaylist" class="toolboxItem videoplaylist">
                            Video PlayList</div> 
                         <div id="relatedarticle" class="toolboxItem videoplaylist">
                            Related Article</div> 
					</div>
					<h3>
						<a href="#">Exhibition</a></h3>
					<div class="module exhibition">
						<div id="exhibitioncategorylist" class="toolboxItem exhibitionCategoryList">
							Exhibition Category List</div>
						<div id="exhibitionheader" class="toolboxItem exhibitionHeader">
							Exhibition Header</div>
						<div id="exhibitionlist" class="toolboxItem exhibitionList">
							Exhibition List</div>
						<div id="exhibitionshowspecials" class="toolboxItem exhibitionShowSpecials">
							Exhibition Show Specials</div>
						<div id="exhibitionvendorlist" class="toolboxItem exhibitionVendorList">
							Exhibition Vendor List</div>
					</div>
					<h3>
						<a href="#">Bulk Email</a></h3>
					<div class="module bulkemail">
						<div id="campaignarchiveslist" class="toolboxItem campaignArchivesList">
							Campaign Archives List</div>
						<div id="unsubscriptionreason" class="toolboxItem unsubscriptionReason">
							Unsubscription Reason</div>
					</div>
					
					<h3>
						<a href="#">Search</a>
					</h3>
					<div class="module search">
						<div id="search" class="toolboxItem search">
							Search</div>
						<div id="searchresult" class="toolboxItem searchResult">
							Search Result</div>
						<div id="elasticsearchresult" class="toolboxItem elasticSearchResult">
							Elastic Search Result</div>
						<div id="searchcategorypanel" class="toolboxItem searchcategorypanel">
							Search Category Tool</div>
						<div id="horizontalsearchcategorypanel" class="toolboxItem horizontalsearchcategorypanel">
							Horizontal Search Category Tool</div>
						<div id="specializedsearches" class="toolboxItem specializedsearches">
							Specialized Searches</div>
						<div id="guidedbrowseindex" class="toolboxItem guidedbrowseindex">
							Guided Browse Index</div>
						<div id="guidedbrowse" class="toolboxItem guidedbrowse">
							Guided Browse</div>
						<div id="fixedguidedbrowseindex" class="toolboxItem fixedguidedbrowseindex">
							Fixed Guided Browse Index</div>
						<div id="fixedguidedbrowse" class="toolboxItem fixedguidedbrowse">
							Fixed Guided Browse </div>
						<div id="prebuiltguidedbrowseindex" class="toolboxItem prebuiltguidedbrowseindex">
							Prebuilt Guided Browse Index</div>
						<div id="prebuiltguidedbrowse" class="toolboxItem prebuiltguidedbrowse">
							Prebuilt Guided Browse</div>
						<div id="prebuiltfixedguidedbrowseindex" class="toolboxItem prebuiltfixedguidedbrowseindex">
							Prebuilt Fixed Guided Browse Index</div>
						<div id="prebuiltfixedguidedbrowse" class="toolboxItem prebuiltfixedguidedbrowse">
							Prebuilt Fixed Guided Browse</div>
						<div id="searchheader" class="toolboxItem searchheader">
							Search Header </div>
						<div id="vendorsearchnotifier" class="toolboxItem vendorsearchnotifier">
							Vendor Search Notifier </div>
					</div>
					<h3>
						<a href="#">Category</a>
					</h3>
					<div class="module search">
						<div id="categorydescription" class="toolboxItem categorydetail">
							Category Description </div>
						<div id="relatedcategories" class="toolboxItem relatedcategories">
							Related Categories</div>
					</div>
				</div>
			</div>
		</div>
		<div class="rightColumn">
			<div id="canvas">
			</div>
		</div>
		<div class="jqmWindow" id="propertyDialog">
			<div class="dialog_container">
				<div class="dialog_content1">
					<div id="closeDialog" class="dialog_close">
						x
					</div>
					<div id="custom">
					</div>
					<div class="clear">
					</div>
					<div class="dialog_buttons" style="padding: 5px 5px 5px 10px;">
						<input type="button" id="propertySave" value="Ok" class="btn" />
						<input type="button" id="propertyCancel" value="Cancel" class="btn" />
					</div>
				</div>
				<div class="dialog_footer">
				</div>
			</div>
		</div>
	</div>
</asp:Content>
