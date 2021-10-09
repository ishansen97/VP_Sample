<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AdvertisementTypePopup.ascx.cs" 
Inherits="VerticalPlatformAdminWeb.Platform.Advertisement.AdvertisementTypePopup" %>
<table>
	<tr>
		<td>
			Name
		</td>
		<td>
			<asp:TextBox ID="txtAdTypeName" runat="server"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvAdType" runat="server" 
				ErrorMessage="Please enter name." ControlToValidate="txtAdTypeName">*</asp:RequiredFieldValidator>
		</td>
	</tr>
	<tr>
		<td>
			Width
		</td>
		<td>
			<asp:TextBox ID="txtWidth" runat="server"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvWidth" runat="server" 
				ErrorMessage="Please enter width." ControlToValidate="txtWidth">*</asp:RequiredFieldValidator>
			<asp:RegularExpressionValidator ID="revWidth" runat="server" ControlToValidate="txtWidth"
				ErrorMessage="Width should be a numeric value." ValidationExpression="[0-9]+">*</asp:RegularExpressionValidator>
		</td>
	</tr>
	<tr>
		<td>
			Height
		</td>
		<td>
			<asp:TextBox ID="txtHeight" runat="server"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvHeight" runat="server" 
				ErrorMessage="Please enter height." ControlToValidate="txtHeight">*</asp:RequiredFieldValidator>
			<asp:RegularExpressionValidator ID="revHeight" runat="server" ControlToValidate="txtHeight"
				ErrorMessage="Height should be a numeric value." ValidationExpression="[0-9]+">*</asp:RegularExpressionValidator>
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
	<tr>
		<td colspan="2">
			<asp:Label runat="server" ID="lblInformation"></asp:Label>
		</td>
	</tr>
</table>
<asp:HiddenField runat="server" ID="hdnAdTypeId" />