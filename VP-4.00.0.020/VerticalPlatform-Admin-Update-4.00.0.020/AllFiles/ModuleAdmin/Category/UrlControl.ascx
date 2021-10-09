<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="UrlControl.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Category.UrlControl" %>

    <style type="text/css">
        .main-container .main-content .page-content-area .tabs-container .menuHorizontal ul.menu > li.urlParent a#ctl00_cphContent_lbtnUrl{background: #ffffff;font-weight: bold;}
    </style>

<div class="inline-form-container">
    <span class="title">Url</span>
    <asp:TextBox ID="txtUrl" runat="server" Width="300"></asp:TextBox>
    <label class="checkbox" style="padding-left:20px;width:230px;"><asp:CheckBox ID="chkOpeninNewWindow" runat="server"/> Open in New Window</label>
</div>
<em>Please enter full url when an external url is given (including http://)</em>
