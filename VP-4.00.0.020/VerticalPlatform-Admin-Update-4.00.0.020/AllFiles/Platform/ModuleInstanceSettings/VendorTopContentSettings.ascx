<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="VendorTopContentSettings.ascx.cs" 
Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.VendorTopContentSettings" %>

<div class="vendorTopContentSettings">
	<ul class="common_form_area">
		<li class="common_form_row clearfix group_row">
			<div class="common_form_row_lable">
				Vendor Top Content Title Truncate Length.
			</div>
			<div class="common_form_row_data">
				<asp:TextBox ID="vendorTopContentTitleLength" runat="server"></asp:TextBox>
				<asp:HiddenField ID="vendorTopContentTitleLengthHiddenVal" runat="server" />
			</div>
		</li>
	</ul>
</div>