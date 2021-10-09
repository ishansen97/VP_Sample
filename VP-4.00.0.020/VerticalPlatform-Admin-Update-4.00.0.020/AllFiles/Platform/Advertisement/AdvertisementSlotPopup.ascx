<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AdvertisementSlotPopup.ascx.cs" 
Inherits="VerticalPlatformAdminWeb.Platform.Advertisement.AdvertisementSlotPopup" %>
<script language="javascript" type="text/javascript">
	$(document).ready(function() {
		$(".adSlotDatePicker").datepicker(
		{
			changeYear: true
		});
	});
</script>
<table>
	<tr>
		<td>
			Vendor
		</td>
		<td>
			<asp:DropDownList ID="ddlVendor" runat="server">
			</asp:DropDownList>
		</td>
	</tr>
	<tr>
		<td>
			Description
		</td>
		<td>
			<asp:TextBox ID="txtDescription" runat="server" Width="183px"></asp:TextBox>
			<asp:RequiredFieldValidator ID="RequiredFieldValidator1" ControlToValidate="txtDescription" ErrorMessage="Please enter description." runat="server"
				ValidationGroup="Validate">*</asp:RequiredFieldValidator>
		</td>
	</tr>
	<tr>
		<td>
			URL
		</td>
		<td>
			<asp:TextBox ID="txtUrl" runat="server" Width="185px"></asp:TextBox>
			<asp:RequiredFieldValidator ID="RequiredFieldValidator2" ControlToValidate="txtUrl" ErrorMessage="Please enter url." runat="server"
				ValidationGroup="Validate">*</asp:RequiredFieldValidator>
			<asp:RegularExpressionValidator ID="revUrl" runat="server" ControlToValidate="txtUrl"
					ErrorMessage="Please enter valid URL." ValidationExpression="http://[A-Za-z0-9.-]{3,}.[A-Za-z]{3}" ValidationGroup="Validate">*</asp:RegularExpressionValidator>
		</td>
	</tr>
	<tr>
		<td>
			Start Date
		</td>
		<td>
			<asp:TextBox ID="txtStartDate" CssClass="adSlotDatePicker" runat="server" Width="186px" ></asp:TextBox>
			<asp:Image ID="imgStartDate" runat="server" ImageUrl="~/Images/SmallCalendar.gif"
				Width="16px" />
			<asp:RequiredFieldValidator ID="RequiredFieldValidator3" ControlToValidate="txtStartDate" ErrorMessage="Please enter start date " runat="server"
				ValidationGroup="Validate">*</asp:RequiredFieldValidator>
		</td>
	</tr>
	<tr>
		<td>
			End Date
		</td>
		<td>
			<asp:TextBox ID="txtEndDate" runat="server" Width="185px" CssClass="adSlotDatePicker"></asp:TextBox>
			<asp:Image ID="imgEndDate" runat="server" ImageUrl="~/Images/SmallCalendar.gif" />
			<asp:Image ID="imgClearEndDate" AlternateText="Clear" runat="server" Width="16" Height="16"
				ImageUrl="~/Images/Eraser.gif" />
		</td>
	</tr>
	<tr>
		<td>
			Impression Target
		</td>
		<td>
			<asp:TextBox ID="txtImpressionTarget" runat="server" Width="185px"></asp:TextBox>
			<asp:RegularExpressionValidator ID="revIntegerValidator" runat="server" ControlToValidate="txtImpressionTarget"
					ErrorMessage="Please enter numeric value." ValidationExpression="[0-9]+" ValidationGroup="Validate">*</asp:RegularExpressionValidator>
		</td>
	</tr>
	<tr>
		<td>
			Enabled
		</td>
		<td>
			<asp:CheckBox ID="chkEnable" runat="server" />
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<asp:HiddenField ID="hdnAdSlotId" runat="server" />
			<asp:HiddenField ID="hdnUrlId" runat="server" />
		</td>
	</tr>
</table>