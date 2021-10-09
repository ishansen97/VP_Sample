<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SegmentRecipientDownload.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.BulkEmail.SegmentRecipientDownload" %>
<div class="AdminPanelContent" style="width:300px;">
	<ul class="common_form_area">
		<li class="common_form_row clearfix"><span class="label_span" style="width: 80px;">
			<label>
				Excel format
			</label>
		</span><span>
			<asp:RadioButton ID="rdbXls" runat="server" GroupName="ExcelType" Text="xls" Checked="true" />
			<asp:RadioButton ID="rdbXlsx" runat="server" GroupName="ExcelType" Text="xlsx" />
		</span></li>
		<li class="common_form_row clearfix"><span class="label_span" style="width:auto; padding-right:10px;">Recreate Excel File</span> <span>
			<asp:CheckBox ID="chkRegenerate" runat="server" Enabled="true" Checked="false" style="margin:0px;" /></span>
		</li>
		<li class="common_form_row clearfix" style="margin-top:15px;">
			<asp:Button ID="btnSummaryDownload" runat="server" Text="Download Summary Report" CssClass="btn"
				onclick="btnSummaryDownload_Click" style="margin-bottom:10px" />
			<asp:Button ID="btnFullDownload" runat="server" Text="Download Full Report" CssClass="btn"
				onclick="btnFullDownload_Click" />
		</li>
	</ul>
</div>
