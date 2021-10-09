<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="UpdateElasticSearchIndexTaskSetting.ascx.cs"
    Inherits="VerticalPlatformAdminWeb.Platform.Task.UpdateElasticSearchIndexTaskSetting" %>

<ul class="common_form_area">
    <li class="common_form_row clearfix">
        <span class="label_span" style="width: 250px;">
            <label>
                Batch Size</label></span> <span>
                    <asp:TextBox runat="server" ID="txtBatchSize" ToolTip="Batch Size" MaxLength="5"></asp:TextBox></span>
    </li>
    <li class="common_form_row clearfix">
        <span class="label_span" style="width: 250px;">
            <label>
                Server Node</label></span> <span>
                    <asp:TextBox runat="server" ID="txtNode" ToolTip="Elasticsearch server node" MaxLength="200"></asp:TextBox></span>
    </li>
    <li class="common_form_row clearfix">
        <span class="label_span" style="width: 250px;">
            <label>
                Retry Count</label></span> <span>
                    <asp:TextBox runat="server" ID="txtRetryCount" ToolTip="Retry Count" MaxLength="20"></asp:TextBox></span>
    </li>
    <li class="common_form_row clearfix">
        <span class="label_span" style="width: 250px;">
            <label>
                Thread Size</label></span> <span>
                    <asp:TextBox runat="server" ID="threadSize" ToolTip="Thread Size" MaxLength="20"></asp:TextBox></span>
    </li>
</ul>

