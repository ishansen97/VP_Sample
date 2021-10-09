RegisterNamespace("VP.ForumThreadPost");

$(document).ready(function() {
	$("input[id$='txtFromDate']").datepicker(
	{
		changeYear: true
	});

	$("input[id$='txtToDate']").datepicker(
	{
		changeYear: true
	});

	$(".author_srh_btn").click(function() {
		$(".author_srh_pane").toggle("slow");
		$(this).toggleClass("hide_icon");
		if ($("input[id$='hdnIsPostBack']").val() == "True") {
			$("input[id$='hdnIsPostBack']").val("False");
		}
		else {
			$("input[id$='hdnIsPostBack']").val("True");
		}
	});

	if ($("input[id$='hdnIsPostBack']").val() == "True") {
		$(".author_srh_pane").toggle("slow");
		$(".author_srh_btn").addClass("hide_icon");
	}
	else {
		$(".common_data_grid td table").removeAttr("width").width('100%');
	}
});