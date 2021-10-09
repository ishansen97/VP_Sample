<%@ Page MasterPageFile="~/MasterPage.Master" Language="C#" AutoEventWireup="true"
	CodeBehind="SiteConfiguration.aspx.cs" Inherits="VerticalPlatformAdminWeb.Platform.SiteConfiguration" %>

<asp:Content ID="conContent" ContentPlaceHolderID="cphContent" runat="server">
	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>
				<asp:Label ID="lblTitle" runat="server" Text="Vertical Platform Configurations"></asp:Label>
			</h3>
		</div>
		<div class="AdminPanelContent">
			<table class = "configTable">
				<tr class = "header">
					<th colspan="2" style="height: 30px">
						Admin Site
					</th>
				</tr>
				<tr>
					<td width="250px">
						Application version
					</td>
					<td>
						<asp:Literal ID="ltlAdminAppVersion" runat="server"></asp:Literal>
					</td>
				</tr>
				<tr>
					<td>
						Modified date
					</td>
					<td>
						<asp:Literal ID="ltlAdminAppBuildDate" runat="server"></asp:Literal>
					</td>
				</tr>
				<tr>
					<td>
						Database name
					</td>
					<td>
						<asp:Literal ID="ltlAdminDbName" runat="server"></asp:Literal>
					</td>
				</tr>
				<tr>
					<td>
						Database version
					</td>
					<td>
						<asp:Literal ID="ltlDbVersion" runat="server"></asp:Literal>
					</td>
				</tr>
				<tr>
					<td>
						Database modified date
					</td>
					<td>
						<asp:Literal ID="ltlDbModified" runat="server"></asp:Literal>
					</td>
				</tr>
				<tr>
					<td>
						Caching enabled</td>
					<td>
						<asp:Literal ID="ltlAdminCacheEnabled" runat="server"></asp:Literal>
					</td>
				</tr>
				<tr>
					<td>
						Remote Cache Service URL
					</td>
					<td>
						<asp:HyperLink ID="lnkRemoteCacheURL" runat="server"></asp:HyperLink>
					</td>
				</tr>
				<tr>
					<td>
						Elastic Search Server Url
					</td>
					<td>
						<asp:Literal ID="esServerUrlAdmin" runat="server"></asp:Literal>
					</td>
				</tr>
				<tr>
					<td>
						Scheduler Service Server
					</td>
					<td>
						<asp:Literal ID="schedulerServiceServer" runat="server"></asp:Literal>
					</td>
				</tr>
				<tr>
					<td>
						&nbsp;
					</td>
					<td>
						&nbsp;
					</td>
				</tr>
				
				<tr class = "header">
					<th colspan="2" style="height: 30px; text-align: left">
						Public Site
					</th>
				</tr>
				<tr>
					<td>
						Application version
					</td>
					<td>
						<asp:Literal ID="ltlPublicAppVersion" runat="server"></asp:Literal>
					</td>
				</tr>
				<tr>
					<td>
						Modified date
					</td>
					<td>
						<asp:Literal ID="ltlPublicBuildDate" runat="server"></asp:Literal>
					</td>
				</tr>
				<tr>
					<td>
						Database name
					</td>
					<td>
						<asp:Literal ID="ltlPublicDbName" runat="server"></asp:Literal>
					</td>
				</tr>
				<tr>
					<td>
						Caching enabled
					</td>
					<td>
						<asp:Literal ID="ltlPublicCacheEnabled" runat="server"></asp:Literal>
					</td>
				</tr>
				<tr>
					<td>
						SMTP server
					</td>
					<td>
						<asp:Literal ID="ltlPublicSmtp" runat="server"></asp:Literal>
					</td>
				</tr>
				<tr>
					<td>
						Elastic Search Server Url
					</td>
					<td>
						<asp:Literal ID="esServerUrl" runat="server"></asp:Literal>
					</td>
				</tr>
				<tr>
					<td>
						&nbsp;</td>
					<td>
						&nbsp;</td>
				</tr>
			</table>
		</div>
	</div>
</asp:Content>
