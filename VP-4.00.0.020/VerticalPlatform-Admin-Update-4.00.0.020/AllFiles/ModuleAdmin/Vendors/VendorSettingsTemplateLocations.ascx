<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="VendorSettingsTemplateLocations.ascx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Vendors.VendorSettingsTemplateLocations" %>
<script src="../../Js/Location.js" type="text/javascript"></script>

<div class="locations">
	<div class="header">
		Location Type</div>
	<div class="location clearfix">
		<div class="type">
			Region
			<asp:RadioButton ID="rdbRegion" runat="server" GroupName="Location" Checked="true" />
		</div>
		<div class="content region">
			<asp:DropDownList ID="ddlRegion" runat="server" AppendDataBoundItems="true">
				<asp:ListItem Text="Select" Value=""></asp:ListItem>
			</asp:DropDownList>
			Exclude
			<asp:CheckBox ID="chkExcludeRegion" runat="server" /></div>
	</div>
	<div class="location clearfix">
		<div class="type">
			Country
			<asp:RadioButton ID="rdbCountry" runat="server" GroupName="Location" />
		</div>
		<div class="content country" style="display: none">
			<asp:DropDownList ID="ddlCountry" runat="server" AppendDataBoundItems="true" Width="265">
				<asp:ListItem Text="Select" Value=""></asp:ListItem>
			</asp:DropDownList>
			Exclude
			<asp:CheckBox ID="chkExcludeCountry" runat="server" /></div>
	</div>
	<div style="display: none;">
		<asp:RadioButton ID="rdbState" runat="server" GroupName="Location" />
		<asp:DropDownList ID="ddlStateCountry" runat="server">
		</asp:DropDownList>
		<asp:CheckBox ID="chkExcludeState" runat="server" />
	</div>
</div>
<asp:Button ID="btnAddLocation" runat="server" Text="Add Location" CssClass="common_text_button location_btn"
	OnClick="btnAddLocation_Click" /><asp:HiddenField ID="hdnAddLocation" runat="server"
		Value="false" />
<br />
<br />
<asp:GridView ID="gvLocation" runat="server" AutoGenerateColumns="false" CssClass="common_data_grid"
	OnRowCommand="gvLocation_RowCommand" OnRowDataBound="gvLocation_RowDataBound" style="width:auto">
	<Columns>
		<asp:BoundField HeaderText="Location Type" DataField="LocationType" />
		<asp:TemplateField HeaderText="Location">
			<ItemTemplate>
				<asp:Label ID="lblLocationName" runat="server"></asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:BoundField HeaderText="Location Id" DataField="LocationId" />
		<asp:CheckBoxField HeaderText="Excluded" DataField="Exclude" />
		<asp:TemplateField ItemStyle-Width="30">
			<ItemTemplate>
				<asp:LinkButton ID="lbtnDelete" runat="server" CommandName="DeleteLocation" CssClass="deleteLocation grid_icon_link delete" ToolTip="Delete"
					OnClientClick="return confirm('Are you sure to delete the location?');">Delete</asp:LinkButton>
			</ItemTemplate>
		</asp:TemplateField>
	</Columns>
	<EmptyDataTemplate>
		No locations defined.
	</EmptyDataTemplate>
</asp:GridView>
<br />
