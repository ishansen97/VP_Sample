<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="Spider.aspx.cs" Inherits="VerticalPlatformAdminWeb.Platform.Task.Spider" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
<script type="text/javascript">
	RegisterNamespace("VP.SpiderActivity");

	$(document).ready(function () {
		$(".spiderIpRow .Click_btn", this).click(function () {
			$(this).parent().next().toggleClass("expanded");
			$(this).toggleClass("collaps_icon");
		});
	});
</script>
<div class="AdminPanelHeader">
	<h3>Current Spider Activity</h3>
</div>
<div id="AdminPanelContent">
	<div class="refresh-button-container">
		<asp:Button ID="refresh" runat="server" CssClass="btn" Style="margin-right: 5px;" Text="Refresh" OnClick = "refresh_Click" />
	</div>
    <br />
    <div class="download-button-container">
		<asp:Button ID="downloadSpiderDetails" runat="server" CssClass="btn" Style="margin-right: 5px;" Text="Download Spider Details" OnClick = "downloadSpiderDetails_Click" />
	</div>
    <br />
       
	<asp:Repeater ID="ipAddressList" runat="server" OnItemDataBound="ipAddressList_ItemDataBound">
		<HeaderTemplate>
			<table width="100%" cellpadding="0" cellspacing="0" class="common_data_grid table table-bordered">
				<asp:TableHeaderRow runat="server" ID="tableCampaignHeaderRow">
					<asp:TableHeaderCell>
						&nbsp;
					</asp:TableHeaderCell>
					<asp:TableHeaderCell>
						<asp:LinkButton ID="ipAddressLink" runat="server" OnClick="ipAddressLink_Click">IP Address</asp:LinkButton>
					</asp:TableHeaderCell>
					<asp:TableHeaderCell>
						<asp:LinkButton ID="countLink" runat="server" OnClick="count_Click">Count</asp:LinkButton>
					</asp:TableHeaderCell>
					<asp:TableHeaderCell>
						IP Group
					</asp:TableHeaderCell>
					<asp:TableHeaderCell>
						Description
					</asp:TableHeaderCell>
					<asp:TableHeaderCell>
						&nbsp;
					</asp:TableHeaderCell>
				</asp:TableHeaderRow>
			</HeaderTemplate>
			<ItemTemplate>
				<asp:TableRow CssClass="spiderIpRow" runat="server" ID="tableSpiderIpRow">
					<asp:TableCell CssClass="Click_btn" VerticalAlign="top">
						<div>&nbsp;</div>
					</asp:TableCell>
					<asp:TableCell VerticalAlign="top">
						<asp:Label runat="server" ID="ipAddressLabel"></asp:Label>
						&nbsp;
					</asp:TableCell>
					<asp:TableCell VerticalAlign="top">
						<asp:Label runat="server" ID="count"></asp:Label>
						&nbsp;
					</asp:TableCell>
					<asp:TableCell VerticalAlign="top">
						<asp:Label runat="server" ID="ipGroup"></asp:Label>
						&nbsp;
					</asp:TableCell>
					<asp:TableCell VerticalAlign="top">
						<asp:Label runat="server" ID="description"></asp:Label>
						&nbsp;
					</asp:TableCell>
					<asp:TableCell VerticalAlign="top">
						<asp:HyperLink ID="add" runat="server" CssClass="aDialog grid_icon_link add"
							ToolTip="Add">Add</asp:HyperLink>&nbsp;
						<asp:HyperLink ID="edit" runat="server" CssClass="aDialog grid_icon_link edit"
							ToolTip="Edit">Edit</asp:HyperLink>&nbsp;
                        <asp:HyperLink ID="lookup" runat="server" CssClass="aDialog grid_icon_link preview"
							ToolTip="Lookup">Lookup</asp:HyperLink>&nbsp;
					</asp:TableCell>
				</asp:TableRow>
				<tr class="campaignRowContent ipGroupRowContent">
					<td colspan="10" style="padding:0px">
						<div class="content_div clearfix">
							<div class="inner clearfix" style="padding:0 5px">
								<asp:GridView ID="IpRequestDetailsList" runat="server" AutoGenerateColumns="false" CssClass = "common_data_grid table table-bordered"
									OnRowDataBound="IpRequestDetailsList_RowDataBound">
									<Columns>
										<asp:TemplateField HeaderText="Fixed URL" ItemStyle-Width="340">
											<ItemTemplate>
												<asp:Label ID="fixedUrl" runat="server"></asp:Label>
											</ItemTemplate>
										</asp:TemplateField>
										<asp:TemplateField HeaderText="Count">
											<ItemTemplate>
												<asp:Label ID="count" runat="server"></asp:Label>
											</ItemTemplate>
										</asp:TemplateField>
										<asp:TemplateField HeaderText="User Agents">
											<ItemTemplate>
												<asp:Label ID="userAgent" runat="server"></asp:Label>
											</ItemTemplate>
										</asp:TemplateField>
									</Columns>
								</asp:GridView>
								<br />
							</div>
						</div>
					</td>
				</tr>
			</ItemTemplate>
		<FooterTemplate>
			</table>
		</FooterTemplate>
	</asp:Repeater>
	<asp:Label ID="emptyData" Text="Not analyzing requests at this time." runat="server" Visible="true">
	</asp:Label>
</div>
</asp:Content>
