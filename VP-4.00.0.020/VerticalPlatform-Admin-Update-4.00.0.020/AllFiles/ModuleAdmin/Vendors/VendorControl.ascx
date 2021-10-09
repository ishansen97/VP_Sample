<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="VendorControl.ascx.cs"
    Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Vendors.VendorControl" %>
<script type="text/javascript">
    $(document).ready(function() {
        var fileInput = document.getElementById("<%=fuVendorImage.ClientID%>");
        var allowedExtension = ".jpg";
        console.log(fileInput);
        fileInput.addEventListener("change", function () {
            // Check that the file extension is supported.
            // If not, clear the input.
            var hasInvalidFiles = false;
            for (var i = 0; i < this.files.length; i++) {
                var file = this.files[i];

                if (!file.name.toLowerCase().endsWith(allowedExtension)) {
                    hasInvalidFiles = true;
                }
            }

            if (hasInvalidFiles) {
                fileInput.value = "";
                alert("Unsupported file selected.");
            }
        });
    });
</script>
<div class="form-horizontal">
    <div class="control-group">
        <label class="control-label">
            <asp:Label ID="lblVendorIdText" runat="server" Text="Vendor Id"></asp:Label></label>
        <div class="controls">
            <asp:Label ID="lblVendorId" runat="server" Width="250px"></asp:Label>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">
            Name</label>
        <div class="controls">
            <asp:TextBox ID="txtName" runat="server" MaxLength="100" Width="250px"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvVendorName" runat="server" ControlToValidate="txtName"
                ErrorMessage="Please enter name.">*</asp:RequiredFieldValidator>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">
            Internal Name</label>
        <div class="controls">
            <asp:TextBox ID="txtInternalName" runat="server" MaxLength="100" Width="250px"></asp:TextBox>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">
            Rank</label>
        <div class="controls">
            <asp:DropDownList ID="ddlRank" runat="server" Width="260px" AppendDataBoundItems="true">
            </asp:DropDownList>
            <asp:RequiredFieldValidator ID="rfvRank" runat="server" ErrorMessage="Please select a rank."
                ControlToValidate="ddlRank">*</asp:RequiredFieldValidator>
        </div>
    </div>
    <table cellpadding="0" cellspacing="0">
        <tr id="trNewVendor" runat="server">
            <td>
                <div class="control-group">
                    <label class="control-label">
                        Enabled</label>
                    <div class="controls">
                        <asp:CheckBox ID="chkEnabled" runat="server" />
                    </div>
                </div>
            </td>
        </tr>
    </table>
    <table cellpadding="0" cellspacing="0">
        <tr id="trExistingVendor" runat="server">
            <td>
                <div class="control-group">
                    <div class="controls">
                        <asp:HyperLink ID="lnkEnableDisableVendor" runat="server" CssClass="aDialog btn" />
                    </div>
                </div>
            </td>
        </tr>
    </table>
    <div class="control-group">
        <label class="control-label">
            Has Image
        </label>
        <div class="controls">
            <asp:CheckBox ID="chkHasImage" runat="server" />
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">
            Image
        </label>
        <div class="controls">
            <div class="vendorImg">
                <asp:Image ID="imgVendor" runat="server" Width="70px" />
            </div>
            <asp:FileUpload ID="fuVendorImage" runat="server"  accept=".jpg"/>
            <label class="checkbox" style="padding-left: 121px;">
                <asp:CheckBox ID="chkResizeImage" runat="server" />
                Create Standard Image Sizes</label>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">
            Keywords
        </label>
        <div class="controls">
            <asp:ListBox ID="lstKeywords" runat="server" Width="275px" Style="margin-bottom: 5px;"></asp:ListBox>
            <div class="inline-form-content">
                <div class="input-append">
                    <asp:TextBox ID="txtKeywords" runat="server" Width="130px" Style="float: left;"></asp:TextBox><asp:Button ID="btnAddKeyword" runat="server" Text="Add" CssClass="btn" OnClick="btnAddKeyword_Click" />
                </div>
                <asp:Button ID="btnRemoveKeyword" runat="server" Text="Remove" CssClass="btn" OnClick="btnRemoveKeyword_Click" />
                <input type="hidden" id="hdnKeywords" runat="server" />
                <input type="hidden" id="hdnRemovedKeywords" runat="server" />
            </div>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">
            Description
        </label>
        <div class="controls">
            <asp:TextBox ID="descriptionTextBox" runat="server" TextMode="MultiLine" Width="500px"
                Height="120px"></asp:TextBox>
        </div>
    </div>




</div>
