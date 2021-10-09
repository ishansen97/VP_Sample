<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SpiderPageViewQueueConsumerTaskSetting.ascx.cs" Inherits="VerticalPlatformAdminWeb.Platform.Task.SpiderPageViewQueueConsumerTaskSetting" %>
<ul class="common_form_area">
	<li class="common_form_row clearfix">
		<span class="label_span" style="width: 160px;"><label>
			Delete records older than (Minutes):</label></span> 
		<span>
			<asp:TextBox runat="server" ID="expireDuration" ToolTip="Expire records older than"></asp:TextBox>
			<asp:CompareValidator ID="expireDurationValidator" ControlToValidate="expireDuration" runat="server" 
					ErrorMessage="Invalid expiration time." Operator="DataTypeCheck" Type="Integer" >*</asp:CompareValidator>
			<asp:RequiredFieldValidator ID="sliderWindowExpireDurationRequiredValidator" ControlToValidate="expireDuration" runat="server"
				ErrorMessage="Expiration time cannot be empty.">*</asp:RequiredFieldValidator>
		</span>
	</li>
	<li>
		<span class="label_span">
				<asp:Label ID="warning" runat="server" Text="* 'Spider Alert' reports can be affected by this value" ForeColor="Red"></asp:Label>
		</span>
	</li>
</ul>