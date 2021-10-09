<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddEditTriggers.ascx.cs" 
Inherits="VerticalPlatformAdminWeb.Platform.Task.AddEditTriggers" %>
<div class="AdminPanelContent">
	<ul class="common_form_area">
		<li class="common_form_row clearfix"><span class="label_span">Type</span> <span>
			<asp:DropDownList ID="ddlTriggerType" runat="server"
				AppendDataBoundItems="true" Width="210px">
				<asp:ListItem Text="--Select--" Value=""></asp:ListItem>
			</asp:DropDownList>
			<asp:RequiredFieldValidator ID="rfvTriggerType" runat="server" ControlToValidate="ddlTriggerType"
				ErrorMessage="Please select trigger type.">*</asp:RequiredFieldValidator>
		</span></li>
		<li class="common_form_row clearfix"><span class="label_span">Name</span> <span>
			<asp:TextBox ID="txtName" runat="server" Width="200px"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName"
				ErrorMessage="Please enter trigger name.">*</asp:RequiredFieldValidator></span>
		</li>
		<li class="common_form_row clearfix"><span class="label_span">Enabled</span>
			<asp:CheckBox ID="chkEnabled" runat="server" Checked="true" ></asp:CheckBox>
		</li>
	</ul>
</div>
