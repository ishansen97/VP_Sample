<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="RecreateElasticSearchIndexTaskSetting.ascx.cs"
    Inherits="VerticalPlatformAdminWeb.Platform.Task.RecreateElasticSearchIndexTaskSetting" %>
<ul class="common_form_area">
    <li class="common_form_row clearfix"><span class="label_span" style="width: 160px;">
        <label>
            Batch Size</label></span> <span>
                <asp:TextBox runat="server" ID="txtBatchSize" ToolTip="Batch Size" MaxLength="5"></asp:TextBox></span>
    </li>
    <li class="common_form_row clearfix"><span class="label_span" style="width: 160px;">
        <label>
            Thread Size</label></span> <span>
                <asp:TextBox runat="server" ID="txtThreadSize" ToolTip="Thread Size" MaxLength="2"></asp:TextBox></span>
    </li>
    <li class="common_form_row clearfix"><span class="label_span" style="width: 160px;">
        <label>
            Server Node</label></span> <span>
                <asp:TextBox runat="server" ID="txtNode" ToolTip="Elasticsearch server node" MaxLength="200"></asp:TextBox></span>
    </li>
    <li class="common_form_row clearfix"><span class="label_span" style="width: 160px;">
        <label>
            Update Indexed Content Table</label></span> <span>
                <asp:CheckBox ID="chkUpdateIndexedContentTable" runat="server" /></span>
    </li>
    <li class="common_form_row clearfix">
        <span class="label_span" style="width: 160px;">
            <label>Disable legacy indexer</label>
        </span>
        <span>
            <asp:CheckBox ID="disableLegacyIndexerChkBox" runat="server" />
        </span>
    </li>
    <li class="common_form_row clearfix">
        <span class="label_span" style="width: 160px;">
            <label>Recreate Product Index</label>
        </span>
        <span>
            <asp:CheckBox ID="recreateProductIndex" runat="server" />
        </span>
    </li>
    <li class="common_form_row clearfix">
        <span class="label_span" style="width: 160px;">
            <label>Recreate Article Index</label>
        </span>
        <span>
            <asp:CheckBox ID="recreateArticleIndex" runat="server" />
        </span>
    </li>
    <li class="common_form_row clearfix"><span class="label_span" style="width: 160px;">
        <label>
            Recreate Vendor Index</label></span> <span>
                <asp:CheckBox ID="recreateVendorIndex" runat="server" /></span>
    </li>
    <li class="common_form_row clearfix"><span class="label_span" style="width: 160px;">
        <label>
            Recreate Forum Index</label></span>
        <asp:CheckBox ID="recreateForumIndex" runat="server" /></span>
    </li>
</ul>
