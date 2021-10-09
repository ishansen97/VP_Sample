<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="BulkEmailTypeUsers.ascx.cs" 
		Inherits="VerticalPlatformAdminWeb.ModuleAdmin.BulkEmail.BulkEmailTypeUsers" %>

<%@ Register Src="../Pager.ascx" TagName="Pager" TagPrefix="uc1" %>

<div class="AdminPanelContent">
	<asp:Label ID="lblUsers" runat="server" />
	<br />
	<asp:GridView ID="gvBulkEmailTypeUser" runat="server" 
		CssClass="common_data_grid" AutoGenerateColumns="False" 
		onrowdatabound="gvBulkEmailTypeUser_RowDataBound">
		<Columns>
			<asp:BoundField HeaderText="User ID" DataField="Id" />
			<asp:TemplateField HeaderText="First Name">
				<ItemTemplate>
					<asp:Label ID="lblFirstName" runat="server"></asp:Label>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField HeaderText="Last Name">
				<ItemTemplate>
					<asp:Label ID="lblLastName" runat="server"></asp:Label>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField HeaderText="Email">
				<ItemTemplate>
					<asp:Label ID="lblEmail" runat="server"></asp:Label>
				</ItemTemplate>
			</asp:TemplateField>
		</Columns>
		<EmptyDataTemplate>No subscribed users found.</EmptyDataTemplate>
	</asp:GridView>
	<uc1:Pager ID="pagerUsers" runat="server" OnPageIndexClickEvent="pagerUsers_PageIndexClick" />
	<br />
	<asp:Panel ID="pnlDownload" runat="server">
		<asp:Button ID="btnDownload" runat="server" CssClass="common_text_button" onclick="btnDownload_Click" Text ="Download Report" />
	</asp:Panel>
</div>