<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CampaignRecipients.ascx.cs" 
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.BulkEmail.CampaignRecipients" %>
<%@ Register Src="../Pager.ascx" TagName="Pager" TagPrefix="uc1" %>

<div style="min-width:330px;">
<asp:GridView ID="gvRecipients" runat="server" AutoGenerateColumns="False"
	OnRowDataBound="gvRecipients_RowDataBound" CssClass="common_data_grid">
	<Columns>
		<asp:TemplateField HeaderText="Email">
			<ItemTemplate>
				<asp:Literal ID="ltlEmail" runat="server"></asp:Literal>
			</ItemTemplate>
		</asp:TemplateField>
	</Columns>
	<Columns>
		<asp:TemplateField HeaderText="First Name">
			<ItemTemplate>
				<asp:Literal ID="ltlFirstName" runat="server"></asp:Literal>
			</ItemTemplate>
		</asp:TemplateField>
	</Columns>
	<Columns>
		<asp:TemplateField HeaderText="Last Name">
			<ItemTemplate>
				<asp:Literal ID="ltlLastName" runat="server"></asp:Literal>
			</ItemTemplate>
		</asp:TemplateField>
	</Columns>
	<EmptyDataTemplate>
		No recipients found.
	</EmptyDataTemplate>
</asp:GridView>
<uc1:Pager ID="pagerRecipients" runat="server" OnPageIndexClickEvent="pageIndex_Click" />
</div>