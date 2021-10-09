<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="UserSubscription.ascx.cs" Inherits="VerticalPlatformWeb.Modules.User.UserSubscription" %>
<div class="userSubscriptionModule module" id="divUserSubscription">
	<asp:PlaceHolder ID="phSelect" runat="server"></asp:PlaceHolder>
	<asp:PlaceHolder ID="phContent" runat="server"></asp:PlaceHolder>
	<div class="inputElements">
		<asp:Button ID="btnSave" runat="server" Text="Save" CssClass="button" 
			onclick="btnSave_Click"/>
	</div>
</div>