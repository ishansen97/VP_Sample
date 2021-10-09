<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RegionEditor.aspx.cs" 
Inherits="VerticalPlatformAdminWeb.Platform.Region.RegionEditor" MasterPageFile="~/MasterPage.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
	<div class="AdminPanelHeader">
		<h3>Region Editor</h3>
	</div>
	<div class="AdminPanelContent">
		<table style="width: 100%;">
			<tr>
				<td style="width: 120px">
					Region Name
				</td>
				<td>
					<asp:TextBox ID="txtRegionName" CssClass="txtRegionName" runat="server"></asp:TextBox>
					<asp:RequiredFieldValidator ID="rfvRegionName" runat="server" ErrorMessage="Please enter Region Name." 
					ControlToValidate="txtRegionName" ValidationGroup="SaveRegion">*</asp:RequiredFieldValidator>
					<asp:RegularExpressionValidator ID="revRegionName" runat="server" ControlToValidate="txtRegionName"
					ErrorMessage="Invalid Region name. Following characters are allowed (alpha numeric, _, -)." 
					ValidationExpression="^[a-zA-Z0-9-_\s]*$" ValidationGroup="SaveRegion">*</asp:RegularExpressionValidator>
				</td>
			</tr>
			<tr>
				<td style="width: 120px">
					Region Type
				</td>
				<td>
					<asp:DropDownList ID="ddlRegionType" runat="server" AutoPostBack="true" 
						Width="120px" OnSelectedIndexChanged="ddlRegionType_SelectedIndexChanged"></asp:DropDownList>
				</td>
			</tr>
			<tr>
				<td style="width: 120px">
					Description
				</td>
				<td>
					<asp:TextBox ID="txtDescription" runat="server" MaxLength="500" Width="200"></asp:TextBox>
				</td>
			</tr>
		</table>
		<table>
			<tr>
				<td style="width: 120px" valign="top">
					Locations
				</td>
				<td valign="top">
					<asp:ListBox ID="lbRemainingLocations" runat="server" SelectionMode="Multiple" Height="200" Width="240"></asp:ListBox>
				</td>
				<td>
					<asp:Button ID="btnAddItem" runat="server" Text=">" OnClick="btnAddItem_Click" CssClass="btn" Width="50" style="margin-bottom:2px;"></asp:Button><br />
					<asp:Button ID="btnRemoveItem" runat="server" Text="<" OnClick="btnRemoveItem_Click" CssClass="btn" Width="50" style="margin-bottom:2px;"></asp:Button><br />
					<asp:Button ID="btnAddAllItems" runat="server" Text=">>" OnClick="btnAddAllItems_Click" CssClass="btn" Width="50" style="margin-bottom:2px;"></asp:Button><br />
					<asp:Button ID="btnRemoveAllItems" runat="server" Text="<<" OnClick="btnRemoveAllItems_Click" CssClass="btn" Width="50"></asp:Button>
				</td>
				<td valign="top">
					<asp:ListBox ID="lbAddedLocations" runat="server" SelectionMode="Multiple" Height="200" Width="240"></asp:ListBox>
				</td>
			</tr>
		</table>
		<table>
			<tr>
				<td><asp:Button ID="btnSave" runat="server" Text="Save" ValidationGroup="SaveRegion" CssClass="btn" OnClick="btnSave_Click"/></td>
				<td><asp:HyperLink ID="lnkBack" CssClass="btn" NavigateUrl="./RegionList.aspx" runat="server">Back</asp:HyperLink></td>
			</tr>
		</table>
		
		
	</div>
</asp:Content>
