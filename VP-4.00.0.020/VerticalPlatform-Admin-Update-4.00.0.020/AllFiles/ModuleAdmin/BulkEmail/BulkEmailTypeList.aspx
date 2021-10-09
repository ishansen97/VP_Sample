<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="BulkEmailTypeList.aspx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.BulkEmail.BulkEmailTypeList" MasterPageFile="~/MasterPage.Master" %>

<%@ Register Src="../Pager.ascx" TagName="Pager" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
	<div class="AdminPanelHeader">
		<h3>
			Bulk Email Types</h3>
	</div>
	<div class="AdminPanelContent">
	<div class="add-button-container"><asp:HyperLink ID="lnkAddBulkEmailType" runat="server" CssClass="aDialog btn">Add Bulk Email Type</asp:HyperLink></div>
	
		<asp:GridView ID="gvBulkEmailType" runat="server" AutoGenerateColumns="False" EnableViewState="false"
			AllowSorting="True" onsorting="gvBulkEmailType_Sorting"
			onrowdatabound="gvBulkEmailType_RowDataBound" CssClass="common_data_grid table table-bordered" 
			onrowcommand="gvBulkEmailType_RowCommand">
			<AlternatingRowStyle CssClass="DataTableRowAlternate" />
			<RowStyle CssClass="DataTableRow" />
			<Columns>
				<asp:BoundField HeaderText="ID" DataField="Id" />
				<asp:BoundField HeaderText="Name" DataField="Name" />
				<asp:CheckBoxField HeaderText="Vendor Specific" DataField="VendorSpecific" />
				<asp:CheckBoxField HeaderText="Enabled" DataField="Enabled" />
				<asp:TemplateField HeaderText="Email Provider">
					<ItemTemplate>
						<asp:Label ID="lblEmailProvider" runat="server"></asp:Label>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Campaign Types">
					<ItemTemplate>
						<asp:HyperLink ID="lnkCampaignTypes" runat="server" Text="Campaign Types"></asp:HyperLink>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="User Fields">
					<ItemTemplate>
						<asp:HyperLink ID="lnkUserField" runat="server" Text="User Fields" CssClass="aDialog"></asp:HyperLink>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Users">
					<ItemTemplate>
						<asp:HyperLink ID="lnkUsers" runat="server" Text="Users" CssClass="aDialog"></asp:HyperLink>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Created" SortExpression="created">
					<ItemTemplate>
						<asp:Literal ID="ltlCreated" runat="server"></asp:Literal>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Last Modified" SortExpression="modified">
					<ItemTemplate>
						<asp:Literal ID="ltlModified" runat="server"></asp:Literal>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField>
					<ItemTemplate>
						<asp:HyperLink ID="lnkEdit" runat="server" CssClass="aDialog grid_icon_link edit" ToolTip="Edit" Text="Edit"></asp:HyperLink><asp:LinkButton ID="lbtnDelete" runat="server" CommandName="DeleteBulkEmailType" CssClass="grid_icon_link delete" ToolTip="Delete">Delete</asp:LinkButton>
					</ItemTemplate>
				</asp:TemplateField>
			</Columns>
			<EmptyDataTemplate>No Bulk Email Types found.</EmptyDataTemplate>
		</asp:GridView>
		<uc1:Pager ID="pagerBulkEmailType" runat="server" OnPageIndexClickEvent="pageIndex_Click" />
	</div>
</asp:Content>
