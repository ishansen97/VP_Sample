<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CampaignContentReport.aspx.cs"
		Inherits="VerticalPlatformAdminWeb.ModuleAdmin.BulkEmail.CampaignContentReport"
		MasterPageFile="~/MasterPage.Master" Title="Campaign Content Report"%>

<%@ Register Src="../Pager.ascx" TagName="Pager" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">

<script src="../../Js/ContentPicker.js" type="text/javascript"></script>
<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>
<script src="../../Js/JQuery/jquery.pager.js" type="text/javascript"></script>

<script type="text/javascript">
	RegisterNamespace("VP.CampaignReport");

	VP.CampaignReport.Initialize = function() {
		$(document).ready(function() {
			$(".campaignRow .Click_btn", this).click(function() {
				$(this).parent().next().toggleClass("expanded");
				$(this).toggleClass("collaps_icon");
			});
		});
	}

	VP.CampaignReport.Preview = function(campaignId, campaignIdKey, templateTypeKey, templateType) {
		var previewWindow = window.open('CampaignPreview.aspx?' + campaignIdKey + '=' + campaignId + '&' + templateTypeKey + '=' + templateType,
					'Preview', 'location=0,status=1,scrollbars=1,width=700,height=600,toolbar=0,menubar=0,resizable=1');
		if (previewWindow) {
			previewWindow.focus();
		}
	};

	VP.CampaignReport.Initialize();
</script>

<div class="AdminPanel">
	<div class="AdminPanelHeader">
		<h3>
			Campaign Content Report</h3>
	</div>
	<div class="AdminPanelContent">
        <div class="form-horizontal">
            <div class="control-group">
                <label class="control-label"><asp:Label ID="lblCampaignType" runat="server" Text="Campaign Type" /></label>
                <div class="controls">
                    <asp:DropDownList ID="ddlCampaignType" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlCampaignType_SelectedIndexChanged" />
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><asp:Label ID="lblContentGroup" runat="server" Text="Content Group" /></label>
                <div class="controls">
                   <asp:DropDownList ID="ddlContentGroup" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlContentGroup_SelectedIndexChanged"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><asp:Label ID="lblContentType" runat="server" Text="Content Type" /></label>
                <div class="controls">
                   <asp:DropDownList ID="ddlContentType" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlContentType_SelectedIndexChanged"/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><asp:Label ID="lblContent" runat="server" Text="Content ID" /></label>
                <div class="controls">
                   <asp:TextBox ID="txtContent" runat="server"/>
					<asp:CompareValidator ID="cvContent" runat="server" ErrorMessage="content id should be a positive integer." Type="Integer" ControlToValidate="txtContent" Operator="GreaterThan" ValueToCompare="0">*</asp:CompareValidator>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"><asp:Label ID="lblVendorContent" runat="server" Text="Vendor Associated Content Type" /></label>
                <div class="controls">
                   <asp:DropDownList ID="ddlVendorContent" runat="server"/>
                </div>
            </div>
        </div>
		<div class="add-button-container"><asp:Button ID="btnSubmit" runat="server" Text="Load Campaigns" OnClick="btnSubmit_Click"
			CssClass="btn" />
		<asp:Button ID="btnReset" runat="server" Text="Reset" OnClick="btnReset_Click"
			CssClass="btn" /></div>
		
		<asp:Label ID="lblArticleName" runat="server" />
		<br />
		<table width="100%" cellpadding="0" cellspacing="0" class="common_data_grid table table-bordered">
			<asp:Repeater ID="rptCampaignList" runat="server" OnItemDataBound="rptCampaignList_ItemDataBound"
					OnItemCommand="rptCampaignList_ItemCommand">
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
							<asp:Label ID="lblDeployedDate" runat="server">
								Deployed Date
							</asp:Label>
						</asp:TableHeaderCell>
						<asp:TableHeaderCell>
							<asp:Label ID="lblPreview" runat="server">
								Preview
							</asp:Label>
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
							<asp:Label runat="server" ID="lblDeployedDate"></asp:Label>
							&nbsp;
						</asp:TableCell>
						<asp:TableCell VerticalAlign="top">
							<asp:LinkButton ID="lbtnHtmlPreview" Text="" runat="server" CommandName="HtmlPreview"
								CssClass="grid_icon_link preview" ToolTip="Preview"></asp:LinkButton>
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
		<uc1:Pager ID="pagerReport" runat="server" OnPageIndexClickEvent="pagerReport_PageIndexClick" />
		<br />
		<asp:Label ID="lblMessage" runat="server" />
		<br />
		<asp:Panel ID="pnlDownload" runat="server">
			<asp:RadioButton ID="rdbXlsx" runat="server" GroupName="ExcelType" Text="xlsx" />
			<asp:RadioButton ID="rdbXls" runat="server" GroupName="ExcelType" Text="xls" />
			<asp:Button ID="btnDownload" runat="server" CssClass="common_text_button" onclick="btnDownload_Click"
				Text ="Download Report" />
		</asp:Panel>
	</div>
</div>
</asp:Content>
