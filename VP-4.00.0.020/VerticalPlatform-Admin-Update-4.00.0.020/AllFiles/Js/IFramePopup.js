RegisterNamespace("VP.IFramePopup");

$(document).ready(function() {
	Sys.WebForms.PageRequestManager.getInstance().add_endRequest(VP.IFramePopup.EndRequestHandler);
	VP.IFramePopup.Init();
});

VP.IFramePopup.Init = function()
{
	$("#dialog").jqm(
	{
		modal:true,
		overlay:50,
		trigger:$('.aDialog'),
		target:$('#jqmContent'),
		onHide:VP.IFramePopup.closeModal,
		onShow:VP.IFramePopup.openInFrame
	});
	$("#btnCancel").click(function ()
	{
		$("#dialog").jqmHide();
	});
};

VP.IFramePopup.closeModal = function(hash)
{
	var $modalWindow = $(hash.w);
	var $modalContainer = $('iframe', $modalWindow);
	$modalContainer.html('').attr('src', '');
	$modalWindow.fadeOut('2000', function()
	{
		hash.o.remove();
		if (hash.refreshAfterClose == true)
		{
			window.document.forms[0].submit();
		}
	});
};

VP.IFramePopup.openInFrame = function(hash)
{
	var $modalWindow = $(hash.w);
	var $trigger = $(hash.t);
	var $modalContainer = $('iframe', $modalWindow);
	var myUrl = $trigger.attr('href');
	$modalContainer.html('').attr('src', myUrl);
	hash.refreshAfterClose = true;
	$modalWindow.show();
};

VP.IFramePopup.EndRequestHandler = function (sender, args)
{
	VP.IFramePopup.Init();
};




