<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="BulkEmailReport.aspx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.BulkEmail.BulkEmailReport" MasterPageFile="~/MasterPage.Master" %>

<%@ Register Src="../Pager.ascx" TagName="Pager" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
	<script src="../../Js/JQuery/tooltip.min.js" type="text/javascript"></script>
	<script src="../../Js/ContentPicker.js" type="text/javascript"></script>
	<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>
	<script type="text/javascript">
		RegisterNamespace("VP.Campaign");
		$(document).ready(function () {
			$(".campaign_srh_btn").click(function () {
				$(".campaign_srh_pane").toggle("slow");
				$(this).toggleClass("hide_icon");
				$("#divSearchCriteria").toggleClass("hide");
			});

			$("#divSearchCriteria").append(VP.Campaign.GetSearchCriteriaText());

			var vendorIdOptions = { siteId: VP.SiteId, type: "Vendor", currentPage: "1", pageSize: "15" };
			$("input[type=text][id*=txtVendorId]").contentPicker(vendorIdOptions);

			var campaignIdElement = { contentId: "txtCampaignId" };
			var campaignNameElement = { contentName: "txtCampaignName" };
			var campaignNameOptions = { siteId: VP.SiteId, type: "Campaign", currentPage: "1", campaignTypeElementId: "ctl00_cphContent_ddlCampaignType",
				pageSize: "15", showName: "true", bindings: campaignIdElement
			};
			$("input[type=text][id*=txtCampaignName]").contentPicker(campaignNameOptions);

			$(".campaignRow .Click_btn", this).click(function () {
				var summaryDiv = $(this).parent().next().find('div.content_div');
				var campaignId = $(this).next().next().text();

				if ($(summaryDiv).children().length == 0) {
					VP.Campaign.Summary(campaignId, summaryDiv);
				}

				$(this).parent().next().toggleClass("expanded");
				$(this).toggleClass("collaps_icon");
			});
		});

		VP.Campaign.GetSearchCriteriaText = function () {
			var ddlType = $("select[id$='ddlCampaignType']");
			var txtCampaignName = $("input[id$='txtCampaignName']");
			var txtCampaignId = $("input[id$='txtCampaignId']");
			var txtVendorId = $("input[id$='txtVendorId']");

			var searchHtml = "";
			if (ddlType.val() != "-1") {
				searchHtml += " ; <b>Type</b> : " + $("option[selected]", ddlType).text();
			}

			if (txtCampaignName.val().trim().length > 0) {
				searchHtml += " ; <b>Campaign</b> : " + txtCampaignName.val().trim();
			}

			if (txtCampaignId.val().trim().length > 0) {
				searchHtml += " ; <b>Campaign Id</b> : " + txtCampaignId.val().trim();
			}

			if (txtVendorId.val().trim().length > 0) {
				searchHtml += " ; <b>Vendor</b> : " + txtVendorId.val().trim();
			}

			searchHtml = searchHtml.replace(' ;', '(');
			if (searchHtml != "") {
				searchHtml += " )";
			}

			return searchHtml;
		};

		VP.Campaign.Summary = function (campaignId, summaryDiv) {
			$.ajax({
				type: "POST",
				async: false,
				cache: false,
				url: VP.ApplicationRoot + "Services/BulkEmailWebService.asmx" + "/GetCampaignSummary",
				data: "{'campaignId' : " + campaignId + "}",
				contentType: "application/json; charset=utf-8",
				dataType: "json",
				success: function (msg) {
					$(summaryDiv).html(msg.d);
				},
				error: function (xmlHttpRequest, textStatus, errorThrown) {
					document.location = "../../Error.aspx";
				}
			});
		};
	</script>
	<script type="text/javascript">
		$(document).ready(function () {
			$(".lnkBounces[title], .lnkOpens[title], .lnkClicks[title], .lnkUnsubscribes[title]").tooltip({ position: "bottom center", opacity: 0.8 });
		});
	</script>
	<div class="AdminPanelHeader">
		<h3>
			Campaign Report</h3>
	</div>
	<div class="AdminPanelContent">
		<div class="campaign_srh_btn">
			Search</div>
		<div id="divSearchCriteria">
		</div>
        <br />
		<div id="divSearchPane" class="campaign_srh_pane" style="display: none;">
			<table>
				<tr>
					<td>
						<asp:Literal ID="ltlCampaignType" runat="server" Text="Campaign Type"></asp:Literal>
					</td>
					<td>
						<asp:DropDownList ID="ddlCampaignType" runat="server">
						</asp:DropDownList>
					</td>
				</tr>
				<tr>
					<td>
						<asp:Literal ID="ltlCampaignName" runat="server" Text="Campaign Name"></asp:Literal>
					</td>
					<td>
						<asp:TextBox ID="txtCampaignName" runat="server" MaxLength="255" Width="150px"></asp:TextBox>
					</td>
				</tr>
				<tr>
					<td>
						<asp:Literal ID="ltlCampaignId" runat="server" Text="Campaign Id"></asp:Literal>
					</td>
					<td>
						<asp:TextBox ID="txtCampaignId" runat="server" MaxLength="255" Width="150px"></asp:TextBox>
						<asp:CompareValidator ID="cvCampaignId" runat="server" ControlToValidate="txtCampaignId"
							ValidationGroup="FilterList" ErrorMessage="Please enter a number for campaign id."
							Type="Integer" Operator="DataTypeCheck">*</asp:CompareValidator>
					</td>
				</tr>
				<tr>
					<td>
						<asp:Literal ID="ltlVendorId" runat="server" Text="Vendor"></asp:Literal>
					</td>
					<td>
						<asp:TextBox ID="txtVendorId" runat="server" MaxLength="255" Width="150px"></asp:TextBox>
						<asp:CompareValidator ID="cvVendorId" runat="server" ControlToValidate="txtVendorId"
							ValidationGroup="FilterList" ErrorMessage="Please enter a number for vendor id."
							Type="Integer" Operator="DataTypeCheck">*</asp:CompareValidator>
					</td>
				</tr>
				<tr>
					<td>
						<asp:Button ID="btnApply" runat="server" Text="Apply" ValidationGroup="FilterList" OnClick="btnApply_Click" CssClass="common_text_button" />
						<asp:Button ID="btnRestFilter" runat="server" Text="Reset Filter" OnClick="btnRestFilter_Click"
							CssClass="common_text_button" />
					</td>
				</tr>
			</table>
		</div>
		<br />
		<br />
		<table width="100%" cellpadding="0" cellspacing="0" class="common_data_grid table table-bordered">
			<asp:Repeater ID="bulkEmailReport" runat="server" OnItemDataBound="BulkEmailReport_ItemDataBound"
				OnItemCommand="BulkEmailReport_ItemCommand">
				<HeaderTemplate>
					<asp:TableHeaderRow runat="server" ID="tableCampaignReportHeaderRow">
						<asp:TableHeaderCell>
							&nbsp;
						</asp:TableHeaderCell>
						<asp:TableHeaderCell>
							<asp:LinkButton ID="campaignType" runat="server" OnClick="CampaignType_Click">
								Campaign Type
							</asp:LinkButton>
						</asp:TableHeaderCell>
						<asp:TableHeaderCell>
							<asp:LinkButton ID="campaignId" runat="server" OnClick="CampaignId_Click">
								Campaign ID
							</asp:LinkButton>
						</asp:TableHeaderCell>
						<asp:TableHeaderCell>
							<asp:LinkButton ID="campaign" runat="server" OnClick="Campaign_Click">
								Campaign
							</asp:LinkButton>
						</asp:TableHeaderCell>
						<asp:TableHeaderCell>
							<asp:LinkButton ID="deployDate" runat="server" OnClick="DeployDate_Click">
								Deploy Date
							</asp:LinkButton>
						</asp:TableHeaderCell>
						<asp:TableHeaderCell>
							<asp:LinkButton ID="totalSent" runat="server" OnClick="TotalSent_Click">
								Total Sent
							</asp:LinkButton>
						</asp:TableHeaderCell>
						<asp:TableHeaderCell>
							<asp:LinkButton ID="bounces" runat="server" OnClick="Bounces_Click">
								Bounces
							</asp:LinkButton>
						</asp:TableHeaderCell>
						<asp:TableHeaderCell>
							<asp:LinkButton ID="opens" runat="server" OnClick="Opens_Click">
								Opens
							</asp:LinkButton>
						</asp:TableHeaderCell>
						<asp:TableHeaderCell>
							<asp:LinkButton ID="clicks" runat="server" OnClick="Clicks_Click">
								Clicks
							</asp:LinkButton>
						</asp:TableHeaderCell>
						<asp:TableHeaderCell>
							<asp:LinkButton ID="unsubscribes" runat="server" OnClick="Unsubscribe_Click">
								Unsubscribes
							</asp:LinkButton>
						</asp:TableHeaderCell>
						<asp:TableHeaderCell>
							<b>xlsx</b>
						</asp:TableHeaderCell>
						<asp:TableHeaderCell>
							<b>xls</b>
						</asp:TableHeaderCell>
					</asp:TableHeaderRow>
				</HeaderTemplate>
				<ItemTemplate>
					<asp:TableRow CssClass="campaignRow" runat="server" ID="tableCampaignTypeRow">
						<asp:TableCell CssClass="Click_btn" VerticalAlign="top">
							<div>&nbsp;</div>
						</asp:TableCell>
						<asp:TableCell VerticalAlign="top">
							<asp:Label runat="server" ID="lblCampaignType"></asp:Label>
							&nbsp;
						</asp:TableCell>
						<asp:TableCell VerticalAlign="top">
							<asp:Label runat="server" ID="lblCampaignId"></asp:Label>
							&nbsp;
						</asp:TableCell>
						<asp:TableCell VerticalAlign="top">
							<asp:Label runat="server" ID="lblCampaign"></asp:Label>
							&nbsp;
						</asp:TableCell>
						<asp:TableCell VerticalAlign="top">
							<asp:Label runat="server" ID="lblDeployDate"></asp:Label>
							&nbsp;
						</asp:TableCell>
						<asp:TableCell VerticalAlign="top">
							<asp:Label runat="server" ID="lblTotalSent"></asp:Label>
							&nbsp;
						</asp:TableCell>
						<asp:TableCell VerticalAlign="top">
							<asp:HyperLink runat="server" ID="lnkBounces" CssClass="aDialog"></asp:HyperLink>
							&nbsp;
						</asp:TableCell>
						<asp:TableCell VerticalAlign="top">
							<asp:HyperLink runat="server" ID="lnkOpens" CssClass="aDialog"></asp:HyperLink>
							&nbsp;
						</asp:TableCell>
						<asp:TableCell VerticalAlign="top">
							<asp:HyperLink runat="server" ID="lnkClicks" CssClass="aDialog"></asp:HyperLink>
							&nbsp;
						</asp:TableCell>
						<asp:TableCell VerticalAlign="top">
							<asp:HyperLink runat="server" ID="lnkUnsubscribes" CssClass="aDialog"></asp:HyperLink>
							&nbsp;
						</asp:TableCell>
						<asp:TableCell VerticalAlign="top">
							<asp:LinkButton ID="lbtnDownload" runat="server" CommandName="Download">
							<asp:Image ID="imgDownload" ImageUrl="~/Images/FileManager/xls.gif" runat="server" />
						</asp:LinkButton>
						</asp:TableCell>
						<asp:TableCell VerticalAlign="top">
							<asp:LinkButton ID="lbtnDownloadxls" runat="server" CommandName="Downloadxls">
							<asp:Image ID="imgDownloadxls" ImageUrl="~/Images/FileManager/xls.gif" runat="server" />
						</asp:LinkButton>
						</asp:TableCell>
					</asp:TableRow>
					<tr class="campaignRowContent">
						<td colspan="20">
							<div class="content_div clearfix">
							</div>
						</td>
					</tr>
				</ItemTemplate>
			</asp:Repeater>
		</table>
		<br />
		<uc1:Pager ID="PagerReport" runat="server" OnPageIndexClickEvent="pageIndex_Click" PostBackPager = "true"/>
		<asp:Literal ID="noCampaignReports" runat="server" Text="No Bulk Email Campaigns Found." Visible="false"></asp:Literal>
	</div>
	<br />
	<asp:RadioButton ID="rdbXlsx" runat="server" GroupName="ExcelType" Text="xlsx" />
	<asp:RadioButton ID="rdbXls" runat="server" GroupName="ExcelType" Text="xls" />
	<asp:Button ID="lbtnFullDownload" runat="server" CommandName="Download" Text="Download Full Report"
		OnClick="btnFullDownload_OnClick" CssClass="common_text_button"></asp:Button>
</asp:Content>
