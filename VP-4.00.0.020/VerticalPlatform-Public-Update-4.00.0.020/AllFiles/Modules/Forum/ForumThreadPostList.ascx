<%@ Control Language="C#" AutoEventWireup="true" EnableViewState="true" CodeBehind="ForumThreadPostList.ascx.cs"
	Inherits="VerticalPlatformWeb.Modules.Forum.ForumThreadPostList" %>
<%@ Register Src="~/Controls/Pager.ascx" TagName="Pager" TagPrefix="uc1" %>
	
	<div class="forumThreadPostListOuter">
			<div class="topForumButtons">
				<asp:HyperLink ID="lnkTopicsPage" runat="server" CssClass="button topicsPage">Topics</asp:HyperLink>
				<asp:HyperLink ID="lnkThreadsPage" runat="server" CssClass="button threadsPage">Threads</asp:HyperLink>
				<asp:HyperLink ID="lnkNewPost" runat="server" CssClass="button newPost">New Post</asp:HyperLink>
			</div>
			<h2>Discussion</h2>
			<div class="forumThreadPostList">
				<uc1:Pager ID="PagerPostListTop" runat="server" />
				<asp:Repeater ID="rptrForumThreadPost" runat="server" OnItemDataBound="rptrForumThreadPost_ItemDataBound">
					<ItemTemplate>
						<div class="threadPost">
							<div class="postContent">
								<div class="userInfo">
									<div class="userName" id="divUserName" runat="server">
										<asp:HyperLink ID="lnkUserName" runat="server" CssClass="viewProfile"></asp:HyperLink>
									</div>
									<div class="nickname" id="divNickname" runat="server">
									</div>
									<div class="noOfPosts" id="divNoOfPosts" runat="server">
									</div>
									<div class="registeredDate" id="divRegisteredDate" runat="server">
									</div>
									<asp:HyperLink ID="lnkViewProfile" runat="server" CssClass="viewProfile">View Profile</asp:HyperLink>
								</div>
								
								<div class="postInfo">
									<div class="subject" id="divSubject" runat="server">
									</div>
									 <div class="timeStamp" id="divTimeStamp" runat="server">
									</div>
									<div class="post" id="divPost" runat="server">
									</div>   
									<div class="postActions">
										<asp:HyperLink ID="lnkReportAbuse" runat="server" NavigateUrl="#" CssClass="reportAbuseLink">Report abuse or spam</asp:HyperLink>
										<asp:HyperLink ID="lnkDetail" runat="server" CssClass="detail">Detail</asp:HyperLink>
										<span class="postId" id="spnPostId" runat="server"></span>
										<asp:HyperLink ID="lnkReply" runat="server" CssClass="reply">Reply</asp:HyperLink>
										<asp:HyperLink ID="lnkQuote" runat="server" CssClass="quote">Quote</asp:HyperLink>
									</div>
								</div>
							</div>
						</div>
					</ItemTemplate>
				</asp:Repeater>
				<br />
				<uc1:Pager ID="PagerPostListBottom" runat="server" />
				<asp:Literal ID="noForumThreadPost" runat="server" Text="There are no posts for this topic."></asp:Literal>
			 </div>
			 <div class="bottomForumButtons">
				<asp:HyperLink ID="lnkNewPost1" runat="server" CssClass="button newPost">New Post</asp:HyperLink>
				<asp:HyperLink ID="lnkThreadsPage1" runat="server" CssClass="button threadsPage">Threads</asp:HyperLink>
				<asp:HyperLink ID="lnkTopicsPage1" runat="server" CssClass="button topicsPage">Topics</asp:HyperLink>
			</div>
		</div>
