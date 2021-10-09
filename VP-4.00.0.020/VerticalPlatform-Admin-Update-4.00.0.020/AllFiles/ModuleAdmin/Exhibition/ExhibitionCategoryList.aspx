<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="ExhibitionCategoryList.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Exhibition.ExhibitionCategoryList" %>

<%@ Register Src="Pager.ascx" TagName="Pager" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
	<div class="AdminPanelHeader">
		<h3>
			<asp:Literal ID="ltlTitle" runat="server"></asp:Literal>
		</h3>
	</div>
	<div class="AdminPanelContent">
		<div class="add-button-container"><asp:HyperLink ID="lnkAdd" runat="server" CssClass="aDialog btn">Add</asp:HyperLink></div>
		
		<asp:GridView ID="gvExhibitionCategory" runat="server" AutoGenerateColumns="false"
			OnRowDataBound="gvExhibitionCategory_RowDataBound" OnRowCommand="gvExhibitionCategory_RowCommand"
			CssClass="common_data_grid table table-bordered" style="width:auto;">
			<Columns>
				<asp:BoundField HeaderText="ID" DataField="Id" />
				<asp:BoundField HeaderText="Name" DataField="Name" />
				<asp:CheckBoxField HeaderText="Enabled" DataField="Enabled" />
				<asp:TemplateField>
					<ItemTemplate>
						<asp:HyperLink ID="lnkSort" runat="server" CssClass="aDialog">Sort Vendors</asp:HyperLink>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField ItemStyle-Width="50px">
					<ItemTemplate>
						<asp:HyperLink ID="lnkEdit" runat="server" CssClass="aDialog grid_icon_link edit" ToolTip="Edit">Edit</asp:HyperLink>
						<asp:LinkButton ID="lbtnDelete" CommandName="DeleteCategory" runat="server" CssClass="grid_icon_link delete" ToolTip="Delete">Delete</asp:LinkButton>
					</ItemTemplate>
				</asp:TemplateField>
			</Columns>
			<EmptyDataTemplate>
				No exhibition categories found.
			</EmptyDataTemplate>
		</asp:GridView>
		<asp:HiddenField ID="hdnExhibitionCategoryId" runat="server" />
		<uc1:Pager ID="pgrExhibitionCategory" runat="server" />
		<br />
		<asp:Button ID="btnBack" runat="server" OnClick="btnBack_Click" Text="&laquo; Back" CssClass="btn" />
	</div>
</asp:Content>
