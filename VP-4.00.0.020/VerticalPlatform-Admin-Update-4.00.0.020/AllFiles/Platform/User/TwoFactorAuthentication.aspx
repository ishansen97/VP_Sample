<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TwoFactorAuthentication.aspx.cs" Inherits="VerticalPlatformAdminWeb.Platform.User.TwoFactorAuthentication"
    MasterPageFile="~/MasterPage.Master" %>

<asp:Content runat="server" ID="cnt2FA" ContentPlaceHolderID="cphContent">
    <div class=" AdminPanel">
        <div class="AdminPanelHeader">
            <h3>
                <asp:Label ID="lblHeader" runat="server" BackColor="Transparent">Two-Factor Authentication</asp:Label>
            </h3>
        </div>

        <div class="AdminPanelContent">
            <div class="add-button-container">
                <asp:HyperLink ID="lnkConfigureAuthenticatorApp" runat="server" CssClass="aDialog btn"></asp:HyperLink>

                <asp:Button ID="btnDisableTwoFactorAuth" runat="server" CssClass="btn" Font-Names="PT Sans" Text="Disable Two Factor Authentication" OnClientClick="return confirm('Are you sure you want to disable Two Factor Authentication?');" OnClick="btnDisableTwoFactorAuth_Click" />

            </div>
        </div>
    </div>

</asp:Content>

