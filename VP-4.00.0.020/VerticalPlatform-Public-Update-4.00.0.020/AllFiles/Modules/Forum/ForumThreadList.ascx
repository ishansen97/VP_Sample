<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ForumThreadList.ascx.cs" Inherits="VerticalPlatformWeb.Modules.Forum.ForumThreadList" %>
<%@ Register Src="../../Controls/Pager.ascx" TagName="Pager" TagPrefix="uc1" %>

<div class="forumThreadList" id="forumThreadListDiv">
	<div class="sorting module" id="forumThreadListSortingDiv" runat="server">
		<h4>Sort</h4>
	</div>
	<div class="forumThreadList module">
		<asp:Label ID="lblMessage" runat="server" CssClass="errorMessage"></asp:Label>
		<asp:PlaceHolder ID="forumThreadListPlaceHolder" runat="server"></asp:PlaceHolder>
	</div>
	<uc1:Pager ID="forumThreadListPager" runat="server" Visible="False"/>
</div>
