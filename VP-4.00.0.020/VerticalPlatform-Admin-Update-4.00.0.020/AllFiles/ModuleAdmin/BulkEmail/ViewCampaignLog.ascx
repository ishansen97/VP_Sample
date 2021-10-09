<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ViewCampaignLog.ascx.cs"
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.BulkEmail.ViewCampaignLog" %>
<div style="min-width:500px;">
<table>
	<tr>
		<td>
			<span class="label_span">Severity</span>
		</td>
		<td>
			<asp:DropDownList ID="ddlSeverity" runat="server" style="padding:3px;" AutoPostBack="true"
			OnSelectedIndexChanged="ddlSeverity_SelectedIndexChange"></asp:DropDownList>
		</td>
	</tr>
</table>
<br />
<asp:GridView ID="gvLogs" runat="server" AutoGenerateColumns="False"
	OnRowDataBound="gvLogs_RowDataBound" CssClass="common_data_grid">
	<Columns>
		<asp:TemplateField HeaderText="Timestamp">
			<ItemTemplate>
				<asp:Literal ID="ltlTimestamp" runat="server"></asp:Literal>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Severity">
			<ItemTemplate>
				<asp:Literal ID="ltlSeverity" runat="server"></asp:Literal>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Event">
			<ItemTemplate>
				<asp:Literal ID="ltlEvent" runat="server"></asp:Literal>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="CM Campaign ID">
			<ItemTemplate>
				<asp:Literal ID="ltlProviderId" runat="server"></asp:Literal>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Status">
			<ItemTemplate>
				<asp:Literal ID="ltlStatus" runat="server"></asp:Literal>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Message">
			<ItemTemplate>
				<asp:Literal ID="ltlMessage" runat="server"></asp:Literal>
			</ItemTemplate>
		</asp:TemplateField>
		
	</Columns>
	<EmptyDataTemplate>
		No logs found.
	</EmptyDataTemplate>
</asp:GridView>
</div>
