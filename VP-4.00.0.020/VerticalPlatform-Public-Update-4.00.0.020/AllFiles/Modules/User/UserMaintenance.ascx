<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="UserMaintenance.ascx.cs" 
Inherits="VerticalPlatformWeb.Modules.User.UserMaintenance" %>
<div id="divUserMaintenance" runat="server">
	<asp:Label ID="lblTitle" runat="server" Text="Registration and Subscription Settings"></asp:Label>
	<br />
	<br />
	<asp:Label ID="lblDescription" runat="server" Text="This page allows you to edit and control your user account and your subscriptions to our Email services including E-newsletters, Product Alerts and Special Offer Alerts. Please select an option below."></asp:Label>
	<br />
	<div id="divTabLinks">
		<ul>
			<li>
				<asp:HyperLink ID="lnkDeleteSubscriptions" runat="server" Text="Delete all of my email subscriptions"></asp:HyperLink>
			</li>
			<li>
				<asp:HyperLink ID="lnkEditSubscriptions" runat="server" Text="View and edit all my current email subscriptions"></asp:HyperLink>
			</li>
			<li>
				<asp:HyperLink ID="lnkEditUserInformation" runat="server" Text="View and edit my current user account information"></asp:HyperLink>
			</li>
		</ul>
	</div>
</div>
