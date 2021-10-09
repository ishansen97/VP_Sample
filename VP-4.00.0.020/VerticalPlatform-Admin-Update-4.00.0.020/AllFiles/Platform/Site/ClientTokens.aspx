<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="ClientTokens.aspx.cs" Inherits="VerticalPlatformAdminWeb.Platform.Site.ClientTokens" %>

<%@ Register src="~/ModuleAdmin/Pager.ascx" tagname="Pager" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
	<div class="AdminPanelHeader">
		<h3>Client List</h3>
	</div>
	<div class="AdminPanelContent">
		<div class="add-button-container">
			<asp:HyperLink ID="addClientToken" runat="server" CssClass="aDialog btn">Add Client</asp:HyperLink>
		</div>
		<asp:GridView ID="clientList" runat="server" AutoGenerateColumns="False" 
				CssClass="common_data_grid table table-bordered" style="width:auto" 
				onrowcommand="clientList_RowCommand" onrowdatabound="clientList_RowDataBound">
			<Columns>
				<asp:TemplateField HeaderText="Name">
					<ItemTemplate>
						<asp:Literal ID="clientName" runat="server"></asp:Literal>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Email">
					<ItemTemplate>
						<asp:Literal ID="clientEmail" runat="server"></asp:Literal>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Token">
					<ItemTemplate>
						<asp:Literal ID="clientToken" runat="server"></asp:Literal>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Enabled">
					<ItemTemplate>
						<asp:CheckBox ID="clientEnabled" runat="server" Enabled="false" />
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Site Logo">
					<ItemTemplate>
						<asp:CheckBox ID="siteLogo" runat="server" Enabled="false" />
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField>
					<ItemTemplate>
						<asp:HyperLink ID="edit" runat="server" CssClass="grid_icon_link edit aDialog" ToolTip="Edit">Edit</asp:HyperLink>
						<asp:LinkButton ID="delete" runat="server" CommandName="DeleteToken" CssClass="grid_icon_link delete" ToolTip="Delete">Delete</asp:LinkButton>
					</ItemTemplate>
				</asp:TemplateField>
			</Columns>
			<EmptyDataTemplate>No Clients Avaliable.</EmptyDataTemplate>
		</asp:GridView>
		<uc1:pager ID="clientListPager" runat="server"/>
	</div>
</asp:Content>
