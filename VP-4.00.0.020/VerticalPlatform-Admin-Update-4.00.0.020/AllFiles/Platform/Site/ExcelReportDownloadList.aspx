<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ExcelReportDownloadList.aspx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.Site.ExcelReportDownloadList" MasterPageFile="~/MasterPage.Master"%>
<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>
				Excel Report Download
			</h3>
		</div>
		<div class="AdminPanelContent" style="padding-left:10px;">
		<asp:Label ID="Label1" runat="server" Text="Download your excel report from :"></asp:Label>
		<br />
		<br />
		<asp:LinkButton ID="lbtnDownloadExcelReport" runat="server" 
		onclick="lbtnDownloadExcelReport_Click"></asp:LinkButton>
		</div>
	</div>
		
	</asp:Content>