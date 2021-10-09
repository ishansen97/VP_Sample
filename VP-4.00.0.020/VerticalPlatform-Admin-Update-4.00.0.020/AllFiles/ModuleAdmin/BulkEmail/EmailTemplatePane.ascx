<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EmailTemplatePane.ascx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.BulkEmail.EmailTemplatePane" %>
<script type="text/javascript">
	$(document).ready(function() {
		var selectedButton = $("input[id$='hdnEditButton']").val();
		if (selectedButton != '') {
			$("#" + selectedButton).parents('tr').css("background-color", "#eeeeee");
		}
	});
</script>

<div class="AdminPanelContent">
<table>
	<tr>
		<td style="width:100px;">
			<span class="label_span" >Pane</span>
		</td>
		<td>
			<asp:TextBox ID="txtPane" runat="server"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvPane" runat="server" ErrorMessage="Please enter pane." 
			ControlToValidate="txtPane" ValidationGroup="save"></asp:RequiredFieldValidator>
		</td>
	</tr>
	<tr>
		<td style="width:100px;">
			<span class="label_span" >Enabled</span>
		</td>
		<td>
			<asp:CheckBox ID="chkEnabled" runat="server" />
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<asp:Button ID="btnSave" runat="server" Text="Save" ValidationGroup="save"
				CssClass="common_text_button lower_case" onclick="btnSave_Click" />
			<asp:Button ID="btnReset" runat="server" Text="Reset"
				CssClass="common_text_button" onclick="btnReset_Click"  />
		</td>
	</tr>
</table>
<br />
	<asp:GridView ID="gvPanes" runat="server" AutoGenerateColumns="False" 
		onrowdatabound="gvPanes_RowDataBound" CssClass="common_data_grid" 
		onrowcommand="gvPanes_RowCommand">
		<Columns>
			<asp:BoundField DataField="Pane" HeaderText="Pane" />
			<asp:CheckBoxField DataField="Enabled" HeaderText="Enabled"/>
			<asp:TemplateField ItemStyle-Width="50">
				<ItemTemplate>
					<asp:LinkButton ID="lbtnEdit" CommandName="paneEdit" runat="server" CssClass="grid_icon_link edit" ToolTip="Edit">Edit</asp:LinkButton>
					<asp:LinkButton ID="lbtnDelete" CommandName="paneDelete" runat="server"
					OnClientClick="return confirm('Are you sure to remove this pane from template?');" CssClass="grid_icon_link delete" ToolTip="Delete">Delete</asp:LinkButton>
				</ItemTemplate>
			</asp:TemplateField>
		</Columns>
		<EmptyDataTemplate>No Email Template panes found.</EmptyDataTemplate>
	</asp:GridView>
	<asp:HiddenField ID="hdnEditButton" runat="server" /> 
</div>