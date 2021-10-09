<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="VerticalPlatformWeb._Default" %>

<%@ Register TagPrefix="vp" Namespace="VerticalPlatform.Web.UI" Assembly="VerticalPlatform.Web" %>
<!DOCTYPE html>
<html class="no-js" lang="en">
<head runat="server">
	<asp:PlaceHolder id="phShortcutIcon" runat="server"></asp:PlaceHolder>
	<title>Untitled Page</title>
	<asp:PlaceHolder id="phCanonicalTag" runat="server"></asp:PlaceHolder>
	<asp:PlaceHolder id="phMetaDescription" runat="server"></asp:PlaceHolder>
	<asp:PlaceHolder id="phMetaKeywords" runat="server"></asp:PlaceHolder>
	<asp:PlaceHolder id="phMetaRobots" runat="server"></asp:PlaceHolder>
	<asp:PlaceHolder id="openGraphMetaTags" runat="server"></asp:PlaceHolder>
    <vp:StyleSheetCombiner ID="VpStyles" runat="server"></vp:StyleSheetCombiner>
    <asp:PlaceHolder id="PlaceHolderPageSpecificStyles" runat="server"></asp:PlaceHolder>
    <vp:AllSitesCommonScriptLoader runat="server"></vp:AllSitesCommonScriptLoader>
	<%--<vp:SiteSpecificHeaderScriptCombiner runat="server"></vp:SiteSpecificHeaderScriptCombiner>--%>	
	<asp:PlaceHolder id="phIESpecific" runat="server"></asp:PlaceHolder>
	<asp:PlaceHolder id="phHeaderScript" runat="server"></asp:PlaceHolder>
	<asp:PlaceHolder id="phMetaReferrer" runat="server"></asp:PlaceHolder>
</head>
<body itemscope itemtype="http://schema.org/WebPage">
	<asp:PlaceHolder ID="phSchemaAttributes" runat="server"></asp:PlaceHolder>
	<asp:PlaceHolder ID="phCustomAdCode" runat="server"></asp:PlaceHolder>
	<asp:PlaceHolder ID="phWebAnalyticsTop" runat="server"></asp:PlaceHolder>
	<vp:VPForm ID="frmMain" runat="server">
		<asp:PlaceHolder ID="phTemplate" runat="server" />
		<div id="modalPopup" class="jqmWindow">
		</div>
	</vp:VPForm>
	<asp:PlaceHolder ID="phWebAnalyticsBottom" runat="server"></asp:PlaceHolder>
	<asp:PlaceHolder ID="phBody" runat="server"></asp:PlaceHolder>
	
<vp:CommonFooterScriptCombiner runat="server"></vp:CommonFooterScriptCombiner>
<vp:CommonScriptCombiner runat="server"></vp:CommonScriptCombiner>
<vp:ControlScriptCombiner runat="server"></vp:ControlScriptCombiner>
</body>
</html>
