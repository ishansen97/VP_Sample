<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="LoginRegister.ascx.cs"
	Inherits="VerticalPlatformWeb.Modules.Login.LoginRegister" %>
<div class="loginRegister" id="divLoginRegister">
	<ul>
		<li><a href="#login"><span>Login</span></a></li>
		<li runat="server" id="liRegister"><a href="#register"><span>Register</span></a></li>
	</ul>
	<div id="login" class="loginModule" runat="server">
		<div id="loginForm" class="login" runat="server" Visible="False">
			<div class="loginHeader">
				<h4>
					Login</h4>
			</div>
			<div class="loginHeader">
				To manage your eNewsletter and email alert subscriptions, log in to view and change your selections.
			</div>
			<div class="loginRow">
				<span class="loginCol1">E-Mail Address:</span> <span class="loginCol2">
					<asp:TextBox ID="txtEmail" runat="server"></asp:TextBox>
					<span id="vEmail" class="error"></span></span>
			</div>
			<div class="loginRow">
				<span class="loginCol1">Password:</span> <span class="loginCol2">
					<asp:TextBox ID="txtPassword" runat="server" TextMode="Password"></asp:TextBox>
					<span id="vPassword" class="error"></span></span>
			</div>
			<div class="loginButtons">
				<asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="button login" OnClientClick="return VP.Forms.LoginRegister.Validate();"
					OnClick="btnLogin_Click" />
			</div>
			<div>
				<asp:Label ID="lblMessage" runat="server" CssClass="error"></asp:Label></div>
		</div>
		<div id="divPasswordReset" class="forgotPassword" runat="server" Visible="False">
			<div class="forgotPasswordHeader">
				Logging in for the first time?
				<br />
				Forgot your password?
			</div>
			<div class="forgotPasswordText">
				<asp:Label ID="lblforgotPasswordText" runat="server" Text="Enter your E-mail Address to receive your Password."/>
			</div>
			<div class="forgotPasswordFooter">
				For first time visitors, or if you have forgotten your password, just enter your email and click "Submit" button. A password will be sent to you.
			</div>
			<div class="forgotPasswordRow">
				<span class="forgotPasswordCol1">E-mail Address:</span><span class="forgotPasswordCol2">
					<asp:TextBox ID="txtForgotPasswordEmail" runat="server" />
				</span>
			</div>
			<div class="loginButtons">
				<asp:Button id="btnForgotPassword" runat="server" Text="Submit" class="button forgotPassword"
					OnClick="btnSubmit_Click" />
			</div>
			<div>
				<asp:Label ID="lblResetMessage" runat="server" CssClass="error"></asp:Label>
			</div>
		</div>
	</div>
	
	<div id="register">
		<asp:PlaceHolder ID="phRegister" runat="server"></asp:PlaceHolder>
		<asp:HiddenField ID="hdnCurrentPage" runat="server" Value="0" />
		<asp:Label ID="lblRegisterMessage" runat="server" CssClass="error"></asp:Label>
	</div>
</div>
