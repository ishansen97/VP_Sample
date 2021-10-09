<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="PrebuiltGuidedBrowse.ascx.cs" 
	Inherits="VerticalPlatformWeb.Modules.GuidedBrowse.PrebuiltGuidedBrowse" %>

<div class="guidedBrowseModule module">
	<div class="guidedBrowseCurrentOptionSegmentsTitle" ID="guidedBrowseCurrentOptionSegmentsTitle" runat="server">
		<asp:Literal ID="ltlCurrentOptionSegmentsTitle" runat="server"></asp:Literal>
	</div>
	<div class="guidedBrowseAlphabeticalIndex guided-list" ID="guidedBrowseAlphabeticalIndex" runat="server">
		<asp:Literal ID="ltlAlphabeticalIndex" runat="server"></asp:Literal>
	</div>
	<div class="guidedBrowseCurrentOptionsSegments" ID="guidedBrowseCurrentOptionsSegments" runat="server">
		<asp:Literal ID="ltlCurrentOptionsSegments" runat="server"></asp:Literal>
	</div>
	<div class="guidedBrowseNextLevelOptions" ID="guidedBrowseNextLevelOptions" runat="server" >
		<asp:Literal ID="ltlNextLevelOptions" runat="server"></asp:Literal>
	</div>
	<div class="guidedBrowseResults" ID="guidedBrowseResults" runat="server">
		<asp:Literal ID="ltlResults" runat="server"></asp:Literal>
	</div>
</div>
