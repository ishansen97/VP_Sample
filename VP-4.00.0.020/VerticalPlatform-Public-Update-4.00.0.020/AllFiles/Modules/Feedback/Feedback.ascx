<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Feedback.ascx.cs" Inherits="VerticalPlatformWeb.Modules.Feedback.Feedback" %>
 	<script type="text/javascript">
 		$(function () {
 		  $("input[id$='requestErrorCodeTextBox']").keydown(function (e) {
 		    e.preventDefault();
 		  });
 		});
	</script>
<div class="feedbackModule">
	<div class="content" runat="server" id="content">
		<div runat="server" id="dvContent">
			<div class="bodyMessage">
					<asp:Literal ID="ltlBodyMessage" runat="server"></asp:Literal>
			</div>
			<div>
				From</div>
			<div>
				<asp:TextBox ID="txtFrom" runat="server"></asp:TextBox>
				<asp:RequiredFieldValidator ID="rfvFrom" runat="server" ControlToValidate="txtFrom"
					ErrorMessage="*" ValidationGroup="sendMail"></asp:RequiredFieldValidator>
				<asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtFrom"
					ErrorMessage="Incorrect e mail format" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
					ValidationGroup="sendMail"></asp:RegularExpressionValidator>
			</div>
			<div>
				Subject</div>
			<div>
				<asp:TextBox ID="txtSubject" runat="server"></asp:TextBox>
				<asp:RequiredFieldValidator ID="rfvSubject" runat="server" ControlToValidate="txtSubject"
					ErrorMessage="*" ValidationGroup="sendMail"></asp:RequiredFieldValidator>
			</div>
			<div>
				Message</div>
			<div>
				<asp:TextBox ID="txtMessage" runat="server" Height="97px" TextMode="MultiLine" Width="297px"></asp:TextBox>
				<asp:RequiredFieldValidator ID="rfvMessage" runat="server" ControlToValidate="txtMessage"
					ErrorMessage="*" ValidationGroup="sendMail"></asp:RequiredFieldValidator>
			</div>
			<asp:Panel runat="server" ID="requestErrorCodePanel" Visible="False">
				<div>Access Denied Error Code</div>
				<div>
					<asp:TextBox ID="requestErrorCodeTextBox" runat="server"></asp:TextBox>
					<asp:HiddenField ID="requestErrorCodeHMACHiddenField" runat="server" ></asp:HiddenField>
				</div>
			</asp:Panel>
			<div>
				<asp:Button ID="btnSend" runat="server" Text="Send Mail" OnClick="btnSend_Click"
					ValidationGroup="sendMail" /></div>
		</div>
		<div runat="server" id="dvMessage" Visible="false">
			<div class='thankMessage'>
				<asp:Literal ID="ltlThankYouMessage" runat="server"></asp:Literal>
			</div>
			<div>
				<asp:Button ID="btnOk" runat="server" Text="Back to home" OnClick="btnOK_Click"/>
			</div>
		</div>
	</div>
	<asp:Label ID="lblError" CssClass="error" runat="server" Visible="false"></asp:Label>
	<div id="msgContent" class="message" runat="server">
	</div>
</div>
