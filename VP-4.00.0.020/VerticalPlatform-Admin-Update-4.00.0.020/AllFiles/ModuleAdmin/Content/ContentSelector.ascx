<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ContentSelector.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Content.ContentSelector" %>

<script type="text/javascript" language="javascript">
	function GetParameterByName(name) {
		name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
		var regexS = "[\\?&]" + name + "=([^&#]*)";
		var regex = new RegExp(regexS);
		var results = regex.exec(window.location.href);
		if (results == null)
			return "";
		else
			return decodeURIComponent(results[1].replace(/\+/g, " "));
	}

	function SetParentControlValue(value) {
		var controlId = GetParameterByName("targetControl");
		parent.document.getElementById(controlId).value = value;
		$.popupDialog.close();
	}
	
</script>

<table>
	<tr>
		<td>
			ContentType
		</td>
		<td>
			<asp:Label ID="lblContentType" runat="server" Text="lblContentType"></asp:Label>
		</td>
	</tr>
	<tr>
		<td>Search</td>
		<td>
			<asp:TextBox ID="txtSearch" runat="server"></asp:TextBox></td>
	</tr>
	<tr>
		<td colspan="2">
			<asp:Button ID="btnSearch" runat="server" Text="Search" 
				onclick="btnSearch_Click" /></td>
	</tr>
</table>

<asp:PlaceHolder ID="phContent" runat="server"></asp:PlaceHolder>
