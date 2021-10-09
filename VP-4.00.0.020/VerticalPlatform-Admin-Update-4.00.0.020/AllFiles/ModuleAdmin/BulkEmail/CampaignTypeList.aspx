<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CampaignTypeList.aspx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.BulkEmail.CampaignTypeList" MasterPageFile="~/MasterPage.Master" %>

<%@ Register Src="../Pager.ascx" TagName="Pager" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">

	<script type="text/javascript">
		$(document).ready(function() {
			$(".campaignRow .Click_btn",this).click(function() {
				$(this).parent().next().toggleClass("expanded");
				$(this).toggleClass("collaps_icon");
			});
			
		});
	</script>

	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>
				<asp:Label ID="lblTitle" runat="server"></asp:Label>
			</h3>
		</div>
		<div class="AdminPanelContent">
			<div class="add-button-container"><asp:HyperLink ID="lnkAddCampaignType" runat="server" CssClass="aDialog btn"
				Text="Add Campaign Type"></asp:HyperLink></div>
			
			<div style="overflow-x: scroll;">
				<table class="common_data_grid table table-bordered" width="100%" cellpadding="0" cellspacing="0">
					<asp:Repeater ID="rptCampaignTypeList" runat="server" OnItemCommand="rptCampaignTypeList_ItemCommand"
						OnItemDataBound="rptCampaignTypeList_ItemDataBound">
						<HeaderTemplate>
							<asp:TableHeaderRow runat="server" ID="tableCampaignTypeHeaderRow">
								<asp:TableHeaderCell>
									&nbsp;
								</asp:TableHeaderCell>
								<asp:TableHeaderCell >
									<asp:LinkButton ID="lbtnId" runat="server" OnClick="lbtnId_Click">
										Id
									</asp:LinkButton>
								</asp:TableHeaderCell>
								<asp:TableHeaderCell>
									<asp:LinkButton ID="lbtnCampaignType" runat="server" OnClick="lbtnCampaignType_Click">
										Campaign Type
									</asp:LinkButton>
								</asp:TableHeaderCell>
								<asp:TableHeaderCell>
									<asp:LinkButton ID="lbtnEmailTemplate" runat="server" OnClick="lbtnEmailTemplate_Click">
										Bulk Email Type
									</asp:LinkButton>
								</asp:TableHeaderCell>
								<asp:TableHeaderCell>
									<b>Enabled</b>
								</asp:TableHeaderCell>
								<asp:TableHeaderCell>
									<b>Email Provider</b>
								</asp:TableHeaderCell>
								<asp:TableHeaderCell>
									<b>Templates</b>
								</asp:TableHeaderCell>
								<asp:TableHeaderCell>
									<b>Campaign Schedule</b>
								</asp:TableHeaderCell>
								<asp:TableHeaderCell>
									<b>Content Groups</b>
								</asp:TableHeaderCell>
								<asp:TableHeaderCell>
									<b>Campaigns</b>
								</asp:TableHeaderCell>
								<asp:TableHeaderCell>
									<asp:LinkButton ID="lbtnCreated" runat="server" OnClick="lbtnCreated_Click">
										Created
									</asp:LinkButton>
								</asp:TableHeaderCell>
								<asp:TableHeaderCell>
									<asp:LinkButton ID="lbtnModified" runat="server" OnClick="lbtnModified_Click">
										Last Modified
									</asp:LinkButton>
								</asp:TableHeaderCell>
								<asp:TableHeaderCell>
									&nbsp;
								</asp:TableHeaderCell>
							</asp:TableHeaderRow>
						</HeaderTemplate>
						<ItemTemplate>
							<asp:TableRow CssClass="campaignRow" runat="server" ID="tableCampaignTypeRow">
								<asp:TableCell CssClass="Click_btn" VerticalAlign="top" >
									<div>&nbsp;</div>
								</asp:TableCell>
								<asp:TableCell VerticalAlign="top">
									<asp:Label ID="lblCampaignTypeId" runat="server"></asp:Label>
									&nbsp;
								</asp:TableCell>
								<asp:TableCell VerticalAlign="top">
									<asp:Label ID="lblCampaignType" runat="server"></asp:Label>
									&nbsp;
								</asp:TableCell>
								<asp:TableCell VerticalAlign="top">
									<asp:Label ID="lblBulkEmailType" runat="server"></asp:Label>
									&nbsp;
								</asp:TableCell>
								<asp:TableCell VerticalAlign="top">
									<asp:CheckBox runat="server" ID="chkEnable" Enabled="false" />
									&nbsp;
								</asp:TableCell>
								<asp:TableCell VerticalAlign="top">
									<asp:Label ID="lblEmailProvider" runat="server"></asp:Label>
									&nbsp;
								</asp:TableCell>
								<asp:TableCell VerticalAlign="top">
									<asp:HyperLink ID="lnkEmailTemplates" runat="server" CssClass="aDialog campaign_list_template_list">Templates</asp:HyperLink>
									<asp:Literal ID="ltrEmailTemplates" runat="server"></asp:Literal>
									&nbsp;
								</asp:TableCell>
								<asp:TableCell VerticalAlign="top">
									<asp:HyperLink ID="lnkCampaignSchedule" runat="server" CssClass="aDialog">Schedule</asp:HyperLink>
									&nbsp;
								</asp:TableCell>
								<asp:TableCell VerticalAlign="top">
									<asp:HyperLink ID="lnkContentGroups" runat="server" CssClass="aDialog">Content Groups</asp:HyperLink>
									&nbsp;
								</asp:TableCell>
								<asp:TableCell VerticalAlign="top">
									<asp:HyperLink ID="lnkCampaigns" runat="server">Campaigns</asp:HyperLink>
									&nbsp;
								</asp:TableCell>
								<asp:TableCell VerticalAlign="top">
									<asp:Label ID="lblCreated" runat="server"></asp:Label>
									&nbsp;
								</asp:TableCell>
								<asp:TableCell VerticalAlign="top">
									<asp:Label ID="lblModified" runat="server"></asp:Label>
									&nbsp;
								</asp:TableCell>
								<asp:TableCell VerticalAlign="top">
									<asp:HyperLink ID="lnkEdit" runat="server" CssClass="aDialog grid_icon_link edit"
										ToolTip="Edit" Text=""></asp:HyperLink>
									<asp:LinkButton ID="lbtnDelete" runat="server"
										CommandName="DeleteCampaignType" Text="" CssClass="grid_icon_link delete" ToolTip="Delete"></asp:LinkButton>
									<asp:LinkButton ID="lbtnClone" runat="server"
										CommandName="CloneCampaignType" Text="" CssClass="grid_icon_link duplicate" ToolTip="Clone"></asp:LinkButton>
									&nbsp;
								</asp:TableCell>
							</asp:TableRow>
							<tr class="campaignRowContent">
								<td colspan="20">
									<div class="content_div clearfix">
										<div class="inner clearfix">
											<asp:Literal runat="server" ID="ltrlSummary"></asp:Literal>
										</div>
									</div>
								</td>
							</tr>
						</ItemTemplate>
					</asp:Repeater>
				</table>
			</div>
			<uc1:Pager ID="pagerCampaignType" runat="server" OnPageIndexClickEvent="pagerCampaignType_PageIndexClick"
				RecordsPerPage="10" />
		</div>
	</div>
</asp:Content>
