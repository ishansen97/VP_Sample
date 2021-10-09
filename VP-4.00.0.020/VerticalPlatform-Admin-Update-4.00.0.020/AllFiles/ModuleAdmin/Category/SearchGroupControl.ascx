<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SearchGroupControl.ascx.cs"
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Category.SearchGroupControl" %>
<h4>Search Groups</h4>
<div class="add-button-container">
	<asp:HyperLink ID="lnkAddSearchGroup" runat="server" CssClass="aDialog btn">Add Search Group</asp:HyperLink>
</div>
<asp:GridView ID="gvSearchGroup" runat="server" AutoGenerateColumns="False" CssClass="common_data_grid table table-bordered"
	OnRowCommand="gvSearchGroup_RowCommand" OnRowDataBound="gvSearchGroup_RowDataBound">
	<Columns>
		<asp:TemplateField  HeaderText="ID">
			<ItemTemplate>
				<asp:Label ID="lblId" runat="server"></asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField  HeaderText="Group Name">
			<ItemTemplate>
				<asp:Label ID="lblName" runat="server"></asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField  HeaderText="Description">
			<ItemTemplate>
				<asp:Label ID="lblDescription" runat="server"></asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField  HeaderText="Display Name">
			<ItemTemplate>
				<asp:Label ID="displayNameLabel" runat="server"></asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField  HeaderText="Matrix Prefix">
			<ItemTemplate>
				<asp:Label ID="lblMatrixPrefix" runat="server"></asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField  HeaderText="Matrix Suffix">
			<ItemTemplate>
				<asp:Label ID="lblMatrixSuffix" runat="server"></asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField  HeaderText="Search Enabled">
			<ItemTemplate>
				<asp:CheckBox ID="chkSearchableValue" runat="server" Enabled="false"></asp:CheckBox>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField  HeaderText="Include All options">
			<ItemTemplate>
				<asp:CheckBox ID="chkIncludeAll" runat="server" Enabled="false"></asp:CheckBox>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField  HeaderText="Search Sort Order">
			<ItemTemplate>
				<asp:Label ID="lblSearchSortOrder" runat="server"></asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField  HeaderText="Expand on Load">
			<ItemTemplate>
				<asp:CheckBox ID="expandOnLoad" runat="server" Enabled="false"></asp:CheckBox>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField  HeaderText="Filter Search Options">
			<ItemTemplate>
				<asp:CheckBox ID="filterSearchOptions" runat="server" Enabled="false"></asp:CheckBox>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField  HeaderText="Send to Matrix">
			<ItemTemplate>
				<asp:CheckBox ID="sendToMatrix" runat="server" Enabled="false"></asp:CheckBox>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Display Options">
			<ItemTemplate>
				<asp:CheckBox ID="showInMatrix" Text="Vertical Matrix/Column Based Matrix" runat="server" AutoPostBack="False" Enabled="false"/>
				<br/>
				<asp:CheckBox ID="showInComparePage" Text="Compare Page" runat="server" AutoPostBack="False" Enabled="false"/>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField  HeaderText="CSS Column Width">
			<ItemTemplate>
				<asp:Label ID="columnWidth" runat="server"></asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField >
			<ItemTemplate>
				<asp:Hyperlink ID="lnkSearchOptions" runat="server" CssClass="aDialog">Search Options</asp:Hyperlink>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField>
			<ItemTemplate>
				<asp:Hyperlink ID="lnkEdit" runat="server" CssClass="aDialog grid_icon_link edit">Edit</asp:Hyperlink>
				<asp:LinkButton OnClientClick="return confirm('Are you sure you want to remove this search group?');"
					ID="lbtnRemove" runat="server" Text="Remove" CommandName="RemoveSearchGroup" CssClass="grid_icon_link delete"></asp:LinkButton>
			</ItemTemplate>
		</asp:TemplateField>
	</Columns>
	<EmptyDataTemplate>No search groups were found.</EmptyDataTemplate>
</asp:GridView>
<br />
<br />

