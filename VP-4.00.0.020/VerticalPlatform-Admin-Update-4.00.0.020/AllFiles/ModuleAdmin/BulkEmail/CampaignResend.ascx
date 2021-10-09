<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CampaignResend.ascx.cs"
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.BulkEmail.CampaignResend" %>
<div class="AdminPanelContent">
	<span class="label_span">Email addresses (comma seperated list)</span>
	<br />
	<asp:TextBox ID="txtEmailList" TextMode="MultiLine" runat="server" Height="100px"
				Width="250px"></asp:TextBox>
	<br />
	<asp:Button ID="btnSend" Text="Send" runat="server" OnClick="btnSend_Click" ValidationGroup="send"
		CssClass="common_text_button" />
</div>