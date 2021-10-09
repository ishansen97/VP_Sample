<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="UserFieldOptionsMapping.ascx.cs" 
Inherits="VerticalPlatformAdminWeb.Platform.PublicUser.UserFieldOptionsMapping" %>
<div style="min-width:650px;">
	<table>
		<tr>
			<td valign="top">
				<span class="label_span">Source Option</span>
			</td>
			<td>
				<asp:DropDownList ID="ddlSourceOptions" runat="server" style="padding:3px;max-width:560px;">
				</asp:DropDownList>
				<asp:RequiredFieldValidator ID="rfvSourceOptions" runat="server" 
					ErrorMessage="Please select a source field option" ControlToValidate="ddlSourceOptions">*</asp:RequiredFieldValidator>
			</td>
		</tr>
		<tr>
			<td valign="top">
				<span class="label_span">Destination Option</span>
			</td>
			<td>
				<asp:DropDownList ID="ddlDestinationOptions" runat="server" style="padding:3px;">
				</asp:DropDownList>
				<asp:RequiredFieldValidator ID="rfvDestinationOptions" runat="server" 
					ErrorMessage="Please select a destination field option" ControlToValidate="ddlDestinationOptions">*</asp:RequiredFieldValidator>
			</td>
		</tr>
		<tr>
			<td>
				<asp:Button ID="btnAddFieldOptionMapping" runat="server" Text="Add Mapping" OnClick="btnAddFieldOptionMapping_Click"
					CssClass="common_text_button" />
			</td>
		</tr>
	</table>
	<br />
	<br />
	<asp:GridView ID="gvFieldOptionMapping" runat="server" CssClass="common_data_grid" AutoGenerateColumns="False"
		OnRowDataBound="gvFieldOptionMapping_RowDataBound" 
		OnRowCommand="gvFieldOptionMapping_RowCommand">
		<AlternatingRowStyle CssClass="DataTableRowAlternate" />
		<RowStyle CssClass="DataTableRow" />
		<Columns>
			<asp:TemplateField HeaderText="Source Field Option">
				<ItemTemplate>
					<asp:Literal ID="ltlSourceFieldOption" runat="server"></asp:Literal>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField HeaderText="Destination Field Option">
				<ItemTemplate>
					<asp:Literal ID="ltlDestinationFieldOption" runat="server"/>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField HeaderText="Action">
				<ItemTemplate>
					<asp:LinkButton ID="lbtnDelete" runat="server" CommandName="DeleteMapping" CssClass="grid_icon_link delete">Delete</asp:LinkButton>
				</ItemTemplate>
			</asp:TemplateField>
		</Columns>
		<EmptyDataTemplate>No Field Option Mappings Found.</EmptyDataTemplate>
	</asp:GridView>
</div>