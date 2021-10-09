<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CampaignRecipientsPreview.ascx.cs" 
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.BulkEmail.CampaignRecipientsPreview" %>
<%@ Register Src="../Pager.ascx" TagName="Pager" TagPrefix="uc1" %>

<div style="min-width:330px;">
<div id="divSearchPane" style="border:solid 1px #dddddd; padding:10px 5px 2px 5px;">
	<ul class="common_form_area">
		<li class="common_form_row clearfix">
		<span class="label_span" style="width:auto; margin-right:10px;">Email Address</span>
		<span>
			<asp:TextBox runat="server" ID="txtEmail" Width="188px" MaxLength="200"></asp:TextBox>&nbsp;
			<asp:Button ID="btnApply" runat="server" Text="Search" onclick="btnApplyFilter_Click"
				CssClass="common_text_button"/>
			<asp:Button ID="btnRestFilter" runat="server" Text="Reset" 
				CssClass="common_text_button" onclick="btnRestFilter_Click" />
		</span>
		</li>
		<li class="common_form_row clearfix">
			
		</li>
	</ul>
</div>
<br />
<asp:GridView ID="gvRecipients" runat="server" AutoGenerateColumns="True" CssClass="common_data_grid" ShowHeader="false">
	<EmptyDataTemplate>
		No recipients found.
	</EmptyDataTemplate>
</asp:GridView>
<br />
<uc1:Pager ID="pagerRecipients" runat="server" OnPageIndexClickEvent="pageIndex_Click" />
</div>
