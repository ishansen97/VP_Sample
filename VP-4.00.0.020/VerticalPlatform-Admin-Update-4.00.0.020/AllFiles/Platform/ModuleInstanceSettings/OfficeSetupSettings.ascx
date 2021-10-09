<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="OfficeSetupSettings.ascx.cs" Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.OfficeSetupSettings" %>
<script type="text/javascript">
	$(document).ready(function() {
			if (!$('#PopupControl_chkDisplayVendorLogo').is(":checked")) {
				$("#PopupControl_dvShowVendorThumbImgSize").hide();
			}
			
			if (!$('#PopupControl_chkDisplayVendorDescription').is(":checked")) {
				$("#PopupControl_dvShowDescriptionLength").hide();
			}

		$('#PopupControl_chkDisplayVendorLogo').click(function () {
			if ($('#PopupControl_chkDisplayVendorLogo').is(":checked")) {
				$("#PopupControl_dvShowVendorThumbImgSize").show();
			}
			else {
				$("#PopupControl_dvShowVendorThumbImgSize").hide();
			}
		});
		
		$('#PopupControl_chkDisplayVendorDescription').click(function () {
			if ($('#PopupControl_chkDisplayVendorDescription').is(":checked")) {
				$("#PopupControl_dvShowDescriptionLength").show();
			}
			else {
				$("#PopupControl_dvShowDescriptionLength").hide();
			}
		});
	});
</script>

<div id="officeSetup">
	<ul class="common_form_area">
		<li class="common_form_row clearfix group_row">
			<div class="common_form_row_lable">
				Lead Page Type
			</div>
			<div class="common_form_row_data">
				<asp:DropDownList ID="ddlLeadTypeList" runat="server">
				</asp:DropDownList>
				<asp:HiddenField ID="hdnLeadTypeList" runat="server" />
			</div>
		</li>
		<li class="common_form_row clearfix group_row">
			<div class="common_form_row_lable">
				Show Office Setup Vendor Description
			</div>
			<div class="common_form_row_data">
				<asp:CheckBox ID="chkDisplayVendorDescription" runat="server" />
				<asp:HiddenField ID="hdnDisplayVendorDescription" runat="server" />
			</div>
		</li>
		<li class="common_form_row clearfix group_row">
			<div id="dvShowDescriptionLength" runat="server">
				<div class="common_form_row_lable">
					Description Length
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtDescriptionLength" runat="server"></asp:TextBox>
					<asp:CompareValidator ID="cpvTruncateLength" runat="server" ErrorMessage="Numbers only"
						ControlToValidate="txtDescriptionLength" Type="Integer" Operator="DataTypeCheck"
						SetFocusOnError="True"></asp:CompareValidator>
					<asp:HiddenField ID="hdnDescriptionLength" runat="server" />
				</div>
			</div>
		</li>
		<li class="common_form_row clearfix group_row">
			<div id="Div1" runat="server">
			<div class="common_form_row_lable">
				Show Vendor Thumbnail Image
			</div>
			<div class="common_form_row_data">
				<asp:CheckBox ID="chkDisplayVendorLogo" runat="server"/>
				<asp:HiddenField ID="hdnDisplayVendorLogo" runat="server"/>
			</div>
			</div>
		</li>
		<li class="common_form_row clearfix group_row" >
			<div id="dvShowVendorThumbImgSize" runat="server">
				<div class="common_form_row_lable">
					Display Vendor Thumbnail Image Size
				</div>
				<div class="common_form_row_data">
					<asp:DropDownList ID="ddlThumbnailImageSize" runat="server"/>
					<asp:HiddenField ID="hdnThumbnailImageSize" runat="server"/>
				</div>
			</div>
		</li>
		<li class="common_form_row clearfix group_row">
			<div class="common_form_row_lable">
				Display Mode
			</div>
			<div class="common_form_row_data">
				<asp:DropDownList ID="ddlDisplayMode" runat="server">
				</asp:DropDownList>
				<asp:HiddenField ID="hdnDisplayMode" runat="server" />
			</div>
		</li>
		<li class="common_form_row clearfix group_row">
			<div class="common_form_row_lable">
				Lead Page Url
			</div>
			<div class="common_form_row_data">
				<asp:TextBox ID="txtLeadPageUrl" runat="server"></asp:TextBox>
				<asp:HiddenField ID="hdnLeadPageUrl" runat="server"/>
			</div>
		</li>
		<li class="common_form_row clearfix group_row">
			<div class="common_form_row_lable">
				Lead Submit Button Text
			</div>
			<div class="common_form_row_data">
				<asp:TextBox ID="txtLeadSubmitButton" runat="server"></asp:TextBox>
				<asp:HiddenField ID="hdnLeadSubmitButton" runat="server" />
			</div>
		</li>
	</ul>
</div>
