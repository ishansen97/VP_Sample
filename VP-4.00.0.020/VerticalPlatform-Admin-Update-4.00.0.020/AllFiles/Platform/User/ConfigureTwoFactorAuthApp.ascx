<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ConfigureTwoFactorAuthApp.ascx.cs" Inherits="VerticalPlatformAdminWeb.Platform.User.ConfigureTwoFactorAuthApp" %>

<div>
    <asp:HiddenField ID="hdnSecretKey" runat="server" />
  <div>To use an Authenticator App go through the following steps.</div>
    <div>
       1. Download a two-factor authenticator app like Microsoft Authenticator for <a href="https://go.microsoft.com/fwlink/?Linkid=825071" target="_blank">Windows Phone</a>,
        <a href="https://play.google.com/store/apps/details?id=com.azure.authenticator" target="_blank">Android</a> and <a href="https://apps.apple.com/app/id983156458" target="_blank">iOS</a> or
        Google Authenticator for <a href="https://play.google.com/store/apps/details?id=com.google.android.apps.authenticator2&hl=en" target="_blank">Android</a> and 
        <a href="https://apps.apple.com/us/app/google-authenticator/id388497605" target="_blank">iOS</a>.
    </div>
    <div>
        2. Scan the QR Code or enter this key <b><asp:Label ID="lblManualSetupCode" runat="server" ForeColor="#993366"></asp:Label></b> into your two factor authenticator app.
        <div>
            <asp:Image ID="imgQrCode" runat="server" />
        </div>
    </div>
    <div>
        3. Once you have scanned the QR code or input the key above, your two factor authentication app will provide you with a unique code. Enter the code in the confirmation box below.
        <div style="font-size: medium; padding: 5px 10px;">
            <b>Verification Code</b>
        </div>
        <div style="padding-left: 10px;">
            <asp:TextBox ID="txtVerificationCode" runat="server"></asp:TextBox>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" ControlToValidate="txtVerificationCode" runat="server" ErrorMessage="Verification Code Required">*</asp:RequiredFieldValidator>
        </div>
    </div>
</div>
