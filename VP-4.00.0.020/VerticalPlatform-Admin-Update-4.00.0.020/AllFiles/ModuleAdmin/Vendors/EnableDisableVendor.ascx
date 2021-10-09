<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EnableDisableVendor.ascx.cs" 
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Vendors.EnableDisableVendor" %>

<div class="AdminPanelContent">
	<ul class="common_form_area">
		<li class="common_form_row clearfix">
			<asp:RadioButtonList ID="rblEnableDisableVendor" runat="server">
				<asp:ListItem Selected="True" Value="0"></asp:ListItem>
				<asp:ListItem Selected="False" Value="1"></asp:ListItem>
			</asp:RadioButtonList>
			<br />
			<br />
			<asp:Literal ID="ltlDisableChildInfo" runat="server" Visible="false" Text="[Child Vendors will be disabled as well.]"></asp:Literal>
		</li>
	</ul>
</div>
