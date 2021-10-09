<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ExhibitionVendorList.aspx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Exhibition.ExhibitionVendorList"
	MasterPageFile="~/MasterPage.Master" %>

<%@ Register Src="Pager.ascx" TagName="Pager" TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
	<div class="AdminPanelHeader">
		<h3>
			<asp:Literal ID="ltlTitle" runat="server"></asp:Literal>
		</h3>
	</div>
	<div class="AdminPanelContent">
		<div class="add-button-container"><asp:HyperLink ID="lnkAddExhibitionVendor" runat="server" CssClass="aDialog btn">Add</asp:HyperLink></div>
		
		<asp:GridView runat="server" ID="gvExhibitionVendors" AutoGenerateColumns="false"
			OnRowDataBound="gvExhibitionVendors_RowDataBound" OnRowCommand="gvExhibitionVendors_RowCommand"
			CssClass="common_data_grid table table-bordered" style="width:auto">
			<Columns>
				<asp:BoundField HeaderText="ID" DataField="Id" />
				<asp:TemplateField HeaderText="Vendor Name">
					<ItemTemplate>
						<asp:Literal ID="ltrVendorName" runat="server"></asp:Literal>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:BoundField HeaderText="Booth" DataField="Booth" />
				<asp:BoundField HeaderText="Article ID" DataField="ArticleId" />
				<asp:BoundField HeaderText="Logo Name" DataField="LogoName" />
				<asp:BoundField HeaderText="Description" DataField="Description" />
				<asp:CheckBoxField HeaderText="Enabled" DataField="Enabled" />
				<asp:TemplateField>
					<ItemTemplate>
						<asp:HyperLink ID="lnkSpecials" runat="server">Specials</asp:HyperLink>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField ItemStyle-Width="50px">
					<ItemTemplate>
					    <asp:HyperLink ID="lnkEdit" runat="server" CssClass="aDialog grid_icon_link edit" ToolTip="Edit">Edit</asp:HyperLink>
						<asp:LinkButton ID="lbtnDelete" CommandName="DeleteVendor" runat="server" CssClass="grid_icon_link delete" ToolTip="Delete">Delete</asp:LinkButton>
					</ItemTemplate>
				</asp:TemplateField>
			</Columns>
			<EmptyDataTemplate>
				No Exhibition Vendors found.
			</EmptyDataTemplate>
		</asp:GridView>
		<asp:HiddenField runat="server" ID="hdnExhibitionVendorId" />
		<asp:Label ID="lblMessage" runat="server"></asp:Label>
		<uc2:Pager ID="pgrExhibitionVendor" runat="server" />
		<br />
		<asp:Button runat="server" Text="&laquo; Back" ID="btnBack" OnClick="btnBack_Click" CssClass="btn" />
	</div>
</asp:Content>
