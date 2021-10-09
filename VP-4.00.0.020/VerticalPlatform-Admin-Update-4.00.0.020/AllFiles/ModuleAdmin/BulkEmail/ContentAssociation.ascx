<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ContentAssociation.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.BulkEmail.ContentAssociation" %>

<script type="text/javascript">
	$(document).ready(function() {
		var element = $("#<%=ddlAssociatedContentType.ClientID %>");
		var options = { siteId: VP.SiteId, currentPage: '1', pageSize: '5', displaySites: 'true',
		contentTypeDropDownId: '', enabled: 'true', publishedOnly: 'true', externalType: "true", typeElement: element};
		$("input[type=text][id*=txtAssociatedContent]").contentPicker(options);
	});
</script>

<div class="AdminPanelContent">
	<table>
		<tr>
			<td>
				<span class="label_span"><b>Create Content Association </b></span>
			</td>
		</tr>
		<tr>
			<td>
				<span class="label_span">Associated Content Type</span>
			</td>
			<td>
				<asp:DropDownList ID="ddlAssociatedContentType" runat="server" AutoPostBack="true" />
			</td>
		</tr>
		<tr>
			<td>
				<span class="label_span">Associated Content Id</span>
			</td>
			<td>
				<asp:TextBox ID="txtAssociatedContent" runat="server" />
				<asp:CompareValidator ID="cvAssociatedContent" runat="server" ErrorMessage="Associated Content id should be a numeric value."
					ControlToValidate="txtAssociatedContent" Operator="DataTypeCheck" Type="Integer"
					ValidationGroup="CampaignContentData">*</asp:CompareValidator>
			</td>
		</tr>
		<tr>
			<td>
				<span class="label_span">Enabled</span>
			</td>
			<td>
				<asp:CheckBox ID="chkAssociationEnabled" runat="server" />
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<asp:Button runat="server" ID="btnSaveCampaignContentData" Text="Save" OnClick="btnSaveContentData_Click"
					CssClass="common_text_button" ValidationGroup="CampaignContentData" />
				<asp:Button runat="server" ID="btnReset" Text="Reset" OnClick="btnReset_Click" CausesValidation="false"
					CssClass="common_text_button" />
			</td>
		</tr>
	</table>
	<asp:GridView ID="gvContentToContent" runat="server" OnRowDataBound="gvContentToContent_RowDataBound"
		AutoGenerateColumns="false" CssClass="common_data_grid" OnRowCommand="gvContentToContent_RowCommand">
		<Columns>
			<asp:BoundField HeaderText="Content Id" DataField="ContentId" />
			<asp:BoundField HeaderText="Content Type" DataField="ContentType" />
			<asp:TemplateField HeaderText="Content Name">
				<ItemTemplate>
					<asp:Label ID="lblContentName" runat="server"></asp:Label>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField HeaderText="Site">
				<ItemTemplate>
					<asp:Label ID="lblSite" runat="server" ></asp:Label>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:BoundField HeaderText="Associated Content Id" DataField="AssociatedContentId" />
			<asp:BoundField HeaderText="Associated Content Type" DataField="AssociatedContentType" />
			<asp:TemplateField HeaderText="Associated Content Name">
				<ItemTemplate>
					<asp:Label ID="lblAssociatedContentName" runat="server"></asp:Label>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField HeaderText="Associated Site">
				<ItemTemplate>
					<asp:Label ID="lblAssociatedSite" runat="server" ></asp:Label>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:BoundField HeaderText="Enabled" DataField="Enabled" />
			<asp:TemplateField>
				<ItemTemplate>
					<asp:LinkButton OnClientClick="return confirm('Are you sure?');" ID="lbtnDelete"
						runat="server" Text="Delete" CommandName="DeleteContentToContent"></asp:LinkButton>
				</ItemTemplate>
			</asp:TemplateField>
		</Columns>
		<EmptyDataTemplate>
			No content associations found.</EmptyDataTemplate>
	</asp:GridView>
</div>
