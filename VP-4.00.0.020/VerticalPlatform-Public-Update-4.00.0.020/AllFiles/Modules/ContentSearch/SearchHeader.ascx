<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SearchHeader.ascx.cs" 
		Inherits="VerticalPlatformWeb.Modules.ContentSearch.SearchHeader" %>

<div class="searchHeaderModule">
    <asp:PlaceHolder ID="subHeadingPlaceHolder" runat="server"></asp:PlaceHolder>
	<a name="All"></a>
	<div id="searchHeaderDiv" class="searchHeader" runat="server">
		<asp:PlaceHolder ID="headerPlaceHolder" runat="server"></asp:PlaceHolder>
	</div>
</div>
