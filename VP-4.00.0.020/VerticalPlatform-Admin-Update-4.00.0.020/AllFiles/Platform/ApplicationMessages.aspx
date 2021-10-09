<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ApplicationMessages.aspx.cs" 
MasterPageFile="~/MasterPage.Master" Inherits="VerticalPlatformAdminWeb.Platform.ApplicationMessages" %>

<asp:Content ID="pageContent" ContentPlaceHolderID="cphContent" runat="server">
	<div class="AdminPanelHeader">
		<h3>Application Messages</h3>
	</div>
	<div class="AdminPanelContent">
		<div class="add-button-container"><asp:HyperLink ID="lnkAddMessage" runat="server" CssClass="aDialog btn">Add Message</asp:HyperLink></div>
		<br />
		<asp:GridView ID="gvMessageList" runat="server" AutoGenerateColumns="False" CssClass="common_data_grid table table-bordered"
			OnRowDataBound="gvMessageList_RowDataBound" OnRowCommand="gvMessageList_RowCommand" style="width:auto">
			<Columns>
				<asp:TemplateField HeaderText="ID">
					<ItemTemplate>
							<asp:Label ID="lblMessageId" runat="server"></asp:Label>
						</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Site">
					<ItemTemplate>
						<asp:Label ID="lblSite" runat="server"></asp:Label>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Application Type">
					<ItemTemplate>
						<asp:Label ID="lblApplicationType" runat="server"></asp:Label>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Message Type">
					<ItemTemplate>
						<asp:Label ID="lblMessageType" runat="server"></asp:Label>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Message">
					<ItemTemplate>
						<asp:Label ID="lblMessage" runat="server"></asp:Label>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Show">
					<ItemTemplate>
						<asp:CheckBox ID="chkShow" runat="server" Enabled="false"></asp:CheckBox>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField ItemStyle-Width="80px">
					<ItemTemplate>
						<asp:HyperLink ID="lnkEdit" runat="server" CssClass="aDialog grid_icon_link edit" ToolTip="Edit">Edit</asp:HyperLink>
						<asp:LinkButton runat="server" ID="lbtnDelete" CommandName="DeleteMessage" CssClass="grid_icon_link delete" ToolTip="Delete">Delete</asp:LinkButton>
						<asp:LinkButton runat="server" ID="lbtnResendMessage" CommandName="ResendMessage" CssClass="grid_icon_link resend" ToolTip="Resend">Resend</asp:LinkButton>
					</ItemTemplate>
				</asp:TemplateField>
			</Columns>
			<EmptyDataTemplate>
				No messages found.</EmptyDataTemplate>
		</asp:GridView>
	</div>
</asp:Content>