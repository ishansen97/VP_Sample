<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="DeleteSubscription.ascx.cs" Inherits="VerticalPlatformWeb.Modules.User.DeleteSubscription" %>
<div id="divDeleteSubscription" class="deleteSubscriptionModule module">
	<span id="vBtnDelete" class="error"></span>
	<input type="button" id="btnDelete" class="button" value="Delete" />
	<input type="button" id="btnDeleteAll" class="button" value="Unsubscribe From All Subscriptions" />
	<div id="divField">
		<asp:CheckBox ID="chkDeleteNewsletter" runat="server" Text="Please permanently unsubscribe me from e-Newsletters."/><asp:HiddenField
			ID="hdnDeleteNewsletter" runat="server" />
		<br />
		<asp:CheckBox ID="chkDeleteOptIn" runat="server" Text="Please permanently unsubscribe me from special offer and product alert emails."/><asp:HiddenField
			ID="hdnDeleteOptIn" runat="server" />
		<br />
		<asp:CheckBox ID="chkDeleteTechnology" runat="server" Text="Please permanently unsubscribe me from technology and video alert emails." /><asp:HiddenField
			ID="hdnDeleteTechnology" runat="server" />
		<br />
	</div>
</div>