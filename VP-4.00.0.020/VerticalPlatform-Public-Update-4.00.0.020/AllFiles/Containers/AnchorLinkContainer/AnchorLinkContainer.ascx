<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AnchorLinkContainer.ascx.cs"
	Inherits="VerticalPlatformWeb.Containers.AnchorLinkContainer.AnchorLinkContainer" %>


<div runat="server" id="divContainer" class="container module">
	<div class="header" id="divHeader" runat="server">
		<h2>
			<asp:Literal ID="ltlTitle" runat="server"></asp:Literal>
		</h2>
	</div>
	<div id="contentPane" runat="server" class="content">
        <div class="anchor-nav-header">
            <ul class="anchor-nav-container">
			    <asp:PlaceHolder ID="AnchorLinkParentContainer" runat="server"></asp:PlaceHolder>
		    </ul>
        </div>
        <div class="anchor-content-body">
            <asp:PlaceHolder ID="AnchorLinkContent" runat="server">
		    </asp:PlaceHolder>
        </div>

	</div>
</div>
