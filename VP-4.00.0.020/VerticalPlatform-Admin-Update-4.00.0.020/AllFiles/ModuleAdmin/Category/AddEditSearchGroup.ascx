<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddEditSearchGroup.ascx.cs"
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Category.AddEditSearchGroup" %>

<table>
	<tr>
		<td>
			Search Group
		</td>
		<td>
			<asp:DropDownList ID="ddlSearchGroup" runat="server">
			</asp:DropDownList>
			<asp:RequiredFieldValidator ID="rfvSearchGroup" runat="server" ErrorMessage="Please select a search group."
				ControlToValidate="ddlSearchGroup">*</asp:RequiredFieldValidator>
		</td>
	</tr>
	<tr>
		<td>
			Search Enabled
		</td>
		<td>
			<asp:CheckBox ID="chkSearchable" runat="server" Checked="true"/>
		</td>
	</tr>
	<tr>
		<td>
			Search Sort Order
		</td>
		<td>
			<asp:TextBox ID="txtSearchSortOrder" runat="server" MaxLength="2"></asp:TextBox>
		</td>
	</tr>
	<tr>
		<td>
			Display Name
		</td>
		<td>
			<asp:TextBox ID="displayNameTextBox" runat="server"></asp:TextBox>
		</td>
	</tr>
	<tr>
		<td>
			Matrix Prefix
		</td>
		<td>
			<asp:TextBox ID="txtMatrixPrefix" runat="server"></asp:TextBox>
		</td>
	</tr>
	<tr>
		<td>
			Matrix Suffix
		</td>
		<td>
			<asp:TextBox ID="txtMatrixSuffix" runat="server"></asp:TextBox>
		</td>
	</tr>
	<tr>
		<td>
			Include All Options
		</td>
		<td>
			<asp:CheckBox ID="chkIncludeAll" runat="server" Checked="true"/>
		</td>
	</tr>
	<tr>
		<td>
			Expand On Load
		</td>
		<td>
			<asp:CheckBox ID="expandOnLoad" runat="server" Checked="true"/>
		</td>
	</tr>
	<tr>
		<td>
			Filter Search Options
		</td>
		<td>
			<asp:CheckBox ID="filterSearchOptions" runat="server" Checked="false"/>
		</td>
	</tr>
	<tr>
		<td>
			Send to Matrix
		</td>
		<td>
			<asp:CheckBox ID="sendToMatrix" runat="server" Checked="false"/>
		</td>
	</tr>
	<tr>
		<td>
			Display Options
		</td>
		<td>
			<asp:CheckBox ID="showInMatrix" Text="Vertical Matrix/Column Based Matrix" runat="server" AutoPostBack="False"/>
			<br/>
			<asp:CheckBox ID="showInComparePage" Text="Compare Page" runat="server" AutoPostBack="False"/>
		</td>
	</tr>
	<tr>
		<td>
			CSS Column Width
		</td>
		<td>
			<asp:TextBox ID="columnWidth" runat="server" Width="181px"></asp:TextBox> %
			<asp:RequiredFieldValidator runat="server" ID="columnWidthRequiredValidator" ErrorMessage="CSS Column Width is Required." 
				ControlToValidate="columnWidth">*</asp:RequiredFieldValidator>
			<asp:RegularExpressionValidator runat="server" ID="columnWidthRegExValidator" 
				ErrorMessage="Column width should be between 0 and 100." ControlToValidate="columnWidth" 
				ValidationExpression="^(100(?:\.00)?|0(?:\.\d\d)?|\d?\d(?:\.\d\d)?)$">*</asp:RegularExpressionValidator>
		</td>
	</tr>
</table>
