<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="VendorConsolidation.aspx.cs"
    Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Vendors.VendorConsolidation" MasterPageFile="~/MasterPage.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
    <script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>
    <script src="../../Js/JQuery/jquery.pager.js" type="text/javascript"></script>
    <script src="../../Js/ContentPicker.js" type="text/javascript"></script>
    <script language="javascript" type="text/javascript">
        $(document).ready(function () {
            var txtSourceVendor = { contentId: "txtSourceVendor" };
            var SourceVendor = { siteId: VP.SiteId, type: "Vendor", currentPage: "1", pageSize: "15", showName: "true", enabled: "true", bindings: txtSourceVendor };
            $("input[type=text][id*=txtSourceVendor]").contentPicker(SourceVendor);

            var txtTargetVendor = { contentId: "txtTargetVendor" };
            var TargetVendor = { siteId: VP.SiteId, type: "Vendor", currentPage: "1", pageSize: "15", showName: "true", enabled: "true", bindings: txtTargetVendor };
            $("input[type=text][id*=txtTargetVendor]").contentPicker(TargetVendor);
        });
    </script>
    <div class="AdminPanelHeader">
        <h3>
            Vendor Consolidation</h3>
    </div>
    <div class="AdminPanelContent min-height-content">
        <div class="inline-form-content">
            <span class="title">Source Vendor</span>
            <div class="input-append relative-content">
                <span class="inner"><em><asp:Literal ID="ltlSourceVendorType" runat="server"></asp:Literal><asp:Literal ID="ltlSourceVendor" runat="server"></asp:Literal></em></span>
                <asp:TextBox ID="txtSourceVendor" CssClass="txtSourceVendor" runat="server" AutoPostBack="True"
                    OnTextChanged="txtSourceVendor_TextChanged"></asp:TextBox><asp:HiddenField ID="hdnSourceVendor"
                        runat="server" /><asp:Button ID="btnAddAsChild" runat="server" Text="Add As A Child" CssClass="btn"
                    OnClick="btnAddAsChild_Click" /><asp:Button ID="btnMove" runat="server" Text="Move to Target Vendor"
                        CssClass="btn" OnClick="btnMove_Click" /><asp:Button ID="btnReset" runat="server"
                            Text="Reset" CssClass="btn" OnClick="btnReset_Click" />
                
            </div>
            <span class="title right">Target Vendor
               
            </span>
            <span class="relative-content"><asp:TextBox ID="txtTargetVendor" CssClass="txtTargetVendor" runat="server" AutoPostBack="True"
                OnTextChanged="txtTargetVendor_TextChanged"></asp:TextBox>
            <asp:HiddenField ID="hdnTargetVendor" runat="server" />
            <span class="inner"><em><asp:Literal ID="ltlTargetVendorType" runat="server"></asp:Literal><asp:Literal ID="ltlTargetVendor" runat="server"></asp:Literal></em></span> 
            </span>
        </div>
        
    </div>
</asp:Content>
