<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ExecuteIntegrationServicesTaskSetting.ascx.cs" 
Inherits="VerticalPlatformAdminWeb.Platform.Task.ExecuteIntegrationServicesTaskSetting" %>

<ul class="common_form_area">
	<li class="common_form_row clearfix">
		<span class="label_span" style="width:160px;">
			<label>SSIS Project Location</label>
		</span>
		<span>
			<asp:TextBox runat="server" ID="ssisProjectLocation" ToolTip="The SSIS Project source folder." Width="200"></asp:TextBox>
			<asp:RequiredFieldValidator ID="ssisProjectLocationValidator" runat="server" ErrorMessage="Project location cannot be empty."
				ControlToValidate="ssisProjectLocation">*</asp:RequiredFieldValidator>
		</span>
	</li>
	<li class="common_form_row clearfix">
		<span class="label_span" style="width:160px;">
			<label>SSIS Project Password</label>
		</span>
		<span>
			<asp:TextBox runat="server" ID="projectPassword" ToolTip="The SSIS Project password." Width="200"></asp:TextBox>
			<asp:RequiredFieldValidator ID="projectPasswordValidator" runat="server" ErrorMessage="Project passsword cannot be empty."
				ControlToValidate="projectPassword">*</asp:RequiredFieldValidator>
		</span>
	</li>
	<li class="common_form_row clearfix">
		<span class="label_span" style="width:160px;">
			<label>Frequency to Check for Task Completion (Milliseconds)</label>
		</span>
		<span>
			<asp:TextBox runat="server" ID="taskInterval" ToolTip="Hoe Often Should the Task Completion be Checked." Width="200"></asp:TextBox>
			<asp:RequiredFieldValidator ID="taskIntervalValidator" runat="server" ErrorMessage="Frequency cannot be empty."
				ControlToValidate="taskInterval">*</asp:RequiredFieldValidator>
			<asp:CompareValidator ID="taskIntervalCompareValidator" runat="server" ErrorMessage="Fequency should be an integer."
				Type="Integer" ControlToValidate="taskInterval" Operator="DataTypeCheck">*</asp:CompareValidator>
		</span>
	</li>
</ul>
