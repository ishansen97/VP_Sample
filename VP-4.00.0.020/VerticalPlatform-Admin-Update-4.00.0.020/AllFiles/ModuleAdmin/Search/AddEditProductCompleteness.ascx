<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddEditProductCompleteness.ascx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Search.AddEditProductCompleteness" %>
<table cellpadding="3">
	<tr>
		<td>Content Type </td>
		<td><asp:DropDownList ID="ddlContentType" AutoPostBack="true" runat="server" 
				Width="180" onselectedindexchanged="ddlContentType_SelectedIndexChanged"></asp:DropDownList></td>
	</tr>
	<tr>
		<td>Content Property </td>
		<td><asp:DropDownList ID="ddlContentProperty" AutoPostBack="true" runat="server" Width="180"></asp:DropDownList></td>
	</tr>
	<tr>
		<td>Completeness Weight</td>
		<td><asp:TextBox ID="txtCompletenessWeight" runat="server" Width="165" MaxLength="2"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvCompletenessWeight" runat="server"
				ErrorMessage="Please enter Completeness Weight." ControlToValidate="txtCompletenessWeight">*</asp:RequiredFieldValidator>
			<asp:CompareValidator ID="cmpvCompletenessWeight" ControlToValidate="txtCompletenessWeight"
				Operator="DataTypeCheck" Type="Integer" ErrorMessage="Completeness weight should be a numeric value."
				runat="server">*</asp:CompareValidator>
			<asp:RangeValidator ID="rnvCompletenessWeight" ControlToValidate="txtCompletenessWeight"
				Type="Integer" MinimumValue="0" MaximumValue="99" runat="server" ErrorMessage="Completeness weight should be between 0 and 1000.">*</asp:RangeValidator>
			</td>
	</tr>
	<tr>
		<td>Incompleteness Weight</td>
		<td><asp:TextBox ID="txtIncompletenessWeight" runat="server" Width="165" MaxLength="3"></asp:TextBox>
			<asp:CompareValidator ID="cmpvIncompletenessWeight" ControlToValidate="txtIncompletenessWeight"
				Operator="DataTypeCheck" Type="Integer" ErrorMessage="Incompleteness weight should be a numeric value."
				runat="server">*</asp:CompareValidator>
			<asp:RangeValidator ID="rnvIncompletenessWeight" ControlToValidate="txtIncompletenessWeight"
				Type="Integer" MinimumValue="-99" MaximumValue="0" runat="server" ErrorMessage="Incompleteness weight should be between -1000 and 0.">*</asp:RangeValidator>
			</td>
	</tr>
</table>