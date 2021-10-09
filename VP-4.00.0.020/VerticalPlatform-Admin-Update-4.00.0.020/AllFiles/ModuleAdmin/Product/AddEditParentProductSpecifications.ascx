<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddEditParentProductSpecifications.ascx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Product.AddEditParentProductSpecifications" %>
<h4>
	Add Parent Product Specification From SKU
</h4>
<table style="width: 100%;">
	<tr>
		<td>Specification Type</td>
		<td>
			<asp:DropDownList ID="ddlSpecificationType" runat="server" 
				AppendDataBoundItems="true" AutoPostBack="True" 
				onselectedindexchanged="ddlSpecificationType_SelectedIndexChanged">
				<asp:ListItem Text="- Select Specification Type -" Value="-1"></asp:ListItem>
			</asp:DropDownList>
		</td>
	</tr>
	<tr>
		<td>Specification</td>
		<td>
			<asp:DropDownList ID="ddlSpecification" runat="server">
			</asp:DropDownList>
		</td>
	</tr>
	<tr>
		<td>
			New Specification</td>
		<td>
			<asp:CheckBox ID="chkNewSpecification" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			&nbsp;</td>
		<td>
			<asp:TextBox ID="txtSpecification" runat="server"></asp:TextBox>
		</td>
	</tr>
</table>
