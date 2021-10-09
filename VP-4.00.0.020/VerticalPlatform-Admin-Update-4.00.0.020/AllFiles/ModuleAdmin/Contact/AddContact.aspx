<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddContact.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Contact.AddContact" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
	<title>Untitled Page</title>
</head>
<body>
	<form id="form1" runat="server">
	<div class="AdminPanel">
	
		<table >
		<div class="AdminPanelHeader"><h3>Add/Edit Contact</h3></div>
			<tr>
				<td>
					<h4>Add Address</h4>
				</td>
			</tr>
			<tr>
				<td>
					<asp:GridView ID="gvAddress" runat="server">
					</asp:GridView>
				</td>
			</tr>
			<tr>
			<td>
				<asp:Panel ID="pnlAddress" runat="server">
					<table>
						<tr>
							<td>
								Contact Type</td>
							<td>
								<asp:DropDownList ID="ddlContactType" runat="server">
								</asp:DropDownList>
							</td>
						</tr>
						<tr>
							<td>
								Company</td>
							<td>
								<asp:TextBox ID="txtCompany" runat="server"></asp:TextBox>
							</td>
						</tr>
						<tr>
							<td>
								Attention</td>
							<td>
								<asp:TextBox ID="txtAttention" runat="server"></asp:TextBox>
							</td>
						</tr>
						<tr>
							<td>
								Address 1</td>
							<td>
								<asp:TextBox ID="txtAddress1" runat="server"></asp:TextBox>
							</td>
						</tr>
						<tr>
							<td>
								Address 2</td>
							<td>
								<asp:TextBox ID="txtAddress2" runat="server"></asp:TextBox>
							</td>
						</tr>
						<tr>
							<td>
								City</td>
							<td>
								<asp:TextBox ID="txtCity" runat="server"></asp:TextBox>
							</td>
						</tr>
						<tr>
							<td>
								State</td>
							<td>
								<asp:TextBox ID="txtState" runat="server"></asp:TextBox>
							</td>
						</tr>
						<tr>
							<td>
								Postal Code</td>
							<td>
								<asp:TextBox ID="txtPostalCode" runat="server"></asp:TextBox>
							</td>
						</tr>
						<tr>
							<td>
								Country</td>
							<td>
								<asp:TextBox ID="txtCountry" runat="server"></asp:TextBox>
							</td>
						</tr>
					</table>
				</asp:Panel>
			</td>
			</tr>
			<tr>
			<td>
					<asp:Button ID="btnAddAddress" runat="server" 
						onclick="btnAddSpecification_Click" Width="130px"/>
						<asp:Button ID="btnCancelAddress" runat="server" Text="Cancel" 
						onclick="btnCancelSpecification_Click" Width="130px" />
			</td>
			</tr>
			<tr>
			<td>
				&nbsp;</td>
			</tr>
			<tr>
			<td>
				&nbsp;</td>
			</tr>
		</table>
	</div>
	</form>
</body>
</html>
