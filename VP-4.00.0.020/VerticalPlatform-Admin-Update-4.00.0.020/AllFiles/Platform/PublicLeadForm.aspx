<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PublicLeadForm.aspx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.PublicLeadForm" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
	<title>Lead form preview</title>

	<script src="../Js/JQuery/jquery-1.4.2.min.js" type="text/javascript"></script>
	<script type="text/javascript">
		function Prev(pageId) {
			var pages = $(".formList");
			var prevPageId;
			for (var i = 0; i < pages.length; i++) {
				var currentPageId = $(pages[i]).attr('id')
				if (currentPageId == pageId) {
					if (prevPageId != null) {
						ShowPage(prevPageId);
						break;
					}
				}
				
				prevPageId = currentPageId;
			}
			return false;
		}

		function Next(pageId) {
			var pages = $(".formList");
			var isNextPage = false; ;
			for (var i = 0; i < pages.length; i++) {
				var currentPageId = $(pages[i]).attr('id')
				if (isNextPage) {
					ShowPage(currentPageId);
					break;
				}
				if (currentPageId == pageId) {
					isNextPage = true;
				}
			}
			
			return false;
		}

		function ShowPage(pageId) {
			var pages = $(".formList");
			for (var i = 0; i < pages.length; i++) {
				if ($(pages[i]).attr('id') == pageId) {
					$(pages[i]).show();
				}
				else {
					$(pages[i]).hide();
				}
			}
		}
	</script>

</head>
<body>
	<form id="form1" runat="server">
	<div>
		<asp:PlaceHolder ID="phContent" runat="server"></asp:PlaceHolder>
	</div>
	</form>
</body>
</html>
