<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EditUserAgent.ascx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.SpiderManagement.EditUserAgent" %>

<div>
	<table>
		<tr>
			<td>
				<asp:Literal ID="ltlUserAgentName" runat="server" Text="User Agent Name"></asp:Literal>
			</td>
			<td>
				<asp:TextBox ID="txtUserAgentName" runat="server" Width="179px"/>&nbsp;&nbsp;
                <asp:CheckBox ID="emptyAgentCheckBox" runat="server" Width="179px" Checked="false" OnCheckedChanged="emptyAgentCheckBox_CheckedChanged" AutoPostBack="true" Text="Empty Agent"/>
				<asp:RequiredFieldValidator ID="rfvUserAgentName" runat="server" ErrorMessage="Please enter name."
				ControlToValidate="txtUserAgentName">*</asp:RequiredFieldValidator>
			</td>
		</tr>
		
		<tr>
			<td>
				<asp:Literal ID="ltlDescription" runat="server" Text="Description"></asp:Literal>
			</td>
			<td>
				<asp:TextBox ID="txtDescription" runat="server" Width="179px">
				</asp:TextBox>
			</td>
		</tr>
		<tr>
			<td>
				<asp:Literal ID="ltlBlocked" runat="server" Text="Blocked"></asp:Literal>
			</td>
			<td>
				<asp:CheckBox ID="chkBlocked" runat="server" Width="179px" Checked="false">
				</asp:CheckBox>
			</td>
		</tr>
		
		<tr>
			<td>
				<asp:Literal ID="ltlFullNameMatch" runat="server" Text="Match Full Name"></asp:Literal>
			</td>
			<td>
				<asp:CheckBox ID="chkFullNameMatch" runat="server" Width="179px" Checked="false">
				</asp:CheckBox>
			</td>
		</tr>
	</table>
	<asp:Label ID="lblMessage" runat="server"></asp:Label>
</div>
