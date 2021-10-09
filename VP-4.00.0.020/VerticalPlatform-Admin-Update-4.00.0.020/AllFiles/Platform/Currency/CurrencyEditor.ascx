<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CurrencyEditor.ascx.cs" Inherits="VerticalPlatformAdminWeb.Platform.Currency.CurrencyEditor" %>
<div> 
	<table>
		<tr>
			<td>
				Description
			</td>
			<td>
				<asp:TextBox ID="txtDescription" runat="server"></asp:TextBox>
				<asp:RequiredFieldValidator ID="rfvDescription" runat="server" ErrorMessage="Enter description. " ControlToValidate="txtDescription">*</asp:RequiredFieldValidator>
			</td>
		</tr>
		<tr>
			<td>
				Local Symbol
			</td>
			<td>
				<asp:TextBox ID="txtLocalSymbol" runat="server"></asp:TextBox>
				<asp:RequiredFieldValidator ID="refLocalSymbol" runat="server" ErrorMessage="Enter local symbol. " ControlToValidate="txtLocalSymbol">*</asp:RequiredFieldValidator>
			</td>
		</tr>
		<tr>
			<td>
				International Symbol
			</td>
			<td>
				<asp:TextBox ID="txtInternationalSymbol" runat="server"></asp:TextBox>
				<asp:RequiredFieldValidator ID="refInternationalSymbol" runat="server" ErrorMessage="Enter international symbol. " ControlToValidate="txtInternationalSymbol">*</asp:RequiredFieldValidator>
			</td>
		</tr>
		<tr>
			<td>
				Enabled
			</td>
			<td>
				<asp:CheckBox ID="chkCurrencyEnabled" runat="server" Checked="True" Text=" " />
			</td>
		</tr>
		<tr>
			<td>
				Associated Country
			</td>
			<td>
				<asp:DropDownList ID="ddlCountryList" runat="server" AppendDataBoundItems="true">
				<asp:ListItem Text="Select" Value=""></asp:ListItem>
				</asp:DropDownList>
				<asp:RequiredFieldValidator ID="rfvCountryList" runat="server" ErrorMessage="Select a country"
						InitialValue="" ValidationGroup="AddCountry" ControlToValidate="ddlCountryList">*</asp:RequiredFieldValidator>
			</td>
		</tr>
		<tr>
			<td>
				Primary Currency
			</td>
			<td>
				<asp:CheckBox ID="chkPrimary" runat="server" />
			</td>
		</tr>
		<tr>
			<td>
				<asp:Button ID="btnAddAssociate" runat="server" Text="Add Country" 
					onclick="btnAddAssociate_Click" ValidationGroup="AddCountry" CssClass="common_text_button"/>
			</td>
		</tr>
		
	</table>
	
	<div>
		<asp:GridView ID="gvCountryToCurrency" runat="server" 
			AutoGenerateColumns="False" onrowcommand="gvCountryToCurrency_RowCommand" 
			onrowdatabound="gvCountryToCurrency_RowDataBound" CssClass="common_data_grid">
			<Columns>
				<asp:TemplateField HeaderText="Associated Country">
					<ItemTemplate>
						<asp:Label ID="lblCountryName" runat="server"></asp:Label>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:CheckBoxField DataField="Primary" HeaderText="Primary" />
				<asp:TemplateField ItemStyle-Width="20">
					<ItemTemplate>
						<asp:LinkButton ID="lbtnRemove" runat="server" OnClientClick="return confirm('Are you sure to delete country association?');" CssClass="grid_icon_link delete" ToolTip="Delete">Remove</asp:LinkButton>
					</ItemTemplate>
				</asp:TemplateField>
			</Columns>
		</asp:GridView>	
	</div>
</div>