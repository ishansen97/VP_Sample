<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="VendorContactContactType.ascx.cs" 
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Vendors.VendorContactContactType" %>



<div class="contactType">
	<div class="header">
		<strong>Contact Type (General Contact or Sales Contact)</strong>
	</div>
	<br />
	<div>
		<table cellpadding="0" cellspacing="0">
			<tr>
				<td>
					Contact Type : 
				</td>
				<td>
					<asp:DropDownList ID="ddlContactType" runat="server" AppendDataBoundItems="true">
					</asp:DropDownList>
				</td>
			</tr>
		</table>
	</div>
</div>