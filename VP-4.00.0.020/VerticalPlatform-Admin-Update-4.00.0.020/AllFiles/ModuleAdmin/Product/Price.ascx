<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Price.ascx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Product.Price" %>
<script src="../../Js/Location.js" type="text/javascript"></script>
<!--<script language="javascript" type="text/javascript">
	$(document).ready(function () {
		if ($('#PopupControl_chkInheritFromVendorBucket').is(":checked")) {
			$("#PopupControl_dvLocation").hide();
			$("#PopupControl_dvPriceGroups").show();
		}
		else {
			$("#PopupControl_dvPriceGroups").hide();
			$("#PopupControl_dvLocation").show();
		}
	});
</script>-->
<style type="text/css">
    input[type=radio],input[type=checkbox]{margin-top:0px}
</style>
<div class="price_div" style="width: 470px;">
	<div class="locations">
		<div class="header">
			<asp:Label ID="lblType" runat="server" Text="Location Type"></asp:Label>
		</div>
		<asp:CheckBox ID="chkInheritFromVendorBucket" class="chkInherit" runat="server" Text="Inherit from vendor template settings"
			OnCheckedChanged="chkInheritFromVendorBucket_CheckedChanged" AutoPostBack="True" />
		<asp:Panel ID="pnlCustom" runat="server">
			<div id="dvRegion" class="location clearfix">
				<div class="type">
					<asp:Label ID="lblRegion" runat="server" Text="Region"></asp:Label>
					<asp:RadioButton ID="rdbRegion" runat="server" GroupName="Location" Checked="true"/>
				</div>
				<div class="content region">
					<asp:DropDownList ID="ddlRegion" runat="server" AppendDataBoundItems="true">
						<asp:ListItem Text="Select" Value=""></asp:ListItem>
					</asp:DropDownList>
					<asp:CheckBox ID="chkExcludeRegion" runat="server" Text="Exclude" />
				</div>
			</div>
			<div id="dvCountry" class="location clearfix">
				<div class="type">
					<asp:Label ID="lblCountry" runat="server" Text="Country"></asp:Label>
					<asp:RadioButton ID="rdbCountry" runat="server" GroupName="Location" />
				</div>
				<div class="content country" style="display: none">
					<asp:DropDownList ID="ddlCountry" runat="server" AppendDataBoundItems="true">
						<asp:ListItem Text="Select" Value=""></asp:ListItem>
					</asp:DropDownList>
					<asp:CheckBox ID="chkExcludeCountry" runat="server" Text="Exclude" />
				</div>
			</div>
		</asp:Panel>
		<asp:Panel ID="pnlPriceGroup" runat="server">
			<div id="dvPriceGroups" class="dvPriceGroupsContent">
				<asp:Label ID="lblPriceGroups" Text="Price Groups" runat="server"></asp:Label>
				<asp:DropDownList ID="ddlPriceGroups" runat="server" AppendDataBoundItems="true">
					<asp:ListItem Text="Select" Value=""></asp:ListItem>
				</asp:DropDownList>
			</div>
		</asp:Panel>
	</div>
	<div class="add-button-container">
	<asp:Button ID="btnAddLocation" runat="server" Text="Add Location" OnClick="btnAddLocation_Click"
		CssClass="btn location_btn" />
	<asp:Button ID="btnAddPriceGroup" runat="server" Text="Add Price Group" OnClick="btnAddPriceGroup_Click"
		CssClass="btn" />
	<asp:Button ID="btnRemovePriceGroup" runat="server" Text="Remove Price Group" OnClick="btnRemovePriceGroup_Click"
		CssClass="btn location_btn" Visible="false" />
	</div>
    <asp:GridView ID="gvLocation" runat="server" AutoGenerateColumns="false" OnRowCommand="gvLocation_RowCommand"
		OnRowDataBound="gvLocation_RowDataBound" CssClass="common_data_grid table table-bordered">
		<Columns>
			<asp:BoundField HeaderText="Location Type" DataField="LocationType" />
			<asp:TemplateField HeaderText="Location">
				<ItemTemplate>
					<asp:Label ID="lblLocationName" runat="server"></asp:Label>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:BoundField HeaderText="LocationId" DataField="LocationId" />
			<asp:CheckBoxField HeaderText="Excluded" DataField="Exclude" />
			<asp:TemplateField ItemStyle-Width="30">
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
			<table>
				<tr>
					<td style="padding-right: 5px; padding-top:5px;" valign="top">
						Currency
					</td>
					<td style="padding-right: 10px;" valign="top">
						<asp:DropDownList ID="ddlCurrency" runat="server" AppendDataBoundItems="true" Width="140">
							<asp:ListItem Text="Select" Value=""></asp:ListItem>
						</asp:DropDownList>
						<asp:Label ID="lblCurrency" runat="server" Text=""></asp:Label>
					</td>
					<td style="padding-right: 5px; padding-top:5px;" valign="top">
						Price
					</td>
					<td valign="top">
						<asp:TextBox ID="txtPrice" runat="server" Width="140"></asp:TextBox>
						<asp:RegularExpressionValidator ID="revPrice" runat="server" ControlToValidate="txtPrice"
							ErrorMessage="Invalid Price." ValidationExpression="\d{1,3}(?:(?:,\d\d\d)|\d*)(?:\.\d\d)?">*</asp:RegularExpressionValidator>
					</td>
				</tr>
			</table>
		</div>
	</div>
</div>
