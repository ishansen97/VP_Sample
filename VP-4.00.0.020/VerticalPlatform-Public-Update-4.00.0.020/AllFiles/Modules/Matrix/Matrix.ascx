<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Matrix.ascx.cs" Inherits="VerticalPlatformWeb.Modules.Matrix.Matrix" %>
<%@ Register Src="../../Controls/Tags.ascx" TagName="Tags" TagPrefix="uc1" %>
<%@ Register Src="../../Controls/Pager.ascx" TagName="Pager" TagPrefix="uc4" %>
<div class="matrixModule" id="divMatrixContent" runat="server">
	<div id="divSearchCategoryMessage" class="searchCategoryMessage" visible="false" runat="server">
			<asp:Literal ID="ltlSearchCategoryMessage" runat="server"></asp:Literal>
	</div>
	<div id="divVerticalMatrixModule" class="verticalMatrixModule module" runat="server">
		<div id="divToggleView" runat="server" visible="false">
			<asp:Literal ID="ltlToggleView" runat="server"></asp:Literal>
		</div>
		<div id="divSearchCategoryProductCountMessage" class="searchCategoryProductCountMessage" visible="false" runat="server">
			<asp:Literal ID="ltlSearchCategoryProductCountMessage" runat="server"></asp:Literal>
		</div>
		<div id="divSearchResultMessage" class="searchResultMessage" visible="false" runat="server">
		</div>
		<div id="divContentSearchMessage" class="contentSearchMessage" runat="server"></div>
		<div id="divContentSearchLink" class="contentSearchLink" runat="server"></div>

		<asp:Literal ID="ltlHeader" runat="server"></asp:Literal>
		<div class="actionHolder top module">
			<div class = "pageAndSort module">
				<uc4:Pager ID="pagerTop" runat="server" />
				<asp:Literal ID = "ltlSortSectionTop" runat="server"></asp:Literal>
			</div>
			<asp:PlaceHolder ID="phRequestInfoButton" runat="server"></asp:PlaceHolder>
			<div id="divFunctionPanelTop" class="functionPanel module" runat="server">
				<asp:Literal ID="ltlFunctionPanelTop" runat="server"></asp:Literal>
			</div>
		</div>
		<div class="productList" id="productList" runat="server">
			<asp:Literal ID="ltlProductList" runat="server"></asp:Literal>
		</div>
		<div class="actionHolder bottom module">
			<div id="divFunctionPanelBottom" class="functionPanel module" runat="server">
				<asp:Literal ID="ltlFunctionPanelBottom" runat="server"></asp:Literal>
			</div>
			<asp:Literal ID="ltlOtherVendors" runat="server"></asp:Literal>
			<div class = "pageAndSort module">
			<uc4:Pager ID="pagerBottom" runat="server" />
			</div>
			<uc1:Tags ID="tagCategory" runat="server" TagContentType="Category" />
		</div>
		<div id="divFeedbackLink" class = "feedbackLink" runat="server"></div>
		<asp:PlaceHolder ID="phCategoryArticle" runat="server"></asp:PlaceHolder>
	</div>
</div>
