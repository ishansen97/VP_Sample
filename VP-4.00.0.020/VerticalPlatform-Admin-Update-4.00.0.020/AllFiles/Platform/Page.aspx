<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
  CodeBehind="Page.aspx.cs" Inherits="VerticalPlatformAdminWeb.Platform.Page" Title="Page" %>

<asp:Content ID="conContent" ContentPlaceHolderID="cphContent" runat="server">
  <script src="../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>
  <script type="text/javascript">
    $(document).ready(function () {
      if ($('.ddlSubstitutePage').val() != '') {
        $('.txtSubstitutePageExternalUrl').val("");
        $('.txtSubstitutePageExternalUrl').attr('disabled', 'disabled');
      }
    });

    $('.ddlSubstitutePage').live('change', function () {
      if ($('.ddlSubstitutePage').val() != '') {
        $('.txtSubstitutePageExternalUrl').val("");
        $('.txtSubstitutePageExternalUrl').attr('disabled', 'disabled');
      }
      else {
        $('.txtSubstitutePageExternalUrl').removeAttr('disabled');
      }
    });

    var tabIndex = $("[id*=hdnTabIndex]").val();
    var $tabs = $('#descriptionPrefixTabs').tabs();
    $('#descriptionPrefixTabs').tabs("select", tabIndex);

    $(function () {
      $("#descriptionPrefixTabs").tabs({
        select: function (event, ui) {
          $("[id*=hdnTabIndex]").val(ui.index + 1);
        }
      });
    });
  </script>

  <div class="AdminPanel">
    <div class="AdminPanelHeader">
      <h3>
        <asp:Label ID="lblTitle" runat="server" /></h3>
    </div>
    <div class="AdminPanelContent">
      <div class="form-horizontal">
        <div class="control-group">
          <label class="control-label">Name</label>
          <div class="controls">
            <asp:DropDownList ID="ddlPageName" runat="server" AppendDataBoundItems="true">
              <asp:ListItem Text="--Select--" Value=""></asp:ListItem>
            </asp:DropDownList>
            <asp:TextBox ID="txtPageName" runat="server" Width="150px"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvPage" runat="server" ErrorMessage="Please select page name." ValidationGroup="Page"
              ControlToValidate="ddlPageName">*</asp:RequiredFieldValidator>
            <asp:RequiredFieldValidator ID="rfvPageName" runat="server" ControlToValidate="txtPageName"
              ErrorMessage="Please enter name." ValidationGroup="Page">*</asp:RequiredFieldValidator>
          </div>
        </div>
        <div class="control-group">
          <label class="control-label">Title</label>
          <div class="controls">
            <asp:TextBox ID="txtTitle" runat="server" MaxLength="100" Width="150px"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvPageTitle" runat="server" ErrorMessage="Please enter title." ValidationGroup="Page"
              ControlToValidate="txtTitle">*</asp:RequiredFieldValidator>
          </div>
        </div>
        <div class="control-group">
          <label class="control-label">Hide Title</label>
          <div class="controls">
            <asp:CheckBox ID="hideTitle" runat="server" />
            <asp:HiddenField ID="hdnHideTitle" runat="server" />
          </div>
        </div>
        <div class="control-group">
          <label class="control-label">Navigation Title</label>
          <div class="controls">
            <asp:TextBox ID="txtNavigationTitle" runat="server" Width="150px"></asp:TextBox>
            <asp:HiddenField ID="hdnNavigationTitle" runat="server" />
          </div>
        </div>
        <div class="control-group">
          <label class="control-label">Fixed URL</label>
          <div class="controls">
            <asp:TextBox ID="txtFixedUrl" runat="server" MaxLength="255" Width="150px"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvFixedUrl" runat="server" ErrorMessage="Please enter fixed url." ValidationGroup="Page"
              ControlToValidate="txtFixedUrl" Display="Dynamic">*</asp:RequiredFieldValidator>
            <asp:RegularExpressionValidator ID="revFixedUrl" runat="server" ErrorMessage="Url should start with '/', end with '/' and should only contain alpha numeric characters ,'-'. example '/pageid-pagename/pagetitle/'"
              ControlToValidate="txtFixedUrl" ValidationExpression="^((?:\/[a-zA-Z0-9]+(?:_[a-zA-Z0-9]+)*(?:\-[a-zA-Z0-9]+)*)+)/$"
              Display="Static" ValidationGroup="Page">*</asp:RegularExpressionValidator>
          </div>
        </div>
        <div class="control-group">
          <label class="control-label">Fixed URL Query String</label>
          <div class="controls">
            <asp:TextBox ID="txtQueryString" runat="server" MaxLength="255" Width="150px"></asp:TextBox>
          </div>
        </div>
        <div class="control-group">
          <label class="control-label">Title Prefix</label>
          <div class="controls">
            <asp:TextBox ID="txtTitlePrefix" runat="server" MaxLength="100" Width="150px"></asp:TextBox>
          </div>
        </div>
        <div class="control-group">
          <label class="control-label">Default Title Prefix</label>
          <div class="controls">
            <asp:TextBox ID="txtDefaultTitlePrefix" runat="server" Width="150px"></asp:TextBox>
            <asp:HiddenField ID="hdnDefaultTitlePrefix" runat="server" />
          </div>
        </div>
        <div class="control-group">
          <label class="control-label">Title Suffix</label>
          <div class="controls">
            <asp:TextBox ID="txtTitleSuffix" runat="server" MaxLength="100" Width="150px"></asp:TextBox>
          </div>
        </div>
        <div class="control-group">
          <label class="control-label">Description Prefix</label>
          <div class="controls">
            <div id="descriptionPrefixTabs" style="width: 360px">
              <ul>
                <li><a href="#tabs-1">Text</a></li>
                <li><a href="#tabs-2">Supported Values</a></li>
              </ul>
              <div id="tabs-1">
                <asp:TextBox ID="txtDescriptionPrefix" runat="server" TextMode="MultiLine" Style="height: 120px; width: 315px"></asp:TextBox>
              </div>
              <div id="tabs-2">
                <ul>
                  <p>
                    <b>Product Details</b><br />
                    context.FilteredProductCount<br />
                    <b>Review Details</b><br />
                    context.ReviewCount<br />
                  </p>
                </ul>
              </div>
            </div>
          </div>
        </div>
        <div class="control-group">
          <label class="control-label">Description Suffix</label>
          <div class="controls">
            <asp:TextBox ID="txtDescriptionSuffix" runat="server" MaxLength="100" Width="150px"></asp:TextBox>
          </div>
          <div class="control-group">
            <label class="control-label">
              Keywords<br />
              <code>(Comma Seperated)</code></label>
            <div class="controls">
              <asp:TextBox ID="txtKeywords" runat="server" Columns="40" Rows="3" TextMode="MultiLine"></asp:TextBox>
            </div>
          </div>
          <div class="control-group">
            <label class="control-label">Hidden</label>
            <div class="controls">
              <asp:CheckBox ID="chkHidden" runat="server" />
            </div>
          </div>
          <div class="control-group">
            <label class="control-label">Navigable</label>
            <div class="controls">
              <asp:CheckBox ID="chkNavigable" runat="server" />
            </div>
          </div>
          <div class="control-group">
            <label class="control-label">Enabled</label>
            <div class="controls">
              <asp:CheckBox ID="chkEnabled" runat="server" />
            </div>
          </div>
          <div class="control-group">
            <label class="control-label">Include in Sitemap</label>
            <div class="controls">
              <asp:CheckBox ID="chkIncludeInSitemap" runat="server" />
            </div>
          </div>
          <div class="control-group">
            <label class="control-label">Priority</label>
            <div class="controls">
              <asp:TextBox ID="txtPriority" runat="server"></asp:TextBox>
              <asp:RegularExpressionValidator ID="revPriorityValidator" runat="server" ControlToValidate="txtPriority"
                ErrorMessage="Priority should be a decimal value between and including 0.0 and 1.0, and contain only 1 
							decimal place."
                ValidationExpression="((0\.[0-9]{1})|(1\.0))" ValidationGroup="Page">*
              </asp:RegularExpressionValidator>
              <asp:HiddenField ID="hdnPriority" runat="server" />
            </div>
          </div>
          <div class="control-group">
            <label class="control-label">Change Frequency</label>
            <div class="controls">
              <asp:DropDownList ID="ddlChangeFrequency" runat="server">
                <asp:ListItem Text="<None>" Value="" Enabled="true" Selected="True"></asp:ListItem>
                <asp:ListItem Text="Always" Value="Always" Enabled="true" Selected="False"></asp:ListItem>
                <asp:ListItem Text="Hourly" Value="Hourly" Enabled="true" Selected="False"></asp:ListItem>
                <asp:ListItem Text="Daily" Value="Daily" Enabled="true" Selected="False"></asp:ListItem>
                <asp:ListItem Text="Weekly" Value="Weekly" Enabled="true" Selected="False"></asp:ListItem>
                <asp:ListItem Text="Monthly" Value="Monthly" Enabled="true" Selected="False"></asp:ListItem>
                <asp:ListItem Text="Yearly" Value="Yearly" Enabled="true" Selected="False"></asp:ListItem>
                <asp:ListItem Text="Never" Value="Never" Enabled="true" Selected="False"></asp:ListItem>
              </asp:DropDownList>
              <asp:HiddenField ID="hdnChangeFrequency" runat="server" />
            </div>
          </div>
          <div class="control-group">
            <label class="control-label">Login to View the Page</label>
            <div class="controls">
              <asp:CheckBox ID="chkLoginToView" runat="server" />
            </div>
          </div>
          <div class="control-group">
            <label class="control-label">Parent Page</label>
            <div class="controls">
              <asp:DropDownList ID="ddlParentPage" runat="server" AppendDataBoundItems="true" Width="160px">
                <asp:ListItem Text="<None>" Value=""></asp:ListItem>
              </asp:DropDownList>
            </div>
          </div>
          <div class="control-group">
            <label class="control-label">Substitute Page</label>
            <div class="controls">
              <asp:DropDownList ID="ddlSubstitutePage" runat="server" AppendDataBoundItems="true"
                CssClass="ddlSubstitutePage" Width="160px">
                <asp:ListItem Text="<None>" Value=""></asp:ListItem>
              </asp:DropDownList>
              <asp:HiddenField ID="hdnSubstitutePage" runat="server" />
            </div>
          </div>
          <div class="control-group">
            <label class="control-label">Substitute Page External URL</label>
            <div class="controls">
              <asp:TextBox runat="server" ID="txtSubstitutePageExternalUrl" CssClass="txtSubstitutePageExternalUrl" Width="150px"></asp:TextBox>
              <asp:HiddenField ID="hdnSubstitutePageExternalUrl" runat="server" />
              <asp:RegularExpressionValidator ControlToValidate="txtSubstitutePageExternalUrl"
                runat="server" ID="revSubstitutePageExternalUrl" ErrorMessage="Invalied Url"
                ValidationExpression="((http|ftp|https):\/\/)?[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&amp;:/~\+#]*[\w\-\@?^=%&amp;/~\+#])?">*
              </asp:RegularExpressionValidator>
            </div>
          </div>
          <div class="control-group">
            <label class="control-label">Open in New Window</label>
            <div class="controls">
              <asp:CheckBox ID="openExternalSubPageInNewWindowCheckBox" runat="server" />
              <asp:HiddenField ID="openExternalSubPageInNewWindowHidden" runat="server" />
            </div>
          </div>
          <div class="control-group">
            <label class="control-label">Template</label>
            <div class="controls">
              <asp:DropDownList ID="ddlTemplate" runat="server" AppendDataBoundItems="true" Width="160px">
                <asp:ListItem Text="--Select--" Value=""></asp:ListItem>
              </asp:DropDownList>
              <asp:RequiredFieldValidator ID="rfvPageTemplate" runat="server" ErrorMessage="Please select template."
                ValidationGroup="Page" ControlToValidate="ddlTemplate">*</asp:RequiredFieldValidator>
            </div>
          </div>
          <div class="control-group">
            <label class="control-label">Custom Css Class</label>
            <div class="controls">
              <asp:TextBox ID="txtCustomCssClass" runat="server" Width="150px"></asp:TextBox><asp:HiddenField
                ID="hdnCustomCssClass" runat="server" />
            </div>
          </div>
          <div class="control-group">
            <label class="control-label">Place Web Analytics Code at Bottom</label>
            <div class="controls">
              <asp:CheckBox ID="chkPlaceWebAnalyticsCodeAtBottom" runat="server" />
              <asp:HiddenField ID="hdnPlaceWebAnalyticsCodeAtBottom" runat="server" />
            </div>
          </div>
          <div class="control-group">
            <label class="control-label">Page Specific Analytics Code</label>
            <div class="controls">
              <asp:CheckBox ID="chkPageAnalyticsCode" runat="server" />
              <asp:HiddenField ID="hdnPageAnalyticsCode" runat="server" />
            </div>
          </div>
          <div class="control-group">
            <label class="control-label">Web Analytics Code</label>
            <div class="controls">
              <asp:TextBox ID="txtWebAnalyticsCode" runat="server" TextMode="MultiLine" Width="300px"
                Height="100px"></asp:TextBox>&nbsp;
            <asp:Image ID="imgInfo" runat="server" ImageUrl="~/App_Themes/Default/Images/Help-browser-small.png"
              ToolTip="Use text '<pagename>' on the javascript variable value for the pagename. This will be replaced with the actual page name dynamicaly. Use <pagetitle> for page title and <server> for server." />
              <asp:HiddenField ID="hdnWebAnalyticsCode" runat="server" />
            </div>
          </div>
        <div class="control-group">
          <label class="control-label">Block Page Loading On iframes</label>
          <div class="controls">
            <asp:CheckBox ID="chkSameOriginHeader" runat="server" Checked="true" />
            <asp:HiddenField ID="hdnSameOriginHeader" runat="server" />
          </div>
        </div>
        <div class="control-group">
            <label class="control-label">Page specific styles
            </label>
            <div class="controls">
                <asp:TextBox ID="TxtPageSpecificStyles" runat="server" TextMode="MultiLine" Width="400px"
                             Height="100px"></asp:TextBox>&nbsp;
                <asp:HiddenField ID="HdnPageSpecificStyles" runat="server" />
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">Apply page specific styles only
            </label>
            <div class="controls">
                <asp:CheckBox ID="ChkApplyPageSpecificStylesOnly" runat="server" Checked="False" />
                <asp:HiddenField ID="HdnApplyPageSpecificStylesOnly" runat="server" />
            </div>
        </div>

          <div class="control-group">
            <div class="controls">
              <asp:Label ID="lblMessage" runat="server" ForeColor="Red"></asp:Label>
            </div>
          </div>
          <div class="control-group">
            <div class="inline-form-container">
              <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_click" ValidationGroup="Page"
                CssClass="btn" />
              <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click"
                CausesValidation="false" CssClass="btn" />
              <asp:HyperLink ID="lnkPageDesigner" runat="server" Visible="false" CssClass="btn">Design Page</asp:HyperLink>
            </div>
          </div>
        </div>

      </div>
    </div>
    <asp:HiddenField ID="hdnTabIndex" runat="server" />
</asp:Content>
