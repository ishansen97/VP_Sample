<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddCampaignContentData.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.BulkEmail.AddCampaignContentData" %>

<script type="text/javascript">

	$(document).ready(function() {
		var selectedButton = $("input[id$='hdnSelectedRow']").val();
		if (selectedButton != '') {
			$("#" + selectedButton).parents('tr').css("background-color", "#eeeeee");
		}
	});
</script>

<script src="../../Js/Knockout/knockout-2.2.0.js" type="text/javascript"></script>
<script src="../../Js/MultiColumnContentPicker.js" type="text/javascript"></script>

<div class="AdminPanelContent">
	<table>
		<tr>
			<td style="padding-right: 5px;">
				<span class="label_span">Campaign Type Content Group</span>
			</td>
			<td>
				<asp:DropDownList ID="ddlContentGroups" runat="server" OnSelectedIndexChanged="ddlContentGroups_SelectedIndexChanged"
					AutoPostBack="true">
				</asp:DropDownList>
			</td>
		</tr>
		<tr>
			<td>
				<span class="label_span">Content ID</span>
			</td>
			<td>
				<asp:TextBox ID="txtContentId" runat="server" Width="200px" ValidationGroup="CampaignContentData"></asp:TextBox>
				<asp:RequiredFieldValidator ID="rfvContentId" runat="server" ErrorMessage="Please enter content id."
					ControlToValidate="txtContentId" ValidationGroup="CampaignContentData">*</asp:RequiredFieldValidator>
				<asp:CompareValidator ID="cvContentId" runat="server" ErrorMessage="Content id should be a numeric value."
					ControlToValidate="txtContentId" Operator="DataTypeCheck" Type="Integer" ValidationGroup="CampaignContentData">*</asp:CompareValidator>
			</td>
		</tr>
		<tr>
			<td>
				<span class="label_span">Sort Order</span>
			</td>
			<td>
				<asp:TextBox ID="txtSortOrder" runat="server" Width="200px" ValidationGroup="CampaignContentData"></asp:TextBox></span>
				<asp:RequiredFieldValidator ID="rfvSortOrder" runat="server" ErrorMessage="Please enter sort order."
					ControlToValidate="txtSortOrder" ValidationGroup="CampaignContentData">*</asp:RequiredFieldValidator>
				<asp:CompareValidator ID="cvSortOrder" runat="server" ErrorMessage="Sort order should be a numeric value."
					ControlToValidate="txtSortOrder" Operator="DataTypeCheck" Type="Integer" ValidationGroup="CampaignContentData">*</asp:CompareValidator>
			</td>
		</tr>
		<tr>
			<td>
				<span class="label_span">Enabled</span>
			</td>
			<td>
				<asp:CheckBox ID="chkEnabled" runat="server" />
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<asp:Button runat="server" ID="btnSaveCampaignContentData" Text="Save" OnClick="btnSaveCampaignContentData_Click"
					CssClass="common_text_button" ValidationGroup="CampaignContentData" />
				<asp:Button runat="server" ID="btnReset" Text="Reset" OnClick="btnReset_Click" CausesValidation="false"
					CssClass="common_text_button" />
			</td>
		</tr>
	</table>
	<br />
	<asp:Repeater runat="server" ID="rptrCampaignTypeContentGroup" OnItemDataBound="rptrCampaignTypeContentGroup_ItemDataBound">
		<ItemTemplate>
			<asp:Label ID="lblContentGroup" runat="server"></asp:Label>
			<asp:GridView ID="gvCampaignContentData" runat="server" AutoGenerateColumns="False"
				CssClass="common_data_grid" OnRowDataBound="gvCampaignContentData_RowDataBound"
				OnRowCommand="gvCampaignContentData_RowCommand">
				<AlternatingRowStyle CssClass="DataTableRowAlternate" />
				<RowStyle CssClass="DataTableRow" />
				<Columns>
					<asp:TemplateField HeaderText="Content">
						<ItemTemplate>
							<asp:Label ID="lblContent" runat="server"></asp:Label>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:BoundField HeaderText="Sort Order" DataField="SortOrder" ItemStyle-Width="70" />
					<asp:TemplateField>
						<ItemTemplate>
							<asp:LinkButton ID="lbtnEdit" runat="server" CommandName="EditCampaignContentData"
								ValidationGroup="CampaignContentData" CausesValidation="false">Edit</asp:LinkButton>
						</ItemTemplate>
						<ItemStyle Width="30" />
					</asp:TemplateField>
					<asp:TemplateField>
						<ItemTemplate>
							<asp:LinkButton ID="lbtnDelete" runat="server" CommandName="DeleteCampaignContentData"
								ValidationGroup="CampaignContentData" OnClientClick="return confirm('Are you sure to delete campaign content data?');"
								CausesValidation="false">Delete</asp:LinkButton>
						</ItemTemplate>
						<ItemStyle Width="40" />
					</asp:TemplateField>
				</Columns>
				<EmptyDataTemplate>
					No campaign content data found.</EmptyDataTemplate>
			</asp:GridView>
			<br />
		</ItemTemplate>
	</asp:Repeater>
	<asp:HiddenField ID="hdnSelectedRow" runat="server" />
</div>
