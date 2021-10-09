<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="ContentToContentManagement.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Content.ContentToContentManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">

	<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>

	<script src="../../Js/JQuery/jquery.pager.js" type="text/javascript"></script>

	<script src="../../Js/ContentPicker.js" type="text/javascript"></script>

	<script type="text/javascript" language="javascript">
		RegisterNamespace("VP.ContentToContentManagement");
	</script>
	
	<script type="text/javascript">
		$(document).ready(function() {
			var element = $("#<%=ddlContentType.ClientID %>");
			var options = { siteId: VP.SiteId, currentPage: "1", pageSize: "10", getFixUrl: "false", externalType: "true", typeElement: element };
			$("input[type=text][id*=txtContentId]").contentPicker(options);
			element = $("#<%=ddlAssociatedContentType.ClientID %>");
			options = { siteId: VP.SiteId, currentPage: "1", pageSize: "10", getFixUrl: "false", externalType: "true", typeElement: element };
			if ($("#<%=ddlAssociatedContentType.ClientID %>").val() != "5")
			{
				options = { siteId: VP.SiteId, currentPage: "1", pageSize: "10", getFixUrl: "false", externalType: "true", typeElement: element, displaySites: true, siteElementId : "hdnAssociatedSiteId"};
			}

			$("input[type=text][id*=txtAssociatedContentId]").contentPicker(options);
		});
	</script>
	
<div class="form-horizontal">
    <div class="control-group">
        <label class="control-label">Content Type</label>
        <div class="controls">
            <asp:DropDownList ID="ddlContentType" runat="server" Width="155" 
					AutoPostBack="True" 
					onselectedindexchanged="ddlContentType_SelectedIndexChanged">
				</asp:DropDownList>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">Content Id</label>
        <div class="controls">
            <asp:TextBox ID="txtContentId" runat="server" Width="145"></asp:TextBox>
				<asp:RequiredFieldValidator ID="rfvContentId" runat="server" 
					ErrorMessage="Please enter 'Content Id'." ControlToValidate="txtContentId"
					Display="Dynamic">*</asp:RequiredFieldValidator>
				<asp:CompareValidator ID="cvContentId" runat="server" ErrorMessage="'Content Id' should be a numeric value."
					ControlToValidate="txtContentId" Type="Integer" Operator="DataTypeCheck" 
					Display="Dynamic">*</asp:CompareValidator>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">Associate Content Type</label>
        <div class="controls">
            <asp:DropDownList ID="ddlAssociatedContentType" runat="server" Width="155" 
					AutoPostBack="True" 
					onselectedindexchanged="ddlAssociatedContentType_SelectedIndexChanged">
				</asp:DropDownList>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">Associate Content Id</label>
        <div class="controls">
            <asp:TextBox ID="txtAssociatedContentId" runat="server" Width="145"></asp:TextBox>
				<asp:RequiredFieldValidator ID="rfvAssociatedContentId" runat="server" ErrorMessage="Please enter 'Associate Content Id'."
					ControlToValidate="txtAssociatedContentId" Display="Dynamic">*</asp:RequiredFieldValidator>
				<asp:CompareValidator ID="cvAssociatedContentId" runat="server" ErrorMessage="'Associate Content Id' should be a numeric value."
					ControlToValidate="txtAssociatedContentId" Type="Integer" Operator="DataTypeCheck" 
					Display="Dynamic">*</asp:CompareValidator>
				<asp:HiddenField ID="hdnAssociatedSiteId" runat="server" />
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">Sort Order</label>
        <div class="controls">
            <asp:TextBox ID="sortOrderInput" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator ID="sortOrderRequired" runat="server" ControlToValidate="sortOrderInput" ErrorMessage="Please a value for enter sort order.">*</asp:RequiredFieldValidator>
            <asp:CompareValidator ID="sortOrderNumberValidation" runat="server" ErrorMessage="Sort order should be a numeric value."
					ControlToValidate="sortOrderInput" Type="Integer" Operator="DataTypeCheck" Display="Dynamic">*</asp:CompareValidator>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">Enabled</label>
        <div class="controls">
            <asp:CheckBox ID="chkEnabled" runat="server" Checked="true" />
        </div>
    </div>
    <table cellpadding="0" cellspacing="0">
        <tr runat="server" id="trFeaturedSettings">
            <td>
                <div class="control-group">
                    <label class="control-label"><asp:Literal ID="ltrFeaturedSettings" runat="server">Featured Settings</asp:Literal></label>
                    <div class="controls">
                        <asp:CheckBoxList ID="chklFeaturedSettings" runat="server" RepeatDirection="Horizontal"
						CssClass="common_check_box">
						    <asp:ListItem Value="1">Featured – Level 1</asp:ListItem>
						    <asp:ListItem Value="2">Featured – Level 2</asp:ListItem>
						    <asp:ListItem Value="3">Featured – Level 3</asp:ListItem>
					    </asp:CheckBoxList>
                    </div>
                </div>
            </td>
        </tr>
        <tr runat="server" id="trAssociateVendor">
            <td>
                 <div class="control-group">
                    <label class="control-label">Associate Product Vendors</label>
                    <div class="controls">
                        <asp:CheckBox ID="chkAssociateVendors" runat="server" Checked="true" />
                    </div>
                </div>
            </td>
        </tr>
		<tr runat="server" id="trAssociateProductCategories">
            <td>
                 <div class="control-group">
                    <label class="control-label">Associate Product Categories</label>
                    <div class="controls">
                        <asp:CheckBox ID="chkProductCategories" runat="server" Checked="true" />
                    </div>
                </div>
            </td>
        </tr>
    </table>
    <div class="inline-form-container">
        <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" CssClass="btn" />
        <asp:Button ID="btnSaveAndAddSettings" runat="server" Text="Save and Add Settings" OnClick="btnSaveAndAddSettings_Click" CssClass="btn" />
        <asp:HyperLink ID="lnkReturnToList" runat="server" Text="Association List" CssClass="btn" ></asp:HyperLink>
    </div>
</div>

	
</asp:Content>
