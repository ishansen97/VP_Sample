<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="VendorSearchNotifierSettings.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.VendorSearchNotifierSettings" %>

<div>
	<ul class="common_form_area">
		<li class="common_form_row clearfix" style="padding-top: 10px;">
			<div class="common_form_row_lable">
				Maximum Number of Vendors
			</div>
			<div class="common_form_row_data">
				<asp:TextBox ID="numberOfVendorsText" runat="server" Width="220px"></asp:TextBox>
				<asp:HiddenField ID="numberOfVendorsHidden" runat="server" />
				<asp:CompareValidator ID="numberOfVendorsCompare" runat="server" ErrorMessage="Please enter a numeric value for number of vendors. "
					ControlToValidate="numberOfVendorsText" Type="Integer" Operator="DataTypeCheck">*</asp:CompareValidator>
				<asp:RangeValidator ID="numberOfVendorsRange" ControlToValidate="numberOfVendorsText"
					Type="Integer" MinimumValue="1" MaximumValue="100" runat="server"
					ErrorMessage="Number of vendors should be between 1 and 100.">*</asp:RangeValidator>
			</div>
		</li>
	</ul>
</div>
