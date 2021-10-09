<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CategoryInfo.aspx.cs" 
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Category.CategoryInfo"  MasterPageFile="~/MasterPage.Master"%>

<asp:Content ID="content" ContentPlaceHolderID="cphContent" runat="server">
<script type="text/javascript" language="javascript">
    $(document).ready(function () {
        $("div.menuHorizontal > ul.menu > li").each(function () {
            var ele = $(this);
            if (ele.text().trim().length == 0) {
                ele.hide();
            }

            $urlText = $("a", ele).text();
            $("a", ele).addClass($urlText);
        });



        $(".menuHorizontal .menu li a.active").parent().addClass("selected");
        $(".menuHorizontal .menu li a.Url").parent().removeClass("selected").addClass('urlParent');

       
    });
</script>
<div class="AdminPanelHeader">
		<h3><asp:Label ID="lblTitle" runat="server"></asp:Label></h3>
</div>
<div class="AdminPanelContent page-content-area">
    <div class="tabs-container">
	    <div class="menuHorizontal">
		    <ul id="ulMenu" class="menu" runat="server">
			    <li class="first">
				    <asp:LinkButton ID="lbtnCategory" runat="server" OnClick="lbtnTab_Click" CommandArgument="1">Category</asp:LinkButton>
			    </li>
			    <li>
				    <asp:LinkButton ID="lbtnFixedUrl" runat="server" OnClick="lbtnTab_Click" CommandArgument="2">Fixed Url</asp:LinkButton>
			    </li>
			    <li>
				    <asp:LinkButton ID="lbtnMetadata" runat="server" OnClick="lbtnTab_Click" CommandArgument="3">Metadata</asp:LinkButton>
			    </li>
			    <li>
				    <asp:LinkButton ID="lbtnSpecification" runat="server" OnClick="lbtnTab_Click" CommandArgument="4">Specifications</asp:LinkButton>
			    </li>
			    <li>
				    <asp:LinkButton ID="lbtnParameter" runat="server" OnClick="lbtnTab_Click" CommandArgument="5">Parameters</asp:LinkButton>
			    </li>
			    <li>
				    <asp:LinkButton ID="lbtnAssociation" runat="server" OnClick="lbtnTab_Click" CommandArgument="6">Associations</asp:LinkButton>
			    </li>
				<li>
				    <asp:LinkButton ID="searchOptionsButton" runat="server" OnClick="lbtnTab_Click" CommandArgument="14" Visible="false">Search Options</asp:LinkButton>
			    </li>
			    <li>
				    <asp:LinkButton ID="lbtnSearchGroup" runat="server" OnClick="lbtnTab_Click" CommandArgument="7">Search Groups</asp:LinkButton>
			    </li>
			    <li>
				    <asp:LinkButton ID="lbtnSearchAspect" runat="server" OnClick="lbtnTab_Click" CommandArgument="8">Search Aspects</asp:LinkButton>
			    </li>
			    <li>
				    <asp:LinkButton ID="lbtnGuidedBrowse" runat="server" OnClick="lbtnTab_Click" CommandArgument="9">Guided Browse</asp:LinkButton>
			    </li>
				 <li>
				    <asp:LinkButton ID="lbtnFixedGuidedBrowse" runat="server" OnClick="lbtnTab_Click" CommandArgument="12">Fixed Guided Browse</asp:LinkButton>
			    </li>
				<li>
				    <asp:LinkButton ID="lbtnProductCompletenessFactor" runat="server" OnClick="lbtnTab_Click" CommandArgument="13">Product Completeness Factors</asp:LinkButton>
			    </li>
			    <li>
				    <asp:LinkButton ID="lbtnUrl" runat="server" OnClick="lbtnTab_Click" CommandArgument="11">Url</asp:LinkButton>
			    </li>
			    <li class="last">
				    <asp:LinkButton ID="lbtnCategoryRelationship" runat="server" OnClick="lbtnTab_Click" CommandArgument="10">Category Relationship</asp:LinkButton>
			    </li>
		    </ul>
	    </div>
    </div>
	<div class="menu_tab_contents">
	<asp:PlaceHolder ID="phCategory" runat="server"></asp:PlaceHolder>
	</div>
	<div>
		<asp:Button ID="btnSave" runat="server" Text="Save" Width="70px" CssClass="btn"  OnClick="btnSave_Click" />
		&nbsp
		<asp:Button ID="btnClose" runat="server" Text="Close" Width="70px" CssClass="btn" OnClick="btnClose_Click" CausesValidation="false" />
	</div>
</div>
</asp:Content>
