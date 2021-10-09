<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="BulkEmailTypeField.ascx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.BulkEmail.BulkEmailTypeField" %>
<div class="AdminPanelContent">
<table>
	<tr>
		<td>
			<span class="label_span">User Field</span>
		</td>
		<td>
			<asp:DropDownList ID="ddlFields" runat="server" style="padding:3px;">
			</asp:DropDownList>
		</td>
	</tr>
	<tr>
		<td colspan="2">Update this field on changes to campaign types
			<asp:CheckBox ID="chkIsCampaignTypeRelated" runat="server"/>
		</td>
	</tr>
	<tr>
		<td>
			<asp:Button ID="btnAddField" runat="server" Text="Add Field"
				CssClass="common_text_button" onclick="btnAddField_Click" />
		</td>
	</tr>
</table>
<br />
	<asp:GridView ID="gvBulkEmailTypeField" runat="server" 
		CssClass="common_data_grid" AutoGenerateColumns="False" 
		onrowdatabound="gvBulkEmailTypeField_RowDataBound" 
		onrowcommand="gvBulkEmailTypeField_RowCommand">
		<Columns>
			<asp:TemplateField HeaderText="Field">
				<ItemTemplate>
					<asp:Literal ID="ltlUserField" runat="server"></asp:Literal>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField HeaderText="Update">
				<ItemTemplate>
					<asp:CheckBox ID="chkCampaignTypeRelated" runat="server" Enabled="false"></asp:CheckBox>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField>
				<ItemTemplate>
					<asp:LinkButton ID="lbtnDelete" runat="server" CommandName="DeleteField">Delete</asp:LinkButton>
				</ItemTemplate>
			</asp:TemplateField>
		</Columns>
		<EmptyDataTemplate>No Bulk Email Type Fields found.</EmptyDataTemplate>
	</asp:GridView>
</div>