<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddUserFieldsMapping.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.PublicUser.AddUserFieldsMapping" %>
<div class="AdminPanelContent">
	<ul class="common_form_area">
		<li class="common_form_row clearfix"><span class="label_span">Source Field</span>
			<asp:DropDownList ID="ddlSourceFields" runat="server" Style="padding: 3px;">
			</asp:DropDownList>
			<asp:RequiredFieldValidator ID="rfvSourceFields" runat="server" ErrorMessage="Please select a source field"
				ControlToValidate="ddlSourceFields">*</asp:RequiredFieldValidator>
		</li>
		<li class="common_form_row clearfix"><span class="label_span">Destination Field</span>
			<asp:DropDownList ID="ddlDestinationFields" runat="server" Style="padding: 3px;">
			</asp:DropDownList>
			<asp:RequiredFieldValidator ID="rfvDestinationFields" runat="server" ErrorMessage="Please select a destination field"
				ControlToValidate="ddlDestinationFields">*</asp:RequiredFieldValidator>
		</li>
		<li class="common_form_row clearfix"><span class="label_span">Prerequisite Field</span>
			<asp:DropDownList ID="ddlPrerequisiteFields" runat="server" Style="padding: 3px;"
				AutoPostBack="true" OnSelectedIndexChanged="ddlPrerequisiteFields_SelectedIndexChange">
			</asp:DropDownList>
		</li>
		<li class="common_form_row clearfix"><span class="label_span">Prerequisite Field Option</span>
			<asp:DropDownList ID="ddlPrerequisiteFieldOptions" runat="server" Style="padding: 3px;">
			</asp:DropDownList>
		</li>
	</ul>
</div>
