<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RegionList.aspx.cs" 
Inherits="VerticalPlatformAdminWeb.Platform.Region.RegionList" MasterPageFile="~/MasterPage.Master" %>

<%@ Register src="~/ModuleAdmin/Pager.ascx" tagname="Pager" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
	<div class="AdminPanelHeader">
		<h3>Region List</h3>
	</div>
	<div class="AdminPanelContent">
		<div class="add-button-container">
			<asp:HyperLink ID="lnkAddRegion" runat="server" CssClass="btn">Add Region</asp:HyperLink>
			<asp:HyperLink ID="lnkAddRegionForAllSites" runat="server" CssClass="btn">Add Region For All Sites</asp:HyperLink>
		</div>
		<asp:GridView ID="gvRegionList" runat="server" AutoGenerateColumns="False" 
				CssClass="common_data_grid table table-bordered" 
				OnRowDataBound="gvRegionList_RowDataBound" OnRowCommand="gvRegionList_RowCommand" style="width:auto" AllowSorting="true" OnSorting="gvRegionList_Sorting">
			<Columns>
				<asp:BoundField HeaderText="Region Id" DataField="Id" />
				<asp:TemplateField HeaderText="Region Name" SortExpression="name">
					<ItemTemplate>
						<asp:Literal ID="ltlRegionName" runat="server"></asp:Literal>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Region Type">
					<ItemTemplate>
						<asp:Literal ID="ltlRegionType" runat="server"></asp:Literal>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Description">
					<ItemTemplate>
						<asp:Literal ID="ltlDescription" runat="server"></asp:Literal>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Site">
					<ItemTemplate>
						<asp:Label ID="lblSite" runat="server" ></asp:Label>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField>
					<ItemTemplate>
						<asp:HyperLink ID="lnkEdit" runat="server" CssClass="grid_icon_link edit" ToolTip="Edit">Edit</asp:HyperLink>
						<asp:LinkButton ID="lbtnDelete" runat="server" CommandName="DeleteRegion" CssClass="grid_icon_link delete" ToolTip="Delete">Delete</asp:LinkButton>
					</ItemTemplate>
				</asp:TemplateField>
			</Columns>
			<EmptyDataTemplate>No Regions found.</EmptyDataTemplate>
		</asp:GridView>
		<uc1:Pager ID="pagerRegion" runat="server" RecordsPerPage="10" OnPageIndexClickEvent="pageIndex_Click"/>
	</div>
</asp:Content>