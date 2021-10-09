<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="DisqusCommentSettings.ascx.cs"
Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.DisqusCommentSettings" %>

<table>
	<tr>
		<td>
			Disqus Comment Short Name
		</td>
		<td>
			<asp:TextBox ID="shortName" runat="server" Style="margin-left: 0px"
				Width="75px"></asp:TextBox>
			<asp:HiddenField ID="hdnShortName" runat="server" />
			<asp:RequiredFieldValidator ID="shortNameValidator" runat="server" ControlToValidate="shortName" 
			ErrorMessage = "Please enter a valid text for disqus comment short name." >*</asp:RequiredFieldValidator>
		</td>
	</tr>
</table>
