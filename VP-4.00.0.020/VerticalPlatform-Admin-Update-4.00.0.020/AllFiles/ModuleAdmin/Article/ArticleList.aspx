<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="ArticleList.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Articles.ArticleList" %>

<asp:Content ID="conContent" ContentPlaceHolderID="cphContent" runat="server">
	<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>
	
	<script src="../../Js/JQuery/jquery.pager.js" type="text/javascript"></script>

	<script src="../../Js/ContentPicker.js" type="text/javascript"></script>

	<script type="text/javascript">
		$(document).ready(function() {

			$(".menuHorizontal .menu li a.active").parent().addClass("selected");

			$("div.AdminPanelContent a.menuLink").click(function () {
				if (typeof (Page_ClientValidate) == 'function')
					var valid = Page_ClientValidate();
			});

			$("div.menuHorizontal > ul.menu > li").each(function () {
				var ele = $(this);
				if (ele.text().trim().length == 0) {
					ele.hide();
				}
			});

		});
	</script>
	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3 runat="server" id="hdrArticleList">
				Article List
			</h3>
		</div>
		<div class="AdminPanelContent page-content-area">
			<div class="tabs-container">
				<div class="menuHorizontal" id="divMenue" runat="server">
					<ul class="menu">
						<li class="first">
							<asp:LinkButton ID="lbtnActiveArticles" runat="server" OnClick="lbtnTab_Click" CommandArgument="1">
							Active Articles</asp:LinkButton>
						</li>
						<li>
							<asp:LinkButton ID="lbtnArchivedArticles" runat="server" OnClick="lbtnTab_Click" CommandArgument="2">
							Archived Articles</asp:LinkButton>
						</li>
					</ul>
				</div>
			</div>
			<div class="menu_tab_contents">
				<asp:PlaceHolder ID="cphArticlesControl" runat="server"></asp:PlaceHolder>
			</div>
		</div>
	</div>
</asp:Content>
