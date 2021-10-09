<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DialogHost.aspx.cs" Inherits="VerticalPlatformAdminWeb.DialogHost" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
	<title>Popup dialog</title>

	<script src="Js/JQuery/jquery-1.4.2.min.js" type="text/javascript"></script>

	<script src="Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>

	<script src="Js/JQuery/jquery.modal.js" type="text/javascript"></script>

	<script src="Js/PopupDialog.js" type="text/javascript"></script>

	<script src="Js/Utility.js" type="text/javascript"></script>

	<script src="Js/JQuery/jquery.pager.js" type="text/javascript"></script>

	<script src="Js/ContentPicker.js" type="text/javascript"></script>

	<script src="Js/Notify.js" type="text/javascript"></script>

	<script src="Js/ValidationSummary.js" type="text/javascript"></script>

	<script type="text/javascript">
	
		RegisterNamespace("VP.AdminWeb");
		
		$(document).ready(function() {
			$(".dialog_close").click(function() {
				$.popupDialog.close();
				return false;
			});

			var theiFrame = $("#popupDialogIframe", parent.document.body);
			var popUpWidth = $(".dialog_content_inner").width();
			var contentHeight = $(".dialog_content").height();
			var dialogHeader = $(".dialog_content").height();
			theiFrame.height($(parent.document).height());
			theiFrame.width($(parent.document.body).width());
			var divHeight = ($(parent.window).height())- 20;

			if (popUpWidth < 645) {
				$(".dialog_container").width(popUpWidth + 50);
			}

			if (contentHeight < 349) {
				$(".dialog_buttons").css({"width": $(".dialog_container").width() - 6 });
			}
			else {
				$(".dialog_buttons").css({"width": ($(".dialog_container").width()) - 22 });
			}

            $(".main-wrapper", parent.document.body).css({'height': divHeight });
			
			$("span[id*='show_progress_div']").hide();
		});
		
		VP.AdminWeb.ShowProgress = function() {
			$("span[id*='show_progress_div']").show();
		};

		VP.AdminWeb.HideProgress = function () {
			$("span[id*='show_progress_div']").hide();
		};
	</script>
    
</head>
<body>
    <style type="text/css">
		body, html
		{
			background: transparent none;
		}
		
		
		.ui-widget input, .ui-widget select, .ui-widget textarea
		{
			font-family:Arial, Sans-Serif;
			font-size:12px !important;
		}
		.ui-widget input.common_text_button
		{
			font-size:10px !important;
			font-family: Verdana,Arial,Helvetica,sans-serif !important;
		}
		.ui-widget select
		{
			height:auto !important;
		}
	</style>
	<form id="form1" runat="server">
	<asp:ScriptManager ID="ScriptManager1" runat="server" />
	<div id="dialogContainer" runat="server" class="dialog_container">
		<div class="dialog_header clearfix">
			<h2>
				<asp:Literal ID="ltlTitle" runat="server"></asp:Literal>
			</h2>
			<div id="closeDialog" class="dialog_close">
				x
			</div>
		</div>
		<div class="select_site_panel_outer">
			<div class="dialog_content_outer">
				<div class="dialog_content clearfix">
					<div class="clearfix">
						<div class="dialog_content_inner">
							<asp:PlaceHolder ID="phPopupContainer" runat="server"></asp:PlaceHolder>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="dialog_footer">
		</div>
		<div class="dialog_buttons main">
			<div class="dialog_buttons_inner">
				<asp:Button ID="btnSave" runat="server" OnClick="btnSave_Click" Visible="false" 
					CssClass="btn" OnClientClick="VP.AdminWeb.ShowProgress();"/>
				<asp:Button ID="btnSaveAndContinue" runat="server" OnClick="btnSaveAndContinue_Click"
					Visible="false" CssClass="btn lower_case" OnClientClick="VP.AdminWeb.ShowProgress();"/>
				<asp:Button ID="btnOk" runat="server" Text="Ok" OnClick="btnOk_Click" Visible="false"
					CssClass="btn" OnClientClick="VP.AdminWeb.ShowProgress();"/>
				<asp:Button ID="btnClose" runat="server" Text="Close" class="dialog_close btn"
					Visible="false" CausesValidation="False" />
				<asp:Button ID="btnCancel" runat="server" Text="Cancel" class="dialog_close btn"
					Visible="false" CausesValidation="False" />
				<span id="show_progress_div" style="margin-left:10px;">
					<asp:Image ID="imgProgress" runat="server" ImageUrl="~/Images/Progress.gif" />
 				</span>
			</div>
		</div>
	</div>
	</form>
</body>
</html>
