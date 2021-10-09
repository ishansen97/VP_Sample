
RegisterNamespace("VP.Forms.Designer");
RegisterNamespace("VP.Pages.Designer");

VP.Pages.Designer.PageId = null;
VP.Pages.Designer.TemplateType = 1;

VP.Pages.Designer.Toolbox = function() {
};

VP.Pages.Designer.Toolbox.prototype.Initialize = function() {
	$(document).ready(function() {
		$("#toolbox .toolboxItem").draggable({
			helper: "clone",
			rivert: true,
			appendTo: 'body'
		});
	});
};

$(document).ready(function() {

	$("#propertyDialog").jqm(
	{
		modal: true
	});

	var toolBox = new VP.Pages.Designer.Toolbox();
	toolBox.Initialize();

	if (VP.Pages.Designer.PageId == 0) {
		VP.Pages.Designer.PageId = null;
	}

	var canvas = new VP.Pages.Designer.Canvas();
	VP.Pages.Designer.CanvasInstance = canvas;
	canvas.Initialize();

	canvas.Load();

	if (!VP.Pages.Designer.PageId) {
		$("a[id*=lnkBack]").hide();
	}

	$("#btnSave").click(function() {
		canvas.Save();
	});


});