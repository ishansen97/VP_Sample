<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddEditTask.ascx.cs" 
Inherits="VerticalPlatformAdminWeb.Platform.Task.AddEditTask" %>
<div class="AdminPanelContent">
	<ul class="common_form_area">
		<li class="common_form_row clearfix"><span class="label_span" style="padding-top:0px">Type</span> <span>
			<asp:DropDownList ID="ddlTaskType" runat="server"
				AppendDataBoundItems="true" Width="212px" style="padding:3px;">
				<asp:ListItem Text="--Select--" Value=""></asp:ListItem>
			</asp:DropDownList>
			<asp:RequiredFieldValidator ID="rfvTaskTypes" runat="server" ControlToValidate="ddlTaskType"
				ErrorMessage="Please select task type.">*</asp:RequiredFieldValidator>
		</span></li>
		<li class="common_form_row clearfix"><span class="label_span" style="padding-top:0px">Name</span> <span>
			<asp:TextBox ID="txtName" runat="server" Width="200px"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName"
				ErrorMessage="Please enter task name.">*</asp:RequiredFieldValidator></span>
		</li>
		<li class="common_form_row clearfix"><span class="label_span" style="padding-top:0px">Site</span> <span></span>
			<asp:DropDownList runat="server" ID="ddlSites" AppendDataBoundItems="true" Width="212px" style="padding:3px;">
				<asp:ListItem Text="--Select--" Value="-1" Selected="True"></asp:ListItem>
			</asp:DropDownList>
			<asp:RequiredFieldValidator ID="rfvSiteId" runat="server" ControlToValidate="ddlSites"
				ErrorMessage="Please select a valid site.">*</asp:RequiredFieldValidator>
		</li>
		<li class="common_form_row clearfix" runat="server" id="liLastRuntime"><span class="label_span" style="padding-top:0px">Last Run Time</span> <span></span>
			<asp:Label ID="lblLastRuntime" runat="server" ></asp:Label>
		</li>
		<li class="common_form_row clearfix" runat="server" id="liStatus"><span class="label_span" style="padding-top:0px">Status</span> <span></span>
			<asp:Label ID="lblStatus" runat="server" ></asp:Label>
		</li>
		<li class="common_form_row clearfix"><span class="label_span" style="padding-top:0px">Enabled</span> <span> </span>
			<asp:CheckBox ID="chkEnabled" runat="server" Checked="true" />
		</li>
		<li class="common_form_row clearfix"><span class="label_span" style="padding-top:0px">
			Notification Emails at the End of Task Execution<br />(comma separated, no whitespaces)</span> <span> </span>
			<asp:TextBox runat="server" ID="txtRecipientEmail" ToolTip="RecipientEmail" Width="200" TextMode="MultiLine" Height="60"></asp:TextBox>
		</li>
		<li class="common_form_row clearfix">
			<span class="label_span" style="padding-top:0px">Notify on Following Task Status(es)</span>
			<span>
				<asp:DropDownList ID="ddlTaskEmailNotificationSetting" runat="server"
					AppendDataBoundItems="true" Width="212px" style="padding:3px;">
					<asp:ListItem Text="--Select--" Value=""></asp:ListItem>
				</asp:DropDownList>
				<asp:RequiredFieldValidator ID="rfvNotificationSetting" runat="server" ControlToValidate="ddlTaskEmailNotificationSetting"
					ErrorMessage="Please select task notification setting.">*</asp:RequiredFieldValidator>
			</span>
		</li>
	</ul>
</div>