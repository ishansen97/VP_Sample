<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="VerticalMatrixSettings.ascx.cs"
  Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.VerticalMatrixSettings" %>
<style type="text/css">
  *:first-child + html .ui-tabs-nav {
    width: auto;
    float: none;
    margin-left: -5px;
    position: static;
  }

  *:first-child + html .ui-tabs .ui-tabs-nav li {
    position: static;
  }

  .ui-widget input, .ui-widget select, .ui-widget textarea, .ui-widget button {
    font-size: 10px;
  }

  .form-horizontal .control-group {
    margin-bottom: 5px;
  }

  .dialog_container .form-horizontal .control-label {
    font-size: 12px;
  }

    .dialog_container .form-horizontal .control-label label, .dialog_container .form-horizontal .controls label {
      margin-bottom: 0px;
      padding: 0px;
    }
</style>

<script language="javascript" type="text/javascript">
  $(document).ready(function () {
    var tabIndex = $("[id*=hdnTabIndex]").val();
    var $tabs = $('#SearchCategoryTab' && '#SearchCategoryTabParagraph').tabs();
    $('#SearchCategoryTab').tabs("select", tabIndex);

    $(function () {
      $("#SearchCategoryTab").tabs({
        select: function (event, ui) {
          $("[id*=hdnTabIndex]").val(ui.index + 1);
        }
      });
    });
  });
</script>

<div class="form-horizontal">
  <div class="control-group">
    <label class="control-label">
      <asp:Label ID="lblModuleInstanceText" runat="server" Text="Page Size"></asp:Label></label>
    <div class="controls">
      <asp:TextBox ID="txtPageSize" runat="server" Style="margin-left: 0px" ValidationGroup="vg1"
        Width="75px"></asp:TextBox>
      <asp:HiddenField ID="hdnPageSize" runat="server" />
      <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtPageSize"
        ErrorMessage="*" ValidationGroup="vg1"></asp:RequiredFieldValidator>
      <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtPageSize"
        ErrorMessage="*" ValidationExpression="^[0-9]*$"></asp:RegularExpressionValidator>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label">Enable Specification Link</label>
    <div class="controls">
      <span class="checkbox inline">
        <asp:CheckBox ID="chkEnableSpecLink" runat="server" Checked="true" /></span>
      <asp:HiddenField ID="hdnEnableSpecEnable" runat="server" />
    </div>
  </div>
  <div class="control-group">
    <label class="control-label">Enable Fulltext Search Data Manager</label>
    <div class="controls">
      <span class="checkbox inline">
        <asp:CheckBox ID="chkEnabledFullTextSearch" runat="server" Checked="false" /></span>
      <asp:HiddenField ID="hdnEnabledFullTextSearch" runat="server" />
    </div>
  </div>
  <div class="control-group">
    <label class="control-label">Enable Full Elastic Search Data Manager</label>
    <div class="controls">
      <span class="checkbox inline">
        <asp:CheckBox ID="chkEnabledElasticSearch" runat="server" Checked="false" /></span>
      <asp:HiddenField ID="hdnEnabledElasticSearch" runat="server" />
    </div>
  </div>
  <div class="control-group">
    <label class="control-label">Enable Elastic Search Product Ids Retrieving Data Manager</label>
    <div class="controls">
      <span class="checkbox inline">
        <asp:CheckBox ID="chkEnabledSqlElasticSearch" runat="server" Checked="false" /></span>
      <asp:HiddenField ID="hdnEnabledSqlElasticSearch" runat="server" />
    </div>
  </div>
  <div class="control-group">
    <label class="control-label">Disable Localization Filter</label>
    <div class="controls">
      <span class="checkbox inline">
        <asp:CheckBox ID="chkDisableLocalizationFilter" runat="server" Checked="false" /></span>
      <asp:HiddenField ID="hdnDisableLocalizationFilter" runat="server" />
    </div>
  </div>
  <div class="control-group">
    <label class="control-label">Disable Completeness and Business Value Contribution for Search</label>
    <div class="controls">
      <span class="checkbox inline">
        <asp:CheckBox ID="disableScriptingContribution" runat="server" Checked="false" /></span>
      <asp:HiddenField ID="hiddenDisableScriptingContribution" runat="server" />
    </div>
  </div>
  <div class="control-group">
    <label class="control-label">Maximum Products Count to Consider when Disabling Completeness and Business Value Contribution for Search</label>
    <div class="controls">
      <asp:TextBox ID="maxProductsToDisableScriptingContribution" runat="server" Width="75px" MaxLength="10"></asp:TextBox>
      <asp:HiddenField ID="hiddenMaxProductsToDisableScriptingContribution" runat="server" />
      <asp:CompareValidator ID="maxProductsToDisableScriptingContributionValidator" runat="server" ValueToCompare="0"
        ControlToValidate="maxProductsToDisableScriptingContribution"
        ErrorMessage="Please enter a positive integer for maximum products count to consider when disabling completeness and business value contribution for search"
        Operator="GreaterThanEqual" Type="Integer">*</asp:CompareValidator>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label">Disable Sorting in Column Based Matrix</label>
    <div class="controls">
      <span class="checkbox inline">
        <asp:CheckBox ID="chkDisabledSortingColumnBasedMatrix" runat="server" Checked="false" /></span>
      <asp:HiddenField ID="hdnDisabledSortingColumnBasedMatrix" runat="server" />
    </div>
  </div>
  <div class="control-group">
    <label class="control-label">
      <asp:Label ID="lblEnableVendorFilter" runat="server" Text="Enable Vendor Filtering"></asp:Label></label>
    <div class="controls">
      <span class="checkbox inline">
        <asp:CheckBox ID="chkEnableVendorFiltering" runat="server" Checked="true" /></span>
      <asp:HiddenField ID="hdnEnableVendorFiltering" runat="server" />
    </div>
  </div>
  <div class="control-group">
    <label class="control-label">
      <asp:Label ID="productRowLevelClickThroughEnabledLabel" runat="server"
        Text="Product Row Level Click Through Enabled">
      </asp:Label></label>
    <div class="controls">
      <span class="checkbox inline">
        <asp:CheckBox ID="productRowLevelClickThroughEnabledCheckBox" runat="server" /></span>
      <asp:HiddenField ID="productRowLevelClickThroughEnabledHidden" runat="server" />
    </div>
  </div>
  <div class="control-group">
    <label class="control-label">Product Title Display Length for Vendor Compressed Matrix</label>
    <div class="controls">
      <asp:TextBox ID="productTitleDisplayLengthTextBox" runat="server" Width="75px"></asp:TextBox>
      <asp:HiddenField ID="productTitleDisplayLengthHidden" runat="server" />
      <asp:CompareValidator ID="productTitleDisplayLengthValidator" runat="server" ErrorMessage="Please enter an integer" ControlToValidate="productTitleDisplayLengthTextBox"
        Type="Integer" Operator="DataTypeCheck">*</asp:CompareValidator>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label">Display Catalog Number</label>
    <div class="controls">
      <span class="checkbox inline">
        <asp:CheckBox ID="chkDisplayCatalogNumber" runat="server" /></span>
      <asp:HiddenField ID="hdnDisplayCatalogNumber" runat="server" />
    </div>
  </div>
  <div class="control-group">
    <label class="control-label">Display Category Image</label>
    <div class="controls">
      <span class="checkbox inline">
        <asp:CheckBox ID="chkDisplayCategoryImage" runat="server" /></span>
      <asp:HiddenField ID="hdnDisplayCategoryImage" runat="server" />
    </div>
  </div>
  <div class="control-group">
    <label class="control-label">Display Ratings</label>
    <div class="controls">
      <span class="checkbox inline">
        <asp:CheckBox ID="chkDisplayRatings" runat="server" /></span>
      <asp:HiddenField ID="hdnDisplayRatings" runat="server" />
    </div>
  </div>
  <div class="control-group">
    <label class="control-label">Other Vendor Section Message</label>
    <div class="controls">
      <asp:TextBox ID="txtOtherVendorMessage" TextMode="MultiLine" runat="server" Height="75px"
        Width="332px"></asp:TextBox>
      <asp:HiddenField ID="hdnOtherVendorMessage" runat="server" />
    </div>
  </div>
  <div class="control-group">
    <label class="control-label">Filter Related Content By Article Types</label>
    <div class="controls">
      <div class="inline-form-container">
        <asp:DropDownList ID="ddlArticleType" runat="server" Width="265" Style="vertical-align: top;"></asp:DropDownList>
        <asp:Button ID="btnAddArticleType" runat="server" Text="Add" OnClick="btnAddArticleType_Click" CssClass="btn" Width="77" Style="vertical-align: top;" />
        <br />
        <asp:ListBox ID="lstArticleType" runat="server" Width="265" Style="vertical-align: top;"></asp:ListBox>
        <asp:Button ID="btnRemoveArticleType" runat="server" Text="Remove" OnClick="btnRemoveArticleType_Click" CssClass="btn" Width="77" Style="vertical-align: top;" /><asp:HiddenField ID="hdnArticleType" runat="server" />
      </div>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label">Display Link to Show Selected Products Action</label>
    <div class="controls">
      <span class="checkbox inline">
        <asp:CheckBox ID="chkDisplayAllProductsAction" runat="server" /></span>
      <asp:HiddenField ID="hdnDisplayAllProductsAction" runat="server" />
    </div>
  </div>
  <div class="control-group">
    <label class="control-label">Search Category Messages</label>
    <div class="controls">
      <div id="SearchCategoryTab" style="width: 332px">
        <ul>
          <li><a href="#tabs-1">Default Message</a></li>
          <li><a href="#tabs-2">Empty Search Results</a></li>
        </ul>
        <div id="tabs-1">
          <asp:TextBox ID="txtSearchCategoryDefaultMessage" TextMode="MultiLine" runat="server"
            Height="75px" Width="315px"></asp:TextBox>
          <asp:HiddenField ID="hdnSearchCategoryDefaultMessage" runat="server" />
        </div>
        <div id="tabs-2">
          <asp:TextBox ID="txtSearchCategoryNoResultsMessage" TextMode="MultiLine" runat="server"
            Height="75px" Width="315px"></asp:TextBox>
          <asp:HiddenField ID="hdnSearchCategoryNoResultsMessage" runat="server" />
        </div>
      </div>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label">Show More Versions Text</label>
    <div class="controls">
      <asp:TextBox ID="txtShowMoreVersions" TextMode="MultiLine" runat="server" Height="75px" Width="332px"></asp:TextBox>
      <asp:HiddenField ID="hdnShowMoreVersions" runat="server" />
    </div>
  </div>
  <div class="control-group">
    <label class="control-label">Custom "Write a Review" Link Text</label>
    <div class="controls">
      <asp:TextBox ID="customWriteAReviewText" TextMode="MultiLine" runat="server" Height="75px" Width="332px"></asp:TextBox>
      <asp:HiddenField ID="customWriteAReviewHdn" runat="server" />
    </div>
  </div>
  <div class="control-group">
    <label class="control-label">Custom "Be the First to Write a Review" Link Text</label>
    <div class="controls">
      <asp:TextBox ID="customBeTheFirstToWriteAReviewText" TextMode="MultiLine" runat="server" Height="75px" Width="332px"></asp:TextBox>
      <asp:HiddenField ID="customBeTheFirstToWriteAReviewHdn" runat="server" />
    </div>
  </div>
  <div class="control-group">
    <label class="control-label">Enable Sorting By</label>
    <div class="controls">
      <span class="checkbox inline">
        <asp:CheckBox ID="chkSortByName" runat="server" Checked="true" Text="Product Name" />
        <asp:HiddenField ID="hdnSortByName" runat="server" />
      </span>
      <span class="checkbox inline">
        <asp:CheckBox ID="chkSortByVendor" runat="server" Checked="true" Text="Vendor Name" />
        <asp:HiddenField ID="hdnSortByVendor" runat="server" />
      </span>
      <span class="checkbox inline">
        <asp:CheckBox ID="chkSortByPrice" runat="server" Checked="true" Text="Price" />
        <asp:HiddenField ID="hdnSortByPrice" runat="server" />
      </span>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label">Search Category Paragraph</label>
    <div class="controls">
      <div id="SearchCategoryTabParagraph" style="width: 332px">
        <ul>
          <li><a href="#tabs-3">Search Category Text</a></li>
          <li><a href="#tabs-4">Supported Values</a></li>
        </ul>
        <div id="tabs-3">
          <asp:TextBox ID="txtSearchCategoryParagraph" TextMode="MultiLine" runat="server"
            Height="120px" Width="315px"></asp:TextBox>
          <asp:HiddenField ID="hdnSearchCategoryParagraph" runat="server" />
        </div>
        <div id="tabs-4">
          <ul>
            <p>
              <b>Product and Vendor Details</b><br />
              context.FilteredProductCount<br />
              context.CurrentPageProductCount<br />
              context.CategoryDiscriptionSingular<br />
              context.CategoryDiscriptionPlural<br />
              <br />
              <b>Category Details</b><br />
              context.Category.Name<br />
              context.Category.Description<br />
              <br />
              <b>Search Option Detail List</b><br />
              context.SearchOption.Name<br />
              <br />
              <b>Search Group Detail List</b><br />
              context.SearchGroup.Name<br />
              context.SearchGroup.PrefixText<br />
              context.SearchGroup.SuffixText<br />
              <br />
              <b>Other Details</b><br />
              context.SearchText<p />
          </ul>
        </div>
      </div>
    </div>
  </div>
    <div class="control-group">
    <label class="control-label">Render New Markup</label>
    <div class="controls">
      <span class="checkbox inline">
        <asp:CheckBox ID="loadNewMatrixMarkupCheckBox" runat="server" /></span>
      <asp:HiddenField ID="loadNewMatrixMarkupHidden" runat="server" />
    </div>
  </div>
</div>
<asp:HiddenField ID="hdnTabIndex" runat="server" />
