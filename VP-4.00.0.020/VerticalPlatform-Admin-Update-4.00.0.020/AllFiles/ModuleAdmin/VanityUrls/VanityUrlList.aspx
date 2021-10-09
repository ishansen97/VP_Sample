<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="VanityUrlList.aspx.cs" MasterPageFile="~/MasterPage.Master" 
	 Inherits="VerticalPlatformAdminWeb.ModuleAdmin.VanityUrls.VanityUrlList" %>
<%@ Register Src="../Pager.ascx" TagName="Pager" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>Vanity Url list</h3>
		</div>
		<div class="AdminPanelContent">
		<div class="add-button-container"><asp:HyperLink ID="lnkAddNew" runat="server" CssClass="aDialog btn" style="margin-right:5px;">Add New Vanity Url</asp:HyperLink></div>

		<table class="common_data_grid table table-bordered" cellpadding="0" cellspacing="0" style="width:auto">
					<asp:Repeater ID="rptVanityList" runat="server" OnItemCommand="rptVanityList_ItemCommand"
						OnItemDataBound="rptVanityList_ItemDataBound">
						<HeaderTemplate>
							<asp:TableHeaderRow runat="server" ID="tableCampaignTypeHeaderRow">
								<asp:TableHeaderCell width="150">
									Short Url
								</asp:TableHeaderCell>
								<asp:TableHeaderCell Width="350">
									Redirect Url
								</asp:TableHeaderCell>
								<asp:TableHeaderCell Width="100">
									Views
								</asp:TableHeaderCell>
								<asp:TableHeaderCell Width="100">
									Enabled
								</asp:TableHeaderCell>
								<asp:TableHeaderCell Width="100">
									&nbsp;
								</asp:TableHeaderCell>
							</asp:TableHeaderRow>
						</HeaderTemplate>
						<ItemTemplate>
							<asp:TableRow CssClass="campaignRow" runat="server" ID="tableCampaignTypeRow">
								<asp:TableCell VerticalAlign="top">
									<asp:Label ID="lblShortUrl" runat="server"></asp:Label>
									&nbsp;
								</asp:TableCell>
								<asp:TableCell VerticalAlign="top">
									<asp:Label ID="lblRedirectUrl" runat="server"></asp:Label>
									&nbsp;
								</asp:TableCell>
								<asp:TableCell VerticalAlign="top">
									<asp:Label ID="lblViews" runat="server"></asp:Label>
									&nbsp;
								</asp:TableCell>
								<asp:TableCell VerticalAlign="top">
									<asp:CheckBox ID="chkEnabled" runat="server" Enabled="false" />
									&nbsp;
								</asp:TableCell>
								<asp:TableCell VerticalAlign="top" Width="40px">
									<asp:HyperLink ID="lnkEdit" runat="server" CssClass="aDialog grid_icon_link edit" ToolTip="Edit" Text="Edit" Visible="false"></asp:HyperLink>
									<asp:LinkButton ID="lbtnDelete" runat="server" CommandName="Delete" Text="Delete" ToolTip="Delete" CssClass="grid_icon_link delete" Visible="false"></asp:LinkButton>
								</asp:TableCell>
							</asp:TableRow>
						</ItemTemplate>
					</asp:Repeater>
				</table>

 		<uc1:Pager ID="pagerVanityUrl" runat="server" RecordsPerPage="10" OnPageIndexClickEvent="pagerVanityUrl_IndexClick" />
		</div>
	</div>

</asp:Content>