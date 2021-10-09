<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="VendorDetailSettings.ascx.cs" Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.VendorDetailSettings" %>

<table>
	<tr>
		<td>
			Display Country Name as Local Office Contact Title
		</td>
		<td>
			<asp:CheckBox ID="chkDisplayCountryName" runat="server" Checked="false" />
			<asp:HiddenField ID="hdnDisplayCountryName" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Display All Contact Details
		</td>
		<td>
			<asp:CheckBox ID="DisplayAllContactDetails" runat="server" Checked="false" />
			<asp:HiddenField ID="hdnDisplayAllContactDetails" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Display Product Categories
		</td>
		<td>
			<asp:CheckBox ID="DisplayProductCategories" runat="server" Checked="false" />
			<asp:HiddenField ID="hdnDisplayProductCategories" runat="server" />
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