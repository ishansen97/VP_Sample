<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ReportPager.ascx.cs" Inherits="VerticalPlatformAdminWeb.Platform.Report.ReportPager" %>
<script src="../../js/JQuery/jquery-1.4.2.min.js" type="text/javascript"></script>
<script language="javascript" type="text/javascript">
$(document).ready(function() {
	$('.recordsPerPageInput').keyup(function () { 
		this.value = this.value.replace(/[^0-9\.]/g,'');
	});
});

</script>

<asp:LinkButton ID="lbtnPrevious" runat="server" onclick="lbtnPrevious_Click"><< Prev</asp:LinkButton>
<asp:LinkButton ID="lbtnNext" runat="server" onclick="lbtnNext_Click">Next >></asp:LinkButton>
&nbsp;&nbsp;&nbsp;
Total Records :
<asp:Label ID="lblTotalRecords" runat="server"></asp:Label>
&nbsp;&nbsp;&nbsp;
Records Per Page 
<asp:TextBox ID="txtRowsPerPage" runat="server" Width="60px" class="recordsPerPageInput" MaxLength="6"></asp:TextBox>
<asp:Button ID="btnRun" runat="server" Text="Run" onclick="btnRun_Click" />
