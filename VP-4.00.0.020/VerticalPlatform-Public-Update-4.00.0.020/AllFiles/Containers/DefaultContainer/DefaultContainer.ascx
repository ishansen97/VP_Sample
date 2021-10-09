<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="DefaultContainer.ascx.cs"
	Inherits="VerticalPlatformWeb.Containers.DefaultContainer.DefaultContainer" %>
<div runat="server" id="divContainer" class="container module default">
	<div class="header" id="divHeader" runat="server">
		<h2>
			<asp:Literal ID="ltlTitle" runat="server"></asp:Literal></h2>
	</div>
	<div id="contentPane" runat="server" class="content">
	</div>
</div>
