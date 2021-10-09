<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ForumThreadPost.ascx.cs"
    Inherits="VerticalPlatformWeb.Modules.Forum.ForumThreadPost" %>
<%@ Register TagPrefix="recaptcha" Namespace="Recaptcha" Assembly="Recaptcha" %>
<script src="https://www.google.com/recaptcha/api.js" async defer></script>

<div class="forumThreadPost">
    <div class="postRow" id="divTopicRow" runat="server" visible="false">
        <span class="postTopic">
            <asp:Literal ID="ltlTopic" runat="server"></asp:Literal></span>
        <li id="lyddlTopic"><span class="postText">
            <asp:DropDownList ID="ddlTopic" runat="server" CssClass="forumPostSubject">
            </asp:DropDownList>
        </span></li>
    </div>
    <div class="postRow">
        <span class="postTitle">
            <asp:Literal ID="ltlSubject" runat="server"></asp:Literal></span>
        <li id="litxtSubject"><span class="postText">
            <asp:TextBox ID="txtSubject" runat="server" CssClass="forumPostSubject"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvSubject" runat="server" ErrorMessage="*" ControlToValidate="txtSubject"></asp:RequiredFieldValidator>
        </span></li>
    </div>
    <div class="postRow" id="divPostRow" runat="server">
        <span class="postTitle">Body</span>
        <li id="litxtBody"><span class="postText">
            <asp:TextBox ID="txtBody" runat="server" TextMode="MultiLine" CssClass="forumPostBody"></asp:TextBox>
        </span></li>
        <div id="postInstructions" class="postInstructions">
            To format your post:<br>
            [b]<b>For bold text</b>[/b]<br>
            [i]<i>For italic text</i>[/i]<br>
            [u]<u>For underline text</u>[/u]<br>
            [q]For quoting a previous post (the whole post or just part of it)[/q]<br>
            [link name="example link name"]http://www.example.org[/link] for creating hyperlinks.
        </div>
    </div>
    <div class="postRow" id="receiveEmail" runat="server">
        <asp:Literal ID="ltlReceiveEmail" runat="server" Text="Receive email alerts"></asp:Literal>
        <asp:CheckBox ID="chkReceiveEmail" runat="server" CssClass="forumPostReceiveEmail" />
    </div>
    <div>
        <div class="g-recaptcha" id ="recaptchaControl" runat="server"></div>
      <br/>
    </div>
    <asp:Label runat="server" ID="lblCaptchaValidateMessage" Visible="False" CssClass="lblValidate"
        Text="The captcha didn't match. Please try again."
        ForeColor="#CC3300"></asp:Label>
    <div class="postButtons">
        <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="forumPostSave" OnClick="btnSave_Click" />
        <asp:Button ID="btnSaveThreadPost" runat="server" Text="Save and Create a new Post"
            CssClass="forumThreadSaveAndNewPost" OnClick="btnSaveThreadPost_Click" />
        <asp:Button ID="btnCancel" runat="server" Text="Cancel" CausesValidation="false"
            CssClass="forumPostCancel" OnClick="btnCancel_Click" />
    </div>
</div>
