<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="MetadataControl.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.Controls.MetadataControl" %>
<div class="form-horizontal">
	<div class="control-group">
		<label class="control-label" style="width: 190px">
			Title</label>
		<div class="controls" style="margin-left: 210px">
			<asp:TextBox ID="txtTitle" runat="server" Width="250px"></asp:TextBox>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label" style="width: 190px">
			Keywords ( <code>,</code> Seperated )</label>
		<div class="controls" style="margin-left: 210px">
			<asp:TextBox ID="txtKeywords" runat="server" Width="250px"></asp:TextBox>
			<asp:RegularExpressionValidator ID="revKeywords" runat="server" ControlToValidate="txtKeywords"
				ErrorMessage="Accepts only a comma seperated list" ValidationExpression="^([a-zA-Z0-9]+(\s)*(,(\s)*([a-zA-Z0-9])+(\s)*)*)$">*</asp:RegularExpressionValidator>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label" style="width: 190px">
			Description</label>
		<div class="controls" style="margin-left: 210px">
			<asp:TextBox ID="txtDescription" runat="server" Width="250px"></asp:TextBox>
		</div>
	</div>
	<div class="control-group" runat="server" id="dvCustomTags">
		<label class="control-label" style="width: 190px">
			Robots</label>
		<div class="controls well" style="margin-left: 210px;width: 225px">
			<asp:DropDownList ID="ddlRobots" runat="server" Width="230px" Enabled="true">
			</asp:DropDownList>
			<div style="height: auto; width: 500px" class="dvCheckBoxListPageNames">
				<asp:CheckBoxList ID="checkBoxListPageNames" CellPadding="5" CellSpacing="5" RepeatColumns="1"
					RepeatDirection="Horizontal" RepeatLayout="Flow" TextAlign="Right" runat="server"
					Width="300px">
				</asp:CheckBoxList>
			</div>
		</div>
	</div>
	<script type="text/javascript">
		RegisterNamespace("VP.Metadata");
		$(document).ready(function () {
			$("select[id$='ddlRobots']").change(
				function (e) {
					VP.Metadata.SetMetadataPageListVisibility();
				}
			);
				VP.Metadata.SetMetadataPageListVisibility();
		});

		VP.Metadata.SetMetadataPageListVisibility = function () {
			var ddlRobotsSelected = $("select[id$='ddlRobots'] option:selected");
			var pageListControl = $("span[id$='checkBoxListPageNames']");

			if (ddlRobotsSelected.text().trim().length == 0) {
				pageListControl.hide();
				$("input[id*='checkBoxListPageNames'][type='checkbox']").each(function() {
					$(this).removeAttr('checked');
				});
			} else {
				pageListControl.show();
			}
		};
	</script>
</div>

