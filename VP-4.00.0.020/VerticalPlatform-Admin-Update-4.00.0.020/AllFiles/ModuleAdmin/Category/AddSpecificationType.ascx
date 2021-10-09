<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddSpecificationType.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Category.AddSpecificationType" %>
<div>
	<table>
		<tr>
			<td>
				Specification Type Name
			</td>
			<td>
				<asp:DropDownList ID="ddlSpecType" runat="server" Width="181px"></asp:DropDownList>
			</td>
		</tr>
		<tr>
			<td>
				Sort Order
			</td>
			<td>
				<asp:TextBox ID="txtSortOrder" runat="server" ValidationGroup="vgSpec" Width="37px"></asp:TextBox>
				<asp:RequiredFieldValidator ID="rvSortOrder0" runat="server" ControlToValidate="txtSortOrder"
					ErrorMessage="Please enter sort order.">*</asp:RequiredFieldValidator>
				<asp:RegularExpressionValidator ID="rvIntSortOrder0" runat="server" ControlToValidate="txtSortOrder"
						ErrorMessage="Sort order should be a numeric value." ValidationExpression="^\d+$">*</asp:RegularExpressionValidator>
			</td>
		</tr>
		<tr>
			<td>
				Enabled
			</td>
			<td>
				<asp:CheckBox ID="chkEnableSpecificationType" runat="server"/>
			</td>
		</tr>
		<tr>
			<td>
				Show in Vertical/Column Matrix
			</td>
			<td>
				<asp:CheckBox ID="chkShowInMatrix" runat="server"/>
			</td>
		</tr>
		<tr>
			<td>
				Specification Length
			</td>
			<td>
				<asp:TextBox ID="txtSpecificationLength" runat="server" Width="50px"></asp:TextBox>
				<asp:CompareValidator ID="cvSpecificationLength" runat="server" ErrorMessage="Specification display length should be a numeric value" 
					ControlToValidate="txtSpecificationLength" Operator="GreaterThan" 
					Type="Integer" ValueToCompare="-1">*</asp:CompareValidator>
			</td>
		</tr>
		<tr>
			<td>
				Display Name (Optional)
			</td>
			<td>
				<asp:TextBox ID="txtDisplayName" runat="server" Width="181px"></asp:TextBox>
			</td>
		</tr>
		<tr>
			<td>
				CSS Column Width
			</td>
			<td>
				<asp:TextBox ID="columnWidth" runat="server" Width="181px"></asp:TextBox> %
				<asp:RegularExpressionValidator runat="server" ID="columnWidthValidator" 
					ErrorMessage="Column width should be between 0 and 100." ControlToValidate="columnWidth" 
					ValidationExpression="^(100(?:\.00)?|0(?:\.\d\d)?|\d?\d(?:\.\d\d)?)$">*</asp:RegularExpressionValidator>
			</td>
		</tr>
    <tr>
			<td>
				Show in Compare Page
			</td>
			<td>
				<asp:CheckBox ID="chkShowInHorizontalMatrix" runat="server"/>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<asp:Literal ID="ltlMessage" runat="server"></asp:Literal>
			</td>
		</tr>
	</table>
</div>
