<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="VendorSearchBox.ascx.cs"
	Inherits="VerticalPlatformWeb.Modules.VendorDetail.VendorSearchBox" %>
<div class="vendorSearchBoxModule module">
	<input id="searchText" type="text" class="textbox searchText" runat="server"/>
	<input id="searchButton" type="button" value="Search" class="button searchButton" />
	<asp:Literal ID="details" runat="server"></asp:Literal>
</div>
