<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="TabContainer.ascx.cs"
	Inherits="VerticalPlatformWeb.Containers.TabContainer.TabContainer" %>

<div runat="server" id="divContainer" class="container module">
	<div class="header" id="stylesheet" runat="server">
		<h2>
			<asp:Literal ID="ltlTitle" runat="server"></asp:Literal></h2>
	</div>
	<div id="contentPane" runat="server" class="content tab">
		<ul id="tabHeaderList" runat="server">
			<asp:Label ID="ltlTabQuote" runat="server"/>
			<asp:PlaceHolder ID="phTab" runat="server"></asp:PlaceHolder>
		</ul>
		<div id="tabContentList" runat="server">
					<asp:PlaceHolder ID="phTabContent" runat="server"></asp:PlaceHolder>
		</div>
	</div>
</div>
