<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="PredefinedPageList.aspx.cs" Inherits="VerticalPlatformAdminWeb.Platform.PredefinedPageList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>
				<asp:Label ID="lblHeader" runat="server" BackColor="Transparent">Page List</asp:Label></h3>
		</div>
		<div class="AdminPanelContent">
		<div class="add-button-container"><asp:HyperLink ID="lnkAdd" runat="server" CssClass="aDialog btn">Add Predefined Page</asp:HyperLink></div>
		
			<asp:GridView ID="gvPage" runat="server" AutoGenerateColumns="false" OnRowDataBound="gvPage_RowDataBound"
				CssClass="common_data_grid table table-bordered">
				<Columns>
					<asp:BoundField DataField="Id" HeaderText="ID" ItemStyle-Width="75" />
					<asp:BoundField DataField="Name" HeaderText="Name" ItemStyle-Width="150" />
					<asp:CheckBoxField DataField="Enabled" HeaderText="Enabled" ItemStyle-Width="75" />
					<asp:TemplateField ItemStyle-Width="150">
						<ItemTemplate>
							<asp:HyperLink ID="lnkDefaultModules" runat="server" CssClass="aDialog">Default Modules</asp:HyperLink>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField ItemStyle-Width="20px">
						<ItemTemplate>
							<asp:HyperLink ID="lnkEdit" runat="server" CssClass="aDialog grid_icon_link edit" ToolTip="Edit">Edit</asp:HyperLink>
						</ItemTemplate>
					</asp:TemplateField>
				</Columns>
			</asp:GridView>
			
		</div>
	</div>
</asp:Content>
