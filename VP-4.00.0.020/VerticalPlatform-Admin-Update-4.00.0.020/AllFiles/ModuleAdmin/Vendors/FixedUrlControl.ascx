<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="FixedUrlControl.ascx.cs"
    Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Vendors.FixedUrlControl" %>
<div class="inline-form-content">
    <span class="title">Fixed URL</span>
    <asp:TextBox ID="txtFixedUrl" runat="server" Width="250px"></asp:TextBox>
    <asp:RequiredFieldValidator ID="rfvFixedUrl" runat="server" ErrorMessage="Please enter fixed url."
        ControlToValidate="txtFixedUrl" Display="Dynamic">*</asp:RequiredFieldValidator>
    <asp:RegularExpressionValidator ID="revFixedUrl" runat="server" ErrorMessage="Url should start with '/', end with '/' and should only contain alpha numeric characters ,'-'. example '/id-vendor-name/'."
        ControlToValidate="txtFixedUrl" ValidationExpression="^((?:\/[a-zA-Z0-9]+(?:_[a-zA-Z0-9]+)*(?:\-[a-zA-Z0-9]+)*)+)/$"
        Display="Static">*</asp:RegularExpressionValidator>
</div>
