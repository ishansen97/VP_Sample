<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="AddMenuAction.aspx.cs" Inherits="VerticalPlatformAdminWeb.Platform.Site.AddMenuAction" %>
<%@ Register TagPrefix="uc1" TagName="Pager" Src="~/ModuleAdmin/Pager.ascx" %>
<asp:Content ID="cntMenuAction" ContentPlaceHolderID="cphContent" runat="server">
    <div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>Navigation Menu Actions</h3>
		</div>
		<div class="AdminPanelContent">
		    <div class="add-button-container">
		        <asp:HyperLink ID="addMenuAction" runat="server" CssClass="aDialog btn"  style="margin-right:5px;">Add New Menu Action</asp:HyperLink>
		    </div>
			<asp:GridView ID="menuActionGrid" runat="server" AutoGenerateColumns="False" 
					CssClass="common_data_grid table table-bordered" onrowdatabound="menuActionList_RowDataBound" 
					onrowcommand="menuActionList_RowCommand" style="width:auto">
				<Columns>
						<asp:TemplateField HeaderText="Menu Action Type" SortExpression="name">
							<ItemTemplate>
								<asp:Literal ID="menuActionType" runat="server"></asp:Literal>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Display Text" SortExpression="name">
							<ItemTemplate>
								<asp:Literal ID="displayText" runat="server"></asp:Literal>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Custom CSS Class">
							<ItemTemplate>
								<asp:Literal ID="customCssClass" runat="server"></asp:Literal>
							</ItemTemplate>
						</asp:TemplateField>
				        <asp:TemplateField HeaderText="Enabled">
				            <ItemTemplate>
                                <asp:CheckBox ID="enabledCheckBox" runat="server" />
				            </ItemTemplate>
				        </asp:TemplateField>
						<asp:TemplateField ItemStyle-Width="50">
							<ItemTemplate>
								<asp:HyperLink ID="editMenuAction" runat="server" CommandName="EditMenuAction" 
										ToolTip="Edit" CssClass="aDialog grid_icon_link edit" Text=""></asp:HyperLink>
								<asp:LinkButton ID="deleteMenuAction" runat="server" CommandName="DeleteMenuAction" 
										CausesValidation="False" CssClass="grid_icon_link delete" ToolTip="Delete"></asp:LinkButton>
							</ItemTemplate>
						</asp:TemplateField>
					</Columns>
					<EmptyDataTemplate>No Menu Action Records found.</EmptyDataTemplate>
			</asp:GridView>
		</div>
	</div>
</asp:Content>
