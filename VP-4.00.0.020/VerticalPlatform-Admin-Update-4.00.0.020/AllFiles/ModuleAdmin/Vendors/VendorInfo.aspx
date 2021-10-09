<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="VendorInfo.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Vendors.VendorInfo"
	Title="Untitled Page" %>

<asp:Content ID="content" ContentPlaceHolderID="cphContent" runat="server">
<script type="text/javascript" language="javascript">
$(document).ready(function(){
	$(".menuHorizontal .menu li a.active").parent().addClass("selected");

	$("div.menuHorizontal > ul.menu > li").each(function () {
		var ele = $(this);
		if (ele.text().trim().length == 0) {
			ele.hide();
		}
	});

});


</script>
<div class="AdminPanelHeader">
		<h3>
			<asp:Label ID="lblHeader" runat="server" BackColor="Transparent"></asp:Label>
		</h3>
	</div>
<div class="AdminPanelContent page-content-area">
    <div class="tabs-container">
	    <div class="menuHorizontal">
		    <ul class="menu">
			    <li class="first">
				    <asp:LinkButton ID="lbtnVendor" runat="server" OnClick="lbtnTab_Click" CommandArgument="1">Vendor</asp:LinkButton>
			    </li>
			    <li>
				    <asp:LinkButton ID="lbtnFixedUrl" runat="server" OnClick="lbtnTab_Click" CommandArgument="2">Fixed Url</asp:LinkButton>
			    </li>
			    <li>
				    <asp:LinkButton ID="lbtnParameter" runat="server" OnClick="lbtnTab_Click" CommandArgument="3">Parameters</asp:LinkButton>
			    </li>
			    <li>
				    <asp:LinkButton ID="lbtnSpecification" runat="server" OnClick="lbtnTab_Click" CommandArgument="4">Specifications</asp:LinkButton>
			    </li>
			    <li>
				    <asp:LinkButton ID="lbtnContactDetail" runat="server" OnClick="lbtnTab_Click" CommandArgument="5">Contact Details</asp:LinkButton>
			    </li>
			    <li>
				    <asp:LinkButton ID="lbtnAssociation" runat="server" OnClick="lbtnTab_Click" CommandArgument="6">Associations</asp:LinkButton>
			    </li>
			    <li>
				    <asp:LinkButton ID="lbtnLocation" runat="server" OnClick="lbtnTab_Click" CommandArgument="8">Locations</asp:LinkButton>
			    </li>
			    <li>
				    <asp:LinkButton ID="lbtnCurrencies" runat="server" OnClick="lbtnTab_Click" CommandArgument="14">Currencies</asp:LinkButton>
			    </li>
			    <li>
				    <asp:LinkButton ID="lbtnOfficeSetup" runat="server" OnClick="lbtnTab_Click" CommandArgument="15">Office Setup</asp:LinkButton>
			    </li>
			    <li>
				    <asp:LinkButton ID="lbtnSettingsTemplate" runat="server" OnClick="lbtnTab_Click" CommandArgument="16">Vendor Settings Template</asp:LinkButton>
			    </li>
			    <li>
				    <asp:LinkButton ID="lbtnAssignAccounts" runat="server" OnClick="lbtnTab_Click" CommandArgument="13">Assign Accounts</asp:LinkButton>
			    </li>
			    <li>
				    <asp:LinkButton ID="lbtnProductSummary" runat="server" OnClick="lbtnTab_Click" CommandArgument="9">Product Summary</asp:LinkButton>
			    </li>
			    <li>
				    <asp:LinkButton ID="lbtnArticles" runat="server" OnClick="lbtnTab_Click" CommandArgument="11">Article Summary</asp:LinkButton>
			    </li>
			    <li>
				    <asp:LinkButton ID="lbtnLeadSummary" runat="server" OnClick="lbtnTab_Click" CommandArgument="12">Lead Summary</asp:LinkButton>
			    </li>
			    <li>
				    <asp:LinkButton ID="lbtnReports" runat="server" OnClick="lbtnTab_Click" CommandArgument="10">Campaign Summary</asp:LinkButton>
			    </li>
			    <li>
				    <asp:LinkButton ID="lbtnChildVendors" runat="server" OnClick="lbtnTab_Click" CommandArgument="7">Child Vendor Management</asp:LinkButton>
			    </li>
			    <li>
				    <asp:LinkButton ID="lbtnMetadata" runat="server" OnClick="lbtnTab_Click" CommandArgument="17">
				    Metadata</asp:LinkButton>
			    </li>
				<li>
					<asp:LinkButton ID="lbtnVendorProfileManagement" runat="server" OnClick="lbtnTab_Click" CommandArgument="18">
						Vendor Profile Management</asp:LinkButton>
				</li>
				<li class="last">
					<asp:LinkButton ID="lbtnVendorRuleFile" runat="server" OnClick="lbtnTab_Click" CommandArgument="19">
						Rule File</asp:LinkButton>
				</li>
		    </ul>
	    </div>
    </div>
	<div class="menu_tab_contents">
	<asp:PlaceHolder ID="phVendor" runat="server"></asp:PlaceHolder>
	</div>
	<div>
		<asp:Button ID="btnSave" runat="server" Text="Save" Width="150px" CssClass="btn"
			OnClick="btnSave_Click" />
		<asp:Button ID="btnClose" runat="server" Text="Close" Width="150px" CssClass="btn"
			OnClick="btnClose_Click" CausesValidation="false" />
	</div>
</div>
</asp:Content>
