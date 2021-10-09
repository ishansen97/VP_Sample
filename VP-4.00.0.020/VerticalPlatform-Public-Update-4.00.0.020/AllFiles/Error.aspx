<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Error.aspx.cs" Inherits="VerticalPlatformWeb.Error" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
	<title>Error</title>
</head>
<body>
	<form id="frmError" runat="server">
	<div>
		<h2>
			Server error please try again later.</h2>
		<p>
			<asp:Literal ID="ltlMessage" runat="server"></asp:Literal>
		</p>
		<p>
			<asp:Literal ID="ltlException" runat="server"></asp:Literal>
		</p>
	</div>
	</form>
</body>
</html>
