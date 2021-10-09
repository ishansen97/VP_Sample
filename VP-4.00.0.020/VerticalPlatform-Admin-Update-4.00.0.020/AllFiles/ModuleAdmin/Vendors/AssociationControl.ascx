<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AssociationControl.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Vendors.AssociationControl" %>

<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>

<script src="../../Js/JQuery/jquery.pager.js" type="text/javascript"></script>

<script src="../../Js/ContentPicker.js" type="text/javascript"></script>

<script type="text/javascript">
		$(document).ready(function() {
			var element = $("#<%=ddlAssociatedContentType.ClientID %>");
			var options = { siteId: VP.SiteId, currentPage: "1", pageSize: "10", getFixUrl: "false", externalType: "true",
					typeElement: element, displaySites: true, siteElementId: "hdnAssociatedSiteId" };
			$("input[type=text][id*=txtAssociatedContentId]").contentPicker(options);
		});
</script>

<div class="form-horizontal">
	<div class="control-group">
		<label class="control-label">Content Type</label>
		<div class="controls">
			<asp:DropDownList ID="ddlAssociatedContentType" runat="server" AutoPostBack="true"
				onselectedindexchanged="ddlAssociatedContentType_SelectedIndexChanged">
			</asp:DropDownList>
			<asp:RequiredFieldValidator ID="rfvAssociatedContentType" runat="server" ErrorMessage="Please select a content type. "
				ControlToValidate="ddlAssociatedContentType" ValidationGroup="AssociateContent">*</asp:RequiredFieldValidator>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">Content Id</label>
		<div class="controls">
			<asp:TextBox runat="server" ID="txtAssociatedContentId"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvAssociatedContentId" runat="server" ErrorMessage="Please enter contect id."
				ControlToValidate="txtAssociatedContentId" ValidationGroup="AssociateContent">*</asp:RequiredFieldValidator>
		</div>
	</div>
	 <div class="control-group">
		<label class="control-label">Sort Order</label>
		<div class="controls">
			<asp:TextBox runat="server" ID="sortOrderInput"></asp:TextBox>
			<asp:RequiredFieldValidator ID="sortOrderValidator" runat="server" ErrorMessage="Please enter sort order."
				ControlToValidate="sortOrderInput" ValidationGroup="AssociateContent">*</asp:RequiredFieldValidator>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label"><asp:Label ID="lblAssociateAllProducts" runat="server" Text="Associate All Products"></asp:Label></label>
		<div class="controls">
			<asp:CheckBox Id="chkAssociateAllProducts" runat="server" Checked="false"/>
		</div>
	</div>
	<div class="control-group">
		<div class="controls">
			<asp:Button ID="btnAssociate" runat="server" Text="Associate" CssClass="btn" OnClick="btnAssociate_Click" ValidationGroup="AssociateContent" />
		</div>
	</div>
</div>
<br />
<asp:GridView ID="gvAssociation" runat="server" AutoGenerateColumns="False" CssClass="common_data_grid table table-bordered"
	OnRowCommand="gvAssociation_RowCommand" OnRowDataBound="gvAssociation_RowDataBound">
	<Columns>
		<asp:TemplateField HeaderText="Associated Content Type">
			<ItemTemplate>
				<asp:Label ID="lblContentType" runat="server"></asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Associated Content Id">
			<ItemTemplate>
				<asp:Label ID="lblContentId" runat="server"></asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Associate Site Id">
			<ItemTemplate>
				<asp:Label ID="lblSiteId" runat="server"></asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Associated Site Name">
			<ItemTemplate>
				<asp:Label ID="lblSiteName" runat="server"></asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Associated Content Name">
			<ItemTemplate>
				<asp:Label ID="lblAssociatedContentName" runat="server"></asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Sort Order">
			<ItemTemplate>
				<asp:Label ID="sortOrderLabel" runat="server"></asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField>
			<ItemTemplate>
				<asp:LinkButton ID="editButton" runat="server" CommandName="EditAssociation" Text="Edit" CssClass="grid_icon_link edit" ToolTip="Edit"></asp:LinkButton>
				<asp:LinkButton ID="lbtnRemove" runat="server" CommandName="RemoveAssociation" 
					OnClientClick="return confirm('Are you sure you want to remove this association?');" 
					Text="Remove" CssClass="grid_icon_link delete" ToolTip="Remove"></asp:LinkButton>
			</ItemTemplate>
		</asp:TemplateField>
	</Columns>
	<EmptyDataTemplate>
		No associations were found.</EmptyDataTemplate>
</asp:GridView>
