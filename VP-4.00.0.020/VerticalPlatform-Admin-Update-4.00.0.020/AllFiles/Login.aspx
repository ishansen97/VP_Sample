<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="VerticalPlatformAdminWeb.Login" %>

<!DOCTYPE html>
<html>
<head id="Head1" runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Vertical Platform - Login</title>
</head>
<body>
<form id="form1" runat="server">
<div class="logiin-container">
    <div class="site-logo"><img id="Img1" src="~/App_Themes/Default/Images/login-logo.png" runat="server" /></div>
    <div class="brand">Vertical Platform <span>Admin</span></div>
    <div id="loginPanel">
        <asp:Login ID="lgnLogin" runat="server" OnAuthenticate="lgnLogin_Authenticate" LabelStyle-CssClass="label-title"
									TitleText="" TitleTextStyle-CssClass="panel-header" CssClass="login-panel"
									DisplayRememberMe="False" LoginButtonStyle-CssClass="btn login-btn" TextBoxStyle-CssClass="input-medium" FailureTextStyle-CssClass="alert alert-error">
        </asp:Login>
    </div>
    <div class="footer-txt">
        &copy; CompareNetworks
    </div>
</div>
</form>

    <form runat="server" id="tfa">
        <div class="logiin-container">
            <div class="site-logo"><img id="Img2" src="~/App_Themes/Default/Images/login-logo.png" runat="server"/></div>
            <div class="brand">Vertical Platform <span>Admin</span></div>
            <div class="two-factor-login-panel">
                <div class="two-factor-heading">
                    Two-Factor Authentication
                </div>
                <div class="two-factor-form">
                    <label>Enter a code to complete sign-in. <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="**" ControlToValidate="tfaCode"></asp:RequiredFieldValidator></label>
                    <div class="two-factor-code">
                        <asp:TextBox ID="tfaCode" runat="server"></asp:TextBox>
                    </div>
                
                    <asp:Label CssClass="two-factor-error" ID="lblTfaError" runat="server" ForeColor="red" Text="Sign-in failed. Please check the code again"></asp:Label>
                
                    <div>
                        <label class="two-factor-remember-me"><asp:CheckBox ID="cbxRememberMe" runat="server"/><span>Remember Me</span></label>
                    </div>
                    <div class="two-factor-buttons">
                        <input id="Submit1" type="submit" value="Submit" runat="server" class="btn login-btn" onserverclick="ValidateTwoFactorAuth" />
                        <asp:HyperLink ID="lnkCancel" runat="server">Cancel</asp:HyperLink>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>





