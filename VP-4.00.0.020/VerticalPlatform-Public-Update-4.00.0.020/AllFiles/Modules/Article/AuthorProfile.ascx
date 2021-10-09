<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AuthorProfile.ascx.cs" Inherits="VerticalPlatformWeb.Modules.Articles.AuthorProfile" %>

<div class="author-info">
    <div class="image" runat="server" ID="divProfileImg" Visible="false">
        <asp:Image ID="authorProfileImg" runat="server" />
    </div>
	<div class="info">
		<asp:PlaceHolder ID="renderAuthorItems" runat="server"></asp:PlaceHolder>
	</div>
</div>
