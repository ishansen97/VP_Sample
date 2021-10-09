<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ExhibitionVendorSpecial.ascx.cs" 
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Exhibition.ExhibitionVendorSpecial" %>
<ul class="common_form_area">
	<li class="common_form_row clearfix" style="padding-top: 10px;">Title </li>
	<li class="common_form_row clearfix">
		<asp:TextBox ID="txtTitle" runat="server" Width="300px" MaxLength="200"></asp:TextBox>
		<asp:RequiredFieldValidator ID="rfvTitle" runat="server" ErrorMessage="Please enter title." ControlToValidate="txtTitle">*</asp:RequiredFieldValidator>
	</li>
	<li class="common_form_row clearfix" style="padding-top: 10px;">Description </li>
	<li class="common_form_row clearfix">
		<asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Width="400px"
				Height="100px" MaxLength="1500"></asp:TextBox>
		<asp:RequiredFieldValidator ID="rvrDescription" runat="server" ErrorMessage="Please enter description." 
				ControlToValidate="txtDescription">*</asp:RequiredFieldValidator>
	</li>
	<li class="common_form_row clearfix" style="padding-top: 10px;">Image</li>
	<li class="common_form_row clearfix">
		<div class="add_site_image" style="margin-right: 10px;">
			<asp:Image ID="imgLogo" runat="server" />
		</div>
		<div class="common_form_content">
			<asp:FileUpload runat="server" ID="fuLogo"/>
		</div>
	</li>
	<li class="common_form_row clearfix" style="padding-top: 10px;">Enabled </li>
	<li class="common_form_row clearfix">
		<asp:CheckBox ID="chkEnabled" runat="server" Checked="True" />
	</li>
	<li class="common_form_row clearfix" style="padding-top: 10px;">
		<asp:Label ID="lblMessage" runat="server"></asp:Label>
	</li>
</ul>