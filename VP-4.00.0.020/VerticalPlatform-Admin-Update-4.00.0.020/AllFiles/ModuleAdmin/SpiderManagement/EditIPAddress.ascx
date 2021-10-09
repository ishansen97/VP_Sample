<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EditIPAddress.ascx.cs" 
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.SpiderManagement.EditIPAddress" %>

<div class="EditIPAddress" runat="server">
	<table>
		<tr>
			<td colspan="2">
				<table cellpadding="0" cellspacing="0" class="add_ip_table">
					<tr>
						<td style="border-right:solid 1px #eeeeee;">
							<asp:RadioButton GroupName="ipRange" ID="rbIpText" runat="server" 
								AutoPostBack="True" oncheckedchanged="rbIPTextCheckedChanged" /> <label>IP Address</label>
						</td>
						
						<td>
							<asp:TextBox ID="txtIPAddress" runat="server"></asp:TextBox>
							<asp:RequiredFieldValidator ID="rfvIPAddress" runat="server"
								ErrorMessage="Please enter 'IP Address'." ControlToValidate="txtIPAddress">*</asp:RequiredFieldValidator>
							<asp:RegularExpressionValidator ID="revIPAddress" runat="server"  
								ErrorMessage="Please enter a valid 'IP Address'." ControlToValidate="txtIPAddress" 
								ValidationExpression="\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b">*</asp:RegularExpressionValidator>
						</td>
					</tr>
					<tr>
						<td style="border-top:solid 1px #eeeeee; border-right:solid 1px #eeeeee;" valign="top">
							<asp:RadioButton GroupName="ipRange" ID="rbRangeText" runat="server" 
								AutoPostBack="True" oncheckedchanged="rbRangeTextCheckedChanged" /> <label>IP Range</label>
						</td>
						<td style="border-top:solid 1px #eeeeee;">
							<table>
								<tr>
									<td>From</td>
									<td>
										<asp:TextBox ID="txtRangeStart" runat="server"></asp:TextBox>
										<asp:RequiredFieldValidator ID="rfRangeStart" runat="server"
											ErrorMessage="Please enter the range start'IP Address'." ControlToValidate="txtRangeStart">*</asp:RequiredFieldValidator>
										<asp:RegularExpressionValidator ID="revRangeStart" runat="server"  
											ErrorMessage="Please enter a valid range start 'IP Address'." ControlToValidate="txtRangeStart" 
											ValidationExpression="\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b">*</asp:RegularExpressionValidator>
									</td>
								</tr>
								<tr>
									<td>To</td>
									<td>
										<asp:TextBox ID="txtRangeEnd" runat="server"></asp:TextBox>
										<asp:RequiredFieldValidator ID="rfRangeEnd" runat="server"
											ErrorMessage="Please enter range end 'IP Address'." ControlToValidate="txtRangeEnd">*</asp:RequiredFieldValidator>
										<asp:RegularExpressionValidator ID="revRangeEnd" runat="server"  
											ErrorMessage="Please enter a valid range end 'IP Address'." ControlToValidate="txtRangeEnd" 
											ValidationExpression="\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b">*</asp:RegularExpressionValidator>
									</td>
								</tr>
							</table>
					</td>
					</tr>
					
				</table>
				<br />
			</td>
		</tr>
		
		<tr>
			<td>
				Status
			</td>
			<td>
				<asp:DropDownList ID="ddlStatus" runat="server" Width="150"></asp:DropDownList>
			</td>
		</tr>
		<tr>
			<td>
				Description
			</td>
			<td>
				<asp:TextBox ID="txtDescription" runat="server" Width="138"></asp:TextBox>
			</td>
		</tr>
		<tr>
			<td>
				Access Code
			</td>
			<td>
				<asp:TextBox ID="accessCodeTextBox" runat="server" Width="138"></asp:TextBox>
			</td>
		</tr>
		<tr>
			<td>
				Country
			</td>
			<td>
				<asp:TextBox ID="txtCountry" runat="server" Width="138"></asp:TextBox>
			</td> 
		</tr>
		<tr>
			<td>
				Owner
			</td>
			<td>
				<asp:TextBox ID="txtOwner" runat="server" Width="138"></asp:TextBox>
			</td>
		</tr>
		<tr>
			<td>
				IP Group
			</td>
			<td>
				<asp:DropDownList ID="ddlGroup" runat="server" Width="150"></asp:DropDownList>
			</td>
		</tr>
	</table>
</div>
