<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="PasswordReset.ascx.cs"
    Inherits="VerticalPlatformWeb.Modules.User.PasswordReset" %>
<div class="passwordResetModule">
    <div class="content">
        <div class="lable">
            Email address</div>
        <div class="inputElement">
            <asp:TextBox ID="txtEmail" runat="server" CssClass="textBox"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ErrorMessage="*" ValidationGroup="passwordReset"
                ControlToValidate="txtEmail"></asp:RequiredFieldValidator><asp:RegularExpressionValidator
                    ID="RegularExpressionValidator1" runat="server" ErrorMessage="Email not in correct format"
                    ControlToValidate="txtEmail" Display="Dynamic" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
        </div>
    </div>
    <div>
        <div class="lable">
            Password
        </div>
        <div class="inputElement">
            <p>
                <asp:Literal ID="LiteralPasswordMsg" runat="server"></asp:Literal>
            </p>
            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="textBox"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ErrorMessage="*" ValidationGroup="passwordReset"
                ControlToValidate="txtPassword"></asp:RequiredFieldValidator>
        </div>
    </div>
    <div>
        <div class="lable">
            Confirm Password</div>
        <div class="inputElement">
            <asp:TextBox ID="txtConfirmPass" runat="server" TextMode="Password" CssClass="textBox"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvConfirmPass" runat="server" ErrorMessage="*" ValidationGroup="passwordReset"
                ControlToValidate="txtConfirmPass"></asp:RequiredFieldValidator>
            <asp:CompareValidator ID="cvConfirmPassword" runat="server" ErrorMessage="Passwords mismatch"
                ControlToValidate="txtConfirmPass" Display="Dynamic" ControlToCompare="txtPassword" ValidationGroup="passwordReset"></asp:CompareValidator>
        </div>
    </div>
    <div class="message">
        <asp:Literal ID="ltlMessage" runat="server"></asp:Literal>
    </div>
    <div class="buttonPanel">
        <asp:Button ID="btnOk" runat="server" Text="Ok" OnClick="btnOk_Click" ValidationGroup="passwordReset"
            CssClass="button okButton" />
        <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="button cancelButton"
            OnClick="btnCancel_Click" />
    </div>
</div>
