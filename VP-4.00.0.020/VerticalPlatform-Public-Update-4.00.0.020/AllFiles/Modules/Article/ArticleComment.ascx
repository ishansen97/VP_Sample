<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ArticleComment.ascx.cs"
	Inherits="VerticalPlatformWeb.Modules.Articles.ArticleComment" %>
<div class="addCommentModule module">
	<div class="name" id="divtxtCmtUsername">
		<span class="formInputLable">Name</span>
		<asp:TextBox ID="txtCmtUserName" runat="server" CssClass="txtCmtUsername" >
		</asp:TextBox>
	</div>
	<div class="email" id="divtxtCmtEmail">
		<span class="formInputLable">E-Mail Address</span>
		<asp:TextBox ID="txtCmtEmail" runat="server" CssClass="txtCmtEmail" ></asp:TextBox>
	</div>
	<div class="commentText" id="divtxtCmtComment">
		<span class="formInputLable">Message</span>
		<asp:TextBox ID="txtCmtComment" runat="server" TextMode="MultiLine" CssClass="txtCmtComment" ></asp:TextBox>
	</div>
	<asp:Label ID="lblError" runat="server" CssClass="error"></asp:Label>
	<div class="buttonSection">
		<asp:Button ID="btnPostComment" runat="server" Text="" OnClick="btnPostComment_Click"
			CssClass="button hiddenButton"/>
		<input type="button" id="btnDummyPostComment" value="Post your comment" class="button postCommentsButton"/>
			
		<asp:Button ID="btnCancel" runat="server" Text="Cancel" CausesValidation="false"
			CssClass="button cancelButton" OnClick="btnCancel_Click" />
	</div>
</div>
