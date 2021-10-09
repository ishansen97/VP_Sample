<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="CountryList.aspx.cs" Inherits="VerticalPlatformAdminWeb.Platform.Country.CountryList" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
<div class="AdminPanelHeader">
		<h3>Country List</h3>
</div>
		<div class="AdminPanelContent">
	<asp:GridView ID="gvCountryList" runat="server" AutoGenerateColumns="False" 
		CssClass="common_data_grid table table-bordered" onrowdatabound="gvCountryList_RowDataBound" style="width:auto;">
		<Columns>
			<asp:BoundField DataField="Id" HeaderText="ID" />
			<asp:BoundField DataField="Name" HeaderText="Country Name" />
			<asp:BoundField DataField="IsoCode" HeaderText="Iso Code" />
			<asp:BoundField DataField="CultureName" HeaderText="Culture Name" />
			<asp:TemplateField HeaderText = "Currency">
				<ItemTemplate>
					<asp:Label ID="lblCurrency" runat="server" Text=""></asp:Label>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField ItemStyle-Width="30">
				<ItemTemplate>
					<asp:HyperLink ID="lnkEdit" runat="server" CssClass="aDialog grid_icon_link edit" ToolTip="Edit">Edit</asp:HyperLink>
				</ItemTemplate>
			</asp:TemplateField>
		</Columns>
	
	</asp:GridView>
</div>
</asp:Content>
