<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ArchivedArticleList.ascx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Articles.ArchivedArticleList" %>

<%@ Register TagPrefix="ajaxToolkit" Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" %>
<%@ Register Src="../Pager.ascx" TagName="Pager" TagPrefix="uc1" %>
<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>
<script type="text/javascript">

    RegisterNamespace("VP.Article");
    $(document).ready(function () {
        $(".article_srh_btn").click(function () {
            $(".article_srh_pane").toggle("slow");
            $(this).toggleClass("hide_icon");
            $("#divSearchCriteria").toggleClass("hide");
        });

        $("#divSearchCriteria").append(VP.Article.GetSearchCriteriaText());

    });

    VP.Article.GetSearchCriteriaText = function () {
        var ddlType = $("select[id$='ddlArticleType']");
        var txtTitle = $("input[id$='txtArticleTitle']");
        var txtArticleId = $("input[id$='txtArticleId']");
        var txtAuthor = $("input[id$='txtArticleAuthor']");

        var searchHtml = "";
        if (ddlType.val() != "-1") {
            searchHtml += " ; <b>Type</b> : " + $("option[selected]", ddlType).text();
        }
        if (txtTitle.val().trim().length > 0) {
            searchHtml += " ; <b>Title</b> : " + txtTitle.val().trim();
        }
        if (txtArticleId.val().trim().length > 0) {
            searchHtml += " ; <b>Article Id</b> : " + txtArticleId.val().trim();
        }
        if (txtAuthor.val().trim().length > 0) {
            searchHtml += " ; <b>Author</b> : " + txtAuthor.val().trim();
        }
        searchHtml = searchHtml.replace(' ;', '(');
        if (searchHtml != "") {
            searchHtml += " )";
        }
        return searchHtml;
    };
</script>
<div class="AdminPanelContent">
    <div class="article_srh_btn hide_icon">
        Filter
    </div>
    <div id="divSearchCriteria">
    </div>
    <br />
    <div id="divSearchPane" class="article_srh_pane" style="display: block;">
        <div class="form-horizontal">
            <div class="control-group">
                <label class="control-label">
                    Article Type</label>
                <div class="controls">
                    <asp:DropDownList ID="ddlArticleType" runat="server" AppendDataBoundItems="true">
                        <asp:ListItem Text="All" Value="-1"></asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">
                    Title</label>
                <div class="controls">
                    <asp:TextBox ID="txtArticleTitle" runat="server" Width="385" ValidationGroup="FilterList"></asp:TextBox>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">
                    Article ID</label>
                <div class="controls">
                    <asp:TextBox ID="txtArticleId" runat="server" Width="150px" ValidationGroup="FilterList"></asp:TextBox>
                    <asp:CompareValidator ID="cvArticleId" runat="server" ControlToValidate="txtArticleId"
                        ValidationGroup="FilterList" ErrorMessage="Please enter a number for article id."
                        Type="Integer" Operator="DataTypeCheck">*</asp:CompareValidator>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">
                    Author</label>
                <div class="controls">
                    <asp:TextBox ID="txtArticleAuthor" runat="server" Width="385" ValidationGroup="FilterList"></asp:TextBox>
                </div>
            </div>
            <div class="form-actions">
                <asp:Button ID="btnArchivedfilter" runat="server" Text="Filter" ValidationGroup="FilterList"
                    OnClick="Filter_Click" CssClass="btn" />
                <asp:Button ID="btnReset" runat="server" Text="Reset" OnClick="Reset_Click" CssClass="btn" />
            </div>
        </div>
    </div>
    <br />
    <asp:GridView ID="gvArticles" runat="server" DataKeyNames="Id" AutoGenerateColumns="False"
        OnDataBound="Articles_DataBound" AllowPaging="True" OnRowDataBound="Articles_RowDataBound"
        CssClass="common_data_grid table table-bordered" Style="width: 100%">
        <AlternatingRowStyle CssClass="DataTableRowAlternate" />
        <RowStyle CssClass="DataTableRow" />
        <Columns>
            <asp:BoundField DataField="ArticleId" HeaderText="ID" ItemStyle-Width="30px" />
            <asp:BoundField DataField="articleTypeId" HeaderText="Type" ItemStyle-Width="100px" />
            <asp:BoundField HeaderText="Title" DataField="Title" ItemStyle-Width="230px" />
            <asp:BoundField HeaderText="Authors" DataField="Authors" ItemStyle-Width="200px" />
            <asp:TemplateField HeaderText="Restore" ItemStyle-Width="5px">
                <ItemTemplate>
                    <asp:ImageButton ID="ibtnArticleRestore" runat="server" OnClick="ArticleRestore_Click"
                        CssClass="enable_disable_button" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    <uc1:Pager ID="pagerArticleList" runat="server" OnPageIndexClickEvent="ArticleList_PageIndexClick" />
</div>
