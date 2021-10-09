<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="LeadForm.ascx.cs" Inherits="VerticalPlatformWeb.Modules.LeadForm.LeadForm" %>
	<script type="text/javascript">
		$(document).ready(function () {
			VP.Forms.LeadForm.ToggleMoreProducts();
		});
	</script>
    <script type="text/javascript" src="https://analytics-eu.clickdimensions.com/ts.js" > </script> 

  <asp:PlaceHolder ID="phDownloadContent" runat="server"></asp:PlaceHolder>
	<asp:PlaceHolder ID="phContent" runat="server"></asp:PlaceHolder>
	<asp:Label ID="lblMessage" runat="server"></asp:Label>
	<asp:HiddenField ID="hdnLeadIds" runat="server" />
	<asp:HiddenField ID="hdnUserId" runat="server" />
	<asp:HiddenField ID="hdnLeadForm" runat="server" Value="1" />
	<asp:HiddenField ID="hdnCurrentPage" runat="server" Value="0" />
	<asp:Button ID="btnHiddenLeadSubmit" runat="server"	onclick="btnHiddenLeadSubmit_Click" style="display:none;" />
	<asp:HiddenField ID="hdnIsNewUser" runat="server" Value="0" />
