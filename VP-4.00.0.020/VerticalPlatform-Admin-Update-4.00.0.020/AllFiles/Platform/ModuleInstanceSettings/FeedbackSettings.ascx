<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="FeedbackSettings.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.FeedbackSettings" %>
<table>
	<tr>
		<td>
			<asp:Literal ID="ltlFeedbackEmail" runat="server" Text="Email Address"></asp:Literal>
		</td>
		<td>
			<asp:TextBox ID="txtEmail" runat="server"></asp:TextBox>
			<asp:HiddenField ID="hdnEmail" runat="server" />
			<asp:CustomValidator ID="emailAddressValidator" runat="server" ControlToValidate="txtEmail" 
				ErrorMessage="Incorrect e mail format" ValidateEmptyText="true" ClientValidationFunction="VP.ValidateEmail"
				ValidationGroup="apply">*</asp:CustomValidator>
		</td>
	</tr>
	<tr>
		<td>
			<asp:Literal ID="ltlMessage" runat="server" Text="Message"></asp:Literal>
		</td>
		<td>
			<asp:TextBox ID="txtMessage" TextMode="MultiLine" runat="server" Height="75px" Width="315px"></asp:TextBox>
			<asp:HiddenField ID="hdnMessage" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			<asp:Literal ID="ltlThankMessage" runat="server" Text="Thank You Message"></asp:Literal>
		</td>
		<td>
			<asp:TextBox ID="txtThankMessage" TextMode="MultiLine" runat="server" Height="75px"
				Width="315px"></asp:TextBox>
			<asp:HiddenField ID="hdnThankMessage" runat="server" />
		</td>
	</tr> 
	<tr>
		<td>
			Include Request Access Code
		</td>
		<td>
			<asp:CheckBox runat="server" ID="requestAccessCodeCheckBox"/> 
			<asp:HiddenField ID="requestAccessCodeHiddenField" runat="server" />
		</td>
	</tr>
</table>
