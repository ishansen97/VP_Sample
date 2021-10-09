<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ApplicationSettings.aspx.cs"
	MasterPageFile="~/MasterPage.Master" Inherits="VerticalPlatformAdminWeb.Platform.ApplicationSettings" %>

<asp:Content ID="cntApplicationSetting" ContentPlaceHolderID="cphContent" runat="server">

	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>
				Application Settings</h3>
		</div>
		<div class="AdminPanelContent">
			<div>
				<table>
					<tr>
						<td>
							Admin Application Website URL
						</td>
						<td>
							<asp:TextBox ID="txtAdminWebsiteUrl" runat="server" Width="300px"></asp:TextBox>
						</td>
					</tr>
				</table>
				<hr />
				<h4>
					User Subscription Scores
				</h4>
				<table>
					<tr>
						<td class="common_form_row_lable">
							Email Received
						</td>
						<td class="common_form_row_data">
							<asp:TextBox ID="emailReceived" runat="server" Width="200px"></asp:TextBox>
							<asp:CompareValidator ID="emailReceivedValidator" runat="server" Operator="DataTypeCheck" Type="Integer" 
								ControlToValidate="emailReceived" ErrorMessage="Value must be a whole number">*</asp:CompareValidator>
							<asp:RequiredFieldValidator id="emailReceivedReqValidator" runat="server" ControlToValidate="emailReceived"
								SetFocusOnError="True">*</asp:RequiredFieldValidator>
						</td>
					</tr>
					<tr>
						<td class="common_form_row_lable">
							Email Opened
						</td>
						<td class="common_form_row_data">
							<asp:TextBox ID="emailOpened" runat="server" Width="200px"></asp:TextBox>
							<asp:CompareValidator ID="emailOpenedValidator" runat="server" Operator="DataTypeCheck" Type="Integer" 
								ControlToValidate="emailOpened" ErrorMessage="Value must be a whole number">*</asp:CompareValidator>
							<asp:RequiredFieldValidator id="emailOpenedReqValidator" runat="server" ControlToValidate="emailOpened"
								SetFocusOnError="True">*</asp:RequiredFieldValidator>
						</td>
					</tr>
					<tr>
						<td class="common_form_row_lable">
							Link Clicked
						</td>
						<td class="common_form_row_data">
							<asp:TextBox ID="linkClicked" runat="server" Width="200px"></asp:TextBox>
							<asp:CompareValidator ID="linkClickedValidator" runat="server" Operator="DataTypeCheck" Type="Integer" 
								ControlToValidate="linkClicked" ErrorMessage="Value must be a whole number">*</asp:CompareValidator>
							<asp:RequiredFieldValidator id="linkClickedReqValidator" runat="server" ControlToValidate="linkClicked"
								SetFocusOnError="True">*</asp:RequiredFieldValidator>
						</td>
					</tr>
					<tr>
						<td class="common_form_row_lable">
							Daily Depreciation
						</td>
						<td class="common_form_row_data">
							<asp:TextBox ID="dailyDepreciation" runat="server" Width="200px" placeholder="e.g: 1.0"></asp:TextBox> %
							<asp:RegularExpressionValidator ID="regexpName" runat="server"
									ErrorMessage="Invalid percentage." 
									ControlToValidate="dailyDepreciation"
									ValidationExpression="^([0-9]{1,3})\.([0-9]{1,2})">*</asp:RegularExpressionValidator>
							<asp:RequiredFieldValidator id="dailyDepreciationReqValidator" runat="server" ControlToValidate="dailyDepreciation"
								SetFocusOnError="True">*</asp:RequiredFieldValidator>
						</td>
					</tr>
					<tr>
						<td class="common_form_row_lable">
							Max Score
						</td>
						<td class="common_form_row_data">
							<asp:TextBox ID="maxScore" runat="server" Width="200px"></asp:TextBox>
							<asp:CompareValidator ID="maxScoreValidator" runat="server" Operator="DataTypeCheck" Type="Integer" 
								ControlToValidate="maxScore" ErrorMessage="Value must be a whole number">*</asp:CompareValidator>
							<asp:RequiredFieldValidator id="maxScoreReqValidator" runat="server" ControlToValidate="maxScore"
								SetFocusOnError="True">*</asp:RequiredFieldValidator>
						</td>
					</tr>
					<tr>
						<td class="common_form_row_lable">
							Opt-out Score
						</td>
						<td class="common_form_row_data">
							<asp:TextBox ID="optOutScore" runat="server" Width="200px"></asp:TextBox>
							<asp:CompareValidator ID="optOutScoreValidator" runat="server" Operator="DataTypeCheck" Type="Integer" 
								ControlToValidate="optOutScore" ErrorMessage="Value must be a whole number">*</asp:CompareValidator>
							<asp:CompareValidator runat="server" id="optOutScoreCompareValidator" controltovalidate="optOutScore" 
								controltocompare="maxScore" operator="LessThan" type="Integer"
								errormessage="Opt-out score should be less than max score">*</asp:CompareValidator>
							<asp:RequiredFieldValidator id="optOutScoreReqValidator" runat="server" ControlToValidate="optOutScore"
								SetFocusOnError="True">*</asp:RequiredFieldValidator>
						</td>
					</tr>
					<tr>
						<td class="common_form_row_lable">
							Unsubscribe Request
						</td>
						<td class="common_form_row_data">
							<asp:TextBox ID="unsubscribeRequestScore" runat="server" Width="200px"></asp:TextBox>
							<asp:CompareValidator ID="unsubscribeRequestValidator" runat="server" Operator="DataTypeCheck" Type="Integer" 
								ControlToValidate="unsubscribeRequestScore" ErrorMessage="Value must be a whole number">*</asp:CompareValidator>
							<asp:RequiredFieldValidator id="unsubscribeRequestScoreReqValidator" runat="server" 
								ControlToValidate="unsubscribeRequestScore" SetFocusOnError="True">*</asp:RequiredFieldValidator>
						</td>
					</tr>
				</table>
				<h5>
					Soft bounces
				</h5>
				<table>
					<tr>
						<td class="common_form_row_lable">
							General Bounce
						</td>
						<td class="common_form_row_data">
							<asp:TextBox ID="generalBounce" runat="server" Width="200px"></asp:TextBox>
							<asp:CompareValidator ID="generalBounceValidator" runat="server" Operator="DataTypeCheck" Type="Integer" 
								ControlToValidate="generalBounce" ErrorMessage="Value must be a whole number">*</asp:CompareValidator>
							<asp:RequiredFieldValidator id="generalBounceReqValidator" runat="server" ControlToValidate="generalBounce"
								SetFocusOnError="True">*</asp:RequiredFieldValidator>
						</td>
					</tr>
					<tr>
						<td class="common_form_row_lable">
							Soft Bounce - General
						</td>
						<td class="common_form_row_data">
							<asp:TextBox ID="softBounceGeneral" runat="server" Width="200px"></asp:TextBox>
							<asp:CompareValidator ID="softBounceGeneralValidator" runat="server" Operator="DataTypeCheck" Type="Integer" 
								ControlToValidate="softBounceGeneral" ErrorMessage="Value must be a whole number">*</asp:CompareValidator>
							<asp:RequiredFieldValidator id="softBounceGeneralReqValidator" runat="server" ControlToValidate="softBounceGeneral"
								SetFocusOnError="True">*</asp:RequiredFieldValidator>
						</td>
					</tr>
					<tr>
						<td class="common_form_row_lable">
							Soft Bounce - DNS Failure
						</td>
						<td class="common_form_row_data">
							<asp:TextBox ID="softBounceDNSFailure" runat="server" Width="200px"></asp:TextBox>
							<asp:CompareValidator ID="softBounceDNSFailureValidator" runat="server" Operator="DataTypeCheck" Type="Integer" 
								ControlToValidate="softBounceDNSFailure" ErrorMessage="Value must be a whole number">*</asp:CompareValidator>
							<asp:RequiredFieldValidator id="softBounceDNSFailureReqValidator" runat="server" ControlToValidate="softBounceDNSFailure"
								SetFocusOnError="True">*</asp:RequiredFieldValidator>
						</td>
					</tr>
					<tr>
						<td class="common_form_row_lable">
							Soft Bounce - Mailbox Full
						</td>
						<td class="common_form_row_data">
							<asp:TextBox ID="softBounceMailFull" runat="server" Width="200px"></asp:TextBox>
							<asp:CompareValidator ID="softBounceMailFullValidator" runat="server" Operator="DataTypeCheck" Type="Integer" 
								ControlToValidate="softBounceMailFull" ErrorMessage="Value must be a whole number">*</asp:CompareValidator>
							<asp:RequiredFieldValidator id="softBounceMailFullReqValidator" runat="server" 
								ControlToValidate="softBounceMailFull" SetFocusOnError="True">*</asp:RequiredFieldValidator>
						</td>
					</tr>
					<tr>
						<td class="common_form_row_lable">
							Soft Bounce - Message Size Too Large
						</td>
						<td class="common_form_row_data">
							<asp:TextBox ID="softBounceMessageSizeTooLarge" runat="server" Width="200px"></asp:TextBox>
							<asp:CompareValidator ID="softBounceMessageSizeTooLargeValidator" runat="server" Operator="DataTypeCheck" Type="Integer" 
								ControlToValidate="softBounceMessageSizeTooLarge" ErrorMessage="Value must be a whole number">*</asp:CompareValidator>
							<asp:RequiredFieldValidator id="softBounceMessageSizeTooLargeReqValidator" runat="server"
								ControlToValidate="softBounceMessageSizeTooLarge" SetFocusOnError="True">*</asp:RequiredFieldValidator>
						</td>
					</tr>
					<tr>
						<td class="common_form_row_lable">
							Bounce - But No Email Address Returned
						</td>
						<td class="common_form_row_data">
							<asp:TextBox ID="bounceNoEmail" runat="server" Width="200px"></asp:TextBox>
							<asp:CompareValidator ID="bounceNoEmailValidator" runat="server" Operator="DataTypeCheck" Type="Integer" 
								ControlToValidate="bounceNoEmail" ErrorMessage="Value must be a whole number">*</asp:CompareValidator>
							<asp:RequiredFieldValidator id="bounceNoEmailReqValidator" runat="server" ControlToValidate="bounceNoEmail"
								SetFocusOnError="True">*</asp:RequiredFieldValidator>
						</td>
					</tr>
					<tr>
						<td class="common_form_row_lable">
							Transient Bounce
						</td>
						<td class="common_form_row_data">
							<asp:TextBox ID="transientBounce" runat="server" Width="200px"></asp:TextBox>
							<asp:CompareValidator ID="transientBounceValidator" runat="server" Operator="DataTypeCheck" Type="Integer" 
								ControlToValidate="transientBounce" ErrorMessage="Value must be a whole number">*</asp:CompareValidator>
							<asp:RequiredFieldValidator id="transientBounceReqValidator" runat="server" ControlToValidate="transientBounce"
								SetFocusOnError="True">*</asp:RequiredFieldValidator>
						</td>
					</tr>
					<tr>
						<td class="common_form_row_lable">
							Mail Block - Relay Denied
						</td>
						<td class="common_form_row_data">
							<asp:TextBox ID="relayDenied" runat="server" Width="200px"></asp:TextBox>
							<asp:CompareValidator ID="relayDeniedValidator1" runat="server" Operator="DataTypeCheck" Type="Integer" 
								ControlToValidate="relayDenied" ErrorMessage="Value must be a whole number">*</asp:CompareValidator>
							<asp:RequiredFieldValidator id="relayDeniedReqValidator" runat="server" ControlToValidate="relayDenied"
								SetFocusOnError="True">*</asp:RequiredFieldValidator>
						</td>
					</tr>
					<tr>
						<td class="common_form_row_lable">
							Mail Block - General
						</td>
						<td class="common_form_row_data">
							<asp:TextBox ID="mailBlockGeneral" runat="server" Width="200px"></asp:TextBox>
							<asp:CompareValidator ID="mailBlockGeneralValidator" runat="server" Operator="DataTypeCheck" Type="Integer" 
								ControlToValidate="mailBlockGeneral" ErrorMessage="Value must be a whole number">*</asp:CompareValidator>
							<asp:RequiredFieldValidator id="mailBlockGeneralReqValidator" runat="server" ControlToValidate="mailBlockGeneral"
								SetFocusOnError="True">*</asp:RequiredFieldValidator>
						</td>
					</tr>
					<tr>
						<td class="common_form_row_lable">
							Mail Block - Known Spammer
						</td>
						<td class="common_form_row_data">
							<asp:TextBox ID="knownSpammer" runat="server" Width="200px"></asp:TextBox>
							<asp:CompareValidator ID="knownSpammerValidator" runat="server" Operator="DataTypeCheck" Type="Integer" 
								ControlToValidate="knownSpammer" ErrorMessage="Value must be a whole number">*</asp:CompareValidator>
							<asp:RequiredFieldValidator id="knownSpammerReqValidator" runat="server" ControlToValidate="knownSpammer"
								SetFocusOnError="True">*</asp:RequiredFieldValidator>
						</td>
					</tr>
					<tr>
						<td class="common_form_row_lable">
							Mail Block - Spam Detected
						</td>
						<td class="common_form_row_data">
							<asp:TextBox ID="spamDetected" runat="server" Width="200px"></asp:TextBox>
							<asp:CompareValidator ID="spamDetectedValidator" runat="server" Operator="DataTypeCheck" Type="Integer" 
								ControlToValidate="spamDetected" ErrorMessage="Value must be a whole number">*</asp:CompareValidator>
							<asp:RequiredFieldValidator id="spamDetectedFieldValidator" runat="server" ControlToValidate="spamDetected"
								SetFocusOnError="True">*</asp:RequiredFieldValidator>
						</td>
					</tr>
					<tr>
						<td class="common_form_row_lable">
							Challenge-Response
						</td>
						<td class="common_form_row_data">
							<asp:TextBox ID="challengeResponse" runat="server" Width="200px"></asp:TextBox>
							<asp:CompareValidator ID="challengeResponseValidator" runat="server" Operator="DataTypeCheck" Type="Integer" 
								ControlToValidate="challengeResponse" ErrorMessage="Value must be a whole number">*</asp:CompareValidator>
							<asp:RequiredFieldValidator id="challengeResponseReqValidator" runat="server" ControlToValidate="challengeResponse"
								SetFocusOnError="True">*</asp:RequiredFieldValidator>
						</td>
					</tr>
				</table>
				<hr />
			</div>
			<div>
				<asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" CssClass="btn"  />&nbsp;
				<input type="button" id="btnCancel" value="Cancel" onclick="window.location = '../Default.aspx'" class="btn" /></div>
		</div>
	</div>
</asp:Content>
