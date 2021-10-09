<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="VendorAssignAccountsControl.ascx.cs" 
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Vendors.VendorAssignAccountsControl" %>
<br />
<div class="form-horizontal">
    <div class="control-group">
        <label class="control-label">Media Coordinator</label>
        <div class="controls">
            <div class="inline-form-content">
                <asp:DropDownList ID="ddlMediaCoordinator" runat="server"></asp:DropDownList>
                <asp:Button ID="btnAddMediaCoordinator" runat="server" 
					CssClass="btn" Text="Add Media Coorninator" 
					onclick="btnAddMediaCoordinator_Click" Width="145"></asp:Button>
            </div>
        </div>
    </div>
     <div class="control-group">
        <label class="control-label">Sales Person</label>
        <div class="controls">
            <div class="inline-form-content">
                <asp:DropDownList ID="ddlSalesPerson" runat="server"></asp:DropDownList>
                <asp:Button ID="btnAddSalesPerson" runat="server" CssClass="btn" 
					Text="Add Sales Person" onclick="btnAddSalesPerson_Click" Width="145"></asp:Button>
            </div>
        </div>
    </div>
</div>
<br />
<asp:GridView ID="gvAdminUsers" runat="server" AutoGenerateColumns="False" 
		CssClass="common_data_grid table table-bordered" OnRowDataBound="gvAdminUsers_RowDataBound" 
		onrowdeleting="gvAdminUsers_RowDeleting" style="width:auto;">
		<Columns>
			<asp:TemplateField HeaderText="Admin User Role">
				<ItemTemplate>
					<asp:Literal ID="ltlAdminUserRole" runat="server"></asp:Literal>
				</ItemTemplate>
				<ItemStyle HorizontalAlign="Left" />
			</asp:TemplateField>
			<asp:TemplateField ShowHeader="False" Visible="false">
				<ItemTemplate>
					<asp:Literal ID="ltlAdminUserId" runat="server"></asp:Literal>
				</ItemTemplate>
				<ItemStyle HorizontalAlign="Left" />
			</asp:TemplateField>
			<asp:TemplateField HeaderText="Admin User Name">
				<ItemTemplate>
					<asp:Literal ID="ltlAdminUserName" runat="server"></asp:Literal>
				</ItemTemplate>
				<ItemStyle HorizontalAlign="Left" />
			</asp:TemplateField>
			<asp:TemplateField ShowHeader="False" ItemStyle-Width="30">
				<ItemTemplate>
				<%--	<asp:LinkButton ID="lbtnDelete1" runat="server" CommandName="Delete">Delete</asp:LinkButton>--%>
					<asp:LinkButton ID="lbtnDelete" runat="server" CommandName="Delete" 
					OnClientClick="return confirm('Are you sure you want to remove this association?');" 
					Text="Delete" CssClass="grid_icon_link delete" ToolTip="Delete"></asp:LinkButton>
				</ItemTemplate>
				<ItemStyle HorizontalAlign="Left" />
			</asp:TemplateField>
		</Columns>
		<EmptyDataTemplate>
			No Admin User To Vendor Associations were found.
		</EmptyDataTemplate>
	</asp:GridView>
	