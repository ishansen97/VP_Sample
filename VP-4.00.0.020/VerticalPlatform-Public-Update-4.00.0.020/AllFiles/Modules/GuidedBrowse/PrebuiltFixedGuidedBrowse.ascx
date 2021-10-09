<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="PrebuiltFixedGuidedBrowse.ascx.cs"
	Inherits="VerticalPlatformWeb.Modules.GuidedBrowse.PrebuiltFixedGuidedBrowse" %>

<div class="guidedBrowseModule module">
	<div class="guidedBrowseCurrentOptionSegmentsTitle" ID="guidedBrowseCurrentOptionSegmentsTitle" runat="server">
		<asp:Literal ID="currentOptionSegmentsTitle" runat="server"></asp:Literal>
	</div>
	<div class="guidedBrowseAlphabeticalIndex guided-list" ID="guidedBrowseAlphabeticalIndex" runat="server">
		<asp:Literal ID="alphabeticalIndex" runat="server"></asp:Literal>
	</div>
	<div class="guidedBrowseCurrentOptionsSegments" ID="guidedBrowseCurrentOptionsSegments" runat="server">
		<asp:Literal ID="currentOptionsSegments" runat="server"></asp:Literal>
	</div>
	<div class="guidedBrowseNextLevelOptions" ID="guidedBrowseNextLevelOptions" runat="server" >
		<asp:Literal ID="nextLevelOptions" runat="server"></asp:Literal>
	</div>
	<div class="guidedBrowseResults" ID="guidedBrowseResults" runat="server">
		<asp:Literal ID="results" runat="server"></asp:Literal>
	</div>
</div>
