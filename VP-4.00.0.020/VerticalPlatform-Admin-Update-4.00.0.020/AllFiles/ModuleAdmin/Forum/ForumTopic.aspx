<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="ForumTopic.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Forum.ForumTopic"
	Title="Forum Topics" %>

<%@ Register TagPrefix="ajaxToolkit" Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" %>
<%@ Register Src="../Pager.ascx" TagName="Pager" TagPrefix="uc1" %>
<asp:Content ID="conContent" ContentPlaceHolderID="cphContent" runat="server">
	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>
				<asp:Label ID="lblHeader" runat="server" BackColor="Transparent">Forum Topics</asp:Label>
			</h3>
		</div>
		<div class="AdminPanelContent">
			<div class="add-button-container"><asp:HyperLink ID="lnkAddForumTopic" runat="server" CssClass="aDialog btn">Add Forum Topic</asp:HyperLink></div>
			<asp:HiddenField ID="hdnForumTopicId" runat="server" />
			<asp:GridView ID="gvForumTopic" runat="server" AutoGenerateColumns="false" OnRowCommand="gvForumTopic_RowCommand"
				OnRowDataBound="gvForumTopic_RowDataBound" CssClass="common_data_grid table table-bordered" Style="width: auto;">
				<Columns>
					<asp:BoundField HeaderText="ID" DataField="Id" ItemStyle-Width="75px" />
					<asp:HyperLinkField HeaderText="Title" DataTextField="Title" ItemStyle-Width="325px"
						DataNavigateUrlFormatString="ForumThread.aspx?ftid={0}" DataNavigateUrlFields="Id" />
					<asp:TemplateField HeaderText="Display Order">
						<ItemTemplate>
							<asp:Literal ID="ltlSortOrder" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "SortOrder") %>'>
							</asp:Literal>&nbsp&nbsp
							<asp:LinkButton runat="server" alt="Up" ID="lbtnMoveUp" CommandName="MoveUpButton"
								CssClass="moveUpBtn" ToolTip="Up" />
							<asp:LinkButton runat="server" alt="Down" ID="lbtnMoveDown" CommandName="MoveDownButton"
								CssClass="moveDownBtn" ToolTip="Down" />
						</ItemTemplate>
					</asp:TemplateField>
					<asp:CheckBoxField HeaderText="Enabled" DataField="Enabled" ItemStyle-Width="75px" />
					<asp:TemplateField ShowHeader="False" ItemStyle-Width="50px">
						<ItemTemplate>
							<asp:HyperLink ID="lnkEditTopic" runat="server" CssClass="aDialog grid_icon_link edit"
								ToolTip="Edit">Edit</asp:HyperLink>
							<asp:LinkButton ID="lbtnDelete" runat="server" CommandName="DeleteTopic" CssClass="grid_icon_link delete"
								ToolTip="Delete">Delete</asp:LinkButton>
						</ItemTemplate>
					</asp:TemplateField>
				</Columns>
				<EmptyDataTemplate>
					No Forum Topics found.
				</EmptyDataTemplate>
			</asp:GridView>
		</div>
		<br />
		<uc1:Pager ID="pgForum" runat="server" OnPageIndexClickEvent="pgForum_PageIndexClick" />
		<br />
	</div>
</asp:Content>
