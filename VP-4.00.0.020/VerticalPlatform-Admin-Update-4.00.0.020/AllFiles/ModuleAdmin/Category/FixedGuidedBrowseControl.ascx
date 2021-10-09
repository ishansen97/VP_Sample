<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="FixedGuidedBrowseControl.ascx.cs"
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Category.FixedGuidedBrowseControl" %>
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
<h4>    Fixed Guided Browse</h4>
<div class="add-button-container">
    <asp:HyperLink ID="addFixedGuidedBrowse" runat="server" CssClass="aDialog btn">Add Fixed Guided Browse</asp:HyperLink>
</div>
<table width="100%" cellpadding="0" cellspacing="0" class="common_data_grid table table-bordered">
	<asp:Repeater ID="guidedBrowse" runat="server" OnItemDataBound="rptGuidedBrowse_ItemDataBound"
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
					Secondary Naming Rule
				</asp:TableHeaderCell>
				<asp:TableHeaderCell>
					Embedded Categories
				</asp:TableHeaderCell>
				<asp:TableHeaderCell>
					Page Size
				</asp:TableHeaderCell>
				<asp:TableHeaderCell>
					Load On-Demand
				</asp:TableHeaderCell>
				<asp:TableHeaderCell>
					Include in Sitemap
				</asp:TableHeaderCell>
				<asp:TableHeaderCell>
					Exclude Primary Options
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
					<asp:Label runat="server" ID="fgbId"></asp:Label>
					&nbsp;
				</asp:TableCell>
				<asp:TableCell VerticalAlign="top">
					<asp:Label runat="server" ID="name"></asp:Label>
					&nbsp;
				</asp:TableCell>
				<asp:TableCell VerticalAlign="top">
					<asp:Label runat="server" ID="prefix"></asp:Label>
					&nbsp;
				</asp:TableCell>
				<asp:TableCell VerticalAlign="top">
					<asp:Label runat="server" ID="suffix"></asp:Label>
					&nbsp;
				</asp:TableCell>
				<asp:TableCell VerticalAlign="top">
					<asp:Label runat="server" ID="namingRule"></asp:Label>
					&nbsp;
				</asp:TableCell>
				<asp:TableCell VerticalAlign="top">
					<asp:Label runat="server" ID="secondaryNamingRule"></asp:Label>
					&nbsp;
				</asp:TableCell>
				<asp:TableCell VerticalAlign="top">
					<asp:PlaceHolder ID="embeddedCategories" runat="server"></asp:PlaceHolder>
					&nbsp;
				</asp:TableCell>
				<asp:TableCell VerticalAlign="top">
					<asp:Label ID="segmentSize" runat="server"></asp:Label>
					&nbsp;
				</asp:TableCell>
				<asp:TableCell VerticalAlign="top">
					<asp:CheckBox ID="isDynamic" runat="server" Enabled="false"></asp:CheckBox>
					&nbsp;
				</asp:TableCell>
				<asp:TableCell VerticalAlign="top">
					<asp:CheckBox ID="includeInSitemap" runat="server" Enabled="false"></asp:CheckBox>
					&nbsp;
				</asp:TableCell>
				<asp:TableCell VerticalAlign="top">
					<asp:CheckBox ID="excludePrimaryOptions" runat="server" Enabled="false"></asp:CheckBox>
					&nbsp;
				</asp:TableCell>
				<asp:TableCell VerticalAlign="top">
					<asp:Hyperlink ID="guidedBrowseSetting" runat="server" CssClass="aDialog grid_icon_link settings" ToolTip="Settings">Settings</asp:Hyperlink>
					<asp:HyperLink ID="edit" runat="server" Text="" CssClass="aDialog grid_icon_link edit"
						ToolTip="Edit"></asp:HyperLink>
					<asp:LinkButton ID="delete" runat="server" CommandName="DeleteFixedGuidedBrowse" Text=""
						CssClass="grid_icon_link delete" OnClientClick="return confirm('Are you sure you want to remove this fixed guided browse?');"
						ToolTip="Delete"></asp:LinkButton>
					<asp:LinkButton ID="rebuild" runat="server" CommandName="RebuildFixedGuidedBrowse" Text=""
						CssClass="grid_icon_link reset" ToolTip="Rebuild Fixed Guided Browse Links"></asp:LinkButton>
				</asp:TableCell>
			</asp:TableRow>
			<tr class="campaignRowContent">
				<td colspan="12" style="padding:0px">
					<div class="content_div clearfix">
						<div class="inner clearfix" style="padding:0 5px">
							<h5>Fixed Guided Browse Search Groups</h5>
							<div class="add-button-container"><asp:HyperLink ID="lnkAddSearchGroup" runat="server" CssClass="aDialog btn">Add Search Group</asp:HyperLink></div>
							<asp:GridView ID="searchGroup" runat="server" AutoGenerateColumns="False"
								CssClass="common_data_grid table table-bordered" OnRowCommand="gvSearchGroup_RowCommand" OnRowDataBound="gvSearchGroup_RowDataBound">
								<Columns>
									<asp:TemplateField  HeaderText="Search Group ID">
										<ItemTemplate>
											<asp:Label ID="searchGroupId" runat="server"></asp:Label>
										</ItemTemplate>
									</asp:TemplateField>
									<asp:TemplateField  HeaderText="Group Name">
										<ItemTemplate>
											<asp:Label ID="groupName" runat="server"></asp:Label>
										</ItemTemplate>
									</asp:TemplateField>
									<asp:TemplateField  HeaderText="Description">
										<ItemTemplate>
											<asp:Label ID="groupDescription" runat="server"></asp:Label>
										</ItemTemplate>
									</asp:TemplateField>
									<asp:TemplateField  HeaderText="Group Prefix">
										<ItemTemplate>
											<asp:Label ID="groupPrefix" runat="server"></asp:Label>
										</ItemTemplate>
									</asp:TemplateField>
									<asp:TemplateField  HeaderText="Group Suffix">
										<ItemTemplate>
											<asp:Label ID="groupSuffix" runat="server"></asp:Label>
										</ItemTemplate>
									</asp:TemplateField>
									<asp:TemplateField  HeaderText="Include All options">
										<ItemTemplate>
											<asp:CheckBox ID="includeAll" runat="server" Enabled="false"></asp:CheckBox>
										</ItemTemplate>
									</asp:TemplateField>
									<asp:TemplateField  HeaderText="Sort Order">
										<ItemTemplate>
											<asp:Label ID="groupSortOrder" runat="server"></asp:Label>
										</ItemTemplate>
									</asp:TemplateField>
									<asp:TemplateField  HeaderText="Navigation Type">
										<ItemTemplate>
											<asp:Label ID="navigationType" runat="server"></asp:Label>
										</ItemTemplate>
									</asp:TemplateField>
									<asp:TemplateField  HeaderText="List Type">
										<ItemTemplate>
											<asp:Label ID="listType" runat="server"></asp:Label>
										</ItemTemplate>
									</asp:TemplateField>
									<asp:TemplateField >
										<ItemTemplate>
											<asp:Hyperlink ID="searchOptions" runat="server" CssClass="aDialog">Search Options</asp:Hyperlink>
										</ItemTemplate>
									</asp:TemplateField>
									<asp:TemplateField>
										<ItemTemplate>
											<asp:HyperLink ID="edit" runat="server" Text="" 
											CssClass="aDialog grid_icon_link edit" ToolTip="Edit"></asp:HyperLink>												
											<asp:LinkButton OnClientClick="return confirm('Are you sure you want to remove this search group?');"
												ID="remove" runat="server" Text="Remove" CssClass="grid_icon_link delete" CommandName="DeleteSearchGroup"></asp:LinkButton>
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
