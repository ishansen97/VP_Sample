<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EditIPGroup.ascx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.SpiderManagement.EditIPGroup" %>


<div>
	<table class="add-ip-group-table">
		<tr>
			<td>
				<asp:Literal ID="ltlIpGroupName" runat="server" Text="IP Address Group Name"></asp:Literal>
			</td>
			<td>
				<asp:TextBox ID="txtIpGroupName" runat="server" Width="179px">
				</asp:TextBox>
				<asp:RequiredFieldValidator ID="rfvGroupName" runat="server" ErrorMessage="Please enter name for the group."
				ControlToValidate="txtIpGroupName">*</asp:RequiredFieldValidator>
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
				<asp:Label ID="lblEnableIpGroup" runat="server" Text="Enabled"></asp:Label>
			</td>
			<td>
				<asp:CheckBox ID="chkIpGroupEnabled" runat="server" Checked="True" Text=" " />
			</td>
		</tr>

		<tr>
			<td>
				<asp:Label ID="lblSelectRule" runat="server" Text="Threshold Combine Rule"></asp:Label>
			</td>
			<td>				
				<asp:DropDownList ID="ddlThratProviderSelect" runat="server" style="width:auto;">
				</asp:DropDownList>
				<asp:HiddenField ID="hdnThreatProviderSelect" runat="server" />
			</td>
		</tr>

		<tr>
			<td>
				<asp:Label ID="lblThreatScore" runat="server" Text="Threat Score Threshold"></asp:Label>
			</td>
			<td>
				<asp:TextBox ID="txtThreatScore" runat="server" Width="50px">
				</asp:TextBox>	
				<asp:CompareValidator ID="cvTreatScore" runat="server" 
					ControlToValidate="txtThreatScore" 
					ErrorMessage="Insert an integer value for treat score" Operator="DataTypeCheck" 
					Type="Integer">*</asp:CompareValidator>
				<asp:HiddenField ID="hdnThreatScore" runat="server" />
			
			</td>
		</tr>

		<tr>
			<td>
				<asp:Label ID="lblVisitorType" runat="server" Text="Visitor Type Threshold"></asp:Label>
			</td>
			<td>
				<asp:TextBox ID="txtVisitorType" runat="server" Width="50px">
				</asp:TextBox>
				<asp:CompareValidator ID="cvVisitorType" runat="server" 
					ControlToValidate="txtVisitorType" 
					ErrorMessage="Insert an integer value for visitor type" Operator="DataTypeCheck" 
					Type="Integer">*</asp:CompareValidator>
				<asp:HiddenField ID="hdnVisitorType" runat="server" />
			</td>
		</tr>

	</table>
	<asp:Label ID="lblMessage" runat="server"></asp:Label>
</div>
