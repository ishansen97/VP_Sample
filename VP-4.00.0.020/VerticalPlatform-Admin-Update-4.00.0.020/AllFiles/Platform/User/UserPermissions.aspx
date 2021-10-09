<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserPermissions.aspx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.User.UserPermissions" EnableEventValidation="false"
	MasterPageFile="~/MasterPage.Master" %>

<asp:Content ID="cntAddEditUserPermission" runat="server" ContentPlaceHolderID="cphContent">
	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>
				<asp:Label ID="lblHeader" runat="server" BackColor="Transparent"></asp:Label>
			</h3>
		</div>
		<div class="AdminPanelContent">
			<asp:GridView ID="gvUserRolePermissions" runat="server" AutoGenerateColumns="False"
				CssClass="common_data_grid permission_grid table table-bordered" EnableViewState="false" OnRowDataBound="gvUserRolePermissions_RowDataBound">
				<AlternatingRowStyle />
				<RowStyle CssClass="DataTableRow" />
				<Columns>
					<asp:BoundField DataField="Id" HeaderText="ID" />
					<asp:TemplateField HeaderText="Subsystem">
						<ItemTemplate>
							<asp:Label ID="lblSubsystem" runat="server"></asp:Label>
							<asp:HiddenField ID="hdnSubsystemId" runat="server" />
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField HeaderText="Operation">
						<ItemTemplate>
							<asp:CheckBoxList CellPadding="0" CellSpacing="0" ID="chklOperations" runat="server"
								CssClass="permission_checkbox_list">
							</asp:CheckBoxList>
						</ItemTemplate>
					</asp:TemplateField>
				</Columns>
			</asp:GridView>
			<br />
			<asp:Button ID="btnSavePermission" runat="server" Text="Save" OnClick="btnSavePermission_Click"
				CssClass="common_text_button" />
			<asp:Button ID="btnBack" runat="server" Text="Back" CssClass="common_text_button" />
		</div>
	</div>
</asp:Content>
