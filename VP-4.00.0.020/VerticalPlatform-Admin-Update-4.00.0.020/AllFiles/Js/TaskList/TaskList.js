RegisterNamespace("VP.TaskList");

VP.TaskList.TriggerInformation = null;
VP.TaskList.TriggerSettingManager = null;
VP.TaskList.TaskSettingManager = null;
VP.TaskList.TaskInformation = null;

VP.TaskList = function() {
	var that = this;
	$("div.triggerRow").hide();

	$("a.lnkSetting", "tr.triggerTableRow").live('click', function() {
		var triggerId = VP.TaskList.GetTriggerId($(this));
		VP.TaskList.GetTriggerSettings(triggerId);
		$.popupDialog.openDialog(VP.ApplicationRoot + VP.TaskList.TriggerInformation.SettingPopupDialogUrl);
	});

	$("a.lnkEdit", "tr.triggerTableRow").live('click', function() {
		var triggerId = VP.TaskList.GetTriggerId($(this));
		VP.TaskList.GetTriggerSettings(triggerId);
		$.popupDialog.openDialog(VP.ApplicationRoot + VP.TaskList.TriggerInformation.EditPopupDialogUrl);
	});

	$("a.lnkDelete", "tr.triggerTableRow").live('click', function() {
		if (confirm("Are you sure you want to delete?")) {
			var triggerId = VP.TaskList.GetTriggerId($(this));
			var taskId = VP.TaskList.GetTaskId($(this));
			var deleted = VP.TaskList.DeleteTrigger(triggerId);
			if (deleted) {
				var triggerRow = $(".divTriggerRow_" + taskId).empty();
				VP.TaskList.GetTriggerList(taskId, triggerRow);
			}
		}
	});

	$("#divTaskHistory").jqm({
		modal: true
	});

	$("#btnCloseTaskHistory", "#divTaskHistory").live('click', function() {
		$("#divTaskHistory").jqmHide();
	});

	$("a.taskHistory", "div.taskRow").live('click', function() {
		var taskId = VP.TaskList.GetTaskId($(this));
		VP.TaskList.ShowTaskHistory(taskId, 10, 1);
	});

	$("a.taskReset", "div.taskRow").live('click', function() {
		if (confirm("Are you sure you want to reset?")) {
			var taskId = VP.TaskList.GetTaskId($(this));
			VP.TaskList.ResetTask(taskId);
		}
	});

	$("a.taskEdit", "div.taskRow").live('click', function() {
		var taskId = VP.TaskList.GetTaskId($(this));
		VP.TaskList.GetTaskSettings(taskId);
		$.popupDialog.openDialog(VP.ApplicationRoot + VP.TaskList.TaskInformation.EditPopupDialogUrl);
	});

	$("a.lnkAddTrigger", "div.taskRow").live('click', function() {
		var taskId = VP.TaskList.GetTaskId($(this));
		VP.TaskList.GetTaskSettings(taskId);
		$.popupDialog.openDialog(VP.ApplicationRoot + VP.TaskList.TaskInformation.EditPopupDialogUrl);
	});

	$("a.taskSettings", "div.taskRow").live('click', function() {
		var taskId = VP.TaskList.GetTaskId($(this));
		VP.TaskList.GetTaskSettings(taskId);
		$.popupDialog.openDialog(VP.ApplicationRoot + VP.TaskList.TaskInformation.SettingPopupDialogUrl);
	});
}

VP.TaskList.TaskRowClicked = function(taskId, taskTree) {
	var taskRow = $(taskTree).parents("div.taskRow");
	if (taskRow.data("triggersAdded") == null) {
		VP.TaskList.GetTriggerList(taskId,
				$(".divTriggerRow_" + taskId, taskRow.next()));
		taskRow.data("triggersAdded", "True");
	}
	taskRow.toggleClass("active").next().slideToggle("slow");
}

VP.TaskList.GetTriggerList = function(taskId, element) {
	var that = this;
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: VP.AjaxWebServiceUrl + "/GetTriggerList",
		data: "{'taskId' : " + taskId + "}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function(msg) {
			$(element).append(VP.TaskList.GetTriggerListHtml(taskId, msg.d));
			$("tr.triggerTableRow td.trimmed[title]", ".divTriggerRow_" + taskId).tooltip({ position: "bottom center", opacity: 0.8 });
		},
		error: function(xmlHttpRequest, textStatus, errorThrown) {
			$.notify({ message: 'Internal Server Error, \'TriggerList\' retrieve failed.', type: 'error' });
		}
	});
}

VP.TaskList.GetTriggerListHtml = function(taskId, triggers) {
	var html = "<table class='triggerTable table table-bordered' width='100%'><tr class='tiggerHeaderRow'>" +
			"<th width='10%'>Id</th>" +
			"<th width='30%'>Name</th>" +
			"<th width='10%'>Type</th>" +
			"<th width='10%'>Enabled</th>" +
			"<th width='10%'></th>" +
			"<th width='10%'></th>" +
			"<th width='10%'></th></tr>";
	for (index in triggers) {
		html += "<tr class='triggerTableRow'><td>" + triggers[index].Id + "</td>" +
			VP.TaskList.GetTriggerRow(triggers[index].TriggerName) +
			"<td>" + VP.TaskList.GetTriggerTypeName(triggers[index].Type) + "</td><td>" + triggers[index].Enabled +
			"</td><td><a class='lnkSetting aDialog' onclick='return false;' rel='" + taskId + "|" + triggers[index].Id + "'>Settings</a></td>" +
			"<td><a class='lnkEdit aDailog' onclick='return false;' rel='" + taskId + "|" + triggers[index].Id + "'>Edit</a></td>" +
			"<td><a class='lnkDelete' onclick='return false;' rel='" + taskId + "|" + triggers[index].Id + "'>Delete</a></td></tr>";
	}
	html += "</table>";
	return html;
}

VP.TaskList.GetTriggerSettings = function(triggerId) {
	var that = this;
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: VP.AjaxWebServiceUrl + "/GetTriggerSettings",
		data: "{'triggerId' : " + triggerId + "}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function(msg) {
			VP.TaskList.TriggerInformation = msg.d;
		},
		error: function(xmlHttpRequest, textStatus, errorThrown) {
			$.notify({ message: 'Internal Server Error, \'TriggerSettings\' retrieve failed.', type: 'error' });
		}
	});
}

VP.TaskList.GetTaskSettings = function(taskId) {
	var that = this;
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: VP.AjaxWebServiceUrl + "/GetTaskSettings",
		data: "{'taskId' : " + taskId + "}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function(msg) {
			VP.TaskList.TaskInformation = msg.d;
		},
		error: function(xmlHttpRequest, textStatus, errorThrown) {
			$.notify({ message: 'Internal Server Error, \'TaskSettings\' retrieve failed.', type: 'error' });
		}
	});
}

VP.TaskList.ShowTaskHistory = function(taskId, pageSize, currentPage) {
	var that = this;
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: VP.AjaxWebServiceUrl + "/GetTaskHistory",
		data: "{'taskId' : " + taskId + ",'pageSize' : " + pageSize + ", 'currentPage' : " + currentPage + "}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function(msg) {
			VP.TaskList._currentTaskId = taskId;
			VP.TaskList.PageSize = pageSize;
			VP.TaskList.CurrentPageCount = Math.ceil(msg.d.TotalCount / VP.TaskList.PageSize);
			$("#divTaskHistoryPager").pager({ pagenumber: currentPage, pagecount: VP.TaskList.CurrentPageCount,
				buttonClickCallback: VP.TaskList.PagerClicked
			});
			var html = VP.TaskList.GetTaskHistoryHtml(msg.d.TaskHistories);
			$("#divTaskHistoryList", "#divTaskHistory").text("").prepend(html);
			$("tr.taskHistoryRow td.trimmed[title]", "#divTaskHistory").tooltip({ position: "bottom center", opacity: 0.8 });
			$("#divTaskHistory").jqmShow();
		},
		error: function(xmlHttpRequest, textStatus, errorThrown) {
			$.notify({ message: 'Internal Server Error, \'TaskHistory\' retrieve failed.', type: 'error' });
		}
	});
}

VP.TaskList.PagerClicked = function(clickedPage) {
	VP.TaskList.ShowTaskHistory(VP.TaskList._currentTaskId, VP.TaskList.PageSize, clickedPage);
}

VP.TaskList.GetTaskHistoryHtml = function(histories) {
	var html = "<table id='taskHistoryTable'>";
	html += "<tr>" +
			"<th><b>Task ID</b></th>" +
			"<th><b>Trigger ID</b></th>" +
			"<th><b>Status</b></th>" +
			"<th><b>Status Message</b></th>" +
			"<th><b>Start Time</b></th>" +
			"<th><b>End Time</b></th>" +
			"</tr>";
	for (index in histories) {
		var statusMsgRow = VP.TaskList.GetStatusMessageRow(histories[index].StatusMessage);

		var statusCode = histories[index].StatusCode;
		var statusClass = "none";
		if (statusCode == 1) {
			statusClass = "success";
		}
		else if (statusCode == 2) {
			statusClass = "error";
		}
		else if (statusCode == 3) {
			statusClass = "warning";
		}
		
		html += "<tr class = 'taskHistoryRow " + statusClass + "'>" +
				"<td>" + histories[index].TaskId + "</td>" +
				"<td>" + histories[index].TriggerId + "</td>" +
				"<td>" + histories[index].Status + "</td>" +
				statusMsgRow +
				"<td>" + histories[index].StartTime + "</td>" +
				"<td>" + histories[index].EndTime + "</td>" +
				"</tr>";
	}
	html += "</table>";

	return html;
}

VP.TaskList.GetStatusMessageRow = function(message) {
	if (message.length > 30) {
		var trimmedMessage = message.substr(0, 26) + " ...";
		message = "<td title='" + message + "' class='trimmed'>" + trimmedMessage + "</td>";
	}
	else {
		message = "<td>" + message + "</td>";
	}
	return message;
}

VP.TaskList.SaveTrigger = function(taskInfo) {
	var triggerRow = $(".divTriggerRow_" + taskInfo.taskId).empty();
	VP.TaskList.GetTriggerList(taskInfo.taskId, triggerRow);
}

VP.TaskList.DeleteTrigger = function(triggerId) {
	var deleted = false;
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: VP.AjaxWebServiceUrl + "/DeleteTrigger",
		data: "{'triggerId' : " + triggerId + "}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function(msg) {
			deleted = true;
		},
		error: function(xmlHttpRequest, textStatus, errorThrown) {
			$.notify({ message: 'Internal Server Error, \'Trigger\' delete failed.', type: 'error' });
		}
	});
	return deleted;
}

VP.TaskList.GetTriggerTypeName = function(triggerTypeId) {
	if (triggerTypeId == 1) {
		return "Daily";
	}
	else if (triggerTypeId == 2) {
		return "Weekly";
	}
	else if (triggerTypeId == 3) {
		return "Hourly";
	}
	else if (triggerTypeId == 4) {
		return "Onetime";
	}
	else if (triggerTypeId == 5) {
		return "Minutely";
	}
}

VP.TaskList.GetTriggerRow = function(name) {
	if (name.length > 40) {
		var trimmedName = name.substr(0, 36) + " ...";
		name = "<td title='" + name + "' class='trimmed'>" + trimmedName + "</td>";
	}
	else {
		name = "<td>" + name + "</td>";
	}
	return name;
}

VP.TaskList.GetTriggerId = function(link) {
	var returnValue = null;
	var value = link.attr("rel");
	value = value.split('|');
	if (value.length == 2) {
		returnValue = value[1];
	}

	return returnValue;
}


VP.TaskList.GetTaskId = function(link) {
	var returnValue = null;
	var value = link.attr("rel");
	value = value.split('|');
	if (!isNaN(value[0])) {
		returnValue = value[0];
	}
	return returnValue;
}

VP.TaskList.ResetTask = function(taskId) {
	var that = this;
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: VP.AjaxWebServiceUrl + "/ResetTask",
		data: "{'taskId' : " + taskId + "}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function(msg) {
			$("td.colRunTime", "#taskTable_" + taskId).html("");
			$("td.colStatus", "#taskTable_" + taskId).html("");
		},
		error: function(xmlHttpRequest, textStatus, errorThrown) {
			$.notify({ message: 'Internal Server Error, \'Task\' reset failed.', type: 'error' });
		}
	});
}
