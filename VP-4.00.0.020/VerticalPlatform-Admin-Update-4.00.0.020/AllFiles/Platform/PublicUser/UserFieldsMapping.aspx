<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserFieldsMapping.aspx.cs" 
Inherits="VerticalPlatformAdminWeb.Platform.PublicUser.UserFieldsMapping" MasterPageFile="~/MasterPage.Master" %>

<asp:Content ID="Content" ContentPlaceHolderID="cphContent" runat="server">
	<div class="AdminPanelHeader">
		<h3>User Fields Mapping</h3>
	</div>
	<div class="AdminPanelContent">
		<div class="add-button-container"><asp:HyperLink ID="lnkAddMapping" runat="server" CssClass="aDialog btn">Add User Field Mapping</asp:HyperLink></div>
		
		<asp:GridView ID="gvFieldMapping" runat="server" CssClass="common_data_grid table table-bordered" AutoGenerateColumns="False"
			OnRowDataBound="gvFieldMapping_RowDataBound" 
			OnRowCommand="gvFieldMapping_RowCommand">
			<AlternatingRowStyle CssClass="DataTableRowAlternate" />
			<RowStyle CssClass="DataTableRow" />
			<Columns>
				<asp:TemplateField HeaderText="ID">
					<ItemTemplate>
						<asp:Literal ID="ltlId" runat="server"></asp:Literal>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Source Field">
					<ItemTemplate>
						<asp:Literal ID="ltlSourceField" runat="server"></asp:Literal>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Destination Field">
					<ItemTemplate>
						<asp:Literal ID="ltlDestinationField" runat="server"/>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Prerequisite Field">
					<ItemTemplate>
						<asp:Literal ID="ltlPrerequisiteField" runat="server"/>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Prerequisite Field Option">
					<ItemTemplate>
						<asp:Literal ID="ltlPrerequisiteFieldOption" runat="server"/>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Options Mapping">
					<ItemTemplate>
						<asp:HyperLink ID="lnkFieldOptionsMapping" runat="server" Text="Mapping" ToolTip="User field options mapping" 
							CssClass="aDialog"></asp:HyperLink>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Action">
					<ItemTemplate>
						<asp:LinkButton ID="lbtnDelete" runat="server" CommandName="DeleteMapping"  CssClass="grid_icon_link delete" ToolTip="Delete">Delete</asp:LinkButton>
					</ItemTemplate>
				</asp:TemplateField>
			</Columns>
			<EmptyDataTemplate>No Field Mappings Found.</EmptyDataTemplate>
		</asp:GridView>
	</div>
</asp:Content>
