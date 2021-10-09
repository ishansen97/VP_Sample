<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="PasswordProtected.ascx.cs" Inherits="VerticalPlatformWeb.Modules.Login.PasswordProtected" %>
<div id="divPasswordProtected">
<h3><asp:Literal ID="ltlTitle" runat="server"></asp:Literal> </h3>
	<div class="loginRow">
				<span class="loginCol1">Password:</span> <span class="loginCol2">
					<asp:TextBox ID="txtPassword" runat="server" TextMode="Password"></asp:TextBox>
					</span>
	</div>

	<div class="loginButtons">
				<input id="btnLogin" value="Submit" class="button login" onclick="return VP.Forms.PasswordProtected.Validate();"/>
	</div>
	<div>
			<span id="lblMessage" class="error"></span>
			<asp:HiddenField ID="hdnFixedUrlId" runat="server" />
			<asp:HiddenField ID="hdnMessage" runat="server" />
	</div>
</div>