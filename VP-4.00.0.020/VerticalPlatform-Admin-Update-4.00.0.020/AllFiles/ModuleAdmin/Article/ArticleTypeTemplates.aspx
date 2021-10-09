<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="ArticleTypeTemplates.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Articles.ArticleTypeTemplates" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3 runat="server" id="hdrArticleList">
				Article Type Template List</h3>
		</div>
		<div class="add-button-container">
			<asp:HyperLink ID="addArticleTypeTemplate" runat="server" Text="Add Article Type Template" CssClass="aDialog btn"></asp:HyperLink>
		</div>
		<div class="AdminPanelContent">
			<asp:GridView ID="articleTypeTemplateList" runat="server" AutoGenerateColumns="false"
				OnRowDataBound="articleTypeTemplateList_RowDataBound" CssClass="common_data_grid table table-bordered">
				<RowStyle CssClass="DataTableRow" />
				<AlternatingRowStyle CssClass="DataTableRowAlternate" />
				<Columns>
					<asp:BoundField HeaderText="ID" DataField="Id" ItemStyle-Width="50" />
					<asp:TemplateField HeaderText="Article Type" ItemStyle-Width="200px" >
						<ItemTemplate>
							<asp:Label ID="articleTypeName" runat="server"></asp:Label>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField ItemStyle-Width="200px" HeaderText="Template Name">
						<ItemTemplate>
							<asp:Label ID="templateName" runat="server"></asp:Label>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField ItemStyle-Width="200px" HeaderText="Page Name">
						<ItemTemplate>
							<asp:Label ID="pageName" runat="server"></asp:Label>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:BoundField HeaderText="Created" DataField="Created" DataFormatString="{0:d}"
						ItemStyle-Width="50" />
					<asp:BoundField HeaderText="Modified" DataField="Modified" DataFormatString="{0:d}"
						ItemStyle-Width="50" />
					<asp:CheckBoxField HeaderText="Enabled" DataField="Enabled" ItemStyle-Width="50" />
					<asp:TemplateField ItemStyle-Width="20px" >
						<ItemTemplate>
							<asp:HyperLink ID="editArticleTypeTemplate" runat="server" CssClass="aDialog grid_icon_link edit" ToolTip="Edit">Edit
								</asp:HyperLink>
						</ItemTemplate>
					</asp:TemplateField>
				</Columns>
			</asp:GridView>
		</div>
	</div>
</asp:Content>
