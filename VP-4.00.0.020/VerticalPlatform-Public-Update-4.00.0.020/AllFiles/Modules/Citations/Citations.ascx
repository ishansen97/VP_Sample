<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Citations.ascx.cs" Inherits="VerticalPlatformWeb.Modules.Citations.Citations" %>

<%@ Register Src="../../Controls/Pager.ascx" TagName="Pager" TagPrefix="uc1" %>

<div class="citations module">
	<div class="citation-widget" data-locale-path="/Modules/Citation/" data-csl-doc="/Modules/Citation/biochemistry.css">
		<asp:PlaceHolder ID="citationsListPlaceholder" runat="server"></asp:PlaceHolder>
	</div>
	<div class="citationPager">
		<uc1:Pager ID="citationListPager" runat="server" />
	</div>
	<div id="citation-logo">
		<a href="http://scrazzl.com/manufacturers" target="_blank">
			<img id="citationLogoImage" alt="Logo" class="citationLogo" src="" runat="server"/>
		</a>
	</div>
</div>