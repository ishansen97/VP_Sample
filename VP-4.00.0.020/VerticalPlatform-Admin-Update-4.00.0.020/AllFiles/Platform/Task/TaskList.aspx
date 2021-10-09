<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TaskList.aspx.cs" Inherits="VerticalPlatformAdminWeb.Platform.Task.TaskList"
	MasterPageFile="~/MasterPage.Master" %>

<%@ Register Src="../../ModuleAdmin/Pager.ascx" TagName="Pager" TagPrefix="uc1" %>
<asp:Content ID="conContent" ContentPlaceHolderID="cphContent" runat="server">
	<script src="../../Js/JQuery/jquery.pager.js" type="text/javascript"></script>
	<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>
	<script src="../../Js/JQuery/jquery.modal.js" type="text/javascript"></script>
	<script src="../../Js/JQuery/jquery.json-1.3.min.js" type="text/javascript"></script>
	<script src="../../Js/TaskList/TaskList.js" type="text/javascript"></script>
	<script src="../../Js/JQuery/tooltip.min.js" type="text/javascript"></script>
	<script type="text/javascript">
		var taskList = null;
		$(document).ready(function () {
			taskList = new VP.TaskList();
			$(".campaign_srh_btn").click(function () {
				$(".campaign_srh_pane").toggle("slow");
				$(this).toggleClass("hide_icon");
				$("#divSearchCriteria").toggleClass("hide");
			});

			$("#divSearchCriteria").append(VP.TaskList.GetSearchCriteriaText());
			$(".triggerTable").attr("cellpadding", 0);
			$(".triggerTable").attr("cellspacing", 0);
		});

		VP.TaskList.CurrentPageCount = null;
		VP.TaskList.PageSize = null;

		VP.TaskList.GetSearchCriteriaText = function () {
			var ddlSites = $("select[id$='ddlSites']");
			var ddlTaskType = $("select[id$='ddlTaskType']");
			var ddlTaskStatus = $("select[id$='ddlTaskStatus']");
			var txtTaskName = $("input[id$='txtTaskName']");
			var searchHtml = "";
			if (ddlSites.val() != "-1") {
				searchHtml += " ; <b>Site</b> :" + $("option[selected]", ddlSites).text().trim();
			}

			if (ddlTaskType.val() != "-1") {
				searchHtml += " ; <b>Task Type</b> :" + $("option[selected]", ddlTaskType).text().trim();
			}

			if (ddlTaskStatus.val() != "-1") {
				searchHtml += " ; <b>Task Status</b> :" + $("option[selected]", ddlTaskStatus).text().trim();
			}

			if (txtTaskName.val().trim().length > 0) {
				searchHtml += " ; <b>Task Name</b> : " + txtTaskName.val().trim();
			}

			searchHtml = searchHtml.replace(' ;', '(');
			if (searchHtml) {
				searchHtml += " )";
			}
			return searchHtml;
		};
	</script>
	<div class="AdminPanel">
		<asp:ScriptManagerProxy ID="smScript" runat="server">
			<Services>
				<asp:ServiceReference InlineScript="true" Path="~/Services/AjaxService.asmx" />
			</Services>
		</asp:ScriptManagerProxy>
		<div class="AdminPanelHeader">
			<h3>
				<asp:Label ID="lblHeader" runat="server" Text="Task List" BackColor="Transparent"></asp:Label>
			</h3>
		</div>
		<div class="AdminPanelContent">
			<div class="campaign_srh_btn">
				Filter</div>
			<div id="divSearchCriteria">
			</div>
			<br />
			<div class="campaign_srh_pane" style="display: none;">
				<div class="form-horizontal">
					<div class="control-group">
						<label class="control-label">
							Site</label>
						<div class="controls">
							<asp:DropDownList runat="server" ID="ddlSites" AppendDataBoundItems="true" Width="220">
								<asp:ListItem Text="-Select-" Value="-1"></asp:ListItem>
							</asp:DropDownList>
							<asp:RequiredFieldValidator runat="server" ID="rfvSite" ControlToValidate="ddlSites"
								ErrorMessage="Please select valid site."></asp:RequiredFieldValidator>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">
							Task Type</label>
						<div class="controls">
							<asp:DropDownList runat="server" ID="ddlTaskType" AppendDataBoundItems="true" Width="220">
								<asp:ListItem Text="-Select-" Value="-1"></asp:ListItem>
							</asp:DropDownList>
							<asp:RequiredFieldValidator runat="server" ID="rfvTaskType" ControlToValidate="ddlTaskType"
								ErrorMessage="Please select valid task type."></asp:RequiredFieldValidator>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">
							Task Status</label>
						<div class="controls">
							<asp:DropDownList runat="server" ID="ddlTaskStatus" AppendDataBoundItems="true" Width="220">
								<asp:ListItem Text="-Select-" Value="-1"></asp:ListItem>
							</asp:DropDownList>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">
							Task Name</label>
						<div class="controls">
							<asp:TextBox runat="server" ID="txtTaskName"></asp:TextBox>
						</div>
					</div>
					<div class="form-actions">
						<asp:Button runat="server" ID="btnApply" Text="Apply Filter" OnClick="btnApply_Click"
							CssClass="btn" />
						<asp:Button runat="server" ID="btnReset" Text="Reset" OnClick="btnReset_Click" CssClass="btn" />
					</div>
				</div>
			</div>
			<br />
			<div id="divTaskListMain">
				<div class="add-button-container">
					<asp:HyperLink runat="server" ID="lnkAddTask" CssClass="aDialog btn">Add Task</asp:HyperLink></div>
				<asp:Repeater ID="rptTaskList" runat="server" OnItemDataBound="rptTaskList_ItemDataBound"
					OnItemCommand="rptTaskList_ItemCommand" EnableViewState="false">
					<HeaderTemplate>
						<div>
							<div>
								<div class="taskHeader">
									<table width="100%" cellpadding="0" cellspacing="0" class="common_data_grid table table-bordered">
										<tr class="taskHeaderRow">
											<th class="taskHeaderCorner" width="25" style="padding-right: 0px;">
												<div style="overflow: hidden;">
												</div>
											</th>
											<th width="45" style="padding-right: 0px;">
												<div style="overflow: hidden;">
													<b>Id</b>
												</div>
											</th>
											<th width="100">
												<b>Name</b>
											</th>
											<th width="100">
												<b>Last Run Time</b>
											</th>
											<th>
												<b>Status</b>
											</th>
											<th width="120">
												<b>Type</b>
											</th>
											<th width="120">
												<b>Site</b>
											</th>
											<th width="60">
												<b>Enabled</b>
											</th>
											<th width="110">
												&nbsp;
											</th>
										</tr>
									</table>
								</div>
							</div>
						</div>
					</HeaderTemplate>
					<ItemTemplate>
						<div class="taskRow">
							<table width="100%" cellpadding="0" cellspacing="0" class="common_data_grid table table-bordered"
								id="taskTable_<%# DataBinder.Eval(Container.DataItem, "Id") %>">
								<tr class="taskTableRow status<%# GetStatusCode(Container.DataItem) %>">
									<td class="taskTree" style="padding-right: 0px; width: 25px;" onclick="VP.TaskList.TaskRowClicked(<%# DataBinder.Eval(Container.DataItem, "Id") %>, this);">
										<div style="overflow: hidden;">
										</div>
									</td>
									<td class="colId" style="padding-right: 0px;" width="45">
										<div style="width: 45px; overflow: hidden;">
											<%# DataBinder.Eval(Container.DataItem, "Id") %>
										</div>
									</td>
									<td width="100" class="colName">
										<%# DataBinder.Eval(Container.DataItem, "TaskName") %>
									</td>
									<td width="100" class="colRunTime">
										<%# DataBinder.Eval(Container.DataItem, "LastRunTime")%>
									</td>
									<td class="colStatus">
										<%# DataBinder.Eval(Container.DataItem, "Status")%>
									</td>
									<td width="120" class="colType">
										<asp:Label runat="server" ID="lblTaskType"></asp:Label>
									</td>
									<td width="120" class="colSite">
										<asp:Label runat="server" ID="lblSite"></asp:Label>
									</td>
									<td width="60" class="colEnabled">
										<asp:CheckBox runat="server" ID="chkTaskEnable" Enabled="false" />
									</td>
									<td width="110">
										<asp:HyperLink ID="lnkSettings" onclick="return false;" runat="server" CssClass="taskSettings grid_icon_link settings"
											ToolTip="Settings">Settings</asp:HyperLink>
										<a onclick="return false;" class="taskHistory grid_icon_link history" rel="<%# DataBinder.Eval(Container.DataItem, "Id") %>"
											title="History">History</a> <a onclick="return false;" class="taskReset grid_icon_link reset"
												rel="<%# DataBinder.Eval(Container.DataItem, "Id") %>" title="Reset">Reset</a>
										<a onclick="return false;" class="taskEdit grid_icon_link edit" rel="<%# DataBinder.Eval(Container.DataItem, "Id") %>"
											title="Edit">Edit</a>
										<asp:LinkButton ID="lbtnDeleteTask" runat="server" OnClientClick="return confirm('Are you sure to delete this task and associated content?');"
											CssClass="grid_icon_link delete" ToolTip="Delete" CommandName="DeleteTask">Delete</asp:LinkButton>
									</td>
								</tr>
							</table>
						</div>
						<div class="triggerRow">
							<div class="add-button-container">
								<asp:HyperLink runat="server" ID="lnkAddTrigger" CssClass="aDialog btn">Add Trigger</asp:HyperLink></div>
							<div class="divTriggerRow_<%# DataBinder.Eval(Container.DataItem, "Id") %>">
							</div>
						</div>
					</ItemTemplate>
				</asp:Repeater>
				<uc1:Pager ID="PagerTaskList" runat="server" OnPageIndexClickEvent="pagerTaskList_PageIndexClick" />
			</div>
			<div id="divTaskHistory" class="jqmWindow">
				<div class="dialog_container">
					<div class="dialog_header clearfix">
						<h2>
							Task History</h2>
						<div id="btnCloseTaskHistory" class="dialog_close">
							x</div>
					</div>
					<div class="select_site_panel_outer">
						<div class="dialog_content_outer">
							<div class="dialog_content1">
								<div id="divTaskHistoryList" style="padding: 10px; padding-bottom: 0px;">
								</div>
								<div id="divTaskHistoryPager" style="display: inline-table; padding: 10px;">
								</div>
							</div>
						</div>
					</div>
					<div class="dialog_footer">
					</div>
				</div>
			</div>
		</div>
	</div>
</asp:Content>
