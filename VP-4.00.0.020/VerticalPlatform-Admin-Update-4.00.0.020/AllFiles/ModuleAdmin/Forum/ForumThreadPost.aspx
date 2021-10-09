<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="ForumThreadPost.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Forum.ForumThreadPost"
	Title="Posts" %>

<%@ Register TagPrefix="ajaxToolkit" Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" %>
<%@ Register Src="../Pager.ascx" TagName="Pager" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
	<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>
	<script src="../../Js/ForumThreadPost.js" type="text/javascript"></script>
	
	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>
				<asp:Label ID="lblHeader" runat="server" BackColor="Transparent">Posts</asp:Label>
			</h3>
		</div>
		
		<div class="AdminPanelContent">
			<div class="author_srh_btn">
				Filter</div>
			<br />
			<div id="divSearchPane" class="author_srh_pane" style="display: none;">
			<table cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td colspan="2">
						Topics&nbsp;&nbsp;
						<asp:DropDownList ID="ddlTopic" runat="server" AppendDataBoundItems="true">
							<asp:ListItem Text="All" Value="-1"></asp:ListItem>
						</asp:DropDownList>
					</td>
				</tr>
				<tr>
					<td colspan="2" style="height: 5px;">
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<div class="radio_button_group">
						</div>
						<asp:RadioButton ID="rdbThread" GroupName="Group" runat="server" Text="Thread" AutoPostBack="True"
							OnCheckedChanged="rdbThread_CheckedChanged" />&nbsp;&nbsp;
						<asp:RadioButton ID="rdbPost" GroupName="Group" runat="server" Text="Post" AutoPostBack="True"
							OnCheckedChanged="rdbPost_CheckedChanged" />
					</td>
				</tr>
				<tr>
					<td colspan="2" style="height: 5px;">
					</td>
				</tr>
				<tr>
					<td colspan="2" style="border: solid 1px #dddddd; padding: 10px;">
						<table style="width: 490px;">
							<tr>
								<td colspan="2">
									<asp:RadioButton ID="rdbMostRecent" GroupName="Option" runat="server" Text="Most Recent"
										AutoPostBack="True" OnCheckedChanged="rdbMostRecent_CheckedChanged" />
								</td>
							</tr>
							<tr>
								<td style="width: 110px;">
									<asp:RadioButton ID="rdbThreadId" GroupName="Option" runat="server" Text="Thread Id"
										AutoPostBack="True" OnCheckedChanged="rdbThreadId_CheckedChanged" />
								</td>
								<td>
									<asp:TextBox ID="txtThreadId" runat="server"></asp:TextBox>
									<ajaxToolkit:FilteredTextBoxExtender ID="fteThreadId" runat="server" FilterType="Numbers"
										TargetControlID="txtThreadId">
									</ajaxToolkit:FilteredTextBoxExtender>
								</td>
							</tr>
							<tr id="trPost" runat="server">
								<td>
									<asp:RadioButton ID="rdbPostId" GroupName="Option" runat="server" Text="Post Id"
										AutoPostBack="True" OnCheckedChanged="rdbPostId_CheckedChanged" />
								</td>
								<td>
									<asp:TextBox ID="txtPostId" runat="server"></asp:TextBox>
									<ajaxToolkit:FilteredTextBoxExtender ID="ftePostId" runat="server" FilterType="Numbers"
										TargetControlID="txtPostId">
									</ajaxToolkit:FilteredTextBoxExtender>
								</td>
							</tr>
							<tr>
								<td>
									<asp:RadioButton ID="rdbDateRange" GroupName="Option" runat="server" Text="Date Range"
										AutoPostBack="True" OnCheckedChanged="rdbDateRange_CheckedChanged" />
								</td>
								<td>
									<table border="0" width="100%" id="tblDateRange" runat="server">
										<tr>
											<td style="font-size: 11px;">
												From&nbsp;
											</td>
											<td>
												<asp:TextBox ID="txtFromDate" runat="server"></asp:TextBox>
											</td>
											<td style="font-size: 11px;">
												&nbsp;To&nbsp;
											</td>
											<td>
												<asp:TextBox ID="txtToDate" runat="server"></asp:TextBox>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td colspan="2" style="height: 5px;">
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<asp:Button ID="btnRetrieve" runat="server" Text="Retrieve" OnClick="btnRetrieve_Click"
							CssClass="btn" />
						<asp:HiddenField ID="hdnIsPostBack" runat="server" Value="false" />
					</td>
				</tr>
			</table>
			<br />
			</div>
			<br />
			<b>
				<asp:Label ID="lblResultHeader" runat="server"></asp:Label></b>
			<asp:GridView ID="gvForumThread" EnableViewState="false" runat="server" AutoGenerateColumns="false" OnRowDataBound="gvForumThread_RowDataBound"
				OnRowCommand="gvForumThread_RowCommand" CssClass="common_data_grid table table-bordered" Style="width: auto;">
				<Columns>
					<asp:BoundField HeaderText="ID" DataField="Id" ItemStyle-Width="75px" />
					<asp:TemplateField HeaderText="Title" ItemStyle-Width="300px">
						<ItemTemplate>
							<asp:HyperLink ID="lnkTitle" runat="server"></asp:HyperLink>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField HeaderText="Owner" ItemStyle-Width="100px">
						<ItemTemplate>
							<asp:Label ID="lblThreadUser" runat="server"></asp:Label>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField HeaderText="Nickname" ItemStyle-Width="100px">
						<ItemTemplate>
							<asp:Label ID="lblNickname" runat="server"></asp:Label>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField HeaderText="Created" ItemStyle-Width="100px">
						<ItemTemplate>
							<asp:Label ID="lblCreated" runat="server"></asp:Label>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:CheckBoxField HeaderText="Enabled" DataField="Enabled" ItemStyle-Width="75px" />
					<asp:TemplateField ShowHeader="false" ItemStyle-Width="100px">
						<ItemTemplate>
							<asp:HyperLink ID="lnkAddPost" runat="server" CssClass="aDialog grid_icon_add_post add" ToolTip="Add Post">Add Post</asp:HyperLink>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField ShowHeader="False">
						<ItemTemplate>
							<asp:HyperLink ID="lnkEditThread" runat="server" CssClass="aDialog grid_icon_link edit" ToolTip="Edit">Edit</asp:HyperLink>
							<asp:LinkButton ID="lbtnDeleteThread" runat="server" CommandName="DeleteThread" CausesValidation="false" CssClass="grid_icon_link delete" ToolTip="Delete">Delete</asp:LinkButton>
							<ajaxToolkit:ConfirmButtonExtender ID="cbeDeleteThread" runat="server" TargetControlID="lbtnDeleteThread"
								ConfirmText="Are you sure to delete this thread and all posts?">
							</ajaxToolkit:ConfirmButtonExtender>
						</ItemTemplate>
					</asp:TemplateField>
				</Columns>
				<EmptyDataTemplate>
					No threads found
				</EmptyDataTemplate>
			</asp:GridView>
			<asp:HiddenField ID="hdnThreadId" runat="server" />
			<br />
			<asp:Label ID="lblThreadName" runat="server"></asp:Label>
			<asp:GridView ID="gvForumThreadPost" EnableViewState="false" runat="server" AutoGenerateColumns="false" OnRowCommand="gvForumThreadPost_RowCommand"
				OnRowDataBound="gvForumThreadPost_RowDataBound" CssClass="common_data_grid table table-bordered" style="width:auto">
				<Columns>
					<asp:BoundField HeaderText="ID" DataField="Id" ItemStyle-Width="75px" />
					<asp:TemplateField HeaderText="User" ItemStyle-Width="100px">
						<ItemTemplate>
							<asp:Label ID="lblPostUser" runat="server"></asp:Label>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField HeaderText="Nickname" ItemStyle-Width="100px">
						<ItemTemplate>
							<asp:Label ID="lblPostNickname" runat="server"></asp:Label>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:BoundField HeaderText="Subject" DataField="Subject" ItemStyle-Width="250px" />
					<asp:TemplateField HeaderText="Created" ItemStyle-Width="100px">
						<ItemTemplate>
							<asp:Label ID="lblCreated" runat="server"></asp:Label>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:CheckBoxField HeaderText="Enabled" DataField="Enabled" ItemStyle-Width="75px" />
					<asp:TemplateField ShowHeader="False">
						<ItemTemplate>
							<asp:HyperLink ID="lnkEditPost" runat="server" CssClass="aDialog grid_icon_link edit" ToolTip="Edit">Edit</asp:HyperLink>
							<asp:LinkButton ID="lbtnDeletePost" runat="server" CommandName="DeletePost" CausesValidation="false" CssClass="grid_icon_link delete" ToolTip="Delete">Delete</asp:LinkButton>
							<ajaxToolkit:ConfirmButtonExtender ID="cbeDeletePost" runat="server" TargetControlID="lbtnDeletePost"
								ConfirmText="Are you sure to delete this post?">
							</ajaxToolkit:ConfirmButtonExtender>
						</ItemTemplate>
					</asp:TemplateField>
				</Columns>
				<EmptyDataTemplate>
					No posts found
				</EmptyDataTemplate>
			</asp:GridView>
			<asp:HiddenField ID="hdnPostId" runat="server" />
			<br />
			<uc1:Pager ID="pgForum" runat="server" OnPageIndexClickEvent="pgForum_PageIndexClick"/>
			<br />
			
		</div>
	</div>
</asp:Content>
