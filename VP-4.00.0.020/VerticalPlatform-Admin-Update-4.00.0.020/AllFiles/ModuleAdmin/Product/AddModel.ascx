<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddModel.ascx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Product.AddModel" %>
<div>
	<table>
		<tr>
			<td>
				<asp:Literal ID="ltlModelName" runat="server" Text="Model Name"></asp:Literal>
			</td>
			<td>
				<asp:TextBox ID="txtModelName" runat="server" CausesValidation="True"></asp:TextBox>
				<asp:RequiredFieldValidator ID="rfvModelName" runat="server" ControlToValidate="txtModelName"
					ErrorMessage="Please enter model name.">*</asp:RequiredFieldValidator>
			</td>
		</tr>
		<tr>
			<td>
				<asp:Literal ID="ltlCatalogNumber" runat="server" Text="Catalog Number"></asp:Literal>
			</td>
			<td>
				<asp:TextBox ID="txtCatalogNumber" runat="server" CausesValidation="True"></asp:TextBox>
				<asp:RequiredFieldValidator ID="rfvCatalogNumber" runat="server" ControlToValidate="txtCatalogNumber"
					ErrorMessage="Please enter Catalog Number.">*</asp:RequiredFieldValidator>
			</td>
		</tr>
		<tr>
			<td>
				<asp:Literal ID="ltlDisplayOrder" runat="server" Text="Display Order"></asp:Literal>
			</td>
			<td>
				<asp:TextBox ID="txtDisplayOrder" runat="server" CausesValidation="True" ReadOnly="true"></asp:TextBox>
			</td>
		</tr>
		<tr>
			<td>
				<asp:Label ID="lblEnableModel" runat="server" Text="Model Enabled"></asp:Label>
			</td>
			<td>
				<asp:CheckBox ID="chkModelEnabled" runat="server" Checked="True" Text=" " />
			</td>
		</tr>
	</table>
	<asp:Label ID="lblMessage" runat="server"></asp:Label>
</div>
