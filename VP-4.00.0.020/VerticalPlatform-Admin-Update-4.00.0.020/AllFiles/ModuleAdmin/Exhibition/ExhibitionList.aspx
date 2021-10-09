<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="ExhibitionList.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Exhibition.ExhibitionList" %>

<%@ Register Src="Pager.ascx" TagName="Pager" TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
	<div class="AdminPanelHeader">
		<h3>
			Exhibitions
		</h3>
	</div>
	<div class="AdminPanelContent">
		<div class="add-button-container"><asp:HyperLink ID="lnkAdd" runat="server" CssClass="aDialog btn">Add</asp:HyperLink></div>
		
		<asp:GridView ID="gvExhibition" runat="server" AutoGenerateColumns="false" OnRowDataBound="gvExhibition_RowDataBound"
			CssClass="common_data_grid table table-bordered" onrowcommand="gvExhibition_RowCommand" style="width:auto;">
			<Columns>
				<asp:BoundField HeaderText="ID" DataField="Id" />
				<asp:BoundField HeaderText="Name" DataField="Name" />
				<asp:BoundField HeaderText="Start&nbsp;Date" DataField="StartDate" DataFormatString="{0:MM/dd/yyyy}" />
				<asp:BoundField HeaderText="End&nbsp;Date" DataField="EndDate" DataFormatString="{0:MM/dd/yyyy}" />
				<asp:CheckBoxField HeaderText="Enabled" DataField="Enabled" />
				<asp:TemplateField>
					<ItemTemplate>
						<asp:HyperLink ID="lnkCategories" runat="server">Categories</asp:HyperLink>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField>
					<ItemTemplate>
						<asp:HyperLink ID="lnkVendors" runat="server">Vendors</asp:HyperLink>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField>
					<ItemTemplate>
					    <asp:HyperLink ID="lnkEdit" runat="server" CssClass="aDialog grid_icon_link edit" ToolTip="Edit">Edit</asp:HyperLink>
						<asp:LinkButton ID="lbtnDelete" runat="server" OnClientClick="return confirm('Are you sure to delete this exhibition and associated categories?');" CommandName="DeleteExhibition" CssClass="grid_icon_link delete" ToolTip="Delete">Delete</asp:LinkButton>
					</ItemTemplate>
				</asp:TemplateField>
			</Columns>
			<EmptyDataTemplate>
				No Exhibitions found.
			</EmptyDataTemplate>
		</asp:GridView>
		<asp:Label ID="lblMessage" runat="server"></asp:Label>
		<uc2:Pager ID="pgrExhibition" runat="server" />
		
	</div>
</asp:Content>
