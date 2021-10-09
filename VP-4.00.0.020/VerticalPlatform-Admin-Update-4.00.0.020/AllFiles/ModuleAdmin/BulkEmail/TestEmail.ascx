<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="TestEmail.ascx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.BulkEmail.TestEmail" %>
<div class="AdminPanelContent">
	<div id="divCampaignOwners" runat="server">
		<span class="label_span">Campaign Owners</span>
		<br />
		<asp:GridView ID="gvOwnerEmails" runat="server" AutoGenerateColumns="False" OnRowDataBound="gvOwnerEmails_RowDataBound"
			CssClass="common_data_grid" ShowHeader="false">
			<Columns>
				<asp:TemplateField>
					<ItemTemplate>
						<asp:CheckBox ID="chkSelect" runat="server" />
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField>
					<ItemTemplate>
						<asp:Literal ID="ltlOwner" runat="server"></asp:Literal>
					</ItemTemplate>
				</asp:TemplateField>
			</Columns>
		</asp:GridView>
		<br />
	</div>
	<span class="label_span">Other Emails (comma separated list)</span>
	<br />	
	<span>
		<asp:TextBox ID="txtEmailList" TextMode="MultiLine" runat="server" Height="59px"
			Width="257px"></asp:TextBox></span>
	<br />
	<br />
	<span class="label_span">Send Through</span>
	<asp:DropDownList ID="ddlSendingOptions" runat="server" Width="140px" style="margin-right:5px;"></asp:DropDownList>
</div>
