<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Search.ascx.cs" Inherits="VerticalPlatformWeb.Modules.Header.Search" %>

<div class="searchControl module">
	<input id="txtSearchFor" type="text" class="textbox" autocomplete="off"/>
	<div id="autoCompleteSpinner" class="autoCompleteSpinner" runat="server"></div>
	<input id="btnSearch" type="button" value="Search" class="button searchButton" />
	<asp:Literal ID="ltlHiddenUrl" runat="server"></asp:Literal>
	<div class="autoCompleteContainer" id="autoCompleteContainer" runat="server"></div>
</div>
