<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SpecificationControl.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Vendors.SpecificationControl" %>

<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>

<script src="../../Js/JQuery/jquery.pager.js" type="text/javascript"></script>

<script src="../../Js/ContentPicker.js" type="text/javascript"></script>

<script language="javascript" type="text/javascript">
	$(document).ready(function() {
		var options = { siteId: VP.SiteId, type: "SpecificationType", currentPage: "1", pageSize: "15",
			showName: "true", bindings: { contentid: "txtSpecificationTypeId"}
		};
		$("input[type=text][id$=txtSpecificationType]").contentPicker(options);
		$(".icon_link_column a").each(function(){
			$text = $(this).text();
			$(this).addClass($text);
		});
	});
</script>

<div class="form-horizontal">
	<div class="control-group">
		<label class="control-label">Specification Type</label>
		<div class="controls">
			<asp:TextBox ID="txtSpecificationType" runat="server"></asp:TextBox>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">Specification Type Id</label>
		<div class="controls">
			<asp:TextBox ID="txtSpecificationTypeId" runat="server"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvSpecificationTypeId" runat="server" ErrorMessage="Please enter specification type id. "
				ControlToValidate="txtSpecificationTypeId" ValidationGroup="AddSpecification">*</asp:RequiredFieldValidator>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">Specification</label>
		<div class="controls">
			<asp:TextBox ID="txtSpecification" runat="server" TextMode="MultiLine" Width="300px"
				Height="50px"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvSpecification" runat="server" ErrorMessage="Please enter specification value."
				ControlToValidate="txtSpecification" ValidationGroup="AddSpecification">*</asp:RequiredFieldValidator>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label"><asp:Literal ID="ltlDisplayOptions" runat="server" Text="Display Options"></asp:Literal></label>
		<div class="controls">
			<label class="checkbox-inline"><asp:CheckBox ID="chkShowInVerticalMatrix" Text="Vertical Matrix" runat="server" Checked="true" /></label>
			<label class="checkbox-inline"><asp:CheckBox ID="chkShowInServiceDetail" Text="Service Detail" runat="server" Checked="true"/></label>
			<label class="checkbox-inline"><asp:CheckBox ID="showInVendorDetailSpec" Text="Vendor Detail Specification" runat="server" Checked="true"/></label>
		</div>
	</div>
	<div class="control-group">
		<div class="controls">
			<asp:Button ID="btnAddSpecification" runat="server" Text="Add Specification" OnClick="btnAddSpecification_Click"
				CssClass="btn" ValidationGroup="AddSpecification" />
		</div>
	</div>
</div>

<br />
<asp:GridView ID="gvSpecification" runat="server" AutoGenerateColumns="False" CssClass="common_data_grid table table-bordered"
	OnRowCommand="gvSpecification_RowCommand" OnRowDataBound="gvSpecification_RowDataBound"
	OnRowCancelingEdit="gvSpecification_RowCancelingEdit" OnRowEditing="gvSpecification_RowEditing"
	OnRowUpdating="gvSpecification_RowUpdating" style="width:auto;">
	<Columns>
		<asp:TemplateField HeaderText="Specification Type" ItemStyle-Width="200">
			<ItemTemplate>
				<asp:Label ID="lblSpecificationTypeName" runat="server"></asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Specificatition">
			<ItemTemplate>
				<asp:Label ID="lblSpecification" runat="server" Text='<%# Bind("SpecificationValue") %>'></asp:Label>
			</ItemTemplate>
			<EditItemTemplate>
				<asp:TextBox ID="txtVendorSpecification" runat="server" Text='<%# Bind("SpecificationValue") %>'
					TextMode="MultiLine" Width="300px" Height="50px">
				</asp:TextBox>
				<asp:RequiredFieldValidator ID="rfvVendorSpecification" runat="server" ErrorMessage="Please enter specification value."
					ControlToValidate="txtVendorSpecification" ValidationGroup="EditSpecification"
					Display="Dynamic">*</asp:RequiredFieldValidator>
			</EditItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Display Options" ItemStyle-Width="280">
			<ItemTemplate>
				<asp:CheckBox ID="chkShowInVerticalMatrix" runat="server" Text="Vertical Matrix"
					Checked="false" Enabled="false" />
				<asp:CheckBox ID="chkShowInServiceDetail" runat="server" Text="Service Detail" Checked="false"
					Enabled="false" />
				<asp:CheckBox ID="showInVendorDetail" runat="server" Text="Vendor Detail" Checked="false"
					Enabled="false" />
			</ItemTemplate>
			<EditItemTemplate>
				<asp:CheckBox ID="chkShowInVerticalMatrix" runat="server" Text="Vertical Matrix" />
				<asp:CheckBox ID="chkShowInServiceDetail" runat="server" Text="Service Detail" />
				<asp:CheckBox ID="showInVendorDetail" runat="server" Text="Vendor Detail" />
			</EditItemTemplate>
		</asp:TemplateField>
		<asp:CommandField ShowEditButton="True" ValidationGroup="EditSpecification" ItemStyle-CssClass="icon_link_column" ControlStyle-CssClass="grid_icon_link" />
		<asp:TemplateField ItemStyle-width="20">
			<ItemTemplate>
				<asp:LinkButton ID="lbtnRemove" runat="server" CommandName="RemoveSpecification" CausesValidation="false"
					OnClientClick="return confirm(&quot;Are you sure you want to delete this vendor specification &quot;);"
					Text="Delete" CssClass="grid_icon_link delete" ToolTip="Delete">
				</asp:LinkButton>
			</ItemTemplate>
		</asp:TemplateField>
	</Columns>
</asp:GridView>
