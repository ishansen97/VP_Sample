<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ForumThread.ascx.cs"
	Inherits="VerticalPlatformWeb.Modules.Forum.ForumThread" %>
<%@ Register Src="~/Controls/Pager.ascx" TagName="Pager" TagPrefix="uc1" %>
<div class="forumThread">
	<div class="newThread">
		<asp:Literal ID="ltlTopicDescription" runat="server"></asp:Literal>
		<asp:HyperLink ID="lnkNewThread" runat="server" class="button">New Thread</asp:HyperLink>
	</div>
	<uc1:Pager ID="PagerPostListTop" runat="server" />
	<asp:Repeater ID="rptrForumThread" runat="server" 
		OnItemDataBound="rptrForumThread_ItemDataBound">
		<HeaderTemplate>
			<div class="forumThreadRowHeader">
				<div class="forumThreadTitleHeader">
					<%--Title--%>
					<asp:HyperLink runat="server" ID="hlnkTitle" Text="Title"></asp:HyperLink>
				</div>
				<div class="forumThreadPostsHeader">
					<%--Posts--%>
					<asp:HyperLink runat="server" ID="hlnkPosts" Text="Posts"></asp:HyperLink>
				</div>
				<div class="forumThreadOwnerHeader">
					<%--Owner--%>
					<asp:HyperLink runat="server" ID="hlnkOwner" Text="Author"></asp:HyperLink>
				</div>
				<div class="forumThreadTimeStampHeader">
					<%--Last Update Date--%>
					<asp:HyperLink runat="server" ID="hlnkDate" Text="Latest Post Date"></asp:HyperLink>
				</div>
			</div>
		</HeaderTemplate>
		<ItemTemplate>
			<div class="forumThreadRow">
				<div class="forumThreadTitle">
					<span><asp:HyperLink ID="lnkTitle" runat="server" CssClass="ForumThreadLink"></asp:HyperLink></span></div>
				<div class="forumThreadPosts" id="divNoOfPosts" runat="server">
				</div>
				<div class="forumThreadOwner" id="divOwner" runat="server">
				</div>
				<div class="forumThreadTimeStamp" id="divLastPostTimeStamp" runat="server">
					<span><asp:Literal id="ltlLastPostTimeStamp" runat="server"></asp:Literal></span>
					<span><asp:Literal id="ltlLastPostAuthor" runat="server"></asp:Literal></span>
				</div>
			</div>
		</ItemTemplate>
	</asp:Repeater>
	<uc1:Pager ID="PagerPostListBottom" runat="server" />
	<asp:HiddenField ID="hdnSortOrder" runat="server" />
</div>
