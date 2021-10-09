<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ForumTopic.ascx.cs"
	Inherits="VerticalPlatformWeb.Modules.Forum.ForumTopic" %>
<%@ Register Src="~/Controls/Pager.ascx" TagName="Pager" TagPrefix="uc1" %>

<div class="forumTopic">
	<asp:Literal ID="ltlForumTopic" runat="server"></asp:Literal>
</div>
<asp:Panel ID="suggestForumTopicPanel" runat="server">
	<div class="suggestForumTopic">
	<asp:TextBox ID="txtSuggestion" runat="server" CssClass="suggessionText"></asp:TextBox>
		<asp:RequiredFieldValidator ID="rfvSuggestion" runat="server" ErrorMessage="*" ValidationGroup="suggestion"
		ControlToValidate="txtSuggestion"></asp:RequiredFieldValidator>
	<asp:Button ID="btnSuggest" runat="server" CssClass="suggestionButton" Text="Suggest New Topic"
		ValidationGroup="suggestion" OnClick="btnSuggest_Click" />
</div>
</asp:Panel>
