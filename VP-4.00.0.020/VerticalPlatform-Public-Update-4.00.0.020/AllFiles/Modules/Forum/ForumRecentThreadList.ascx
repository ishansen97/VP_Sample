<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ForumRecentThreadList.ascx.cs"
	Inherits="VerticalPlatformWeb.Modules.Forum.ForumRecentThreadList" %>
<%@ Register Src="~/Controls/Pager.ascx" TagName="Pager" TagPrefix="uc1" %>
<div class="forumThread">
	<div id="newPostButtonDiv">
		<asp:HyperLink ID="lnkNewPost" runat="server" CssClass="button newPost">New Post</asp:HyperLink>
	</div>
	<div class="pageTitle">
		<asp:Literal runat="server" ID="ltlPagingDescription"></asp:Literal>
	</div>
	<uc1:Pager ID="PagerPostListTop" runat="server" />
	<asp:Repeater ID="rptrForumThread" runat="server" OnItemDataBound="rptrForumThread_ItemDataBound">
		<HeaderTemplate>
			<div class="forumThreadRowHeader">
				<div class="forumThreadTitleHeader">
					<asp:HyperLink runat="server" ID="hlnkTitle" Text="Discussions"></asp:HyperLink>
				</div>
				<div class="forumThreadPostsHeader">
					<asp:HyperLink runat="server" ID="hlnkPosts" Text="Posts"></asp:HyperLink>
				</div>
				<div class="forumThreadOwnerHeader">
					<asp:HyperLink runat="server" ID="hlnkOwner" Text="Author"></asp:HyperLink>
				</div>
				<div class="forumThreadTimeStampHeader">
					<asp:HyperLink runat="server" ID="hlnkDate" Text="Latest Post Date"></asp:HyperLink>
				</div>
			</div>
		</HeaderTemplate>
		<ItemTemplate>
			<div class="forumThreadRow">
			<div class="forumThreadTitle">
				<span>
					<asp:HyperLink ID="lnkTitle" runat="server" CssClass="ForumThreadLink"></asp:HyperLink>
					<div>
						<asp:HyperLink ID="lnkTopic" runat="server" CssClass="ForumThreadTopicLInk"></asp:HyperLink>
					</div>
				</span>
			</div>
			<div class="forumThreadPosts" id="divNoOfPosts" runat="server">
			</div>
			<div class="forumThreadOwner" id="divOwner" runat="server">
			</div>
			<div class="forumThreadTimeStamp" id="divLastPost" runat="server">
				<span><asp:Literal id="ltlLastPostTimeStamp" runat="server"></asp:Literal></span>
				<span><asp:Literal id="ltlLastPostAuthor" runat="server"></asp:Literal></span>
			</div>
			</div>
		</ItemTemplate>
	</asp:Repeater>
	<uc1:Pager ID="PagerPostListBottom" runat="server" />
	<asp:HiddenField ID="hdnSortOrder" runat="server" />
</div>
