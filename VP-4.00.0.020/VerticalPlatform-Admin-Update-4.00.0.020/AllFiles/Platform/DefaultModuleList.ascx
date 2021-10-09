<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="DefaultModuleList.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.DefaultModuleList" %>
<table>
	<tr>
		<td colspan="2">
			<asp:GridView ID="gvPageModule" runat="server" AutoGenerateColumns="false" OnRowCommand="gvPageModule_RowCommand"
				OnRowDataBound="gvPageModule_RowDataBound" CssClass="common_data_grid">
				<RowStyle CssClass="GridItem" />
				<AlternatingRowStyle CssClass="GridAltItem" />
				<HeaderStyle CssClass="GridHeader" />
				<Columns>
					<asp:BoundField DataField="Id" HeaderText="ID" ItemStyle-Width="75" />
					<asp:TemplateField HeaderText="Module" ItemStyle-Width="200">
						<ItemTemplate>
							<asp:Label ID="lblModuleName" runat="server"></asp:Label>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:CheckBoxField DataField="Enabled" HeaderText="Enabled" ItemStyle-Width="75" />
					<asp:TemplateField ItemStyle-Width="75">
						<ItemTemplate>
							<asp:LinkButton ID="lbtnDeletePageModule" runat="server" CommandName="DeletePageModule"
								CausesValidation="false">Delete</asp:LinkButton>
						</ItemTemplate>
					</asp:TemplateField>
				</Columns>
				<EmptyDataTemplate>
					No default modules for this page.
				</EmptyDataTemplate>
			</asp:GridView>
			<asp:HiddenField ID="hdnPageDefaultModuleId" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Modules
		</td>
		<td>
			<asp:DropDownList ID="ddlModule" runat="server">
			</asp:DropDownList>
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<asp:Button ID="btnAddModule" runat="server" Text="Add Module" OnClick="btnAddModule_Click"
				CssClass="common_text_button" />
		</td>
	</tr>
</table>
