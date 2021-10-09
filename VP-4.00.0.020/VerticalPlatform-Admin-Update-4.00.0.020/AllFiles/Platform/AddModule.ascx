<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddModule.ascx.cs" Inherits="VerticalPlatformAdminWeb.Platform.AddModule" %>
<div>
	<table>
		<tr>
			<td>
				Name
			</td>
			<td>
				<asp:TextBox ID="txtName" runat="server"></asp:TextBox>
				<asp:RequiredFieldValidator ID="rfvName" runat="server" ValidationGroup="Module"
					ErrorMessage="Please enter name" ControlToValidate="txtName">*</asp:RequiredFieldValidator>
			</td>
		</tr>
		<tr>
			<td>
				Path
			</td>
			<td>
				<asp:TextBox ID="txtPath" runat="server" Width="400"></asp:TextBox>
				<asp:RequiredFieldValidator ID="rfvPath" runat="server" ValidationGroup="Module"
					ErrorMessage="Please enter path" ControlToValidate="txtPath">*</asp:RequiredFieldValidator>
			</td>
		</tr>
		<tr>
			<td>
				Enabled
			</td>
			<td>
				<asp:CheckBox ID="chkEnabled" runat="server" />
			</td>
		</tr>
	</table>
</div>
