<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="VendorReportsControl.ascx.cs" 
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Vendors.VendorReportsControl" %>
	<%@ Register Src="../Pager.ascx" TagName="Pager" TagPrefix="uc1" %>
	
<script src="../../Js/ContentPicker.js" type="text/javascript"></script>
<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>
<script src="../../Js/JQuery/jquery.pager.js" type="text/javascript"></script>
		<script src="../../Js/ArticleEditor/ArticleList.js" type="text/javascript"></script>
<script type="text/javascript">
	RegisterNamespace("VP.VendorCampaignContentReport");

	VP.VendorCampaignContentReport.Initialize = function() {
		$(document).ready(function() {
			$(".campaignRow .Click_btn", this).click(function() {
				$(this).parent().next().toggleClass("expanded");
				$(this).toggleClass("collaps_icon");
			});

			$(".reports a.active").addClass("selected");

			$(".article_srh_btn").click(function() {
				$(".article_srh_pane").toggle("slow");
				$(this).toggleClass("hide_icon");
				$("#divSearchCriteria").toggleClass("hide");
			});
		});

		VP.VendorCampaignContentReport.GetSearchCriteriaText = function() {
			var txtDateFrom = $("input[id$='txtStartDate']");
			var txtDateTo = $("input[id$='txtEndDate']");
			
			if (txtDateFrom.val().trim().length > 0) {
				searchHtml += " ; <b>From</b> : " + txtDateFrom.val().trim();
			}
			
			if (txtDateTo.val().trim().length > 0) {
				searchHtml += " ; <b>To</b> : " + txtDateTo.val().trim();
			}
			
			searchHtml = searchHtml.replace(' ;', '(');
			if (searchHtml != "") {
				searchHtml += " )";
			}
			return searchHtml;
		};
	}
	VP.VendorCampaignContentReport.Initialize();
	
</script>
<h4>Vendor Associated Campaigns</h4>
<asp:HyperLink ID="lnkAddCampaign" runat="server" Text="Add Campaign" CssClass="btn aDialog"></asp:HyperLink>
<br />
<br />
	<div class="campaign_summary clearfix">
		<div class="left reports">
			<ul>
				<li>
					<asp:LinkButton ID="lbtnScheduledCampaigns" runat="server" CommandArgument="All" 
					onclick="lbtn_Click" >All Vendor Related Campaigns</asp:LinkButton>
				</li>
				<li>
					<asp:LinkButton ID="lbtnContentAssociatedCampaigns" runat="server" CommandArgument="Content"
					onclick="lbtn_Click">Campaign Content Report</asp:LinkButton>
				</li>
				<li>
					<asp:LinkButton ID="lbtnVendorSpecificCampaigns" runat="server" CommandArgument="Specific"
					onclick="lbtn_Click">Vendor Specific Campaigns Report</asp:LinkButton>    
				</li>
			</ul>
		</div>
		<div class="content">
			<div class="article_srh_btn">Filter</div>
			<div id="divSearchCriteria"></div>
			<div id="divSearchPane" class="article_srh_pane" style="display: none;">
                <div class="inline-form-container">
                    <span class="title">Date Range</span>
                    <div class="input-prepend">
                        <span class="add-on">From</span><asp:TextBox CssClass="txtStartDate" ID="txtStartDate" runat="server" Width="150px" ValidationGroup="FilterList"></asp:TextBox>
                    </div>
                    <div class="input-prepend">
                        <span class="add-on">To</span><asp:TextBox CssClass="txtEndDate" ID="txtEndDate" runat="server" Width="150px" ValidationGroup="FilterList"></asp:TextBox>
                    </div>
                    <asp:Button ID="btnfilter" runat="server" Text="Filter" ValidationGroup="FilterList" CssClass="btn" onclick="btnfilter_Click" />
					<asp:Button ID="btnReset" runat="server" Text="Reset"  CssClass="btn" onclick="btnReset_Click" />
                </div>
		
			</div>

			<div><asp:Literal ID="ltlTotalCount" runat="server"></asp:Literal></div>
			<br />
			<table width="100%" cellpadding="0" cellspacing="0" class="common_data_grid table table-bordered">
					<asp:Repeater ID="rptCampaignList" runat="server" 
						onitemdatabound="rptCampaignList_ItemDataBound">
						<HeaderTemplate>
							<asp:TableHeaderRow runat="server" ID="tableCampaignHeaderRow">
								<asp:TableHeaderCell>
									&nbsp;
								</asp:TableHeaderCell>
								<asp:TableHeaderCell>
									<asp:Label ID="lblId" runat="server">
										Id
									</asp:Label>
								</asp:TableHeaderCell>
								<asp:TableHeaderCell>
									<asp:Label ID="lblCampaign" runat="server">
										Campaign Name
									</asp:Label>
								</asp:TableHeaderCell>
								<asp:TableHeaderCell>
									<asp:Label ID="lblType" runat="server">
										Campaign Type
									</asp:Label>
								</asp:TableHeaderCell>
								<asp:TableHeaderCell>
									<asp:Label ID="lblSDate" runat="server">
										Scheduled Date
									</asp:Label>
								</asp:TableHeaderCell>
								<asp:TableHeaderCell>
									<asp:Label ID="lblResDate" runat="server">
										Rescheduled Date
									</asp:Label>
								</asp:TableHeaderCell>
								<asp:TableHeaderCell>
									<asp:Label ID="lblDDate" runat="server">
										Deployed Date
									</asp:Label>
								</asp:TableHeaderCell>
								<asp:TableHeaderCell>
									<asp:Label ID="lblCampaignEnabled" runat="server">
										Enabled
									</asp:Label>
								</asp:TableHeaderCell>
								<asp:TableHeaderCell>
									<asp:Label ID="lblCampaignStatus" runat="server">
										Status
									</asp:Label>
								</asp:TableHeaderCell>
							</asp:TableHeaderRow>
						</HeaderTemplate>
						<ItemTemplate>
							<asp:TableRow CssClass="campaignRow" runat="server" ID="tableCampaignTypeRow">
								<asp:TableCell CssClass="Click_btn" VerticalAlign="top" ID="tblColClick">
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
									<asp:Label runat="server" ID="lblCampaignType"></asp:Label>
									&nbsp;
								</asp:TableCell>
								<asp:TableCell VerticalAlign="top">
									<asp:Label runat="server" ID="lblScheduledDate"></asp:Label>
									&nbsp;
								</asp:TableCell>
								<asp:TableCell VerticalAlign="top">
									<asp:Label runat="server" ID="lblRescheduledDate"></asp:Label>
									&nbsp;
								</asp:TableCell>
								<asp:TableCell VerticalAlign="top">
									<asp:Label runat="server" ID="lblDeployedDate"></asp:Label>
									&nbsp;
								</asp:TableCell>
								<asp:TableCell VerticalAlign="top">
									<asp:Label runat="server" ID="lblEnabled"></asp:Label>
									&nbsp;
								</asp:TableCell>
								<asp:TableCell VerticalAlign="top">
									<asp:Label runat="server" ID="lblStatus"></asp:Label>
									&nbsp;
								</asp:TableCell>
							</asp:TableRow>
							<tr class="campaignRowContent">
								<td colspan="200">
									<div class="content_div clearfix">
										<div class="inner clearfix">
											<asp:Literal runat="server" ID="ltlSummary"></asp:Literal>
										</div>
									</div>
								</td>
							</tr>
						</ItemTemplate>
					</asp:Repeater>
				</table>
				<uc1:Pager ID="pagerReport" runat="server" OnPageIndexClickEvent="pagerReport_PageIndexClick"/>
				<br />
				<asp:Label ID="lblMessage" runat="server" />
				<br />
				<asp:HiddenField ID="hdnCurrentCommand" runat="server" />
			
		</div>
	
	</div>
	
	

