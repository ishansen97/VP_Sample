<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddAdditionalEmailAddresses.ascx.cs" 
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.BulkEmail.AddAdditionalEmailAddresses" %>

<div class="AdminPanelContent">
	<asp:Label ID="lblText" Text="Please enter email addresses (comma separated list)" runat="server"></asp:Label>
	<br />
	<asp:TextBox ID="txtEmailList" TextMode="MultiLine" runat="server" Rows="10" Wrap="true" Width="300px"></asp:TextBox>
	<br />
	<br />
	<asp:FileUpload ID="fuEmailListExcel" runat="server" CssClass="buttonFace"/>
	<asp:RequiredFieldValidator ID="rfvEmailListExcel" runat="server" ControlToValidate="fuEmailListExcel"
			ErrorMessage="Please select file." CssClass="displayMsg" ValidationGroup="Upload">*</asp:RequiredFieldValidator>
	<asp:Button ID="btnUpload" runat="server" CommandName="Upload"
			Text="Upload" OnClick="btnUpload_OnClick" CssClass="common_text_button" />
	<br />
	<br />
	<asp:Label ID="lblEmailListExcelFormat" runat="server" Text="Only Microsoft Excel files are allowed. (xls, xlsx)"></asp:Label>
	<br />
	<asp:Label ID="lblEmailExcelListColumns" runat="server" Text="Email addresses should be in the first column of the excel file."></asp:Label>
</div>
