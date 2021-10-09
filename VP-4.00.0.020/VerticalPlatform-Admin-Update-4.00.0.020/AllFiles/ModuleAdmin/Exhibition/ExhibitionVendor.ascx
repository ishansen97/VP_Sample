<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ExhibitionVendor.ascx.cs" 
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Exhibition.ExhibitionVendor" %>

<%@ Register src="~/Controls/ContentList.ascx" tagname="ContentList" tagprefix="uc1" %>

<ul class="common_form_area">
	<li class="common_form_row clearfix">
		<div style="width: 315px; float: left">Vendor Name</div>
		<div style="float: left;">Booth Number</div>
	</li>
	<li class="common_form_row clearfix">
		<div style="width: 315px; float: left">
			<uc1:ContentList ID="clVendors" runat="server" ContentTextWidth="300" 
			ControlContentType="Vendor" EnableContentIdInput="false" />
		</div>
		<div style="float: left;">
			<asp:TextBox ID="txtBoothNumber" runat="server" MaxLength="50"></asp:TextBox>
		</div>
	</li>
	<li class="common_form_row clearfix" style="padding-top: 10px;">Exhibition Vendor Landing Page URL </li>
	<li class="common_form_row clearfix">
	<asp:TextBox ID="txtFixedUrl" runat="server" Width="300px"></asp:TextBox>
	<asp:RequiredFieldValidator ID="rfvFixedUrl" runat="server" ErrorMessage="Please enter exhibition vendor landing page URL."
		ControlToValidate="txtFixedUrl" Display="Dynamic">*</asp:RequiredFieldValidator>
	<asp:RegularExpressionValidator ID="revFixedUrl" runat="server" ControlToValidate="txtFixedUrl"
		ErrorMessage="Invalid exhibition vendor landing page URL." ValidationExpression="^((?:\/[a-zA-Z0-9]+(?:_[a-zA-Z0-9]+)*(?:\-[a-zA-Z0-9]+)*)+)/$">*</asp:RegularExpressionValidator>
	</li>
	<li class="common_form_row clearfix" style="padding-top: 10px;">Exhibition Vendor Article</li>
	<li class="common_form_row clearfix">
		<uc1:ContentList ID="clArticle" runat="server" ContentTextWidth="300"
		ControlContentType="Article" EnableContentIdInput="true" />
	</li>
	<li class="common_form_row clearfix" style="padding-top: 10px;">Enabled</li>
	<li class="common_form_row clearfix">
		<asp:CheckBox ID="chkEnabled" runat="server" Checked="True" />
	</li>
	<li class="common_form_row clearfix" style="padding-top: 10px;">Logo</li>
	<li class="common_form_row clearfix">
		<div class="add_site_image" style="margin-right: 10px;">
			<asp:Image ID="imgLogo" runat="server" />
		</div>
		<div class="common_form_content">
			<asp:FileUpload runat="server" ID="fuLogo"/>
		</div>
	</li>
	<li class="common_form_row clearfix" style="padding-top: 10px;">Booth Description</li>
	<li class="common_form_row clearfix">
		<asp:TextBox runat="server" TextMode="MultiLine" Width="400px" Height="100px" ID="txtDescription" MaxLength="1000"></asp:TextBox>
	</li>
	<li class="common_form_row clearfix" style="padding-top: 10px;">Associate Categories
		to Vendor </li>
	<li class="common_form_row clearfix">
		<asp:CheckBoxList runat="server" RepeatColumns="2" RepeatDirection="Horizontal" ID="chklCategories">
		
		</asp:CheckBoxList>
	</li>
	<li class="common_form_row clearfix">
		<asp:Label ID="lblMessage" runat="server"></asp:Label>
	</li>
</ul>