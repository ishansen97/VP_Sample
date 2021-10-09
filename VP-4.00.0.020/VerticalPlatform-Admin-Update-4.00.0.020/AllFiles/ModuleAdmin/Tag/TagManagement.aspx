<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="TagManagement.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Tag.TagManagement"
	Title="Untitled Page" %>

<%@ Register TagPrefix="ajaxToolkit" Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" %>
<asp:Content ID="conContent" ContentPlaceHolderID="cphContent" runat="server">

	<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>

	<script src="jquery.tagsearch.js" type="text/javascript"></script>

	<script type="text/javascript">
		$(document).ready(function() {
			$("input[type=text][id*=txtSearch]").tagSearch();
		});
	</script>

	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>
				<asp:Label ID="lblHeader" runat="server" BackColor="Transparent">Tags</asp:Label>
			</h3>
		</div>
		<div class="AdminPanelContent">
			<div class="inline-form-container">
			<span class="title">Search</span>
			<asp:TextBox ID="txtSearch" runat="server" Width="372px"></asp:TextBox>
			<asp:Button ID="btnTags" runat="server" Text="Retrieve Tags" OnClick="btnTags_Click"
				ValidationGroup="Retrieve" CssClass="btn" />
			</div>
			<br />
			<asp:GridView ID="gvTag" runat="server" AutoGenerateColumns="false" OnRowCommand="gvTag_RowCommand"
				OnRowDataBound="gvTag_RowDataBound" CssClass="common_data_grid table table-bordered">
				<Columns>
					<asp:BoundField HeaderText="ID" DataField="Id" ItemStyle-Width="50px" />
					<asp:BoundField HeaderText="Tag" DataField="TagName" ItemStyle-Width="200px" />
					<asp:TemplateField HeaderText="User" ItemStyle-Width="150px">
						<ItemTemplate>
							<asp:Label runat="server" ID="lblUser"></asp:Label></ItemTemplate>
					</asp:TemplateField>
					<asp:CheckBoxField HeaderText="Enabled" DataField="Enabled" ItemStyle-Width="75px" />
					<asp:TemplateField ItemStyle-Width="50px">
						<ItemTemplate>
							<asp:HyperLink ID="lnkEdit" runat="server" CssClass="aDialog grid_icon_link edit" ToolTip="Edit">Edit</asp:HyperLink>
							<asp:LinkButton ID="lbtnDelete" runat="server" CommandName="DeleteTag" CssClass="grid_icon_link delete" ToolTip="Delete">Delete</asp:LinkButton>
						</ItemTemplate>
					</asp:TemplateField>
				</Columns>
				<EmptyDataTemplate>
					No tags were found.
				</EmptyDataTemplate>
			</asp:GridView>
			<asp:HiddenField ID="hdnTagId" runat="server" />
			<asp:Label ID="lblMessage" runat="server"></asp:Label>
		</div>
	</div>
</asp:Content>
