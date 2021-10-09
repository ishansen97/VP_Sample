<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddEditProductSpecification.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Product.AddEditProductSpecification" %>
<div>
	<table>
		<tr>
			<td>
				<asp:Literal ID="ltlSpecificationTypeLabel" runat="server" Text="Specification Type"></asp:Literal>
			</td>
			<td>
				<asp:DropDownList ID="ddlSpecificationType" runat="server">
				</asp:DropDownList>
			</td>
		</tr>
		<tr>
			<td>
				<asp:Literal ID="ltlSpecificationLabel" runat="server" Text="Specification"></asp:Literal>
			</td>
			<td>
				<asp:TextBox ID="txtSpecification" runat="server" Width="400px" TextMode="MultiLine"
					Height="80px" CausesValidation="True"></asp:TextBox>
			</td>
		</tr>
		<tr>
			<td>
				<asp:Literal ID="ltlDisplayOptions" runat="server" Text="Display Options"></asp:Literal>
			</td>
			<td>
				<asp:CheckBox ID="chkShowInProductDetail" Text="Product Detail" runat="server" />
			</td>
		</tr>
		<tr>
			<td>
				<asp:Literal ID="sortOrderLiteral" runat="server" Text="Sort Order"></asp:Literal></td>
			<td>
				<asp:TextBox runat="server" ID="sortOrderTextBox"></asp:TextBox> 
				<asp:CompareValidator ID="sortOrderNumberValidator" runat="server"
						ErrorMessage="Please enter a numeric value for 'specification sort order'."
						ControlToValidate="sortOrderTextBox" Type="Integer" Operator="DataTypeCheck" SetFocusOnError="True">*
				</asp:CompareValidator>
			</td>
		</tr>
		<tr>
			<td>
				<asp:Literal ID="ltlEnableSpecLable" runat="server" Text="Enabled"></asp:Literal>
			</td>
			<td>
				<asp:CheckBox ID="chkSpecEnable" runat="server" Checked="True" Text=" " />
			</td>
		</tr>
	</table>
</div>
