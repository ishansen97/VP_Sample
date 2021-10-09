<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="VendorAssociatedArticles.ascx.cs" 
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Vendors.VendorAssociatedArticles" %>
<%@ Register Src="../Pager.ascx" TagName="Pager" TagPrefix="uc1" %>

<script src="../../Js/ContentPicker.js" type="text/javascript"></script>
<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>
<script src="../../Js/JQuery/jquery.pager.js" type="text/javascript"></script>

<script type="text/javascript">
	RegisterNamespace("VP.VendorArticles");

	VP.VendorArticles.Initialize = function() {
		$(document).ready(function() {
			$(".articleTypeRow .Click_btn", this).live('click', function() {
				$(this).parent().next().toggleClass("expanded");
				$(this).toggleClass("collaps_icon");
			});
		});
	}

	VP.VendorArticles.Initialize();
</script>
<div>
	<table width="100%" cellpadding="0" cellspacing="0" class="common_data_grid table table-bordered">
		<asp:Repeater ID="rptArticleList" runat="server" 
			onitemdatabound="rptArticleList_ItemDataBound">
			<HeaderTemplate>
				<asp:TableHeaderRow runat="server" ID="tableCampaignHeaderRow">
					<asp:TableHeaderCell Width="30">
						&nbsp;
					</asp:TableHeaderCell>
					<asp:TableHeaderCell Width="50">
						<asp:Label ID="lblId" runat="server">
							Id
						</asp:Label>
					</asp:TableHeaderCell>
					<asp:TableHeaderCell>
						<asp:Label ID="lbltype" runat="server">
							Article Type
						</asp:Label>
					</asp:TableHeaderCell>
					<asp:TableHeaderCell  Width="100">
						<asp:Label ID="lblcount" runat="server">
							Number of Articles
						</asp:Label>
					</asp:TableHeaderCell>
				</asp:TableHeaderRow>
			</HeaderTemplate>
			<ItemTemplate>
				<asp:TableRow CssClass="articleTypeRow" runat="server" ID="tableArticleTypeRow">
					<asp:TableCell CssClass="Click_btn" VerticalAlign="top" ID="tblColClick">
						<div>&nbsp;</div>
					</asp:TableCell>
					<asp:TableCell VerticalAlign="top">
						<asp:Label runat="server" ID="lblId"></asp:Label>
						&nbsp;
					</asp:TableCell>
					<asp:TableCell VerticalAlign="top">
						<asp:Label runat="server" ID="lblArticleType"></asp:Label>
						&nbsp;
					</asp:TableCell>
					<asp:TableCell VerticalAlign="top">
						<asp:Label runat="server" ID="lblArticleCount"></asp:Label>
					</asp:TableCell>
				</asp:TableRow>
				<tr class="campaignRowContent">
					<td colspan="200">
						<div class="content_div clearfix">
							<div class="inner clearfix" style="padding:10px;">
								<asp:GridView ID="gvArticleList" OnRowDataBound="gvArticleList_RowDataBound" 
								runat="server" AutoGenerateColumns="False" CssClass="common_data_grid table table-bordered">
								<Columns>
									<asp:BoundField HeaderText="Associated Article Id" DataField="Id" />
									<asp:BoundField HeaderText="Article Title" DataField="Title" />
									<asp:BoundField HeaderText="Article Short Title" DataField="ShortTitle" />
									<asp:BoundField HeaderText="Article Summary" DataField="Summary" />
									<asp:BoundField HeaderText="Enabled" DataField="Enabled" />
									<asp:BoundField HeaderText="Created" DataField="Created" />
									<asp:TemplateField HeaderText="Unpublished Date">
										<ItemTemplate>
											<asp:Label ID="unpublishedDate" runat="server" ItemStyle-Width="50"></asp:Label>
										</ItemTemplate>
									</asp:TemplateField>
									<asp:TemplateField>
										<ItemTemplate>
											<asp:HyperLink ID="lnkEdit" runat="server" CssClass="grid_icon_link edit" ToolTip="Edit">Edit</asp:HyperLink>
										</ItemTemplate>
									</asp:TemplateField>
								</Columns>
								<EmptyDataTemplate>
									No Associated Articles were found.
								</EmptyDataTemplate>
								</asp:GridView>
							</div>
						</div>
					</td>
				</tr>
			</ItemTemplate>
		</asp:Repeater>
	</table>
</div>
<br />
<br />

