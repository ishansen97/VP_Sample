<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ChangeCampaignStatus.ascx.cs" 
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.BulkEmail.ChangeCampaignStatus" %>
	
<div class="AdminPanelContent">
	<ul class="common_form_area">
		<li class="common_form_row clearfix"><span class="label_span">Campaign Status</span> 
			<span>
				<asp:DropDownList ID="ddlStatus" runat="server"></asp:DropDownList>
				<asp:HiddenField ID="hdnStatus" runat="server" />
			</span>
		</li>
		<li class="common_form_row clearfix"><span class="label_span">Special Comments</span>
			<span>
				<asp:TextBox ID="txtSpecialComments" runat="server" TextMode="MultiLine"></asp:TextBox>						
			</span>
		</li>
	</ul>
</div>
