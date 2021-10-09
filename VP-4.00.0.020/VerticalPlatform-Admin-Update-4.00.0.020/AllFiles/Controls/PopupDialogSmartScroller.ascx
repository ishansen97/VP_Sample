<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="PopupDialogSmartScroller.ascx.cs" Inherits="VerticalPlatformAdminWeb.Controls.PopupDialogSmartScroller" %>
<script type="text/javascript">
RegisterNamespace("VP.Scroller");

VP.Scroller = function(hdnField){
	this._dialog = $(".dialog_content");
	this._hiddenField = hdnField;
	var that = this;
	
	this._dialog.scroll(function()
	{
		that.RecordPopupScrollPosition();
	});
	
	this._dialog.click(function(){
		that.RecordPopupScrollPosition();
	});
	
	$(window).load( function()
	{
		that.LoadScrollPosition();
	});
};

VP.Scroller.prototype.RecordPopupScrollPosition = function()
{
	var scrollY = this._dialog.scrollTop();
	$("#" + this._hiddenField).val(scrollY);
};

VP.Scroller.prototype.LoadScrollPosition = function()
{
	var y = $("#" + this._hiddenField).val();
	this._dialog.scrollTop(y);
};
</script>
<asp:HiddenField ID="hdnYCoordinateHolder" runat="server" />