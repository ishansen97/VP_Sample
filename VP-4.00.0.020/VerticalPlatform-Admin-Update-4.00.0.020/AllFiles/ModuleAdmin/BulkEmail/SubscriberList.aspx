<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SubscriberList.aspx.cs"
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.BulkEmail.SubscriberList" MasterPageFile="~/MasterPage.Master" %>

<%@ Register Src="../Pager.ascx" TagName="Pager" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
	<div class="AdminPanelHeader">
		<h3>
			Subscriber List</h3>
	</div>
	<div class="AdminPanelContent">
		<div id="divSearchPane" class="add-button-container inline-form-container">
			<span class="title">Email</span>
			<asp:TextBox runat="server" ID="txtEmail" Width="188px" MaxLength="200"></asp:TextBox>
			<asp:Button ID="btnApply" runat="server" Text="Apply" OnClick="btnApplyFilter_Click"
						CssClass="btn" />
					<asp:Button ID="btnRestFilter" runat="server" Text="Reset Filter" CssClass="btn"
						OnClick="btnRestFilter_Click" />
			
		</div>

		<asp:GridView ID="gvSubscriberList" runat="server" AutoGenerateColumns="False" CssClass="common_data_grid table table-bordered"
			OnRowDataBound="gvSubscriberList_RowDataBound" OnRowCommand="gvSubscriberList_RowCommand" style="width:auto">
			<Columns>
				<asp:BoundField DataField="Id" HeaderText="ID" />
				<asp:BoundField DataField="Email" HeaderText="Email" />
				<asp:TemplateField HeaderText="Subscription">
					<ItemTemplate>
						<asp:LinkButton runat="server" ID="lbtnSubscription" CommandName="SubscribeUser"
								CssClass="grid_icon_link" ToolTip="User Subscription"></asp:LinkButton>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Action">
					<ItemTemplate>
						<asp:HyperLink ID="lnkEdit" runat="server" Text="" CssClass="aDialog grid_icon_link edit"
								ToolTip="Edit"></asp:HyperLink>
					</ItemTemplate>
				</asp:TemplateField>
			</Columns>
			<EmptyDataTemplate>
				No Subscribers found.</EmptyDataTemplate>
		</asp:GridView>
		<uc1:Pager ID="pagerSubscribers" runat="server" RecordsPerPage="10" OnPageIndexClickEvent="pagerSubscribers_PageIndexClick" />

		<asp:Panel ID="pnlDownload" runat="server">
			<asp:Button ID="btnDownload" runat="server" CssClass="common_text_button" onclick="btnDownload_Click" Text ="Download Subscribers List" />
		</asp:Panel>
	</div>
</asp:Content>