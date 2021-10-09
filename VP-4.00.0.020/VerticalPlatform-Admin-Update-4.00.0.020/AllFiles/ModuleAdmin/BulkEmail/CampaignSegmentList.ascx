<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CampaignSegmentList.ascx.cs"
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.BulkEmail.CampaignSegmentList" %>
<div style="min-width:330px;">
<table>
	<tr>
		<td>
			<span class="label_span">Site</span>
		</td>
		<td>
			<asp:DropDownList ID="ddlSites" runat="server" style="padding:3px;" AutoPostBack="true"
			OnSelectedIndexChanged="ddlSites_SelectedIndexChange"></asp:DropDownList>
		</td>
	</tr>
	<tr>
		<td>
			<span class="label_span">Type</span>
		</td>
		<td>
			<asp:DropDownList ID="ddlSegmentTypes" runat="server" style="padding:3px;" AutoPostBack="true"
			OnSelectedIndexChanged="ddlSegmentTypes_SelectedIndexChange"></asp:DropDownList>
		</td>
	</tr>
	<tr>
		<td>
			<span class="label_span">Status</span>
		</td>
		<td>
			<asp:DropDownList ID="segmentStatus" runat="server" style="padding:3px;" AutoPostBack="true"
			onselectedindexchanged="segmentStatus_SelectedIndexChanged">
			</asp:DropDownList>
		</td>
	</tr>
	<tr>
		<td>
			<span class="label_span">Segment</span>
		</td>
		<td>
			<asp:DropDownList ID="ddlSegments" runat="server" style="padding:3px;">
			</asp:DropDownList>
			<asp:RequiredFieldValidator ID="rfvSegments" runat="server" 
				ErrorMessage="Please select a segment" ControlToValidate="ddlSegments">*</asp:RequiredFieldValidator>
		</td>
		<td>
			<asp:Button ID="btnAddSegment" runat="server" Text="Add Segment" OnClick="btnAddSegment_Click"
				CssClass="common_text_button" />
		</td>
	</tr>
</table>
<br />
<asp:GridView ID="gvSegments" runat="server" AutoGenerateColumns="False" OnRowCommand="gvSegments_RowCommand"
	OnRowDataBound="gvSegments_RowDataBound" CssClass="common_data_grid">
	<Columns>
		<asp:TemplateField HeaderText="Segment">
			<ItemTemplate>
				<asp:Literal ID="ltlName" runat="server"></asp:Literal>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Site">
			<ItemTemplate>
				<asp:Literal ID="ltlSite" runat="server"></asp:Literal>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Type">
			<ItemTemplate>
				<asp:Literal ID="ltlType" runat="server"></asp:Literal>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Action">
			<ItemTemplate>
				<asp:LinkButton ID="lbtnDelete" CommandName="DeleteSegment" runat="server" CausesValidation="false">
				Delete</asp:LinkButton>
			</ItemTemplate>
		</asp:TemplateField>
	</Columns>
	<EmptyDataTemplate>
		No Segments found.
	</EmptyDataTemplate>
</asp:GridView>
</div>

