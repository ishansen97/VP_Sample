<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CampaignList.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.BulkEmail.CampaignList"
	MasterPageFile="~/MasterPage.Master" %>

<%@ Register Src="../Pager.ascx" TagName="Pager" TagPrefix="uc1" %>
<asp:Content ID="contents" ContentPlaceHolderID="cphContent" runat="server">
	
	<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>
	<script src="../../Js/ContentPicker.js" type="text/javascript"></script>
	<script src="../../Js/JQuery/jquery-ui-timepicker-addon.js" type="text/javascript"></script>
	<script src="../../Js/BulkEmail/CampaignList.js" type="text/javascript"></script>

	<div class="AdminPanelHeader">
		<h3>Campaign List</h3>
	</div>
	<div class="AdminPanelContent">
		<div class="campaign_srh_btn">
			Filter</div>
		<div id="divSearchCriteria"></div>
		<br />
		<div id="divSearchPane" class="campaign_srh_pane" style="display: none;">
			<div class="form-horizontal">
				<div class="control-group">
					<label class="control-label">Id</label>
					<div class="controls">
						<asp:TextBox runat="server" ID="txtCampaignId"></asp:TextBox>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Type</label>
					<div class="controls">
						<asp:DropDownList ID="ddlCampaignType" runat="server">
					</asp:DropDownList>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Name</label>
					<div class="controls">
						<asp:TextBox runat="server" ID="txtCampaignName"></asp:TextBox>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Status</label>
					<div class="controls">
						<asp:DropDownList ID="ddlStatus" runat="server">
						</asp:DropDownList>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Year</label>
					<div class="controls">
						<asp:DropDownList ID="ddlCampaignYear" runat="server">
						</asp:DropDownList>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Visibility Status</label>
					<div class="controls">
						<asp:DropDownList ID="ddlVisibility" runat="server"></asp:DropDownList>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Associated Article</label>
					<div class="controls">
						<asp:TextBox runat="server" ID="associatedArticleSearch"></asp:TextBox>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Scheduled Date</label>
					<div class="controls">
						<asp:TextBox ID="scheduledDateTxt" runat="server"></asp:TextBox>
						<asp:RegularExpressionValidator ID="campaignScheduleDateRev" runat="server" ControlToValidate="scheduledDateTxt"
							ErrorMessage="Please enter a valid schedule date" ValidationExpression="^[0,1]\d{1}\/(([0-2]\d{1})|([3][0,1]{1}))\/(([1]{1}[9]{1}[9]{1}\d{1})|([2-9]{1}\d{3}))$">*</asp:RegularExpressionValidator>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Vendor</label>
					<div class="controls">
						<asp:TextBox runat="server" ID="vendorTxt"></asp:TextBox>
					</div>
				</div>
				<div class="form-actions">
					<asp:Button ID="btnApply" runat="server" Text="Apply" CssClass="btn"
						OnClick="btnApply_Click" />
					<asp:Button ID="btnRestFilter" runat="server" Text="Reset Filter" CssClass="btn"
						OnClick="btnRestFilter_Click" />
				</div>
			</div>
			
		</div>
		<br />
		<div class="add-button-container"><asp:HyperLink ID="lnkAddCampaign" runat="server" Text="Add Campaign" CssClass="btn aDialog"></asp:HyperLink></div>
		<table width="100%" cellpadding="0" cellspacing="0" class="common_data_grid table table-bordered">
			<asp:Repeater ID="rptCampaignList" runat="server" OnItemDataBound="rptCampaignList_ItemDataBound" 
				OnItemCommand="rptCampaignList_ItemCommand">
				<HeaderTemplate>
					<asp:TableHeaderRow runat="server" ID="tableCampaignHeaderRow">
						<asp:TableHeaderCell>
							&nbsp;
						</asp:TableHeaderCell>
						<asp:TableHeaderCell>
							<asp:LinkButton ID="lbtnId" runat="server" OnClick="lbtnId_Click">
								Id
							</asp:LinkButton>
						</asp:TableHeaderCell>
						<asp:TableHeaderCell>
							<asp:LinkButton ID="lbtnCampaign" runat="server" OnClick="lbtnCampaign_Click">
								Name
							</asp:LinkButton>
						</asp:TableHeaderCell>
						<asp:TableHeaderCell>
							<asp:LinkButton ID="lbtnCampaignType" runat="server" OnClick="lbtnCampaignType_Click">
								Campaign Type
							</asp:LinkButton>
						</asp:TableHeaderCell>
						<asp:TableHeaderCell>
							<b>Content Pane Editor (HTML)</b>
						</asp:TableHeaderCell>
						<asp:TableHeaderCell>
							<b>Content Pane Editor (Text)</b>
						</asp:TableHeaderCell>
						<asp:TableHeaderCell>
							<asp:LinkButton ID="lbtnScheduledDate" runat="server" OnClick="lbtnScheduledDate_Click">
								Scheduled Date
							</asp:LinkButton>
						</asp:TableHeaderCell>
						<asp:TableHeaderCell>
							<b>Recipients</b>
						</asp:TableHeaderCell>
						<asp:TableHeaderCell>
							<b>Enabled</b>
						</asp:TableHeaderCell>
						<asp:TableHeaderCell>
							<asp:LinkButton ID="lbthStatus" runat="server" OnClick="lbthStatus_Click">
								Status
							</asp:LinkButton>
						</asp:TableHeaderCell>
						<asp:TableHeaderCell>
							<b>Media Owners</b>
						</asp:TableHeaderCell>
						<asp:TableHeaderCell>
							<b>Content Data</b>
						</asp:TableHeaderCell>
						<asp:TableHeaderCell>
							<b>Logs</b>
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
						<asp:TableCell CssClass="Click_btn" VerticalAlign="top">
							<div>&nbsp;</div>
						</asp:TableCell>
						<asp:TableCell VerticalAlign="top">
							<asp:Label runat="server" ID="lblId"></asp:Label>
							<asp:HiddenField runat="server" ID="errorStatus" />
							&nbsp;
						</asp:TableCell>
						<asp:TableCell VerticalAlign="top">
							<asp:Label runat="server" ID="lblName"></asp:Label>
							&nbsp;
						</asp:TableCell>
						<asp:TableCell VerticalAlign="top">
							<asp:Label runat="server" ID="lblType"></asp:Label>
							&nbsp;
						</asp:TableCell>
						<asp:TableCell VerticalAlign="top">
							<asp:Label ID="lblHtmlEmailTemplate" runat="server"></asp:Label><br />
							<asp:LinkButton ID="lbtnHtmlPreview" Text="" runat="server" CommandName="HtmlPreview"
								CssClass="grid_icon_link preview" ToolTip="Preview"></asp:LinkButton>
							<asp:HyperLink ID="lnkCampaignHtmlContent" runat="server" Text="" CssClass="campaignContent grid_icon_link edit_content"
								ToolTip="Edit Content"></asp:HyperLink>
							<asp:HyperLink ID="lnkTestHtmlEmail" runat="server" Text="" CssClass="aDialog grid_icon_link send_test"
								ToolTip="Send Test Mail"></asp:HyperLink>
							&nbsp;
						</asp:TableCell>
						<asp:TableCell VerticalAlign="top">
							<asp:Label ID="lblTextEmailTemplate" runat="server"></asp:Label><br />
							<asp:LinkButton ID="lbtnTextPreview" Text="" runat="server" CommandName="TextPreview"
								CssClass="grid_icon_link preview" ToolTip="Preview"></asp:LinkButton>
							<asp:HyperLink ID="lnkCampaignTextContent" runat="server" Text="" CssClass="campaignContent grid_icon_link edit_content"
								ToolTip="Edit Content"></asp:HyperLink>
							<asp:HyperLink ID="lnkTestTextEmail" runat="server" Text="" CssClass="aDialog grid_icon_link send_test"
								ToolTip="Send Test Mail"></asp:HyperLink>
							&nbsp;
						</asp:TableCell>
						<asp:TableCell VerticalAlign="top">
							<asp:Label runat="server" ID="lblScheduledDate"></asp:Label>
							&nbsp;
						</asp:TableCell>
						<asp:TableCell VerticalAlign="top">
							<asp:HyperLink ID="lnkRecipients" runat="server" Text="Segments" CssClass="aDialog"></asp:HyperLink>
							<asp:HyperLink ID="lnkRecipientsPreview" runat="server" CssClass="aDialog grid_icon_link preview" ToolTip="Preview Recipients"></asp:HyperLink>
							&nbsp;
						</asp:TableCell>
						<asp:TableCell VerticalAlign="top">
							<asp:CheckBox runat="server" ID="chkEnable" Enabled="false" />
							&nbsp;
						</asp:TableCell>
						<asp:TableCell VerticalAlign="top">
							<asp:Label ID="lblStatus" runat="server"></asp:Label>
							<asp:HyperLink ID="lnkStatus" runat="server" Text="Status" CssClass="aDialog"></asp:HyperLink>
							&nbsp;
						</asp:TableCell>
						<asp:TableCell VerticalAlign="top">
							<asp:HyperLink ID="lnkOwners" runat="server" Text="Owners" CssClass="aDialog"></asp:HyperLink>
							&nbsp;
						</asp:TableCell>
						<asp:TableCell VerticalAlign="top">
							<asp:HyperLink ID="lnkCampaignContentData" runat="server" Text="Add / View"></asp:HyperLink>
							&nbsp;
						</asp:TableCell>
						<asp:TableCell VerticalAlign="top">
							<asp:HyperLink ID="lnkLogs" runat="server" Text="Logs" CssClass="aDialog"></asp:HyperLink>
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
							<asp:HyperLink ID="lnkEdit" runat="server" Text="" CssClass="aDialog grid_icon_link edit"
								ToolTip="Edit"></asp:HyperLink>
							<asp:LinkButton ID="lbtnDuplicate" runat="server" CommandName="DuplicateCampaign"
								Text=""
								CssClass="grid_icon_link duplicate" ToolTip="Copy"></asp:LinkButton>
							<asp:LinkButton ID="lbtnClone" runat="server" CommandName="CloneCampaign"
								Text=""
								CssClass="grid_icon_link clone" ToolTip="Copy with content data"></asp:LinkButton>
							<asp:LinkButton ID="cloneWithoutData" runat="server" CommandName="CloneCampaignWithoutData"
								Text=""
								CssClass="grid_icon_link clone" ToolTip="Copy without content data"></asp:LinkButton>
							<asp:LinkButton ID="lbtnDelete" runat="server" CommandName="DeleteCampaign" Text=""
								CssClass="grid_icon_link delete"
								ToolTip="Delete"></asp:LinkButton>
							<asp:LinkButton ID="lbtnDeploy" runat="server" CommandName="Deploy" Text=""
								CssClass="grid_icon_link deploy"
								ToolTip="Deploy"></asp:LinkButton>
							<asp:HyperLink ID="lnkResend" runat="server" Text="" CssClass="aDialog grid_icon_link resend"
								ToolTip="Resend Campaign"></asp:HyperLink>
							&nbsp;
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
		<uc1:Pager ID="pagerCampaign" runat="server" OnPageIndexClickEvent="pagerCampaign_PageIndexClick"
			RecordsPerPage="10" PostBackPager = "false" />
		<asp:Literal ID="ltlNoCampaigns" runat="server" Text="No Campaigns found." Visible="false"></asp:Literal>
	</div>
</asp:Content>
