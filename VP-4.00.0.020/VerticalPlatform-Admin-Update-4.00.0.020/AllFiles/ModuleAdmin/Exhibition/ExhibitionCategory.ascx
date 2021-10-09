<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ExhibitionCategory.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Exhibition.ExhibitionCategory" %>
<ul class="common_form_area">
	<li class="common_form_row clearfix">Category Name </li>
	<li class="common_form_row clearfix">
		<asp:TextBox ID="txtName" runat="server" Width="300px" MaxLength="225"></asp:TextBox>
		<asp:RequiredFieldValidator ID="rfvName" runat="server" ErrorMessage="Please enter category name.
			" ControlToValidate="txtName">*</asp:RequiredFieldValidator>
	</li>
	<li class="common_form_row clearfix" style="padding-top: 10px;">Exhibit Category Landing Page URL </li>
		<li class="common_form_row clearfix">
			<asp:TextBox ID="txtFixedUrl" runat="server" Width="300px"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvFixedUrl" runat="server" ErrorMessage="Please enter exhibit category landing page URL."
				ControlToValidate="txtFixedUrl" Display="Dynamic">*</asp:RequiredFieldValidator>
			<asp:RegularExpressionValidator ID="revFixedUrl" runat="server" ControlToValidate="txtFixedUrl"
				ErrorMessage="Invalid exhibit category landing page URL." ValidationExpression="^((?:\/[a-zA-Z0-9]+(?:_[a-zA-Z0-9]+)*(?:\-[a-zA-Z0-9]+)*)+)/$">*
				</asp:RegularExpressionValidator>
		</li>
	<li class="common_form_row clearfix" style="padding-top: 10px;">Description </li>
	<li class="common_form_row clearfix">
		<asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Width="400px"
			Height="100px" MaxLength="500"></asp:TextBox>
	</li>
	<li class="common_form_row clearfix" style="padding-top: 10px;">Enabled </li>
	<li class="common_form_row clearfix">
		<asp:CheckBox ID="chkEnabled" runat="server" Checked="True" />
	</li>
	<li class="common_form_row clearfix" style="padding-top: 10px;">Sort Order </li>
	<li class="common_form_row clearfix">
		<asp:TextBox ID="txtSortOrder" runat="server"></asp:TextBox>
		<asp:CompareValidator ID="cvSortOrder" runat="server" ControlToValidate="txtSortOrder" Operator="DataTypeCheck" Type="Integer" ErrorMessage="Sort order should be an integer"></asp:CompareValidator>
	</li>
	<li class="common_form_row clearfix" style="padding-top: 10px;">Image </li>
	<li class="common_form_row clearfix">
		<div class="add_site_image" style="margin-right: 10px;">
			<asp:Image ID="imgLogo" runat="server" />
		</div>
		<div class="common_form_content">
			<asp:FileUpload ID="fuLogo" runat="server" />
		</div>
	</li>
</ul>
