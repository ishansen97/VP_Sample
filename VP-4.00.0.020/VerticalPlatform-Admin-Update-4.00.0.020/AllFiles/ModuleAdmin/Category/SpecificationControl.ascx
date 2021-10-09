<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SpecificationControl.ascx.cs"
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Category.SpecificationControl" %>
<h4>Specifications</h4>
<div class="add-button-container">
    <asp:HyperLink ID="lnkAddSpecType" runat="server" CssClass="aDialog btn">
	Add specification type</asp:HyperLink>
<asp:HyperLink ID="lnkAddNewSpecType" runat="server" CssClass="aDialog btn">
	New specification type</asp:HyperLink>
</div>
<asp:GridView ID="gvSpecTypeList" runat="server" AutoGenerateColumns="False"
	OnRowCommand="gvSpecTypeList_RowCommand" OnRowDataBound="gvSpecTypeList_RowDataBound"
	CssClass="common_data_grid table table-bordered">
	<Columns>
		<asp:TemplateField HeaderText="Enabled">
			<ItemTemplate>
				<asp:CheckBox ID="chkEnabled" runat="server" Enabled="false"/>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField  HeaderText="Spec Type">
			<ItemTemplate>
				<asp:Label ID="lblSpecName" runat="server"></asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField  HeaderText="Spec Type Id">
			<ItemTemplate>
				<asp:Label ID="lblSpecTypeId" runat="server"></asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Display Name">
			<ItemTemplate>
				<asp:Label ID="lblDisplayName" runat="server"></asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField  HeaderText="Sort Order">
			<ItemTemplate>
				<asp:Label ID="lblSpecSortOrder" runat="server"></asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
			<asp:TemplateField  HeaderText="Spec Length">
			<ItemTemplate>
				<asp:Label ID="lblSpecLength" runat="server"></asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField  HeaderText="Display Options">
			<ItemTemplate>
				<asp:CheckBox ID="chkShowInMatrix" runat="server" Enabled="False" Text="Show In Vertical/Column Matrix"/>
        <br />
        <asp:CheckBox ID="chkShowInComparePage" runat="server" Enabled="False"  Text="Show In Compare Page"/>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField  HeaderText="CSS Column Width">
			<ItemTemplate>
				<asp:Label ID="columnWidth" runat="server"></asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField ItemStyle-Width="50">
			<ItemTemplate>
				<asp:HyperLink ID="lnkEdit" runat="server" CssClass="aDialog grid_icon_link edit" ToolTip="Edit">Edit</asp:HyperLink>
				<asp:LinkButton ID="lbtnRemove" runat="server" CausesValidation="false" CommandName="DeleteSpecType"
					Text="Delete" OnClientClick="return confirm('Are you sure you want to delete this product specification type');" CssClass="grid_icon_link delete" ToolTip="Delete"></asp:LinkButton>
			</ItemTemplate>
		</asp:TemplateField>
	</Columns>
</asp:GridView>
<br />

