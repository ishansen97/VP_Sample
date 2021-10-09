<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddSegment.ascx.cs" 
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.BulkEmail.AddSegment" %>

<div class="AdminPanelContent">
	<ul class="common_form_area">
		<li class="common_form_row clearfix"><span class="label_span">Name</span> <span>
			<asp:TextBox ID="txtName" runat="server" Width="200px" MaxLength="30"></asp:TextBox>
			<asp:RegularExpressionValidator ID="revSegmentName" runat="server" ControlToValidate="txtName"
				ErrorMessage="Invalid segment name. Following characters are allowed(alpha numeric, _, -)." 
				ValidationExpression="^[a-zA-Z0-9-_\s]*$">*</asp:RegularExpressionValidator>
			<asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName"
				ErrorMessage="Please enter segment name.">*</asp:RequiredFieldValidator></span>
		</li>
		<li class="common_form_row clearfix"><span class="label_span">Type</span> <span>
			<asp:DropDownList ID="ddlSegmentTypes" runat="server" AutoPostBack="True" 
				onselectedindexchanged="ddlSegmentTypes_SelectedIndexChanged">
			</asp:DropDownList></span>
		</li>
		<li class="common_form_row clearfix"><span class="label_span">Limit Results for the Defined Cap</span> <span>
			<asp:CheckBox ID="chkCappedApplicable" runat="server" Enabled="true" Checked="true" /></span>
		</li>
	</ul>
</div>