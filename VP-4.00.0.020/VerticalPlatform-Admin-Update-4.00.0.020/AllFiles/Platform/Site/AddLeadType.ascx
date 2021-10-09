<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddLeadType.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.Site.AddLeadType" %>

<script type="text/javascript">
	$(document).ready(function() {
		var options = { siteId: VP.SiteId, type: "Page", currentPage: "1", pageSize: "10" };
		$("input[type=text][id*=txtLandingPage]").contentPicker(options);
	});
</script>

<table>
	<tr>
		<td>
			<asp:Literal ID="ltlActionName" runat=server></asp:Literal>
		</td>
		<td>
			<asp:TextBox ID="txtActionName" runat="server"></asp:TextBox><asp:RequiredFieldValidator
				ID="rfvActionName" runat="server" ControlToValidate="txtActionName">*</asp:RequiredFieldValidator>
		</td>
	</tr>
	<tr>
		<td>
			<asp:Literal ID="ltlActionTitle" runat=server></asp:Literal>
		</td>
		<td>
			<asp:TextBox ID="txtActionTypeTitle" runat="server"></asp:TextBox><asp:RequiredFieldValidator
				ID="rfvActionTypeTitle" runat="server" ControlToValidate="txtActionTypeTitle">*</asp:RequiredFieldValidator>
		</td>
	</tr>
	<%--<tr>
		<td>
			Enabled
		</td>
		<td>
			<asp:CheckBox ID="chkEnabled" runat="server" />
		</td>
	</tr>--%>
	<tr>
		<td>
			<asp:Literal ID="ltlLandingPage" runat=server></asp:Literal>
		</td>
		<td>
			<asp:TextBox ID="txtLandingPage" runat="server"></asp:TextBox>
		</td>
	</tr>
	<tr>
		<td>
			Alternative Link Text
		</td>
		<td>
			<asp:TextBox ID="txtAlternativeLinkText" runat="server"></asp:TextBox>
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<asp:Label ID="lblMessage" runat="server" ForeColor="Red"></asp:Label>
		</td>
	</tr>
</table>
