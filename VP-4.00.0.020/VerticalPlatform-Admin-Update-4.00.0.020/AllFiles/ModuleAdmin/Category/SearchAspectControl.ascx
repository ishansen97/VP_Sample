<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SearchAspectControl.ascx.cs"
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Category.SearchAspectControl" %>
<h4>Search Aspects</h4>
<div class="add-button-container">
    <asp:HyperLink ID="lnkAddSearchAspect" runat="server" CssClass="aDialog btn">Add Search Aspect</asp:HyperLink>
</div>
<asp:GridView ID="gvSearchAspect" runat="server" AutoGenerateColumns="False" CssClass="common_data_grid table table-bordered"
	OnRowCommand="gvSearchAspect_RowCommand" OnRowDataBound="gvSearchAspect_RowDataBound">
	<Columns>
		<asp:TemplateField HeaderText="ID">
			<ItemTemplate>
				<asp:Label ID="lblId" runat="server"></asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Name">
			<ItemTemplate>
				<asp:Label ID="lblName" runat="server"></asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Prefix">
			<ItemTemplate>
				<asp:Label ID="lblPrefix" runat="server"></asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Suffix">
			<ItemTemplate>
				<asp:Label ID="lblSuffix" runat="server"></asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Contents">
			<ItemTemplate>
				<asp:Hyperlink ID="lnkContent" runat="server" CssClass="aDialog">Contents</asp:Hyperlink>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField>
			<ItemTemplate>
				<asp:Hyperlink ID="lnkEdit" runat="server" CssClass="aDialog grid_icon_link edit">Edit</asp:Hyperlink>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField>
			<ItemTemplate>
				<asp:LinkButton OnClientClick="return confirm('Are you sure you want to remove this search aspect?');"
					ID="lbtnRemove" runat="server" Text="Remove" CommandName="RemoveSearchAspect" CssClass="grid_icon_link delete"></asp:LinkButton>
			</ItemTemplate>
		</asp:TemplateField>
	</Columns>
	<EmptyDataTemplate>No search aspects were found.</EmptyDataTemplate>
</asp:GridView>



