<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="ModuleList.aspx.cs" Inherits="VerticalPlatformAdminWeb.Platform.ModuleList"
	Title="Untitled Page" %>

<asp:Content ID="conContent" ContentPlaceHolderID="cphContent" runat="server">
	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>
				<asp:Label ID="lblHeader" runat="server" BackColor="Transparent">Module List</asp:Label></h3>
		</div>
		<div class="AdminPanelContent">
			<div class="add-button-container"><asp:HyperLink ID="lnkAddModule" runat="server" CssClass="aDialog btn">Add Module</asp:HyperLink></div>
			<asp:GridView ID="gvModule" runat="server" AutoGenerateColumns="false" OnRowDataBound="gvModule_RowDataBound"
				CssClass="common_data_grid table table-bordered">
				<Columns>
					<asp:BoundField DataField="Id" HeaderText="ID" ItemStyle-Width="75" />
					<asp:BoundField DataField="Name" HeaderText="Name" ItemStyle-Width="150" />
					<asp:BoundField DataField="ControlName" HeaderText="Path" ItemStyle-Width="300" />
					<asp:CheckBoxField DataField="Enabled" HeaderText="Enabled" ItemStyle-Width="75" />
					<asp:TemplateField ItemStyle-Width="20px">
						<ItemTemplate>
							<asp:HyperLink ID="lnkEditModule" runat="server" CssClass="aDialog grid_icon_link edit" ToolTip="Edit">Edit</asp:HyperLink>
						</ItemTemplate>
					</asp:TemplateField>
				</Columns>
			</asp:GridView>
		</div>
	</div>
</asp:Content>
