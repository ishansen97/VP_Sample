<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="StickyHeaderSettings.ascx.cs" Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.StickyHeaderSettings" %>

<div class="form-horizontal">
    <div class="control-group">
        <label class="control-label">Content Type</label>
        <div class="controls">
            <asp:DropDownList ID="contentTypeList" runat="server"></asp:DropDownList>
            <asp:HiddenField ID="contentTypeHidden" runat="server" />
        </div>
         <label class="control-label">Back To Top Link Text</label>
        <div class="controls">
            <asp:TextBox ID="backToToLinkText" runat="server"></asp:TextBox>
            <asp:HiddenField ID="backToToLinkTextHiddenField" runat="server" />
        </div>

        <label class="control-label">Image Thumbnail Size</label>
        <div class="controls">
            <asp:DropDownList ID="thumbnailSizeDropdown" runat="server"></asp:DropDownList>
            <asp:HiddenField ID="thumbnailSizeHidden" runat="server" />
        </div>
        
        <label class="control-label">Enable Lead Form Popup</label>
        <div class="controls">
            <asp:CheckBox ID="enableLeadFormPopupChk" runat="server" />
            <asp:HiddenField ID="enableLeadFormPopupHdn" runat="server" />
        </div>
    </div>
</div>