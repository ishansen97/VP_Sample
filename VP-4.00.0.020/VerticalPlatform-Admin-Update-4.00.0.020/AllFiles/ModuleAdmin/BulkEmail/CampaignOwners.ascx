<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CampaignOwners.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.BulkEmail.CampaignOwners" %>
<table>
	<tr>
		<td>
			<span class="label_span">Site</span>
		</td>
		<td>
			<asp:DropDownList ID="ddlSites" runat="server" style="padding:3px;" AutoPostBack="true"
			OnSelectedIndexChanged="ddlSites_SelectedIndexChange"></asp:DropDownList>
		</td>
		<td>
		</td>
	</tr>
	<tr>
		<td>
			<span class="label_span">Media Owner</span>
		</td>
		<td>
			<asp:DropDownList ID="ddlUsers" runat="server" style="padding:3px;" width="120px">
			</asp:DropDownList>
		</td>
		<td>
			<asp:Button ID="btnAddOwner" runat="server" Text="Add Owner" OnClick="btnAddOwner_Click"
				CssClass="common_text_button" />
		</td>
	</tr>
</table>
<br />
<asp:GridView ID="gvOwner" runat="server" AutoGenerateColumns="False" OnRowCommand="gvOwner_RowCommand"
	OnRowDataBound="gvOwner_RowDataBound" CssClass="common_data_grid">
	<Columns>
		<asp:TemplateField>
			<ItemTemplate>
				<asp:Literal ID="ltlName" runat="server"></asp:Literal>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField>
			<ItemTemplate>
				<asp:LinkButton ID="lbtnDelete" CommandName="DeleteOwner" runat="server">Delete</asp:LinkButton>
			</ItemTemplate>
		</asp:TemplateField>
	</Columns>
	<EmptyDataTemplate>
		No owners found for campaign.
	</EmptyDataTemplate>
</asp:GridView>
