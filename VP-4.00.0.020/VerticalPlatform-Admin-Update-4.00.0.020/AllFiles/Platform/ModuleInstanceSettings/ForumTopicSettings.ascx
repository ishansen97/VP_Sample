<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ForumTopicSettings.ascx.cs" 
Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.ForumTopicSettings" %>

<div>
	<ul class="common_form_area">
		<li class="common_form_row clearfix" style="padding-top: 10px;">
			<div class="common_form_row_lable">
				Enable Topic Suggestions
			</div>
			<div class="common_form_row_data">
				<asp:CheckBox ID="EnableTopicSuggestion" runat="server" />
				<asp:HiddenField ID="hdnEnableTopicSuggestion" runat="server" />
			</div>
		</li>
		<li class="common_form_row clearfix" style="padding-top: 10px;">
			<div class="common_form_row_lable">
				Display Synopsis Length
			</div>
			<div class="common_form_row_data">
				<asp:TextBox ID="synopsisLength" runat="server"/>
				<asp:HiddenField ID="hdnSynopsisLength" runat="server" />
				<asp:CompareValidator runat="server" ControlToValidate="synopsisLength" ErrorMessage="Values has to be a numeric." 
						Operator="DataTypeCheck" Type="Integer">*</asp:CompareValidator>
				
			</div>
		</li>
	</ul>
</div>