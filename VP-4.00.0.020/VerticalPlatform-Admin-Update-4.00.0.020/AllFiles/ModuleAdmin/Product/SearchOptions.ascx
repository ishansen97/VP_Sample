<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SearchOptions.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Product.SearchOptions" %>
<script type="text/javascript">
	$(document).ready(function () {
		var toggleDelete = function (checkBox) {
			var deleteButton = checkBox.closest("td").next("td").find("a");
			if (checkBox.is(':checked')) {
				deleteButton.attr('disabled', 'disabled');
			}
			else {
				deleteButton.removeAttr('disabled');
			}
		};

		$('input[type=checkbox]').each(function () {
			toggleDelete($(this));
		});

		$(".delete").bind("click", function (e) {
			var checkbox = $(this).closest("td").prev("td").find("input");
			if (checkbox.is(':checked')) {
				e.preventDefault();
			}
			else {
				return confirm('Are you sure to remove the option?');
			}
		});

		$(".lockedCheckBox").bind("click", function () {
			var checkbox = $(this).find('input');
			toggleDelete(checkbox);
		});
	});
</script>
<asp:HyperLink ID="lnkAddSearchOption" runat="server" CssClass="aDialog btn">Add Search Option</asp:HyperLink>
<br />
<br />
<asp:GridView ID="gvSearchOption" runat="server" AutoGenerateColumns="False" OnRowDataBound="gvSearchOption_RowDataBound"
	OnRowDeleting="gvSearchOption_RowDeleting" EnableViewState="False" CssClass="common_data_grid table table-bordered" style="width:auto;"
	AllowSorting="True" OnSorting="gvSearchOption_Sorting">
	<Columns>
		<asp:TemplateField HeaderText="Option Group Id">
			<ItemTemplate>
				<asp:Literal ID="ltlOptionGroupId" runat="server"></asp:Literal>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Option Group" SortExpression="Group">
			<ItemTemplate>
				<asp:Literal ID="ltlOptionGroup" runat="server"></asp:Literal>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Option Id">
			<ItemTemplate>
				<asp:Literal ID="ltlOptionId" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "SearchOptionId") %>'></asp:Literal>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Option Name" SortExpression="Option">
			<ItemTemplate>
				<asp:Literal ID="ltlOptionName" runat="server"></asp:Literal>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Locked">
			<ItemTemplate>
				<asp:CheckBox ID="lockedCheckBox" CssClass="lockedCheckBox" runat="server"></asp:CheckBox>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField ShowHeader="False">
			<ItemTemplate>
				<asp:LinkButton ID="lbtnRemove1" runat="server" CausesValidation="False" CommandName="Delete"
					Text="Remove" CssClass="grid_icon_link delete" ToolTip="Delete"></asp:LinkButton>
			</ItemTemplate>
			<ItemStyle Width="30" />
		</asp:TemplateField>
		
	</Columns>
</asp:GridView>
<asp:Button ID="applyChanges" runat = "server" Text="Apply Changes" CssClass="btn" OnClick="applyChanges_Click"/>
