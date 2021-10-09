<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ProductUrl.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Product.ProductUrl" %>

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
			<asp:DropDownList ID="ddlCountry" runat="server" AppendDataBoundItems="true">
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
<asp:Button ID="btnAddLocation" runat="server" Text="Add Location" OnClick="btnAddLocation_Click"
	CssClass="common_text_button location_btn" />
<asp:GridView ID="gvLocation" runat="server" AutoGenerateColumns="false" OnRowCommand="gvLocation_RowCommand"
	OnRowDataBound="gvLocation_RowDataBound" CssClass="common_data_grid">
	<Columns>
		<asp:BoundField HeaderText="Location Type" DataField="LocationType" />
		<asp:TemplateField HeaderText="Location">
			<ItemTemplate>
				<asp:Label ID="lblLocationName" runat="server"></asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:BoundField HeaderText="LocationId" DataField="LocationId" />
		<asp:CheckBoxField HeaderText="Excluded" DataField="Exclude" />
		<asp:TemplateField>
			<ItemTemplate>
				<asp:LinkButton ID="lbtnDelete" runat="server" CommandName="DeleteLocation" CssClass="deleteLocation grid_icon_link delete"
					OnClientClick="return confirm('Are you sure to delete the location?');" ToolTip="Delete">Delete</asp:LinkButton>
			</ItemTemplate>
		</asp:TemplateField>
	</Columns>
	<EmptyDataTemplate>
		No locations defined.
	</EmptyDataTemplate>
</asp:GridView>
<br />
<div class="locations">
	<div class="location clearfix">
		Url Display Text&nbsp;
		<asp:TextBox ID="txtUrlDisplayText" runat="server"></asp:TextBox>
		Url&nbsp;<asp:TextBox ID="txtUrl" runat="server"></asp:TextBox>
		<asp:RegularExpressionValidator ID="revUrl" runat="server" ControlToValidate="txtUrl"
			ErrorMessage="Invalid Url." ValidationExpression="http(s)?://([\w-]+\.)+[\w-]+([\w\-\.,@?^=%&amp; :/~\+#\(\)]*[\w\-\@?^=%&amp; /~\+#\(\)])?">*</asp:RegularExpressionValidator>
	</div>
</div>
