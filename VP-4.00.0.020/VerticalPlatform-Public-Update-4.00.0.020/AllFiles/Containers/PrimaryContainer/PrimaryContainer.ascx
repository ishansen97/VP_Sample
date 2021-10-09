<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="PrimaryContainer.ascx.cs"
	Inherits="VerticalPlatformWeb.Containers.PrimaryContainer.PrimaryContainer" %>
<div runat="server" id="divContainer" class="container module primary">
	<div class="header">
		<h1>
			<asp:Literal ID="ltlTitle" runat="server"></asp:Literal></h1>
	</div>
	<div id="contentPane" runat="server" class="content">
		<asp:PlaceHolder ID="phDescription" runat="server"></asp:PlaceHolder>
	</div>
</div>
