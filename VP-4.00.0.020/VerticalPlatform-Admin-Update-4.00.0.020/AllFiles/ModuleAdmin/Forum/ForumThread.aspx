<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="ForumThread.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Forum.ForumThread"
	Title="Threads" %>

<%@ Register TagPrefix="ajaxToolkit" Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" %>
<%@ Register Src="../Pager.ascx" TagName="Pager" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>

	<script type="text/javascript">
		$(document).ready(function() {
			$(".author_srh_btn").click(function() {
				$(".author_srh_pane").toggle("slow");
				$(this).toggleClass("hide_icon");
			});
			$(".common_data_grid td table").removeAttr("width").width('100%');
		});
	</script>
	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>
				<asp:Label ID="lblHeader" runat="server" BackColor="Transparent">Threads</asp:Label>
			</h3>
		</div>
		<div class="AdminPanelContent">
		<div class="author_srh_btn">
				Filter</div>
			<br />
			<div id="divSearchPane" class="author_srh_pane" style="display: none;">
				<asp:DropDownList ID="ddlTopicList" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlTopicList_SelectedIndexChanged">
				</asp:DropDownList>
			</div>
			<br />
			<div class="add-button-container"><asp:HyperLink ID="lnkAddForumThread" runat="server" CssClass="aDialog btn">Add Forum Thread</asp:HyperLink></div>
			<asp:HiddenField ID="hdnForumThreadId" runat="server" />
			<asp:GridView ID="gvForumThread" runat="server" AutoGenerateColumns="false" OnRowCommand="gvForumThread_RowCommand"
				OnRowDataBound="gvForumThread_RowDataBound" CssClass="common_data_grid table table-bordered" style="width:auto">
				<Columns>
					<asp:BoundField HeaderText="ID" DataField="Id" ItemStyle-Width="75px" />
					<asp:HyperLinkField HeaderText="Title" DataTextField="Title" ItemStyle-Width="325px"
						DataNavigateUrlFormatString="ForumThreadPost.aspx?fthid={0}" DataNavigateUrlFields="Id" />
					<asp:TemplateField HeaderText="Owner" ItemStyle-Width="100px">
						<ItemTemplate>
							<asp:Label ID="lblUser" runat="server"></asp:Label>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField HeaderText="Nickname" ItemStyle-Width="100px">
						<ItemTemplate>
							<asp:Label ID="lblNickname" runat="server"></asp:Label>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:CheckBoxField HeaderText="Enabled" DataField="Enabled" ItemStyle-Width="75px" />
					<asp:TemplateField ShowHeader="False" ItemStyle-Width="50">
						<ItemTemplate>
							<asp:HyperLink ID="lnkEdit" runat="server" CssClass="aDialog grid_icon_link edit" ToolTip="Edit">Edit</asp:HyperLink>
							<asp:LinkButton ID="lbtnDelete" runat="server" CommandName="DeleteThread" CausesValidation="false" CssClass="grid_icon_link delete" ToolTip="Delete">Delete</asp:LinkButton>
							<ajaxToolkit:ConfirmButtonExtender ID="cbeDelete" runat="server" TargetControlID="lbtnDelete"
								ConfirmText="Are you sure to delete this thread and all posts?">
							</ajaxToolkit:ConfirmButtonExtender>
						</ItemTemplate>
					</asp:TemplateField>
				</Columns>
				<EmptyDataTemplate>
					No threads found
				</EmptyDataTemplate>
			</asp:GridView>
			<br />
			<br />
			<uc1:Pager ID="pgForum" runat="server" OnPageIndexClickEvent="pgForum_PageIndexClick"/>
			<br />
			
			<br />
			
			
		</div>
	</div>
</asp:Content>
