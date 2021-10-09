<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AssociationControl.ascx.cs"
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Category.AssociationControl" %>
<%@ Register src="../Pager.ascx" tagname="Pager" tagprefix="uc3" %>
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
            <asp:DropDownList ID="ddlAssociatedContentType" runat="server">
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
			<asp:RequiredFieldValidator ID="sortOrderValidator" runat="server" ErrorMessage="Please a value for sort order."
				ControlToValidate="sortOrderInput" ValidationGroup="AssociateContent">*</asp:RequiredFieldValidator>
        </div>
    </div>
    <div class="control-group">
        <div class="controls">
            <asp:Button ID="btnAssociate" runat="server" Text="Associate" CssClass="btn"
				OnClick="btnAssociate_Click" ValidationGroup="AssociateContent" />
        </div>
    </div>
</div>

<br />
<asp:GridView ID="gvAssociation" runat="server" AutoGenerateColumns="False" CssClass="common_data_grid table table-bordered"
	OnRowCommand="gvAssociation_RowCommand" OnRowDataBound="gvAssociation_RowDataBound">
	<Columns>
		<asp:TemplateField HeaderText="Associated Content Type">
			<ItemTemplate>
				<asp:Label ID="lblAssociatedContentType" runat="server"></asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Associated Content Id">
			<ItemTemplate>
				<asp:Label ID="lblAssociatedContentId" runat="server"></asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Associated Site Id">
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
		<asp:BoundField HeaderText="Sort Order" DataField="SortOrder" />		
		<asp:TemplateField>
			<ItemTemplate>
				<asp:LinkButton ID="editButton" runat="server" Text="Edit" CommandName="EditAssociation" CssClass="grid_icon_link edit" ToolTip="Edit"></asp:LinkButton>
				<asp:LinkButton OnClientClick="return confirm('Are you sure you want to remove this association?');"
					ID="lbtnRemove" runat="server" Text="Remove" CommandName="RemoveAssociation" CssClass="grid_icon_link delete" ToolTip="Delete"></asp:LinkButton>
			</ItemTemplate>
		</asp:TemplateField>
	</Columns>
	<PagerStyle CssClass="content_grid_pager" />
	<EmptyDataTemplate>
		No associations were found.</EmptyDataTemplate>
</asp:GridView>
<uc3:Pager ID="pgrContentToContent" runat="server" OnPageIndexClickEvent="pgrContentToContent_PageIndexClick" />
