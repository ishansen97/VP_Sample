<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SliderContainer.ascx.cs"
	Inherits="VerticalPlatformWeb.Containers.SliderContainer.SliderContainer" %>
<div runat="server" id="divContainer" class="container module">
	<div class="header" id="divHeader" runat="server">
		<h2>
			<asp:Literal ID="ltlTitle" runat="server"></asp:Literal></h2>
	</div>
	<div id="contentPane" runat="server" class="content slider">
		<asp:Panel ID="pnlSlides" runat="server" CssClass="slides_container">
		</asp:Panel>
	</div>
</div>
