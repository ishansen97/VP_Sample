<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddEditUserRoles.aspx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.User.AddEditUserRoles" EnableEventValidation="false"
	MasterPageFile="~/MasterPage.Master" %>

<asp:Content ID="cntAddEditUserRolse" runat="server" ContentPlaceHolderID="cphContent">

	<div class=" AdminPanel">
		<div class="AdminPanelHeader">
			<h3>
				<asp:Label ID="lblHeader" runat="server" BackColor="Transparent">Add/Edit Roles</asp:Label>
			</h3>
		</div>
		<div class="AdminPanelContent">
			<div class="add-button-container"><asp:HyperLink ID="lnkAdd" runat="server" CssClass="aDialog btn">Add Role</asp:HyperLink></div>
			
			<asp:GridView ID="gvUserRolesList" runat="server" AutoGenerateColumns="False" OnRowDataBound="gvUserRolesList_RowDataBound"
				CssClass="common_data_grid table table-bordered" Width="600px" OnRowCommand="gvUserRolesList_RowCommand">
				<AlternatingRowStyle CssClass="DataTableRowAlternate" />
				<RowStyle CssClass=" DataTableRow" />
				<Columns>
					<asp:BoundField DataField="Id" HeaderText="ID" />
					<asp:BoundField DataField="Name" HeaderText="Role" />
					<asp:CheckBoxField DataField="Enabled" />
					<asp:TemplateField ShowHeader="False">
						<ItemStyle Width="50px" />
						<ItemTemplate>
							<asp:HyperLink ID="lnkPermission" runat="server">Permission</asp:HyperLink>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField ShowHeader="False">
						<ItemTemplate>
							<asp:HyperLink ID="lnkEdit" runat="server" CssClass="aDialog  grid_icon_link edit"
								ToolTip="Edit">Edit</asp:HyperLink>
							<asp:LinkButton ID="lbtnDelete" runat="server" CommandName="DeletRole" CssClass="grid_icon_link delete"
								ToolTip="Delete">Delete</asp:LinkButton>
						</ItemTemplate>
						<ItemStyle Width="50px" />
					</asp:TemplateField>
				</Columns>
			</asp:GridView>
			<br />
		</div>
	</div>
</asp:Content>
