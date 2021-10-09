<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="UserRoles.ascx.cs" 
Inherits="VerticalPlatformAdminWeb.Platform.User.UserRoles" %>
<div class="user_roles_content">
	<div class="user_roles_buttons clearfix">
	<asp:LinkButton ID="lbtnAll" runat="server" OnClick="lbtnAll_Click">Common For All Sites</asp:LinkButton>
	<asp:LinkButton ID="lbtnOther" runat="server" OnClick="lbtnOther_Click">For Individual Sites</asp:LinkButton>
	</div>
	
	<div class="user_roles_content_inner">
	<asp:MultiView ID="mvRoles" runat="server" ActiveViewIndex="0">
		<asp:View ID="allSiteRoleView" runat="server">
			<div id="divAllSiteRole" runat="server">
				<h4>
					User roles for all sites</h4>
				<asp:GridView ID="gvAllSiteRole" runat="server" AutoGenerateColumns="false" OnRowDataBound="gvAllSiteRole_RowDataBound"
					HeaderStyle-CssClass="GridHeader" CssClass="common_data_grid">
					<AlternatingRowStyle CssClass="DataTableRowAlternate" />
					<RowStyle CssClass="DataTableRow" />
					<Columns>
						<asp:BoundField HeaderText="ID" DataField="Id" />
						<asp:TemplateField HeaderText="Role" ItemStyle-Width="250">
							<ItemTemplate>
								<asp:CheckBox ID="chkRole" runat="server" />
							</ItemTemplate>
						</asp:TemplateField>
					</Columns>
				</asp:GridView>
			</div>
		</asp:View>
		<asp:View ID="selectedSiteRoleView" runat="server">
			<div>
				<h4>
					User roles for selected site.</h4>
				<asp:Panel ID="pnlSite" runat="server">
					Site :
					<asp:DropDownList ID="ddlSite" runat="server" AppendDataBoundItems="true" OnSelectedIndexChanged="ddlSite_SelectedIndexChanged"
						AutoPostBack="true">
						<asp:ListItem Text="--Select--" Value=""></asp:ListItem>
					</asp:DropDownList>
					<asp:RequiredFieldValidator ID="rfvSite" runat="server" ErrorMessage="*" ControlToValidate="ddlSite"></asp:RequiredFieldValidator>
				</asp:Panel>
				<br />
				<asp:GridView ID="gvRole" runat="server" AutoGenerateColumns="false" OnRowDataBound="gvRole_RowDataBound"
					HeaderStyle-CssClass="GridHeader" CssClass="common_data_grid">
					<AlternatingRowStyle CssClass="DataTableRowAlternate" />
					<RowStyle CssClass="DataTableRow" />
					<Columns>
						<asp:BoundField HeaderText="ID" DataField="Id" />
						<asp:TemplateField HeaderText="Role" ItemStyle-Width="250">
							<ItemTemplate>
								<asp:CheckBox ID="chkRole" runat="server" />
							</ItemTemplate>
						</asp:TemplateField>
					</Columns>
				</asp:GridView>
			</div>
		</asp:View>
	</asp:MultiView>
	</div>
</div>
