<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddEditSearchOption.ascx.cs"
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Search.AddEditSearchOption" %>
<table>
	<tr>
		<td>
			<span class="label_span">Option Name</span>
		</td>
		<td>
			<asp:TextBox ID="txtOptionName" runat="server" Width="140" MaxLength="250"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvTxtOptionName" runat="server"
				ErrorMessage="Please enter option name." ControlToValidate="txtOptionName">*</asp:RequiredFieldValidator>
		</td>
	</tr>
	<tr>
		<td>
			<span class="label_span">Sort Order</span>
		</td>
		<td>
			<asp:TextBox ID="txtSortOrder" runat="server" Width="140" MaxLength="4"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvTxtSortOrder" runat="server"
					ErrorMessage="Please enter sort order." ControlToValidate="txtSortOrder">*</asp:RequiredFieldValidator>
			<asp:RegularExpressionValidator ID="revSortOrder" runat="server" ControlToValidate="txtSortOrder"
					ErrorMessage="Please enter a positive numeric value as the sort order." 
					ValidationExpression="^[0-9][0-9]*$">*</asp:RegularExpressionValidator>
		</td>
	</tr>
	<tr>
		<td>
			<span class="label_span">Enabled</span>
		</td>
		<td>
			<asp:CheckBox ID="chkEnabled" Checked="true" runat="server"></asp:CheckBox>
		</td>
	</tr>
	<tr>
		<td valign="top">
			<span class="label_span">Parent Option</span>
		</td>
		<td>
			<asp:DropDownList ID="ddlParentOption" runat="server" style="padding:3px;"  Width="150"></asp:DropDownList>
		</td>
		<td valign="top">
			<asp:Button ID="btnAddOptionMapping" runat="server" Text="Add Parent Option" OnClick="btnAddOptionMapping_Click"
				CssClass="common_text_button" />
		</td>
	</tr>
	<tr>
		<td valign="top">
			<span class="label_span">Parent Options</span>
		</td>
		<td>
			<asp:ListBox ID="lbParentOption" runat="server" style="padding:3px;"  Width="150" SelectionMode="Single"></asp:ListBox>
		</td>
		<td valign="top">
			<asp:Button ID="btnDeleteOptionMapping" runat="server" Text="Delete Parent Option" OnClick="btnDeleteOptionMapping_Click"
				CssClass="common_text_button" />
		</td>
	</tr>
</table>
