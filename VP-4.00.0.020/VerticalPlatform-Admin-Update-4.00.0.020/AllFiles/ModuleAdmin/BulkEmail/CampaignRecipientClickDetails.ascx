<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CampaignRecipientClickDetails.ascx.cs"
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.BulkEmail.CampaignRecipientClickDetails" %>
<%@ Register Src="../Pager.ascx" TagName="Pager" TagPrefix="uc1" %>
<table>
	<tr>
		<td>
			<span class="label_span">Url</span>
		</td>
		<td>
			<asp:DropDownList ID="ddlUrls" runat="server" style="padding:3px;"
			OnSelectedIndexChanged="ddlUrls_SelectedIndexChange" AutoPostBack="true"></asp:DropDownList>
		</td>
	</tr>
</table>
<br/>
<div style="min-width:330px;">
<asp:GridView ID="gvRecipientClickDetails" runat="server" AutoGenerateColumns="False"
	OnRowDataBound="gvRecipientClickDetails_RowDataBound" CssClass="common_data_grid">
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
		No click details found.
	</EmptyDataTemplate>
</asp:GridView>
<uc1:Pager ID="pagerRecipients" runat="server" OnPageIndexClickEvent="pageIndex_Click" />
</div>
