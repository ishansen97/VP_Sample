<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ProductContactInformationSettings.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.ProductContactInformationSettings" %>
<table>
	<tr>
		<td>
			Show Contact Information Only for Non-Ranked Vendors
		</td>
		<td>
			<asp:CheckBox ID="chkDisplayNoneRankedContactInfo" runat="server" />
			<asp:HiddenField ID="hdnDisplayNoneRankedContactInfo" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Show Contact Information Only for Minimized Vendors
		</td>
		<td>
			<asp:CheckBox ID="chkDisplayMinimizedContactInfo" runat="server" />
			<asp:HiddenField ID="hdnDisplayMinimizedContactInfo" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Show Contact Information Only for Standard Vendors
		</td>
		<td>
			<asp:CheckBox ID="chkDisplayStandardContactInfo" runat="server" />
			<asp:HiddenField ID="hdnDisplayStandardContactInfo" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Show Contact Information Only for Featured Vendors
		</td>
		<td>
			<asp:CheckBox ID="chkDisplayFeaturedContactInfo" runat="server" />
			<asp:HiddenField ID="hdnDisplayFeaturedContactInfo" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Enable Contact Information ClickThrough Tracking
		</td>
		<td>
			<asp:CheckBox ID="chkContactClickThrough" runat="server" />
			<asp:HiddenField ID="hdnContactClickThrough" runat="server" />
		</td>
	</tr>
		<tr>
		<td>
			Display Vendor Thumbnail Image Size
		</td>
		<td>
			<asp:DropDownList ID="ddlThumbnailImageSize" runat="server"/>
			<asp:HiddenField ID="hdnThumbnailImageSize" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Display Country Name as Local Office Contact Title
		</td>
		<td>
			<asp:CheckBox ID="chkDisplayCountryName" runat="server" />
			<asp:HiddenField ID="hdnDisplayCountryName" runat="server" />
		</td>
	</tr>
		<tr>
		<td>
			Facebook Link Text
		</td>
		<td>
			<asp:TextBox ID="FacebookLinkText" runat="server"></asp:TextBox>
			<asp:HiddenField ID="HiddenFacebookLinkText" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Twitter Link Text
		</td>
		<td>
			<asp:TextBox ID="TwitterLinkText" runat="server"></asp:TextBox>
			<asp:HiddenField ID="HiddenTwitterLinkText" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			LinkedIn Link Text
		</td>
		<td>
			<asp:TextBox ID="LinkedInLinkText" runat="server"></asp:TextBox>
			<asp:HiddenField ID="HiddenLinkedInLinkText" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			YouTube Link Text
		</td>
		<td>
			<asp:TextBox ID="YouTubeLinkText" runat="server"></asp:TextBox>
			<asp:HiddenField ID="HiddenYouTubeLinkText" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Google+ Link Text
		</td>
		<td>
			<asp:TextBox ID="GooglePlusLinkText" runat="server"></asp:TextBox>
			<asp:HiddenField ID="HiddenGooglePlusLinkText" runat="server" />
		</td>
	</tr>
</table>
