<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RapidJobQueueList.aspx.cs" MasterPageFile="~/MasterPage.Master"
	Inherits="VerticalPlatformAdminWeb.Platform.Task.RapidJobQueueList" %>

<%@ Register Src="../../ModuleAdmin/Pager.ascx" TagName="Pager" TagPrefix="uc1" %>
<asp:Content ID="rapidJobQueue" ContentPlaceHolderID="cphContent" runat="server">
	<script src="../../Js/ContentPicker.js" type="text/javascript"></script>
	<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>
	<script src="../../Js/JQuery/jquery.pager.js" type="text/javascript"></script>

	<script type="text/javascript">
		RegisterNamespace("VP.JobQueueList");

		VP.JobQueueList.Initialize = function () {
			$(document).ready(function () {
				var vendorIdElement = { contentId: "vendorId" };
				var vendorNameElement = { contentName: "vendorName" };
				var vendorNameOptions = { siteId: VP.SiteId, type: "Vendor", currentPage: "1", pageSize: "15", showName: "true", bindings: vendorIdElement };
				var vendorIdOptions = { siteId: VP.SiteId, type: "Vendor", currentPage: "1", pageSize: "15", bindings: vendorNameElement };
				$("input[type=text][id*=vendorName]").contentPicker(vendorNameOptions);
				$("input[type=text][id*=vendorId]").contentPicker(vendorIdOptions);

				$(".campaign_srh_btn").click(function () {
					$(".jobQueue_srh_pane").toggle("slow");
					$(this).toggleClass("hide_icon");
					$("#divSearchCriteria").toggleClass("hide");
				});

				$("#divSearchCriteria").append(VP.JobQueueList.GetSearchCriteriaText());
			});
		}

		VP.JobQueueList.GetSearchCriteriaText = function () {
			var vendorNameValue = $("input[id$='vendorName']");
			var vendorIdValue = $("input[id$='vendorId']");
			var actionListValue = $("select[id$='actionList']");

			var searchHtml = "";
			if (vendorNameValue.length && vendorNameValue.val().trim().length > 0 || vendorIdValue.length && vendorIdValue.val().trim().length > 0) {
				searchHtml += " ; <b>Vendor : </b> " + vendorNameValue.val().trim() + " (" + vendorIdValue.val().trim() + ")";
			}

			if (actionListValue.val() != "-1") {
				searchHtml += " ; <b>Action</b> :" + $("option[selected]", actionListValue).text().trim();
			}

			searchHtml = searchHtml.replace(' ;', '(');
			if (searchHtml != "") {
				searchHtml += " )";
			}
			return searchHtml;
		};

		VP.JobQueueList.Initialize();
	</script>

	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>
				Rapid Job Queue List
			</h3>
		</div>
		<div class="campaign_srh_btn">Filter</div>
		<div id="divSearchCriteria">
		</div>
		<br />
		<div class="jobQueue_srh_pane" style="display: none;">
			<div class="form-horizontal">
				<div class="control-group">
					<label class="control-label">Vendor</label>
					<div class="controls">
						<asp:TextBox runat="server" ID="vendorName"></asp:TextBox>
						<asp:TextBox runat="server" ID="vendorId"></asp:TextBox>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Action</label>
					<div class="controls">
						<asp:DropDownList runat="server" ID="actionList" AppendDataBoundItems="true" >
							<asp:ListItem Text="-Select-" Value="-1" Selected="True"></asp:ListItem>
						</asp:DropDownList>
					</div>
				</div>
				<div class="form-actions">
					<asp:Button runat="server" ID="filter" Text="Apply Filter" CssClass="btn" 
						onclick="filter_Click" />
					<asp:Button runat="server" ID="reset" Text="Reset" CssClass="btn" 
						onclick="reset_Click" />
				</div>
			</div>
		</div>
		<br />
		<div class="refresh-button-container">
			<asp:Button ID="refresh" runat="server" CssClass="btn" Style="margin-right: 5px;" Text="Refresh" OnClick = "refresh_Click" />
		</div>
		<br />
		<div class="AdminPanelContent">
			<asp:GridView ID="jobQueueList" runat="server" AutoGenerateColumns="false" CssClass="common_data_grid table table-bordered"
				OnRowDataBound = "JobQueueList_RowDataBound" AllowSorting="True" 
				onsorting="jobQueueList_Sorting">
				<Columns>
					<asp:BoundField HeaderText="Id" DataField="Id" SortExpression = "rjq.job_queue_id" />
					<asp:BoundField HeaderText="Vendor Id" DataField="VendorId" SortExpression = "rjq.vendor_id" />
					<asp:TemplateField HeaderText="Vendor Name">
						<ItemTemplate>
							<asp:Label ID="vendorName" runat="server" CssClass="trimmed"></asp:Label>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:BoundField HeaderText="Job Id" DataField="JobId" SortExpression = "rjq.job_id" />
					<asp:BoundField HeaderText="Action" DataField="Action" SortExpression = "rjq.action" />
					<asp:BoundField HeaderText="Priority" DataField="Priority" />
					<asp:BoundField HeaderText="Queue Time" DataField="QueueTime" SortExpression = "rjq.queue_time" >
						<ItemStyle CssClass="colRunTime" />
					</asp:BoundField>
					<asp:BoundField HeaderText="Start Time" DataField="StartTime" >
						<ItemStyle CssClass="colRunTime" />
					</asp:BoundField>
					<asp:BoundField HeaderText="Stop Time" DataField="StopTime" >
						<ItemStyle CssClass="colRunTime" />
					</asp:BoundField>
					<asp:TemplateField HeaderText="Error Description">
						<ItemTemplate>
							<asp:Label ID="errorDescription" runat="server" CssClass="trimmed"></asp:Label>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField>
						<ItemTemplate>
							<asp:HyperLink ID="jobLog" class="jobLog grid_icon_link history aDialog" runat="server" Visible = "false"></asp:HyperLink>
						</ItemTemplate>
					</asp:TemplateField>
				</Columns>
				<EmptyDataTemplate>
					No Queues Available.
				</EmptyDataTemplate>
			</asp:GridView>
			<uc1:Pager ID="queueListPager" runat="server" OnPageIndexClickEvent="QueueListPager_PageIndexClick" />
		</div>
	</div>
</asp:Content>
