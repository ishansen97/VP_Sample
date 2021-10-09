<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="GuidedBrowseControl.ascx.cs"
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Category.GuidedBrowseControl" %>
<script type="text/javascript">
		RegisterNamespace("VP.GuidedBrowse");

		$(document).ready(function() {
			$(".campaignRow .Click_btn", this).click(function() {
				$(this).parent().next().toggleClass("expanded");
				$(this).toggleClass("collaps_icon");
			});
		});
</script>
<style type="text/css">
.main-container .main-content .table-bordered .campaignRowContent > td{padding:0px;}
.main-container .main-content .table-bordered .campaignRowContent td{padding:5px;}
</style>
<h4>Guided Browse</h4>
<div class="add-button-container">
<asp:HyperLink ID="lnkAddGuidedBrowse" runat="server" CssClass="aDialog btn">Add Guided Browse</asp:HyperLink>
</div>
<table width="100%" cellpadding="0" cellspacing="0" class="common_data_grid table table-bordered">
			<asp:Repeater ID="rptGuidedBrowse" runat="server" OnItemDataBound="rptGuidedBrowse_ItemDataBound"
				OnItemCommand="rptGuidedBrowse_ItemCommand">
				<HeaderTemplate>
					<asp:TableHeaderRow runat="server" ID="tableCampaignHeaderRow">
						<asp:TableHeaderCell>
							&nbsp;
						</asp:TableHeaderCell>
						<asp:TableHeaderCell>
							Id
						</asp:TableHeaderCell>
						<asp:TableHeaderCell>
							Name
						</asp:TableHeaderCell>
						<asp:TableHeaderCell>
							Prefix
						</asp:TableHeaderCell>
						<asp:TableHeaderCell>
							Suffix
						</asp:TableHeaderCell>
						<asp:TableHeaderCell>
							Naming Rule
						</asp:TableHeaderCell>
						<asp:TableHeaderCell>
							Page Size
						</asp:TableHeaderCell>
						<asp:TableHeaderCell>
							Sort Order
						</asp:TableHeaderCell>
						<asp:TableHeaderCell>
							Starting Method
						</asp:TableHeaderCell>
						<asp:TableHeaderCell>
							&nbsp;
						</asp:TableHeaderCell>
					</asp:TableHeaderRow>
				</HeaderTemplate>
				<ItemTemplate>
					<asp:TableRow CssClass="campaignRow" runat="server" ID="tableCampaignTypeRow">
						<asp:TableCell CssClass="Click_btn" VerticalAlign="top">
							<div>&nbsp;</div>
						</asp:TableCell>
						<asp:TableCell VerticalAlign="top">
							<asp:Label runat="server" ID="lblId"></asp:Label>
							&nbsp;
						</asp:TableCell>
						<asp:TableCell VerticalAlign="top">
							<asp:Label runat="server" ID="lblName"></asp:Label>
							&nbsp;
						</asp:TableCell>
						<asp:TableCell VerticalAlign="top">
							<asp:Label runat="server" ID="lblPrefix"></asp:Label>
							&nbsp;
						</asp:TableCell>
						<asp:TableCell VerticalAlign="top">
							<asp:Label runat="server" ID="lblSuffix"></asp:Label>
							&nbsp;
						</asp:TableCell>
						<asp:TableCell VerticalAlign="top">
							<asp:Label runat="server" ID="lblNamingRule"></asp:Label>
							&nbsp;
						</asp:TableCell>
						<asp:TableCell VerticalAlign="top">
							<asp:Label ID="lblPageSize" runat="server"></asp:Label>
							&nbsp;
						</asp:TableCell>
						<asp:TableCell VerticalAlign="top">
							<asp:Label ID="lblSortOrder" runat="server"></asp:Label>
							&nbsp;
						</asp:TableCell>
						<asp:TableCell VerticalAlign="top">
							<asp:Label ID="lblStartingMethod" runat="server"></asp:Label>
							&nbsp;
						</asp:TableCell>
						<asp:TableCell VerticalAlign="top">
							<asp:Hyperlink ID="guidedBrowseSetting" runat="server" CssClass="aDialog grid_icon_link settings" ToolTip="Settings">Settings</asp:Hyperlink>
							<asp:HyperLink ID="lnkEdit" runat="server" Text="" CssClass="aDialog grid_icon_link edit"
								ToolTip="Edit"></asp:HyperLink>
							<asp:LinkButton ID="lbtnDelete" runat="server" CommandName="DeleteGuidedBrowse" Text=""
								CssClass="grid_icon_link delete" OnClientClick="return confirm('Are you sure you want to remove this guided browse?');"
								ToolTip="Delete"></asp:LinkButton>
						</asp:TableCell>
					</asp:TableRow>
					<tr class="campaignRowContent">
						<td colspan="10" style="padding:0px">
							<div class="content_div clearfix">
								<div class="inner clearfix" style="padding:0 5px">
									<h5>Guided Browse Search Groups</h5>
									<div class="add-button-container"><asp:HyperLink ID="lnkAddSearchGroup" runat="server" CssClass="aDialog btn">Add Search Group</asp:HyperLink></div>
									<asp:GridView ID="gvSearchGroup" runat="server" AutoGenerateColumns="False"
									 CssClass="common_data_grid table table-bordered" OnRowCommand="gvSearchGroup_RowCommand" OnRowDataBound="gvSearchGroup_RowDataBound">
										<Columns>
											<asp:TemplateField  HeaderText="Search Group ID">
												<ItemTemplate>
													<asp:Label ID="lblSearchGroupId" runat="server"></asp:Label>
												</ItemTemplate>
											</asp:TemplateField>
											<asp:TemplateField  HeaderText="Group Name">
												<ItemTemplate>
													<asp:Label ID="lblGroupName" runat="server"></asp:Label>
												</ItemTemplate>
											</asp:TemplateField>
											<asp:TemplateField  HeaderText="Description">
												<ItemTemplate>
													<asp:Label ID="lblGroupDescription" runat="server"></asp:Label>
												</ItemTemplate>
											</asp:TemplateField>
											<asp:TemplateField  HeaderText="Group Prefix">
												<ItemTemplate>
													<asp:Label ID="lblGroupPrefix" runat="server"></asp:Label>
												</ItemTemplate>
											</asp:TemplateField>
											<asp:TemplateField  HeaderText="Group Suffix">
												<ItemTemplate>
													<asp:Label ID="lblGroupSuffix" runat="server"></asp:Label>
												</ItemTemplate>
											</asp:TemplateField>
											<asp:TemplateField  HeaderText="Include All options">
												<ItemTemplate>
													<asp:CheckBox ID="chkIncludeAll" runat="server" Enabled="false"></asp:CheckBox>
												</ItemTemplate>
											</asp:TemplateField>
											<asp:TemplateField  HeaderText="Sort Order">
												<ItemTemplate>
													<asp:Label ID="lblGroupSortOrder" runat="server"></asp:Label>
												</ItemTemplate>
											</asp:TemplateField>
											<asp:TemplateField >
												<ItemTemplate>
													<asp:Hyperlink ID="lnkSearchOptions" runat="server" CssClass="aDialog">Search Options</asp:Hyperlink>
												</ItemTemplate>
											</asp:TemplateField>
											<asp:TemplateField>
												<ItemTemplate>
													<asp:HyperLink ID="lnkEdit" runat="server" Text="" 
													CssClass="aDialog grid_icon_link edit" ToolTip="Edit"></asp:HyperLink>												
													<asp:LinkButton OnClientClick="return confirm('Are you sure you want to remove this search group?');"
														ID="lbtnRemove" runat="server" Text="Remove" CssClass="grid_icon_link delete" CommandName="DeleteSearchGroup"></asp:LinkButton>
												</ItemTemplate>
											</asp:TemplateField>
										</Columns>
										<EmptyDataTemplate>No search groups were found.</EmptyDataTemplate>
									</asp:GridView>
									<br />
								</div>
							</div>
						</td>
					</tr>
				</ItemTemplate>
			</asp:Repeater>
		</table>
<br />
