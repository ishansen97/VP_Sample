<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CampaignArchivesList.ascx.cs"
	Inherits="VerticalPlatformWeb.Modules.BulkEmail.CampaignArchivesList" %>
<%@ Register Src="../../Controls/Pager.ascx" TagName="Pager" TagPrefix="uc1" %>
<div class="filter module" id="divCampaignFilter" runat="server">
	<h4>Filter</h4>
	<a id="lnkScrollPosition" runat="server"></a>
	<div id="filterBody" class="filterBody">
		<div class="campaignName">
			<asp:TextBox runat="server" ID="campaignNameTxt" CssClass="campaignName" placeholder="Campaign Name"/>
		</div>
		<div class="campaignType">
			<asp:DropDownList ID="ddlCampaignType" runat="server" CssClass="dropdownList campaignType" AppendDataBoundItems="true">
				<asp:ListItem Text="-Select Campaign Type-" Value=""></asp:ListItem>
			</asp:DropDownList>
		</div>
		<div class="dateDeployed">
			<span>Filter By Year</span>
			<%--<asp:TextBox runat="server" ID="txtStartDate" CssClass="txtStartDate" MaxLength="10"></asp:TextBox>--%>
			<asp:DropDownList runat="server" ID="ddlyear" CssClass="dropdownList dropdownYear"></asp:DropDownList>
			<span>Filter By Month</span>
			<%--<asp:TextBox runat="server" ID="txtEndDate" CssClass="txtEndDate" MaxLength="10"></asp:TextBox>--%>
			<asp:DropDownList runat="server" ID="ddlMonth" CssClass="dropdownList dropdownMonth"></asp:DropDownList>
		</div>
	</div>
	<div class="filterButtons">
		<input type="button" class="btnCampaignArchiveListFilter button" value="Filter" />
		<input type="button" class="btnCampaignArchiveListReset button" value="Reset" />
		<div class="error" id="campaignArchiveListError"></div>
	</div>
</div>
<div class="sorting module" id="divCampaignSorting" runat="server">
	<h4>Sort</h4>
	<asp:HyperLink runat="server" ID="lnkSortByDateDeployed">Date Deployed</asp:HyperLink>
	<asp:HyperLink runat="server" ID="lnkSortByCampaign">Campaign</asp:HyperLink>
</div>
<div>
	<asp:Literal ID="ltlCampaignList" runat="server"></asp:Literal>
	<uc1:Pager ID="pagerCampaignArchiveList" runat="server" />
</div>
