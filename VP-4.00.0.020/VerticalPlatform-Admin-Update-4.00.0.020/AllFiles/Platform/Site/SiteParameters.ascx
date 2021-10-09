<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SiteParameters.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.Site.SiteParameters" %>
<%@ Register Src="../../ModuleAdmin/MatrixElementDisplaySelector.ascx" TagName="MatrixElementDisplaySelector"
	TagPrefix="uc1" %>
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
	.common_form_row_lable
	{
		padding-right: 20px;
	}
	
	#moduleTitleNamingRuleTab{width:600px;}
	#moduleTitleNamingRuleTab .tab2-container span{display:block;}
	#moduleTitleNamingRuleTab .tab2-container span b:first-child{margin-top:0px;}
	#moduleTitleNamingRuleTab .tab2-container span b{display:block; margin-top:5px;}
</style>

<script language="javascript" type="text/javascript">
	function DisplayWebAnalytics(chkWebAnalyticsSupportOn, tblWebAnalytics) {
		if ($get(chkWebAnalyticsSupportOn).checked) {
			$get(tblWebAnalytics).style.display = 'inline';
		}
		else {
			$get(tblWebAnalytics).style.display = 'none';
		}
	}

	$(function() {
		$("#tabs").tabs();
		$("#moduleTitleNamingRuleTab").tabs();
	});

</script>

<div id="tabs">
	<ul>
		<li><a href="#tabs-parameters">General</a></li>
		<li><a href="#tabs-displaySettings">Display</a></li>
		<li><a href="#tabs-scripts">Scripts</a></li>
		<li><a href="#tabs-actions">Actions</a></li>
		<li><a href="#tabs-webAnalytics">Web Analytics</a></li>
		<li><a href="#tabs-forums">Forums</a></li>
		<li><a href="#tabs-search">Search</a></li>
	</ul>
	<div id="tabs-parameters">
		<ul class="common_form_area">
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Item Selection Check Box Alignment
				</div>
				<div class="common_form_row_data">
					<asp:DropDownList ID="ddlAlignments" runat="server">
					</asp:DropDownList>
					<asp:HiddenField ID="hdnMatrixCheckBoxAlignmentId" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Page Title Prefix
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtPageTitlePrefix" runat="server" Width="400px"></asp:TextBox>
					<asp:HiddenField ID="hdnPageTitlePrefix" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Page Title Suffix
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtPageTitleSuffix" runat="server" Width="400px"></asp:TextBox>
					<asp:HiddenField ID="hdnPageTitleSuffix" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Description Prefix
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtDescriptionPrefix" runat="server" Width="400px"></asp:TextBox>
					<asp:HiddenField ID="hdnDescriptionPrefix" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Description Suffix
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtDescriptionSuffix" runat="server" Width="400px"></asp:TextBox>
					<asp:HiddenField ID="hdnDescriptionSuffix" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Article Link in Product Directory Enable
				</div>
				<div class="common_form_row_data">
					<asp:DropDownList ID="ddlArticleLinkEnable" runat="server">
						<asp:ListItem Text="True" Value="True"></asp:ListItem>
						<asp:ListItem Text="False" Value="False"></asp:ListItem>
					</asp:DropDownList>
					<asp:HiddenField ID="hdnArticleLinkEnable" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Article Link in Product Directory
				</div>
				<div class="common_form_row_data">
					<asp:DropDownList ID="ddlArticleLink" runat="server">
					</asp:DropDownList>
					<asp:HiddenField ID="hdnArticleLink" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Article Publish Date Format
				</div>
				<div class="common_form_row_data">
					<asp:DropDownList ID="ddlArticlePublishDateFormat" runat="server">
					</asp:DropDownList>
					<asp:HiddenField ID="hdnArticlePublishDateFormat" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Brightcove Publisher ID
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtBrightCovePublisherId" runat="server"></asp:TextBox>
					<asp:HiddenField ID="hdnBrightCovePublisherId" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Brightcove Player ID for Service Category
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtBrightCovePlayerId" runat="server"></asp:TextBox>
					<asp:HiddenField ID="hdnBrightCovePlayerId" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Preset Classes for Sections
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtPresetClass" runat="server"></asp:TextBox>
					<asp:HiddenField ID="hdnPresetClass" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Specification Length
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtSpecLength" runat="server" Width="100px"></asp:TextBox>
					<asp:CompareValidator ID="cvSpecLength" ControlToValidate="txtSpecLength" Operator="DataTypeCheck"
						Type="Integer" runat="server" ErrorMessage="Please enter a valid specification length">*</asp:CompareValidator>
					<asp:HiddenField ID="hdnMatrixSpecificationLengthId" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Vertical Matrix Full Specification Length
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtFullSpecLength" runat="server" Width="100px"></asp:TextBox>
					<asp:CompareValidator ID="cvFullSpecLength" ControlToValidate="txtFullSpecLength"
						Operator="DataTypeCheck" Type="Integer" runat="server" ErrorMessage="Please enter a valid specification length">*</asp:CompareValidator>
					<asp:HiddenField ID="hdnFullSpecificationLength" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Blank Specification Text
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtBlankSpecText" runat="server" Width="400px"></asp:TextBox>
					<asp:HiddenField ID="hdnBlankSpecTextId" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Site Start With WWW
				</div>
				<div class="common_form_row_data">
					<asp:DropDownList ID="ddlSiteStart" runat="server">
						<asp:ListItem Text="False" Value="False"></asp:ListItem>
						<asp:ListItem Text="True" Value="True"></asp:ListItem>
					</asp:DropDownList>
					<asp:HiddenField ID="hdnSiteStart" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Required Login to View Site
				</div>
				<div class="common_form_row_data">
					<asp:DropDownList ID="ddlLoginToViewSite" runat="server">
						<asp:ListItem Text="False" Value="False"></asp:ListItem>
						<asp:ListItem Text="True" Value="True"></asp:ListItem>
					</asp:DropDownList>
					<asp:HiddenField ID="hdnLoginToViewSite" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Vendor Product Page Open in New Window
				</div>
				<div class="common_form_row_data">
					<asp:DropDownList ID="ddlOpenVendorProductPage" runat="server">
						<asp:ListItem Text="False" Value="False"></asp:ListItem>
						<asp:ListItem Text="True" Value="True"></asp:ListItem>
					</asp:DropDownList>
					<asp:HiddenField ID="hdnOpenVendorProductPage" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					"Vendor" Text Alternative
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtVendorAlt" runat="server" />
					<asp:HiddenField ID="hdnVendorAlt" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Image Gallery Single Image Size
				</div>
				<div class="common_form_row_data">
					<asp:DropDownList ID="ddlImageGalleryImageSizes" runat="server">
					</asp:DropDownList>
					<asp:HiddenField ID="hdnImageGalleryImageSize" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Matrix Product Row Image Size Extension
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtProductRowImageSizeExt" runat="server"></asp:TextBox>
					(52x39/400x300/1600x1200)<asp:HiddenField ID="hdnProductRowImageSizeExt" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Subhome Prefix
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtSubHomePrefix" runat="server"></asp:TextBox>
					<asp:HiddenField ID="hdnSubHomePrefix" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Vertical Platform Lead Deployment Enabled
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="chkLeadDeploymentEnabled" runat="server" /><asp:HiddenField ID="hdnLeadDeploymentEnabled"
						runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Copy Lead Emails to
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtCopyLeadsToEmail" runat="server"></asp:TextBox>
					<asp:CustomValidator ID="emailAddressValidator" runat="server" ControlToValidate="txtCopyLeadsToEmail" 
						ErrorMessage="Invalid email address." ClientValidationFunction="VP.ValidateEmail">*</asp:CustomValidator>
					<asp:HiddenField ID="hdnCopyLeadsToEmail" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Privacy Policy Url
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtPrivacyPolicyUrl" runat="server" Width="200px"></asp:TextBox><asp:HiddenField
						ID="hdnPrivacyPolicyUrl" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Offline
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="chkOffline" runat="server" /><asp:HiddenField ID="hdnOffline" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Vendor Compression Matrix Page Size
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtVendorsPerPage" runat="server" Width="200px"></asp:TextBox><asp:HiddenField
						ID="hdnVendorsPerPage" runat="server" />
					<asp:CompareValidator ID="cmvVendorsPerPage" ControlToValidate="txtVendorsPerPage"
						Operator="DataTypeCheck" Type="Integer" ErrorMessage="Vendor compression matrix page size should be a numeric value."
						runat="server">*</asp:CompareValidator>
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Vendor Compression Initial Product Count
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtVendorCompressedInitialCount" runat="server" Width="200px"></asp:TextBox><asp:HiddenField
						ID="hdnVendorCompressedInitialCount" runat="server" />
					<asp:CompareValidator ID="cmvVendorCompressedInitialCount" ControlToValidate="txtVendorCompressedInitialCount"
						Operator="DataTypeCheck" Type="Integer" ErrorMessage="Vendor compression initial count should be a numeric value."
						runat="server">*</asp:CompareValidator>
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Vendor Compression Expanded Product Count
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtVendorCompressedExpandedCount" runat="server" Width="200px"></asp:TextBox><asp:HiddenField
						ID="hdnVendorCompressedExpandedCount" runat="server" />
					<asp:CompareValidator ID="cmvVendorCompressedExpandedCount" ControlToValidate="txtVendorCompressedExpandedCount"
						Operator="DataTypeCheck" Type="Integer" ErrorMessage="Vendor compression expanded count should be a numeric value."
						runat="server">*</asp:CompareValidator>
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Include "Priority" Tag in Sitemap
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="chkHasPriorityTag" runat="server" />
					<asp:HiddenField ID="hdnHasPriorityTag" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Persist User Login
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="persistLoginCheck" runat="server" Checked="true"/>
					<asp:HiddenField ID="persistLoginHiddenField" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Authentication Cookie Expiration Period (in days)
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="cookieExpirationPeriod" runat="server" Text="365"/>
					<asp:HiddenField ID="expirationPeriodHiddenField" runat="server" />
					<asp:RangeValidator ID="expirationValidator" ControlToValidate="cookieExpirationPeriod"
						MaximumValue="1000" MinimumValue="1" Type="Integer" ErrorMessage="Authentication cookie expiration period should be a numeric value between 1 and 1000."
						runat="server">*</asp:RangeValidator>
				</div>
			</li>
            <li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Matrix Product Image To Supplier Page
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="matrixProdImageToSupplierCheckbox" runat="server" Checked="false"/>
					<asp:HiddenField ID="matrixProdImageToSupplierHidden" runat="server" />
				</div>
			</li>
            <li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">User Login Max Attempts</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtUserMaxLogin" runat="server"></asp:TextBox>
                    <asp:RegularExpressionValidator ID="revUserMaxLogin" runat="server" ControlToValidate="txtUserMaxLogin" ValidationExpression="\d+" ErrorMessage="User Login Max Attempts field can only contain numbers. ">*
                    </asp:RegularExpressionValidator>
					<asp:HiddenField ID="hdnUserMaxLogin" runat="server" />
				</div>
			</li>
            <li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">User Login Time Limit(minutes)</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtUserLoginTimeLimit" runat="server"></asp:TextBox>
                    <asp:RegularExpressionValidator ID="revUserLoginTimeLimit" runat="server" ControlToValidate="txtUserLoginTimeLimit" ValidationExpression="\d+" ErrorMessage="User Login Time Limit field can only contain numbers. ">*
                    </asp:RegularExpressionValidator>
					<asp:HiddenField ID="hdnUserLoginTimeLimit" runat="server" />
				</div>
			</li>
            <li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">User Locked Admin Contact Email</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtAdminContact" runat="server"></asp:TextBox>
                    <asp:CustomValidator ID="CustomValidatorAdminContact" runat="server" ControlToValidate="txtAdminContact" 
                                         ErrorMessage="Invalid email address. " ClientValidationFunction="VP.ValidateEmail">*</asp:CustomValidator>
					<asp:HiddenField ID="hdnAdminContact" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Reset Password Email Subject Header Text
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtResetPasswordSubjectHeader" runat="server" Width="400px"/>
					<asp:HiddenField ID="hdnResetPasswordSubjectHeader" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Reset Password Body Header Text
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtResetPasswordHeader" runat="server" Width="400px"/>
					<asp:HiddenField ID="hdnResetPasswordHeader" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Reset Password Body Text
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtResetPasswordBody" runat="server" Width="400px"/>
					<asp:HiddenField ID="hdnResetPasswordBody" runat="server" />
				</div>
			</li>
		</ul>
	</div>
	<div id="tabs-displaySettings">
		<ul class="common_form_area">
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Show Vertical Matrix Images
				</div>
				<div class="common_form_row_data">
					<uc1:MatrixElementDisplaySelector ID="medsShowVerticalMatrixImage" runat="server"
						HideInheritedStatus="true" Enabled="true" />
				</div>
			</li>  
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Featured Product Header Text
				</div>
				<div class="common_form_row_data">
					<div class="common_form_row_data">
						<asp:TextBox ID="featuredProductHeaderTextBox" runat="server" Width="400px"></asp:TextBox>
						<asp:HiddenField ID="featuredProductHeaderHiddenField" runat="server" />
					</div>
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Show Vertical Matrix Images Only for Featured Products/Vendors
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="chkShowMatrixImagesForFeatured" runat="server" /><asp:HiddenField
						ID="hdnShowMatrixImagesForFeatured" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					<asp:Label ID="lblShowModelCount" runat="server" Text="Show Model Count"></asp:Label>
				</div>
				<div class="common_form_row_data">
					<uc1:MatrixElementDisplaySelector ID="medsShowModelCount" runat="server" HideInheritedStatus="True"
						Enabled="true" CurrentStatus="False" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Login Required to View Prices
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="chkViewPrices" runat="server" /><asp:HiddenField ID="hdnViewPrices"
						runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Matrix Pricing Info text
				</div>
				<div class="common_form_row_data">
					<div class="common_form_row_data">
						<asp:TextBox ID="pricingInfoText" runat="server" Width="400px"></asp:TextBox>
						<asp:HiddenField ID="pricingInfoTextHidden" runat="server" />
					</div>
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Display Link to Vendor Profile Page
				</div>
				<div class="common_form_row_data">
					<uc1:MatrixElementDisplaySelector ID="medsVendorProfile" runat="server" HideInheritedStatus="True"
						Enabled="true" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Display Request Info Vendors on Lead Form
				</div>
				<div class="common_form_row_data">
					<asp:DropDownList ID="ddlDisplayLeadVendor" runat="server">
						<asp:ListItem Text="True" Value="True"></asp:ListItem>
						<asp:ListItem Text="False" Value="False"></asp:ListItem>
					</asp:DropDownList>
					<asp:HiddenField ID="hdnDisplayLeadVendor" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Request Info Vendors Label on Lead Form
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtLeadVendorsLabel" runat="server" Width="400px"></asp:TextBox>
					<asp:HiddenField ID="hdnLeadVendorsLabel" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Display Associated Vendors in Vertical Matrix
				</div>
				<div class="common_form_row_data">
					<asp:DropDownList ID="ddlDisplayVendors" runat="server">
						<asp:ListItem Text="True" Value="True"></asp:ListItem>
						<asp:ListItem Text="False" Value="False"></asp:ListItem>
					</asp:DropDownList>
					<asp:HiddenField ID="hdnDisplayVendors" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Display Product Count in Product Directory
				</div>
				<div class="common_form_row_data">
					<uc1:MatrixElementDisplaySelector ID="medsProductCount" runat="server" HideInheritedStatus="True"
						Enabled="true" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Display Images in Related Product Module
				</div>
				<div class="common_form_row_data">
					<uc1:MatrixElementDisplaySelector ID="medsDisplayRelatedProductImages" runat="server"
						HideInheritedStatus="True" Enabled="true" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Hide Price Information
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="hidePriceInformationCheckBox" runat="server" />
					<asp:HiddenField ID="hidePriceInformationHiddenField" runat="server" />
				</div>
			</li> 
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Display Registration Form in Modal
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="displayRegitrationFormModalCheckBox" runat="server" />
					<asp:HiddenField ID="displayRegitrationFormModalHiddenField" runat="server" />
				</div>
			</li>
		    <li class="common_form_row clearfix" style="padding-top: 10px;">
		        <div class="common_form_row_lable">
		            Featured Display Text
		        </div>
		        <div class="common_form_row_data">
		            <asp:TextBox ID="featuredDisplayText" runat="server" Width="400px"></asp:TextBox>
		            <asp:HiddenField ID="featuredDisplayTextHdn" runat="server" />
		        </div>
		    </li>
		    <li class="common_form_row clearfix" style="padding-top: 10px;">
		        <div class="common_form_row_lable">
		            Featured Plus Display Text
		        </div>
		        <div class="common_form_row_data">
		            <asp:TextBox ID="featuredPlusDisplayText" runat="server" Width="400px"></asp:TextBox>
		            <asp:HiddenField ID="featuredPlusDisplayTextHdn" runat="server" />
		        </div>
		    </li>
			<li class="common_form_row clearfix" style="padding-top: 10px; margin-top: 20px;
				border-top: solid 1px #dddddd;">
				<div>
					<strong>Matrix Element Display Settings</strong>
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					<asp:Label ID="lblShowCheckBox" runat="server" Text="Show Check Boxes"></asp:Label>
				</div>
				<div class="common_form_row_data">
					<uc1:MatrixElementDisplaySelector ID="medsShowCheckBox" runat="server" HideInheritedStatus="True"
						Enabled="true" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					<asp:Label ID="lblShowImage" runat="server" Text="Show Images in Compare Page"></asp:Label>
				</div>
				<div class="common_form_row_data">
					<uc1:MatrixElementDisplaySelector ID="medsShowImage" runat="server" HideInheritedStatus="True"
						Enabled="true" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					<asp:Label ID="lblShowManufacturer" runat="server" Text="Show Manufacturers"></asp:Label>
				</div>
				<div class="common_form_row_data">
					<uc1:MatrixElementDisplaySelector ID="medsShowManufacturer" runat="server" HideInheritedStatus="True"
						Enabled="true" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					<asp:Label ID="lblShowDistributor" runat="server" Text="Show Distributors"></asp:Label>
				</div>
				<div class="common_form_row_data">
					<uc1:MatrixElementDisplaySelector ID="medsShowDistributor" runat="server" HideInheritedStatus="True"
						Enabled="true" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					<asp:Label ID="lblShowSpecification" runat="server" Text="Show Specifications"></asp:Label>
				</div>
				<div class="common_form_row_data">
					<uc1:MatrixElementDisplaySelector ID="medsShowSpecification" runat="server" HideInheritedStatus="True"
						Enabled="true" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					<asp:Label ID="lblShowPrice" runat="server" Text="Show Prices"></asp:Label>
				</div>
				<div class="common_form_row_data">
					<uc1:MatrixElementDisplaySelector ID="medsShowPrice" runat="server" HideInheritedStatus="True"
						Enabled="true" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					<asp:Label ID="lblShowPriceAndLeads" runat="server" Text="Show 'Leads Turned Off Text' When Price Info is Available"></asp:Label>
				</div>
				<div class="common_form_row_data">
					<uc1:MatrixElementDisplaySelector ID="medsShowPriceAndLeads" runat="server" HideInheritedStatus="True"
						Enabled="true" CurrentStatus="True" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					<asp:Label ID="lblShowLink" runat="server" Text="Show Link to Item Details"></asp:Label>
				</div>
				<div class="common_form_row_data">
					<uc1:MatrixElementDisplaySelector ID="medsShowItemLink" runat="server" HideInheritedStatus="True"
						Enabled="true" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					<asp:Label ID="lblShowAssociation" runat="server" Text="Show Content Associations"></asp:Label>
				</div>
				<div class="common_form_row_data">
					<uc1:MatrixElementDisplaySelector ID="medsShowAssociation" runat="server" HideInheritedStatus="True"
						Enabled="true" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					<asp:Label ID="lblShowLinkVendor" runat="server" Text="Show Link To Vendor Product Pages"></asp:Label>
				</div>
				<div class="common_form_row_data">
					<uc1:MatrixElementDisplaySelector ID="medsShowVenderLink" runat="server" HideInheritedStatus="True"
						Enabled="true" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					<asp:Label ID="lblShowRequestInformationLink" runat="server" Text="Show Request Information Link"></asp:Label>
				</div>
				<div class="common_form_row_data">
					<uc1:MatrixElementDisplaySelector ID="medsShowRequestInformationLink" runat="server"
						HideInheritedStatus="True" CurrentStatus="False" Enabled="true" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					<asp:Label ID="lblShowReqInfoForAll" runat="server" Text="Show 'Request Info for All' Button in Vertical Matrix"></asp:Label>
				</div>
				<div class="common_form_row_data">
					<uc1:MatrixElementDisplaySelector ID="medsShowRequestInfoForAll" runat="server" HideInheritedStatus="True"
						Enabled="true" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					<asp:Label ID="lblShowHorizontalMatrixReqInfoForAll" runat="server" Text="Show 'Request Info for All' Button in Compare Page"></asp:Label>
				</div>
				<div class="common_form_row_data">
					<uc1:MatrixElementDisplaySelector ID="medsShowHorizontalMatrixReqInfoForAll" runat="server" HideInheritedStatus="True"
						Enabled="true" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					<asp:Label ID="lblShowVendorSpec" runat="server" Text="Show Vendor Specification"></asp:Label>
				</div>
				<div class="common_form_row_data">
					<uc1:MatrixElementDisplaySelector ID="medsShowVendorSpec" runat="server" HideInheritedStatus="True"
						Enabled="true" />
				</div>
			</li>
		</ul>
	</div>
	<div id="tabs-scripts">
		<ul class="common_form_area">
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Custom Advertisement Code
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtCustomAdCode" runat="server" TextMode="MultiLine" Width="400px"
						Height="100px"></asp:TextBox>
					<asp:HiddenField ID="hdnCustomAdCode" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Custom Header Script
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtCustomHeaderScript" runat="server" TextMode="MultiLine" Width="400px"
						Height="100px"></asp:TextBox>
					<asp:HiddenField ID="hdnCustomHeaderScript" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Body html
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtBodyHtml" runat="server" TextMode="MultiLine" Width="400px" Height="100px"></asp:TextBox>
					<asp:HiddenField ID="hdnBodyHtml" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div >
					Guided Browse Module Title Default Naming Rule
				</div>
				<div >
					<div id="moduleTitleNamingRuleTab">
						<ul>
							<li><a href="#tabs-1">Ruby Script</a></li>
							<li><a href="#tabs-2">Supported Properties</a></li>
						</ul>
						<div id="tabs-1">
							<asp:TextBox ID="txtModuleTitleNamingRule" Width="570" Height="140" runat="server" TextMode="MultiLine"></asp:TextBox>
						</div>
						<div id="tabs-2" class="tab2-container">
							<div>
								<span><b>Guided Browse Details</b></span>
								<span>context.GuidedBrowse.Name</span>
								<span>context.GuidedBrowse.Prefix</span>
								<span>context.GuidedBrowse.Suffix</span>
								<span><b>Category Details</b></span>
								<span>context.Category.Name</span>
								<span>context.Category.Description</span>
								<span>context.Category.ShortName</span>
								<span><b>Guided Browse Search Group Details</b></span>
								<span>context.GroupDetails.GuidedBrowseSearchGroup.Name</span>
								<span>context.GroupDetails.GuidedBrowseSearchGroup.Description</span>
								<span>context.GroupDetails.GuidedBrowseSearchGroup.Prefix</span>
								<span>context.GroupDetails.GuidedBrowseSearchGroup.Suffix</span>
								<span><b>Search Group Details</b></span>
								<span>context.GroupDetails.SearchGroup.Name</span>
								<span>context.GroupDetails.SearchGroup.Description</span>
								<span>context.GroupDetails.SearchGroup.PrefixText</span>
								<span>context.GroupDetails.SearchGroup.SuffixText</span>
								<span>context.GroupDetails.SearchOption</span>
								<span><b>Methods</b></span>
								<span>bool Exists(int groupId)</span>
								<span>GuidedBrowseSearchGroupDetail GetGroupDetail(int groupId)</span>
							</div>
						</div>
					</div>
					<asp:HiddenField ID="hdnModuleTitleNamingRule" runat="server" />
				</div>
			</li>
		</ul>
	</div>
	<div id="tabs-actions">
		<ul class="common_form_area">
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Primary Lead Form Button Text
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtPrimaryLeadButtonText" runat="server" Width="200px"></asp:TextBox>
					<asp:HiddenField ID="hdnPrimaryLeadButtonText" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Secondary Lead Form Button Text
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtSecondaryLeadButtonText" runat="server" Width="200px"></asp:TextBox>
					<asp:HiddenField ID="hdnSecondaryLeadButtonText" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Request Information for Selected Products Button Text
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtSelectedInfoText" runat="server" Width="200px"></asp:TextBox>
					<asp:HiddenField ID="hdnSelectedInfoTextId" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Request Information for All Products Button Text
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtAllButtonText" runat="server" Width="200px"></asp:TextBox>
					<asp:HiddenField ID="hdnRequestAllInfoButtonTextId" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Leads are Turned Off Text
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtNoLead" runat="server" Width="200px"></asp:TextBox>
					<asp:HiddenField ID="hdnNoLead" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Direct Click Through Button Text
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtDirectClickThroughButtonText" runat="server" Width="200px"></asp:TextBox>
					<asp:HiddenField ID="hdnDirectClickThroughButtonId" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Default Clickthrough
				</div>
				<div class="common_form_row_data">
					<asp:DropDownList ID="defaultClickthroughDropdown" runat="server" AppendDataBoundItems="true">
						<asp:ListItem Text="- None -" Value=""></asp:ListItem>
					</asp:DropDownList>
					<asp:HiddenField ID="defaultClickthroughHidden" runat="server" />
				</div>
			</li>
		</ul>
	</div>
	<div id="tabs-webAnalytics">
		<ul class="common_form_area">
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Web Analytics Support on
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="chkWebAnalyticsSupportOn" runat="server" />
					<asp:HiddenField ID="hdnWebAnalyticsSupportOn" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<table id="tblWebAnalytics" runat="server" width="100%">
					<tr>
						<td style="width: 40%">
							Place Web Analytics Code at the Bottom
						</td>
						<td>
							<asp:CheckBox ID="chkPlaceWebAnalyticsCodeAtBottom" runat="server" />
							<asp:HiddenField ID="hdnPlaceWebAnalyticsCodeAtBottom" runat="server" />
						</td>
					</tr>
					<tr>
						<td>
							Web Analytics Code
						</td>
						<td>
							<asp:TextBox ID="txtWebAnalyticsCode" runat="server" Width="400px" TextMode="MultiLine"
								Height="100px"></asp:TextBox>
							<asp:Image ID="imgInfo" runat="server" ImageUrl="~/Images/Info.gif" AlternateText="Use text '<pagename>' on the javascript variable value for the pagename. This will be replaced with the actual page name dynamicaly. Use <pagetitle> for page title and <server> for server." />
							<asp:HiddenField ID="hdnWebAnalyticsCode" runat="server" />
						</td>
					</tr>
				</table>
			</li>
		</ul>
	</div>
	<div id="tabs-forums">
		<ul class="common_form_area">
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Registration Required to Read Forum Post
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="chkReadForumPost" runat="server" /><asp:HiddenField ID="hdnReadForumPost"
						runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Registration Required to Write Forum Post
				</div>
				<div class="common_form_row_data">
					<asp:CheckBox ID="chkWriteForumPost" runat="server" /><asp:HiddenField ID="hdnWriteForumPost"
						runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Number of days for Most Recent Posts
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtMostRecentPostDays" runat="server" Width="100px"></asp:TextBox>
					<asp:CompareValidator ID="cmpvMostRecentPostDays" ControlToValidate="txtMostRecentPostDays"
						Operator="DataTypeCheck" Type="Integer" runat="server" ErrorMessage="Please enter a valid Number of days">*</asp:CompareValidator>
					<asp:HiddenField ID="hdnMostRecentPostDays" runat="server" />
				</div>
			</li>
		</ul>
	</div>
	<div id="tabs-search">
		<ul class="common_form_area">
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Search Provider
				</div>
				<div class="common_form_row_data">
					<asp:DropDownList ID="searchProviderDropDownList" runat="server">
					</asp:DropDownList>
					<asp:HiddenField ID="searchProviderHiddenField" runat="server" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Completeness Multiplier
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtCompletenessMultiplier" runat="server" Width="200px"></asp:TextBox><asp:HiddenField
						ID="hdnCompletenessMultiplier" runat="server" />%
					<asp:CompareValidator ID="cmpvCompletenessMultiplier" ControlToValidate="txtCompletenessMultiplier"
						Operator="DataTypeCheck" Type="Integer" ErrorMessage="Completeness multiplier should be a numeric value."
						runat="server">*</asp:CompareValidator>
					<asp:RangeValidator ID="rnvCompletenessMultiplier" ControlToValidate="txtCompletenessMultiplier"
						Type="Integer" MinimumValue="1" MaximumValue="100" runat="server" ErrorMessage="Completeness multiplier should be between 1 and 100.">*</asp:RangeValidator>
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Business Value Multiplier
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtBusinessValueMultiplier" runat="server" Width="200px"></asp:TextBox><asp:HiddenField
						ID="hdnBusinessValueMultiplier" runat="server" />%
					<asp:CompareValidator ID="cmpvBusinessValueMultiplier" ControlToValidate="txtBusinessValueMultiplier"
						Operator="DataTypeCheck" Type="Integer" ErrorMessage="Business value multiplier should be a numeric value."
						runat="server">*</asp:CompareValidator>
					<asp:RangeValidator ID="rnvBusinessValueMultiplier" ControlToValidate="txtBusinessValueMultiplier"
						Type="Integer" MinimumValue="1" MaximumValue="100" runat="server" ErrorMessage="Business value multiplier should be between 1 and 100.">*</asp:RangeValidator>
				</div>
			</li>
            <li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Featured Plus Products Weight Percentage
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="featuredPlusWeightText" runat="server" Width="200px"></asp:TextBox><asp:HiddenField
						ID="featuredPlusWeightHidden" runat="server" />%
					<asp:CompareValidator ID="featuredPlusWeightCompareValidator" ControlToValidate="featuredPlusWeightText"
						Operator="DataTypeCheck" Type="Integer" ErrorMessage="Featured Plus weight percentage should be a numeric value."
						runat="server">*</asp:CompareValidator>
					<asp:RangeValidator ID="featuredPlusWeightRangeValidator" ControlToValidate="featuredPlusWeightText"
						Type="Integer" MinimumValue="-100" MaximumValue="100" runat="server" ErrorMessage="Featured Plus weight percentage should be between 1 and 100.">*</asp:RangeValidator>
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Featured Products Weight Percentage
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="featuredWeightText" runat="server" Width="200px"></asp:TextBox><asp:HiddenField
						ID="featuredWeightHidden" runat="server" />%
					<asp:CompareValidator ID="featuredWeightCompareValidator" ControlToValidate="featuredWeightText"
						Operator="DataTypeCheck" Type="Integer" ErrorMessage="Featured weight percentage should be a numeric value."
						runat="server">*</asp:CompareValidator>
					<asp:RangeValidator ID="featuredWeightRangeValidator" ControlToValidate="featuredWeightText"
						Type="Integer" MinimumValue="-100" MaximumValue="100" runat="server" ErrorMessage="Featured weight percentage should be between 1 and 100.">*</asp:RangeValidator>
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Standard Products Weight Percentage
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="standardWeightText" runat="server" Width="200px"></asp:TextBox><asp:HiddenField
						ID="standardWeightHidden" runat="server" />%
					<asp:CompareValidator ID="standardWeightCompareValidator" ControlToValidate="standardWeightText"
						Operator="DataTypeCheck" Type="Integer" ErrorMessage="Standard weight percentage should be a numeric value."
						runat="server">*</asp:CompareValidator>
					<asp:RangeValidator ID="standardWeightRangeValidator" ControlToValidate="standardWeightText"
						Type="Integer" MinimumValue="-100" MaximumValue="100" runat="server" ErrorMessage="Standard weight percentage should be between 1 and 100.">*</asp:RangeValidator>
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Minimized Products Weight Percentage
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="minimizedWeightText" runat="server" Width="200px"></asp:TextBox><asp:HiddenField
						ID="minimizedWeightHidden" runat="server" />%
					<asp:CompareValidator ID="minimizedWeightCompareValidator" ControlToValidate="minimizedWeightText"
						Operator="DataTypeCheck" Type="Integer" ErrorMessage="Minimized weight percentage should be a numeric value."
						runat="server">*</asp:CompareValidator>
					<asp:RangeValidator ID="minimizedWeightRangeValidator" ControlToValidate="minimizedWeightText"
						Type="Integer" MinimumValue="-100" MaximumValue="100" runat="server" ErrorMessage="Minimized weight percentage should be between 1 and 100.">*</asp:RangeValidator>
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Number of Featured Items
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtFeaturedItemCount" runat="server"></asp:TextBox>
					<asp:HiddenField ID="hdnFeaturedItemCount" runat="server" />
					<asp:CompareValidator ID="cmpvFeaturedCount" ControlToValidate="txtFeaturedItemCount"
						Operator="DataTypeCheck" Type="Integer" ErrorMessage="Featured Item count should be numeric value."
						runat="server">*</asp:CompareValidator>
				</div>
			</li>
		</ul>
	</div>
</div>
