﻿<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Action.ascx.cs" Inherits="VerticalPlatformAdminWeb.Controls.Action" %>
<script type="text/javascript">
	$(document).ready(function() {
		$(".actionList").actionList({});
	});
	
	(function($) {
		$.fn.actionList = function() {
//			$(".specify").click(SetUi);
			$(".default").click(SetRadioButtons);
			SetUi();
		};

		function SetUi() {
			if ($(".specify").length > 0) {
				if ($(".specify").find(':checkbox').is(':checked')) {
					$("#divActionSettings").attr('disabled', '');
				}
				else {
					$("#divActionSettings").attr('disabled', 'true');
				}
			}
		}

		function SetRadioButtons(event) {
			var target = $(event.currentTarget).find(':radio');
			if ($(target).is(':checked')) {
				$(".default").find(':radio').attr('checked', '');
				$(target).attr('checked', 'true');
			}
		}
	})(jQuery);
</script>
<div class="actionList">
	<div>
		<asp:CheckBox ID="chkSpecify" runat="server" CssClass="specify" 
			oncheckedchanged="chkSpecify_CheckedChanged" AutoPostBack="True"/>
			<br />
		<asp:CheckBox ID="chkUpdateProducts" runat="server" CssClass="specify" Text="Update All Products." 
		Visible="false"/>
	</div>
	<div id = "divActionSettings">
		<asp:GridView ID="gvAction" runat="server" AutoGenerateColumns="False" OnRowDataBound="gvAction_RowDataBound"
			CssClass="common_data_grid" style="width:auto;">
			<Columns> 
				<asp:TemplateField HeaderText="Name">
					<ItemTemplate>
						<asp:Literal ID="ltlName" runat="server"></asp:Literal>
						<asp:HiddenField ID="hdnActionId" runat="server" />
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Enabled">
					<ItemTemplate>
						<asp:CheckBox ID="chkEnabled" runat="server" CssClass=""/>
						<asp:HiddenField ID="hdnActionContentId" runat="server" />
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Default">
					<ItemTemplate>
						<asp:RadioButton ID="rdbDefault" runat="server" CssClass="default"/>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Order">
					<ItemTemplate>
						<asp:TextBox ID="txtOrder" runat="server" Width="50px"></asp:TextBox>
						<asp:CompareValidator ID="cvSortOrder" runat="server" ErrorMessage="Sort order should be a number." Operator="DataTypeCheck" Type="Integer" ControlToValidate="txtOrder">*</asp:CompareValidator>
					</ItemTemplate>
				</asp:TemplateField>
			</Columns>
		</asp:GridView>
	</div>
</div>