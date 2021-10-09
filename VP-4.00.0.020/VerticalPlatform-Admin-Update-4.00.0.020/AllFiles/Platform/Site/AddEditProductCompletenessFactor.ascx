<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddEditProductCompletenessFactor.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.Site.AddEditProductCompletenessFactor" %>
<table cellpadding="3">
	<tr>
		<td>
			Content Type
		</td>
		<td>
			<asp:DropDownList ID="factorContentType" AutoPostBack="true" runat="server" Width="180"
				OnSelectedIndexChanged="factorContentType_SelectedIndexChanged">
			</asp:DropDownList>
		</td>
	</tr>
	<tr>
		<td>
			Content Name
		</td>
		<td>
			<asp:DropDownList ID="factorContentName" AutoPostBack="true" runat="server" Width="180">
			</asp:DropDownList>
		</td>
	</tr>
	<tr>
		<td>
			Completeness Weight
		</td>
		<td>
			<asp:TextBox ID="completenessWeight" runat="server" Width="165" MaxLength="2"></asp:TextBox>
			<asp:RequiredFieldValidator ID="completenessWeightRequiredFieldValidator" runat="server"
				ErrorMessage="Please enter Completeness Weight." ControlToValidate="completenessWeight">*</asp:RequiredFieldValidator>
			<asp:RangeValidator ID="completenessWeightRangeValidator" ControlToValidate="completenessWeight"
				Type="Integer" MinimumValue="0" MaximumValue="99" runat="server" ErrorMessage="Completeness weight should be between 0 and 99.">*</asp:RangeValidator>
		</td>
	</tr>
	<tr>
		<td>
			Incompleteness Weight
		</td>
		<td>
			<asp:TextBox ID="incompletenessWeight" runat="server" Width="165" MaxLength="3"></asp:TextBox>
			<asp:RangeValidator ID="incompletenessWeightRangeValidator" ControlToValidate="incompletenessWeight"
				Type="Integer" MinimumValue="-99" MaximumValue="0" runat="server" ErrorMessage="Incompleteness weight should be between -99 and 0.">*</asp:RangeValidator>
		</td>
	</tr>
</table>
