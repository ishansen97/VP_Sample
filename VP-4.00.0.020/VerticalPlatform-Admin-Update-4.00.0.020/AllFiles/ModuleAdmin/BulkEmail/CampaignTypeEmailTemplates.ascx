<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CampaignTypeEmailTemplates.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.BulkEmail.CampaignTypeEmailTemplates" %>

<script type="text/javascript">
	$(document).ready(function () {
		$(".templatesList").templatesList({});
	});

	(function ($) {
		$.fn.templatesList = function () {
			$(".defaultHtml").click(SetHtmlRadioButtons);
			$(".defaultText").click(SetTextRadioButtons);
		};

		function SetHtmlRadioButtons(event) {
			var target = $(event.currentTarget).find(':checkbox');
			if ($(target).is(':checked')) {
				$(".defaultHtml").find(':checkbox').attr('checked', '');
				$(target).attr('checked', 'true');
			}
		}

		function SetTextRadioButtons(event) {
			var target = $(event.currentTarget).find(':checkbox');
			if ($(target).is(':checked')) {
				$(".defaultText").find(':checkbox').attr('checked', '');
				$(target).attr('checked', 'true');
			}
		}
	})(jQuery);
</script>

<div class="AdminPanelContent clearfix templatesList">
	<asp:GridView ID="gvEmailTemplate" runat="server" AutoGenerateColumns="false" 
		ondatabound="gvEmailTemplate_DataBound" CssClass="common_data_grid" Width="320"
		AllowSorting="true" OnSorting="gvEmailTemplate_Sorting">
	<Columns>
		<asp:BoundField HeaderText="ID" DataField="Id" SortExpression="id"/>
		<asp:BoundField HeaderText="Template" DataField="TemplateName" SortExpression="name"/>
		<asp:TemplateField HeaderText="Enable">
			<ItemTemplate>
				<asp:CheckBox ID="chkSelect" runat="server"/>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Default Html Template">
			<ItemTemplate>
				<asp:CheckBox ID="defaultHtmlCheckBox" runat="server" CssClass="defaultHtml"/>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Default Text Template">
			<ItemTemplate>
				<asp:CheckBox ID="defaultTextCheckBox" runat="server" CssClass="defaultText"/>
			</ItemTemplate>
		</asp:TemplateField>
	</Columns>
	<EmptyDataTemplate>No Email Templates found.</EmptyDataTemplate>
	</asp:GridView>
</div>
