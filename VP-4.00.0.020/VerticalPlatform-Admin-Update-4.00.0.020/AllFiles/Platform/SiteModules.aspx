<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="SiteModules.aspx.cs" Inherits="VerticalPlatformAdminWeb.Platform.SiteModules"
	Title="Untitled Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>
				<asp:Label ID="lblHeader" runat="server" BackColor="Transparent">Site Modules</asp:Label></h3>
		</div>
		<div class="AdminPanelContent">
		<asp:HyperLink ID="lnkAddModule" runat="server" CssClass="aDialog common_text_button">Add module for all pages</asp:HyperLink>
		<br />
		<br />
			<asp:GridView ID="gvModule" runat="server" AutoGenerateColumns="false" OnRowCommand="gvModule_RowCommand"
				OnRowDataBound="gvModule_RowDataBound" CssClass="common_data_grid">
				<Columns>
					<asp:BoundField DataField="Id" HeaderText="ID" ItemStyle-Width="50" />
					<asp:TemplateField HeaderText="Module" ItemStyle-Width="150">
						<ItemTemplate>
							<asp:Label ID="lblModuleName" runat="server"></asp:Label>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:BoundField DataField="Pane" HeaderText="Pane" ItemStyle-Width="100" />
					<asp:BoundField DataField="SortOrder" HeaderText="Sort Order" ItemStyle-Width="100" />
					<asp:CheckBoxField DataField="Enabled" HeaderText="Enabled" ItemStyle-Width="75" />
					<asp:TemplateField ItemStyle-Width="75">
						<ItemTemplate>
						    <asp:HyperLink ID="lnkEditModule" runat="server" CssClass="aDialog">Edit</asp:HyperLink>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField ItemStyle-Width="75">
						<ItemTemplate>
							<asp:LinkButton ID="lbtnDeleteModule" runat="server" CommandName="DeleteModuleInstance">Delete</asp:LinkButton>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField ItemStyle-Width="75">
						<ItemTemplate>
							<asp:HyperLink ID="lnkSettings" runat="server" CssClass="aDialog">Settings</asp:HyperLink>
						</ItemTemplate>
					</asp:TemplateField>
				</Columns>
				<EmptyDataTemplate>
					No modules found which appear in all pages.
				</EmptyDataTemplate>
			</asp:GridView>
			
		</div>
	</div>
</asp:Content>
