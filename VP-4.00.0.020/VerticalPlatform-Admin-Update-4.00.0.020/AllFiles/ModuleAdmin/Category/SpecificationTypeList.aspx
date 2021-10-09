<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="SpecificationTypeList.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Category.SpecificationTypeList"
	EnableEventValidation="true" %>
<%@ Register Src="../Pager.ascx" TagName="Pager" TagPrefix="uc1" %>
<asp:Content ID="conContent" ContentPlaceHolderID="cphContent" runat="server">
	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>
				<asp:Label ID="lblHeader" runat="server" BackColor="Transparent">Product Specification</asp:Label></h3>
		</div>
		<div class="inline-form-content bottom-space">
            <span class="control-label"><asp:Literal ID="ltlSpecificationName" runat="server" Text="Product Specification"></asp:Literal></span>
		    <asp:TextBox ID="txtSpecificationType" runat="server" MaxLength="255" Width="150px"></asp:TextBox>
		    <asp:Button ID="btnFilterSpecificationType" runat="server" Text="Search" onclick="btnFilterSpecificationType_Click" CssClass="btn" />
		    <asp:Button ID="btnReset" runat="server" Text="Show All" onclick="btnReset_Click" CssClass="btn" />
		</div>
		<div class="AdminPanelContent">
		    <div class="add-button-container"><asp:HyperLink ID="lnkAddSpecificationType" runat="server" CssClass="aDialog btn">Add Specification Type</asp:HyperLink></div>
			<asp:GridView ID="gvListItems" runat="server" AutoGenerateColumns="False" OnRowDataBound="gvListItems_RowDataBound"
				CssClass="common_data_grid table table-bordered" style="width:auto;">
				<AlternatingRowStyle CssClass="DataTableRowAlternate" />
				<RowStyle CssClass="DataTableRow" />
				<EmptyDataTemplate>
					No Specifications found
				</EmptyDataTemplate>
				<Columns>
					<asp:BoundField HeaderText="ID" DataField="Id" />
					<asp:BoundField HeaderText="Specification" DataField="SpecType" />
					<asp:BoundField HeaderText="Validation Expression" DataField="ValidationExpression"
						ItemStyle-Width="250" />
					<asp:CheckBoxField HeaderText="Is Visible" DataField="IsVisible" />
					<asp:CheckBoxField HeaderText="Enabled" DataField="Enabled" />
					<asp:CheckBoxField HeaderText="SearchEnabled" DataField="SearchEnabled" />
				    <asp:CheckBoxField HeaderText="Auto Truncate ElasticSearch" DataField="AutoTruncateElasticSearch" />
					<asp:TemplateField>
						<ItemTemplate>
							<asp:HyperLink ID="lnkEdit" runat="server" CssClass="aDialog grid_icon_link edit" ToolTip="Edit">Edit</asp:HyperLink>
							<asp:HyperLink ID="lnkSettings" runat="server" CssClass="aDialog grid_icon_link settings" ToolTip="Settings">Settings</asp:HyperLink>
						</ItemTemplate>
						<ItemStyle Width="30px" />
					</asp:TemplateField>
				</Columns>
			</asp:GridView>
			<uc1:Pager ID="pagerSpecificationTypeList" runat="server" OnPageIndexClickEvent="pagerSpecificationTypeList_PageIndexClick" />
		</div>
	</div>
</asp:Content>
