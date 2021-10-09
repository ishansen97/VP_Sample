
RegisterNamespace("VP.Forms.Designer");

VP.Forms.Designer.ToolboxItem = function() {
	var p = new Object();
}

VP.Forms.Designer.Toolbox = function() {

}

VP.Forms.Designer.Toolbox.prototype.Initialize = function() {
	$(document).ready(function() {
		$(window).scroll(function() {
			$("#toolbox1").animate(
			{ marginTop: $(window).scrollTop() + "px" },
			{ queue: false, duration: 350 });
		});

		$("#toolbox .toolboxItem").draggable(
		{
			helper: "clone",
			rivert: true
		});
	});
}

var canvas;

$(document).ready(function() {

	var toolBox = new VP.Forms.Designer.Toolbox();
	toolBox.Initialize();

	canvas = new VP.Forms.Designer.Canvas();
	canvas.Initialize();

	if (formId == 0) {
		canvas.LoadDefaultForm();
	}
	else {
		canvas.LoadForm(formId);
	}

	VP.Forms.Designer.CanvasInstance = canvas;

	$("#btnSave").click(function() {
		canvas.SaveForm();
	});

	$("#btnCancel").click(function() {
		window.location = redirectUrl;
	});

	$("#deleteForm").click(function() {
		if (confirm("Are you sure you want to delete this form?")) {
			canvas.DeleteForm();
		}
	});

	$("#custom").keypress(function(event) {
		if (event.which == 13) {
			$("#propertySave").click();
			event.returnValue = false;
			event.cancel = true;
			event.keyCode = 0;
			return false;
		}
	});

});



