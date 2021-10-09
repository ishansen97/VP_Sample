<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AccordionContainer.ascx.cs"
	Inherits="VerticalPlatformWeb.Containers.AccordionContainer.AccordionContainer" %>
<div runat="server" id="divContainer" class="container module">
	<div class="header" id="divHeader" runat="server">
		<h2>
			<asp:Literal ID="ltlTitle" runat="server"></asp:Literal></h2>
	</div>
	<div id="contentPane" runat="server" class="content accordion">
	</div>
</div>
