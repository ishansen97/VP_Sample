<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="ContentMetadataReport.aspx.cs" Inherits="VerticalPlatformAdminWeb.Platform.Report.ContentMetadataReport"
	Title="Untitled Page" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=9.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"
	Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>
<%@ Register Src="ReportPager.ascx" TagName="ReportPager" TagPrefix="uc2" %>
<asp:Content ID="cntReportViewer" ContentPlaceHolderID="cphContent" runat="server">
	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3 runat="server" id="hdrContentMetadataReport">
				Content Metadata View</h3>
		</div>
		<div class="AdminPanelContent">
			<table>
				<tr>
					<td>
						<asp:Label ID="lblVertical" runat="server" Text="Vertical" Visible="false"></asp:Label>
					</td>
					<td>
						<asp:DropDownList ID="ddlVertical" runat="server" DataTextField="Name" DataValueField="Id"
							AutoPostBack="True" Visible="false" Width="140px" OnSelectedIndexChanged="ddlVertical_SelectedIndexChanged">
						</asp:DropDownList>
					</td>
				</tr>
				<tr>
					<td>
						<asp:Label ID="lblContentType" runat="server" Text="Content Type"></asp:Label>
					</td>
					<td>
						<asp:DropDownList ID="ddlContentType" runat="server" AutoPostBack="True" Width="140px"
							OnSelectedIndexChanged="ddlContentType_SelectedIndexChanged">
						</asp:DropDownList>
					</td>
				</tr>
			</table>
			<br />
			<div>
				<uc2:ReportPager ID="rpReportPager" runat="server" RecordsPerPage="2" />
			</div>
			<br />
			<div class="report_view_table">
			<rsweb:ReportViewer ID="rvContentMetadataReportViewer" runat="server" 
				AsyncRendering="False" 
				ShowPageNavigationControls="False" ShowFindControls="False" SizeToReportContent="True"  >
				<LocalReport ReportPath="Platform\Report\ContentMetadataView.rdlc">
					<DataSources>
						<rsweb:ReportDataSource DataSourceId="ContentDataSource" Name="ContentMetadataRecord" />
					</DataSources>
				</LocalReport>
			</rsweb:ReportViewer>
			<asp:ObjectDataSource ID="ContentDataSource" runat="server" SelectMethod="GetContentMetadata"
				TypeName="VerticalPlatformAdminWeb.Platform.Report.ContentMetadataManager" StartRowIndexParameterName="pageStart"
				MaximumRowsParameterName="recordCount" OnSelected="ContentDataSource_Selected">
				<SelectParameters>
					<asp:ControlParameter ControlID="ddlVertical" DefaultValue="" Name="siteId" PropertyName="SelectedValue"
						Type="String" />
					<asp:ControlParameter ControlID="ddlContentType" DefaultValue="" Name="contentTypeId"
						PropertyName="SelectedValue" Type="String" />
					<asp:Parameter Direction="Output" Name="totalRecords" Type="Int32" />
					<asp:ControlParameter ControlID="rpReportPager" PropertyName="StartingRowNumber"
						Name="pageStart" Type="Int32" />
					<asp:ControlParameter ControlID="rpReportPager" PropertyName="RecordsPerPage" Name="recordsPerPage"
						Type="Int32" />
				</SelectParameters>
			</asp:ObjectDataSource>
			</div>
		</div>
		</div>
</asp:Content>
