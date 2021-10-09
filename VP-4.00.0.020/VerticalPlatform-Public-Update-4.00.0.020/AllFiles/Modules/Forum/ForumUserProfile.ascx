<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="true" CodeBehind="ForumUserProfile.ascx.cs"
	Inherits="VerticalPlatformWeb.Modules.Forum.ForumUserProfile" %>
<%@ Register Src="~/Controls/Pager.ascx" TagName="Pager" TagPrefix="uc1" %>
<div class="forumUserPostList module">
	<ul class="forumUser">
		<li class="forumUserProfileUserName">
			<span>User Name: </span>
			<asp:Literal ID="ltlUserName" runat="server"></asp:Literal>
		</li>
		<li class="forumUserProfileNickName">
			<span runat="server" id="spanNickname">Nick Name: </span>
			<asp:Literal ID="ltlNickName" runat="server" Visible="false"></asp:Literal>
		</li>
		<li class="forumUserProfilePosts">
			<span>Posts: </span>
			<asp:Literal ID="ltlPostCount" runat="server"></asp:Literal>
		</li>
		<li class="forumUserProfileJoined">
			<span>Joined:</span>
			<asp:Literal ID="ltlJoined" runat="server"></asp:Literal>
		</li>
	</ul>
	<uc1:Pager ID="PagerPostListTop" runat="server" />
	<asp:PlaceHolder ID="phPostList" runat="server"></asp:PlaceHolder>
	<uc1:Pager ID="PagerPostListBottom" runat="server" />
</div>
