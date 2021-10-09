$(document).ready(function() {
	intiateCommentList();
});

var prm = Sys.WebForms.PageRequestManager.getInstance();

prm.add_endRequest(function() {
	intiateCommentList();
});


function intiateCommentList() {

	$("input[id$='txtStartDate']").datepicker(
		{
			changeYear: true
		});
	$("input[id$='txtEndDate']").datepicker(
		{
			changeYear: true
		});

	$("input[id$='chkTimeDuration']").click(function() {
		if (!$("input[id$='chkTimeDuration']")[0].checked) {
			$("[id$='txtStartDate']").val("");
			$("[id$='txtEndDate']").val("");
		}
	});
	$("input[id$='chkCommentById']").click(function() {
		if ($("input[id$='chkCommentById']")[0].checked) {
			$("input[id$='chkTimeDuration']").removeAttr("checked");
			$("[id$='txtStartDate']").val("");
			$("[id$='txtEndDate']").val("");
			$("select[id$='ddlArticleType']").val("");
			$("select[id$='ddlArticleList']").val("");
			$("select[id$='ddlArticleList']").attr("disabled", "disabled");
			$("[id$='txtStartDate']").attr("disabled", "disabled");
			$("[id$='txtEndDate']").attr("disabled", "disabled");
			$("input[id$='chkTimeDuration']").attr("disabled", "disabled");

		}
		else {
			$("[id$='txtCommentId']").val("");
			$("[id$='txtStartDate']").removeAttr("disabled");
			$("[id$='txtEndDate']").removeAttr("disabled");
			$("input[id$='chkTimeDuration']").removeAttr("disabled");
		}
	});
	$("select[id$='ddlArticleType']").change(function() {
		$("input[id$='chkCommentById']").removeAttr("checked");
	});
	$("select[id$='ddlArticleList']").change(function() {
		$("input[id$='chkCommentById']").removeAttr("checked");
	});
	if ($("input[id$='chkCommentById']").attr("checked")) {
		$("[id$='txtStartDate']").attr("disabled", "disabled");
		$("[id$='txtEndDate']").attr("disabled", "disabled");
		$("input[id$='chkTimeDuration']").attr("disabled", "disabled");
	}
}


function ValideteCommentList() {
	$("#divCommentGrid").hide({ duration: 0 });
	var isvalied = true;
	isvalied = validateDropdownLists() && isvalied;
	isvalied = validateDateRange() && isvalied;
	if (isvalied) {
		$("#divCommentGrid").show({ duration: 0 });
	}
	return isvalied;
}

function validateDropdownLists() {
	if ($("select[id$='ddlArticleType']").val() > 0) {
		if ($("select[id$='ddlArticleList']").val() > 0) {
			return true;
			$(".lblMessage")[0].innerHTML = "";
		}
		else {
			$(".lblMessage")[0].innerHTML = "Please select an article";
			return false;
		}
	}
	$(".lblMessage")[0].innerHTML = "";
	return true;
}

function validateDateRange() {
	if (!$("input[id$='chkTimeDuration']")[0].checked) {
		return true;
	}
	if ($("input[id$='chkTimeDuration']")[0].checked && ($("[id$='txtStartDate']").val() != "") 
			&& ($("[id$='txtEndDate']").val() != "")) {
		return true;
	}
	else {
		$(".lblMessage")[0].innerHTML = "Please enter start date and end date";
		return false;
	}
}