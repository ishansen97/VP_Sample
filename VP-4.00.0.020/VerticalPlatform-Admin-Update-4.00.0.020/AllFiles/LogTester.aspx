<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="LogTester.aspx.cs" Inherits="VerticalPlatformAdminWeb.LogTester" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
	<asp:Label ID="lblMessage" runat="server" ></asp:Label>
	<asp:Button ID="btnLog"
		runat="server" Text="Log Error" onclick="btnLog_Click" />
</asp:Content>
