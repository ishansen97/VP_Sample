<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="RapidJobQueueLog.ascx.cs" Inherits="VerticalPlatformAdminWeb.Platform.Task.RapidJobQueueLog" %>

<div class="rapigJobLogs">
	<asp:GridView ID="jobQueueLog" runat="server" AutoGenerateColumns="false" CssClass="common_data_grid">
	<Columns>
		<asp:BoundField HeaderText="Job ID" DataField="JobId" />
		<asp:BoundField HeaderText="Date" DataField="Date" />
		<asp:BoundField HeaderText="Level" DataField="Level" />
		<asp:BoundField HeaderText="Message" DataField="Message" />
		<asp:BoundField HeaderText="Exception" DataField="Exception" />
		<asp:BoundField HeaderText="Count" DataField="Count" />
		<asp:BoundField HeaderText="Action" DataField="Action" />
	</Columns>
	<EmptyDataTemplate>
		No logs available.
	</EmptyDataTemplate>
</asp:GridView>
</div>