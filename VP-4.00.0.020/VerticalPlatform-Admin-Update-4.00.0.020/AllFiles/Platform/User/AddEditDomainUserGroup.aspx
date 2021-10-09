<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddEditDomainUserGroup.aspx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.User.AddEditDomainUserGroup" EnableEventValidation="false"
	MasterPageFile="~/MasterPage.Master" %>

<asp:Content ID="cntAddEditUserRolse" runat="server" ContentPlaceHolderID="cphContent">
	<div class=" AdminPanel">
		<div class="AdminPanelHeader">
			<h3>
				<asp:Label ID="lblHeader" runat="server" BackColor="Transparent">Domain User Group Mapping</asp:Label>
			</h3>
		</div>
		<div class="AdminPanelContent">
		<div class="add-button-container"><asp:HyperLink ID="lnkAdd" runat="server" CssClass="aDialog btn">Add Domain User Group</asp:HyperLink></div>
		
			<asp:GridView ID="gvADgroupRole" runat="server" AutoGenerateColumns="False" OnRowDataBound="gvADgroupRole_RowDataBound"
				CssClass="common_data_grid table table-bordered" style="width:auto" onrowcommand="gvADgroupRole_RowCommand">
				<AlternatingRowStyle CssClass="DataTableRowAlternate" />
				<RowStyle CssClass="DataTableRow" />
				<Columns>
					<asp:TemplateField HeaderText="ID" SortExpression="Id">
						<ItemTemplate>
							<asp:Literal ID="ltlId" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "ADgroupRoleInfo.Id") %>'></asp:Literal>
						</ItemTemplate>
						
					</asp:TemplateField>
					<asp:TemplateField HeaderText="Role" SortExpression="RoleName">
						<ItemTemplate>
							<asp:Literal ID="ltlRoleName" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "Role.Name") %>'></asp:Literal>
						</ItemTemplate>
						
					</asp:TemplateField>
					<asp:TemplateField HeaderText="Site" SortExpression="SiteName">
						<ItemTemplate>
							<asp:Literal ID="ltlSiteName" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "Site.Name") %>'></asp:Literal>
						</ItemTemplate>
						
					</asp:TemplateField>
					<asp:TemplateField HeaderText="Domain User Group" SortExpression="DomainUserGroup">
						<ItemTemplate>
							<asp:Literal ID="ltlDomainUserGroup" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "ADgroupRoleInfo.DomainUserGroup") %>'></asp:Literal>
						</ItemTemplate>
						
					</asp:TemplateField>
					<asp:TemplateField SortExpression="Enabled">
						<ItemTemplate>
							<asp:CheckBox ID="chkEnabled" Enabled="false" runat="server" Checked='<%# DataBinder.Eval(Container.DataItem, "ADgroupRoleInfo.Enabled") %>'></asp:CheckBox>
						</ItemTemplate>
						
					</asp:TemplateField>
					<asp:TemplateField ShowHeader="False">
						<ItemTemplate>
							<asp:HyperLink ID="lnkEdit" runat="server" CssClass="aDialog grid_icon_link edit" ToolTip="Edit">Edit</asp:HyperLink>
							<asp:LinkButton ID="lbtnDelete" runat="server" CommandName="DeletADgroupRole" CssClass="grid_icon_link delete" ToolTip="Delete">Delete</asp:LinkButton>
						</ItemTemplate>
					</asp:TemplateField>
				</Columns>
			</asp:GridView>
			<br />
			
		</div>
	</div>
</asp:Content>
