<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ElasticSearchResultSettings.ascx.cs"
    Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.ElasticSearchResultSettings" %>

<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>
<script src="../../Js/ContentPicker.js" type="text/javascript"></script>

<script language="javascript" type="text/javascript">
    RegisterNamespace("VP.ElasticSearchResult");
    $(document).ready(function () {
        RegisterNamespace("VP.ArticleList");
        var articleTypeFilterOptions = { siteId: VP.SiteId, type: "Article Type", currentPage: "1", pageSize: "15", showName: "true" };
			$("input[type=text][id*=txtArticleTypeFilter]").contentPicker(articleTypeFilterOptions);
			$("input[type=text][id*=txtDisplayArticleTypeNames]").contentPicker(articleTypeFilterOptions);
    });
</script>
<table>
    <tr>
        <td>Search Header Link Text
        </td>
        <td>
            <asp:TextBox ID="searchHeaderLinkText" runat="server"></asp:TextBox>
            <asp:HiddenField ID="searchHeaderLinkTextHidden" runat="server" />
            <asp:RequiredFieldValidator ID="searchHeaderLinkTextValidator" runat="server" ErrorMessage="Please provide a link text."
                ControlToValidate="searchHeaderLinkText">*</asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <td>Content Type
        </td>
        <td>
            <asp:DropDownList ID="ddlContentType" runat="server"
                AppendDataBoundItems="True" AutoPostBack="true"
                OnSelectedIndexChanged="ddlContentType_SelectedIndexChanged" Width="210">
                <asp:ListItem Text="--Select--" Value=""></asp:ListItem>
            </asp:DropDownList>
            <asp:RequiredFieldValidator ID="rfvContentType" runat="server" ErrorMessage="Please select content type" ControlToValidate="ddlContentType">*</asp:RequiredFieldValidator>
            <asp:HiddenField ID="hdnContentType" runat="server" />
        </td>
    </tr>
    <tr>
        <td>Number of initial results
        </td>
        <td>
            <asp:TextBox ID="txtModuleResults" runat="server" Width="200"></asp:TextBox>
            <asp:HiddenField ID="hdnModuleResults" runat="server" />
            <asp:CompareValidator ID="cpvModuleResults" runat="server" ErrorMessage="Numbers only" ControlToValidate="txtModuleResults"
                Type="Integer" Operator="DataTypeCheck"></asp:CompareValidator>
        </td>
    </tr>
    <tr>
        <td>Number of total results
        </td>
        <td>
            <asp:TextBox ID="txtModuleTotalResults" runat="server" Width="200"></asp:TextBox>
            <asp:HiddenField ID="hdnModuleTotalResults" runat="server" />
            <asp:CompareValidator ID="cpvModuleTotalResults" runat="server" ErrorMessage="Numbers only" ControlToValidate="txtModuleTotalResults"
                Type="Integer" Operator="DataTypeCheck"></asp:CompareValidator>
        </td>
    </tr>
    <tr>
        <td>
            <asp:Literal ID="ltlGroupByType" runat="server" Text="Group By Article Type"></asp:Literal>
        </td>
        <td>
            <asp:CheckBox ID="chkGroupByType" runat="server" />
            <asp:HiddenField ID="hdnGroupByType" runat="server" />
        </td>
    </tr>
    <tr runat="server" id="sortByArticlePublishedDateRaw">
        <td>Sort By Article Published Date</td>
        <td>
            <asp:CheckBox ID="chkSortByPublishedDate" runat="server" />
            <asp:HiddenField ID="hdnSortByPublishedDate" runat="server" />
        </td>
    </tr>
    <tr>
        <td valign="top">
            <asp:Literal ID="ltlArticleType" runat="server" Text="Enabled Article Types"></asp:Literal>
        </td>
        <td>
            <div>
                <asp:TextBox ID="txtArticleTypeFilter" runat="server" Style="width: 154px" />
                <asp:Button ID="btnAddArticleType" runat="server" Text="Add" OnClick="btnAddArticleType_Click"
                    CausesValidation="false" CssClass="common_text_button" Width="40px" />
            </div>
            <div style="padding-top: 4px">
                <asp:ListBox ID="lstArticleType" runat="server" Width="210px" Height="70px"></asp:ListBox>
                <asp:HiddenField ID="hdnArticleType" runat="server" />
                &nbsp;
            
            <div class="common_form_row_div clearfix">
                <asp:Button ID="btnMoveUp" runat="server" OnClick="btnMoveUp_Click" Text="Move Up"
                    CssClass="common_text_button" CausesValidation="False" Width="60" />
                <asp:Button ID="btnMoveDown" runat="server" Text="Move Down" OnClick="btnMoveDown_Click"
                    CssClass="common_text_button" CausesValidation="False" Width="85" />
                <asp:Button ID="btnRemoveArticleType" Text="Remove" runat="server" OnClick="btnRemoveArticleType_Click"
                    CssClass="common_text_button" CausesValidation="False" Width="60" />
            </div>

            </div>

        </td>
    </tr>
    <tr>
        <td>
            Display Image
        </td>
        <td>
            <asp:DropDownList ID="imageSizeDropDown" runat="server"></asp:DropDownList>
            <asp:HiddenField ID="imageSizeHidden" runat="server" />
        </td>
    </tr>
	<tr>
		<td>
			Display Synopsis
		</td>
		<td>
			<asp:CheckBox ID="chkDisplaySyposis" runat="server" AutoPostBack="true" OnCheckedChanged="chkDisplaySyposis_checkedChange"/>
            <asp:HiddenField ID="hdnDisplaySyposis" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Synopsis Length
		</td>
		<td>
			<asp:TextBox ID="txtSynopsisLength" runat="server"></asp:TextBox>
            <asp:HiddenField ID="hdnSynopsisLength" runat="server" />
		    <asp:CompareValidator ID="cpvtxtSynopsisLength" runat="server" ErrorMessage="Numbers only" ControlToValidate="txtSynopsisLength"
		                          Type="Integer" Operator="DataTypeCheck"></asp:CompareValidator>
		</td>
	</tr>
    
    <tr>
        <td>
            Show Readmore Link
        </td>
        <td>
            <asp:CheckBox ID="chkShowReadmoreLink" runat="server" AutoPostBack="true" OnCheckedChanged="chkShowReadmoreLink_checkedChange"/>
            <asp:HiddenField ID="hdnShowReadmoreLink" runat="server" />
        </td>
    </tr>

    <tr>
        <td>
            Readmore Text
        </td>
        <td>
            <asp:TextBox ID="txtReadmoreText" runat="server"></asp:TextBox>
            <asp:HiddenField ID="hdnReadmoreText" runat="server" />
        </td>
    </tr>
		<tr runat="server" id="Tr1">
        <td>Set Filter Menu Name To Search Header Link Text</td>
        <td>
            <asp:CheckBox ID="chkDefaultTitle" runat="server" />
            <asp:HiddenField ID="hdnDefaultTitle" runat="server" />
        </td>
    </tr>
  	<tr runat="server" id="Tr2">
        <td>Show Vendor For Products</td>
        <td>
            <asp:CheckBox ID="chkShowVendor" runat="server" />
            <asp:HiddenField ID="hdnShowVendor" runat="server" />
        </td>
    </tr>
	   <tr runat="server" id="displayItemContentType">
        <td>Display Item Content Type</td>
        <td>
            <asp:CheckBox ID="chkDisplayItemContentType" runat="server" AutoPostBack="true" OnCheckedChanged="chkDisplayItemContentType_click"/>
            <asp:HiddenField ID="hdnDisplayItemContentType" runat="server" />
        </td>
    </tr>
	  <tr>
        <td valign="top">
            <asp:Literal ID="ltlDisplayArticleTypeNames" runat="server" Text="Select Article Type Names To Be Displayed"></asp:Literal>
        </td>
        <td>
            <div>
                <asp:TextBox ID="txtDisplayArticleTypeNames" runat="server" Style="width: 154px" />
                <asp:Button ID="btnDisplayArticleTypeNames" runat="server" Text="Add" OnClick="btnAddDisplayArticleTypeNames_Click"
                    CausesValidation="false" CssClass="common_text_button" Width="40px" />
            </div>
            <div style="padding-top: 4px">
                <asp:ListBox ID="lstDisplayArticleTypeNames" runat="server" Width="210px" Height="70px"></asp:ListBox>
                <asp:HiddenField ID="hdnDisplayArticleTypeNames" runat="server" />
                &nbsp;
            </div>

        </td>
    </tr>
	  <tr>
        <td valign="top">
            <asp:Literal ID="ltlDisplayArticleSections" runat="server" Text="Article Sections To Be Displayed"></asp:Literal>
        </td>
        <td>
            <div>
                <asp:TextBox ID="txtDisplayArticleSections" runat="server" Style="width: 154px" />
                <asp:Button ID="btnAddDisplayArticleSections" runat="server" Text="Add" OnClick="btnAddArticleSections_Click"
                    CausesValidation="false" CssClass="common_text_button" Width="40px" />
            </div>
            <div style="padding-top: 4px">
                <asp:ListBox ID="lstDisplayArticleSections" runat="server" Width="210px" Height="70px"></asp:ListBox>
                <asp:HiddenField ID="hdnDisplayArticleSections" runat="server" />
                &nbsp;
            <div class="common_form_row_div clearfix">
                <asp:Button ID="btnRemoveDisplayArticleSections" runat="server" Text="Remove" OnClick="btnRemoveSortParameter_Click"
                        CausesValidation="false" CssClass="common_text_button" Width="60px" />
            </div>
            </div>

        </td>
    </tr>
    <tr runat="server" id="trReivew">
        <td>Show Review Ratings</td>
        <td>
            <asp:CheckBox ID="chkShowReviewRatings" runat="server" AutoPostBack="true" OnCheckedChanged="chkShowReviewRating_click"/>
            <asp:HiddenField ID="hdnShowReviewRatings" runat="server" />
        </td>
    </tr>
    <tr runat="server" id="trRatingName">
        <td>
            Rating Custom Property Name
        </td>
        <td>
            <asp:TextBox ID="txtRatingPropertyName" runat="server"></asp:TextBox>
            <asp:HiddenField ID="hdnRatingPropertyName" runat="server" />
        </td>
    </tr>
</table>
