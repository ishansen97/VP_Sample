$(document).ready(function () {

	var saveButton = $(".saveButton");
	var fileNameTextBox = $(".fileName");
	var editedImage = $(".editedImage");

	$(".editImage").click(function () {
		$(".editCanvas").empty().append('<img id="image" class="editingImage">');
		var editingImage = $(".editingImage");
		
		var src = $(this).attr("src");
		editingImage.attr("src", src);
		editingImage.css({ 'height': 300, 'width': 400 });

		editedImage.attr("src", src);
		$("input[id$='originalImageWidth']").val(editedImage.width());
		$("input[id$='originalImageHeight']").val(editedImage.height());
		editedImage.show();

		setImageSelector(editingImage);

		$("input[id$='editingImgUrl']").val(src);

		setFileName(fileNameTextBox, src);
	});

	if ($("input[id$='editingImgUrl']").val() != '') {
		$(".editCanvas").empty().append('<img id="image" class="editingImage">');
		var editingImage = $(".editingImage");

		var src = $("input[id$='editingImgUrl']").val();
		editingImage.attr("src", src);
		editingImage.css({ 'height': 300, 'width': 400 });
		setImageSelector(editingImage);

		if (editedImage.attr("src") == "") {
			editedImage.attr("src", src);
		}
		
		$("input[id$='editingImgUrl']").val(src);

		setFileName(fileNameTextBox, src);
	}
	else {
		fileNameTextBox.val("");
		$(".editCanvas").empty();
		editedImage.hide();
	}

	$(".deleteButton").click(function () {
		$("input[id$='editingImgUrl']").val("");
	});
});

function setFileName(fileNameTextBox, url) {
	url = decodeURIComponent(url);
	var filename = url.substring(url.lastIndexOf('/') + 1);
	filename = filename.substring(0, filename.lastIndexOf('?'));
	fileNameTextBox.val(filename);
};

function setImageSelector(editingImage) {
	editingImage.imgAreaSelect({ 
		handles: true,
		onSelectEnd: storeCoords
	 });
};

function storeCoords(img, selection) {
	$("input[id$='cropX']").val(selection.x1);
	$("input[id$='cropY']").val(selection.y1);
	$("input[id$='cropWidth']").val(selection.width);
	$("input[id$='cropHeight']").val(selection.height);
};
