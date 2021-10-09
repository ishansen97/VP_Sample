<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CountryEditor.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.Country.CountryEditor" %>
<div>
<table>
	<tr>
		<td>Culture Name</td>
		<td>
			<asp:TextBox ID="txtCultureName" runat="server"></asp:TextBox></td>
	</tr>
	<tr>
		<td>
			<asp:Button ID="btnSaveCulture" runat="server" Text="Save Culture" 
				onclick="btnSaveCulture_Click" CssClass="common_text_button" /></td>
	</tr>
</table>
	<table>
		<tr>
			<td>
				Currency Vlaue
			</td>
			<td>
				<asp:DropDownList ID="ddlCurrencyValue" runat="server">
				</asp:DropDownList>
			</td>
		</tr>
			<tr>
			<td>
				Primary
			</td>
			<td>
				<asp:CheckBox ID="chkPrimary" runat="server" />
			</td>
		</tr>
		<tr>
			<td>
				<asp:Button ID="btnAddCurrency" runat="server" Text="Add Currency" 
					onclick="btnAddCurrency_Click" CssClass="common_text_button"/>
			</td>
		</tr>
	</table>
	
	<div>
		<asp:GridView ID="gvCountryToCurrency" runat="server" 
			AutoGenerateColumns="False" CssClass="common_data_grid" 
			onrowcommand="gvCountryToCurrency_RowCommand" 
			onrowdatabound="gvCountryToCurrency_RowDataBound">
			<Columns>
				<asp:BoundField DataField="Id" HeaderText="Id" />
				<asp:TemplateField HeaderText="Decription">
					<ItemTemplate>
						<asp:Label ID="lblDescription" runat="server"></asp:Label>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:CheckBoxField DataField="Primary" HeaderText="Primary" />
				<asp:TemplateField>
					<ItemTemplate>
						<asp:LinkButton ID="lbtnDelete" runat="server" CommandName="DeleteAssosiation" CssClass="grid_icon_link delete" ToolTip="Delete">Delete</asp:LinkButton>
					</ItemTemplate>
				</asp:TemplateField>
			</Columns>
		</asp:GridView>	
	</div>
</div>
