<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserAgentList.aspx.cs" MasterPageFile="~/MasterPage.Master"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.SpiderManagement.UserAgentList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>User Agent List</h3>
		</div>
		<div class="AdminPanelContent">
			<div class="add-button-container">
                <asp:HyperLink ID="lnkAddUserAgent" runat="server" CssClass="aDialog btn">Add New User Agent</asp:HyperLink>
            </div>
			<div>
				<asp:GridView ID="gvUserAgentList" runat="server" AutoGenerateColumns="False" 
					CssClass="common_data_grid table table-bordered" onrowdatabound="gvUserAgentList_RowDataBound" 
					onrowcommand="gvUserAgentList_RowCommand" style="width:auto">
					<Columns>
						<asp:TemplateField HeaderText="Blocked User Agent Name" SortExpression="name">
							<ItemTemplate>
								<asp:Literal ID="ltlUserAgentName" runat="server"></asp:Literal>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Description">
							<ItemTemplate>
								<asp:Literal ID="ltlDescription" runat="server"></asp:Literal>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Full Name Match">
							<ItemTemplate>
								<asp:Literal ID="ltlFullNameMatch" runat="server"></asp:Literal>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField>
							<ItemTemplate>
								<asp:HyperLink ID="lnkEdit" runat="server" CommandName="EditUserAgent" 
										ToolTip="Edit" CssClass="aDialog grid_icon_link edit" Text=""></asp:HyperLink>
								<asp:LinkButton ID="lbtnDelete" runat="server" CommandName="DeleteUserAgent" 
										CssClass="grid_icon_link delete" ToolTip="Delete"></asp:LinkButton>
							</ItemTemplate>
						</asp:TemplateField>
						<%--<asp:TemplateField>
							<ItemTemplate>
								<asp:LinkButton ID="lbtnDelete" runat="server" CommandName="DeleteUserAgent">Delete</asp:LinkButton>
							</ItemTemplate>
						</asp:TemplateField>--%>
					</Columns>
					<EmptyDataTemplate>No User Agents found.</EmptyDataTemplate>
				</asp:GridView>
			</div>
		</div>
	</div>
</asp:Content>
