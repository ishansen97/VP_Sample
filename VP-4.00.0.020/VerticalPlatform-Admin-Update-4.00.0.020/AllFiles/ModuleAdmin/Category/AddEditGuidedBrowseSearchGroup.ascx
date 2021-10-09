<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddEditGuidedBrowseSearchGroup.ascx.cs"
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Category.AddEditGuidedBrowseSearchGroup" %>

<table>
	<tr>
		<td>
			Search Group
		</td>
		<td>
			<asp:DropDownList ID="searchGroupList" runat="server"  AutoPostBack="true"
				onselectedindexchanged="ddlSearchGroup_SelectedIndexChanged">
			</asp:DropDownList>
			<asp:RequiredFieldValidator ID="rfvSearchGroup" runat="server" ErrorMessage="Please select a search group."
				ControlToValidate="searchGroupList">*</asp:RequiredFieldValidator>
		</td>
	</tr>
	<tr>
		<td>
			Name
		</td>
		<td>
			<asp:TextBox ID="searchGroupName" runat="server" ></asp:TextBox>
				<asp:RequiredFieldValidator ID="rfvName" runat="server" ErrorMessage="Please enter guided browse search group name."
				ControlToValidate="searchGroupName">*</asp:RequiredFieldValidator>
		</td>
	</tr>
	<tr>
		<td>
			Description
		</td>
		<td>
			<asp:TextBox ID="description" runat="server"  TextMode="MultiLine" Height="60"></asp:TextBox>
		</td>
	</tr>
	<tr>
		<td>
			Search Group Prefix
		</td>
		<td>
			<asp:TextBox ID="prefix" runat="server"></asp:TextBox>
		</td>
	</tr>
	<tr>
		<td>
			Search Group Suffix
		</td>
		<td>
			<asp:TextBox ID="suffix" runat="server" ></asp:TextBox>
		</td>
	</tr>
	
	<tr>
		<td>
			Sort Order
		</td>
		<td>
			<asp:TextBox ID="groupSortOrder" runat="server"></asp:TextBox>
			<asp:RegularExpressionValidator ControlToValidate="groupSortOrder" ValidationExpression="^\d+$"
					ID="revGuidedBrowseSortOrder" runat="server" ErrorMessage="Please enter a numeric value for Sort Order.">*</asp:RegularExpressionValidator>
				
		</td>
	</tr>
	<tr runat="server" ID="trNavigationLevelDisplay">
		<td>
			Navigation Level
		</td>
		<td>
			<asp:DropDownList ID="navigationLevel" runat="server">
			</asp:DropDownList>
		</td>
	</tr>
	<tr runat="server" ID="trListType">
		<td>
			List Type
		</td>
		<td>
			<asp:DropDownList ID="listType" runat="server">
			</asp:DropDownList>
		</td>
	</tr>
	<tr>
		<td>
			Include All Options
		</td>
		<td>
			<asp:CheckBox ID="includeAll" runat="server" Checked="true"/>
		</td>
	</tr>
	<tr>
		<td>
			Enabled
		</td>
		<td>
			<asp:CheckBox ID="enabled" runat="server" Checked="true"/>
		</td>
	</tr>
</table>
