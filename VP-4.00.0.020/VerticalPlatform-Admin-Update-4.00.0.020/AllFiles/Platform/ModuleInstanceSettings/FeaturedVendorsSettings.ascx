<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="FeaturedVendorsSettings.ascx.cs" Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.FeaturedVendorsSettings" %>

<table>
	<tr>
		<td>
			Number of vendors to display
		</td>
		<td>
			<asp:TextBox ID="vendorsToDisplay" runat = "server"> </asp:TextBox>
			<asp:RequiredFieldValidator ID="vendorsToDisplayRequiredValidator" runat="server" 
				ErrorMessage="Enter number of vendors to display." ControlToValidate="vendorsToDisplay">*</asp:RequiredFieldValidator>
			<asp:RegularExpressionValidator ID="vendorsToDisplayNumOnlyValidator" runat="server" ControlToValidate="vendorsToDisplay"
				ErrorMessage = "'Number of vendors to display' should be a number" ValidationExpression="^[0-9]*$">*</asp:RegularExpressionValidator>
			<asp:HiddenField ID = "vendorsToDisplayHiddenField" runat = "server" />
		</td>
	</tr>
	<tr>
		<td>
			Vendor summary text length
		</td>
		<td>
			<asp:TextBox ID="vendorSummaryLength" runat = "server"></asp:TextBox>
			<asp:RequiredFieldValidator ID="vendorSummaryLengthRequiredValidator" runat="server"
				ErrorMessage="Enter vendor summary text length." ControlToValidate="vendorSummaryLength">*</asp:RequiredFieldValidator>
			<asp:RegularExpressionValidator ID="vendorSummaryLengthNumOnlyValidator" runat="server" ControlToValidate="vendorSummaryLength"
				ErrorMessage = "'Vendor summary text length' should be a number." ValidationExpression="^[0-9]*$">*</asp:RegularExpressionValidator>
			<asp:HiddenField ID = "vendorSummaryLengthHiddenField" runat = "server" />
		</td>
	</tr>
</table>