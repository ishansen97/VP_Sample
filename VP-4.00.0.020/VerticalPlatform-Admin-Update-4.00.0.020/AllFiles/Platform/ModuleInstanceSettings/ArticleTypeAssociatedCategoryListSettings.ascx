<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ArticleTypeAssociatedCategoryListSettings.ascx.cs"
Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.ArticleTypeAssociatedCategoryListSettings" %>  
<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>
<script src="../../Js/ContentPicker.js" type="text/javascript"></script>   
<script src="../../Js/UrlHelper.js" type="text/javascript"></script>
<table>
	<tr>
		<td>
			Article Type List
		</td>
		<td>  <asp:TextBox ID="articleTypeFileterTextBox" runat="server" Style="width: 225px;float:left;" />
			<asp:Button ID="addArticleTypeButton" runat="server" Text="Add" OnClick="addArticleTypeButton_Click"
			CausesValidation="false" CssClass="common_text_button" style="width:70px;margin-left:5px" />
			<asp:HiddenField ID="articleTypeHidden" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			
		</td>
		<td style="vertical-align: top">
			<asp:ListBox ID="articleTypeListBox" runat="server" Width="240px" Height="54px" Style="float: left;">
			</asp:ListBox> 
			<asp:Button ID="removeArticleTypeButton" Text="Remove" runat="server" OnClick="removeArticleTypeButton_Click"
			CssClass="common_text_button" CausesValidation="False" style="width:70px;margin-left:5px" />
		</td>
	</tr>  
	<tr>
		<td Style="width: 175px">
			Article List Landing Page URL
		</td>
		<td style="vertical-align: top">
			<asp:TextBox ID="articleListLandingPageTextBox" runat="server" Width="225px" />  
			<asp:CustomValidator ID="landingPageURLCustomValidator" runat="server" ClientValidationFunction="VP.ArticleTypeAssociatedCategoryList.ValidateRedirectUrl"
				 ErrorMessage="Please enter a valid url for article list landing page url eg. http://www.example.com/al-page or a relative url eg. /example/al-page/">*</asp:CustomValidator>
			<asp:HiddenField runat="server" ID="articleListLandingPageHidden"/>
		</td>
	</tr>
	<tr>
		<td>Page Size</td> 
		<td><asp:TextBox ID="pageSizeTextBox" runat="server" Width="225px" />	
			<asp:HiddenField runat="server" ID="pageSizeHidden"/> 
			<asp:CompareValidator ID="pageSizeValidator" runat="server" ErrorMessage="Please enter a numeric value for  'Page Size'."
						ControlToValidate="pageSizeTextBox" Type="Integer" Operator="DataTypeCheck"
						SetFocusOnError="True">*</asp:CompareValidator>	
			<asp:RequiredFieldValidator runat="server" ID="pageSizeRequiredValidator"  ErrorMessage="Please enter a 'Page Size'" ControlToValidate="pageSizeTextBox" SetFocusOnError="True">*</asp:RequiredFieldValidator>
		</td>
	</tr>
	<tr>
		<td>Display Paging On Top</td> 
		<td>
			<asp:CheckBox runat="server" ID="displayPagingOnTopCheckBox"/> 
			<asp:HiddenField runat="server" ID="displayPagingOnTopHidden"/>
		</td>
	</tr> 
	<tr>
		<td>Display Paging On Bottom</td> 
		<td><asp:CheckBox runat="server" ID="displayPagingOnBottomCheckBox"/>  
			<asp:HiddenField runat="server" ID="displayPagingOnBottomHidden"/>
		</td>
	</tr>
	<tr>
		<td>Open In New Window</td> 
		<td>
			<asp:CheckBox runat="server" ID="openInNewWindowCheckBox"/>  
			<asp:HiddenField runat="server" ID="openInNewWindowHidden"/>
		</td>
	</tr>
</table>  
<asp:HiddenField runat="server" ID="articleTypeListSettingHidden"/>
<script type="text/javascript">
  $(document).ready(function () {
    RegisterNamespace("VP.ArticleTypeAssociatedCategoryList");
    var articleTypeHidden = { contentId: "articleTypeHidden" };
    var articleTypeFilterOptions = { siteId: VP.SiteId, type: "Article Type", currentPage: "1", pageSize: "15", showName: "true",
      bindings: articleTypeHidden
    };

    $("input[type=text][id*=articleTypeFileterTextBox]").contentPicker(articleTypeFilterOptions);

    VP.ArticleTypeAssociatedCategoryList.ValidateRedirectUrl = function (src, args) {
      var articleListLandingPageUrl = $("input[type=text][id*=articleListLandingPageTextBox]").val().trim();
      if (articleListLandingPageUrl.length == 0) {
        args.IsValid = false;
      }
      else if (articleListLandingPageUrl.length > 0) {
        var urlValidator = new VP.UrlHelper.UrlValidator(articleListLandingPageUrl);
        args.IsValid = urlValidator.ValidateAbsoluteOrRelativeUrl();
      }
    };
  });
</script> 