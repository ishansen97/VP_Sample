<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="RunningTasks.aspx.cs" Inherits="VerticalPlatformAdminWeb.Platform.Task.RunningTasks" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
	<script language="javascript" type="text/javascript">

		var refreshInterval = '<%=RefreshInterval %>';
		if (refreshInterval == "") {
			refreshInterval = "30";
		}
		var interval = parseInt(refreshInterval) * 1000;

		$(document).ready(function () {
			RenderTasks();

			setInterval(RenderTasks, interval);
		});

		function RenderTasks() {
			$.ajax({
				url: "/services/AjaxService.asmx/GetRunningTasks",
				timeout: 10000,
				contentType: "application/json; charset=utf-8",
				dataType: "json",
				cache: false,
				success: function (data) {
					var tasks = $.parseJSON($.parseJSON(data.d));
					RenderTaskData(tasks);
				},
				error: function (jqXhr, textStatus, errorThrown) {
					$("#taskProgress").empty().append("Error occurred while retrieving task details. Error thrown : '" + textStatus + "'");
				}
			});
		}

		function RenderTaskData(tasks) {
			var html = "";
			if (tasks != null && tasks.length > 0) {
				for (var i = 0; i < tasks.length; i++) {
					var task = tasks[i];
					html += "<div class='taskProgress'>";
					html += "<div class='taskProgressRow'>";
					html += "<div class='taskName'><strong>Task Name:</strong> " + task.TaskName + "(" + task.TaskId + ")</div>";
					html += "<div class='taskStarted'><strong>Started At:</strong>  " + task.StartedTime + "</div>";
					html += "<div class='taskDuration'><strong>Running For:</strong>  " + task.RunningTime + "</div>";
					html += "</div>";
					if (task.Message != null && task.Message != "") {
						html += "<div class='taskMessage'>" + task.Message + "</div>";
					}

					html += "</div>";
				}
			}
			else {
				html = "No tasks running.";
			}

			$("#taskProgress").empty().append(html);
		}
</script>

<div class="taskSpawnControls">
	<div class="control-group">
		Spawn New Tasks Status
		&nbsp;&nbsp;
		<asp:Button ID="spawnToggle" runat = "server" class="btn" onclick="spawnToggle_Click"/>
	</div>
</div>
<hr />

<div id="taskProgress">

</div>
</asp:Content>
