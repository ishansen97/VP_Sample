<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="ContentToContentList.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Content.ContentToContentList" %>

<%@ Register src="../Pager.ascx" tagname="Pager" tagprefix="uc3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">

<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>

<script src="../../Js/JQuery/jquery.pager.js" type="text/javascript"></script>

<script src="../../Js/ContentPicker.js" type="text/javascript"></script>

<script type="text/javascript">
	$(document).ready(function () {
		var contentElement = $("#<%=ddlContentType.ClientID %>");
		var associatedContentElement = $("#<%=ddlAssociatedContentType.ClientID %>");
		var contentOptions = { siteId: VP.SiteId, currentPage: "1", pageSize: "10", getFixUrl: "false", externalType: "true", typeElement: contentElement };
		var associatedContentOptions = { siteId: VP.SiteId, currentPage: "1", pageSize: "10", getFixUrl: "false", externalType: "true", typeElement: associatedContentElement, displaySites: true, siteElementId: "hdnAssociatedSiteId" };

		$("input[type=text][id*=txtContentId]").contentPicker(contentOptions);
		$("input[type=text][id*=txtAssociatedContentId]").contentPicker(associatedContentOptions);
	});
	</script>
<div class="AdminPanelHeader">
		<h3>
			Association List</h3>
	</div>
<div class="form-horizontal">
    <div class="control-group">
        <label class="control-label">Content Type</label>
        <div class="controls">
            <asp:DropDownList ID="ddlContentType" AutoPostBack="True" OnSelectedIndexChanged="ddlContentType_SelectedIndexChanged" runat="server">
				</asp:DropDownList>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">Associated Content Type</label>
        <div class="controls">
            <asp:DropDownList ID="ddlAssociatedContentType" runat="server"
					AutoPostBack="True"> 
				</asp:DropDownList>
        </div>
    </div>
    <div class="control-group">
        <label class="control-label">
            Content ID
        </label>
        <div class="controls">
            <asp:TextBox ID="txtContentId" runat="server"></asp:TextBox>
        </div>
    </div>
	<div class="control-group">
        <label class="control-label">
            Associated Content ID
        </label>
        <div class="controls">
            <asp:TextBox ID="txtAssociatedContentId" runat="server"></asp:TextBox>
			<asp:HiddenField ID="hdnAssociatedSiteId" runat="server" />
        </div>
    </div>
    <div class="form-actions">
        <asp:Button ID="btnRetrive" runat="server" Text="Retrieve" OnClick="btnRetrive_Click"
					CssClass="btn" />
        <a href="ContentToContentManagement.aspx" class="btn">Associate</a> 
    </div>
</div>


	<asp:GridView ID="gvContentToContent" runat="server" OnRowDataBound="gvContentToContent_RowDataBound"
		AutoGenerateColumns="false" CssClass="common_data_grid table table-bordered" OnRowCommand="gvContentToContent_RowCommand">
		<Columns>
			<asp:BoundField HeaderText="Content Id" DataField="ContentId" />
			<asp:BoundField HeaderText="Content Type" DataField="ContentType" />
			<asp:TemplateField HeaderText="Content Name">
				<ItemTemplate>
					<asp:Label ID="lblContentName" runat="server"></asp:Label>
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
			<asp:TemplateField HeaderText="Featured Level" Visible = "false">
				<ItemTemplate>
					<asp:CheckBoxList ID="chklFeaturedSettings" runat="server" RepeatDirection="Vertical"
						CssClass="check_box_table">
						<asp:ListItem Value="1">Level 1</asp:ListItem>
						<asp:ListItem Value="2">Level 2</asp:ListItem>
						<asp:ListItem Value="3">Level 3</asp:ListItem>
						</asp:CheckBoxList>
					</ItemTemplate>
			</asp:TemplateField>
            <asp:BoundField HeaderText="Sort Order" DataField="SortOrder" />
			<asp:BoundField HeaderText="Enabled" DataField="Enabled" />
			<asp:TemplateField HeaderText="Settings">
				<ItemTemplate>
					<asp:HyperLink ID="lnkSetting" CssClass="aDialog" runat="server">Setting</asp:HyperLink>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField ItemStyle-Width="50px">
				<ItemTemplate>
					<asp:HyperLink ID="lnkEdit" Text="Edit" runat="server" CssClass="grid_icon_link edit" ToolTip="Edit"></asp:HyperLink>
					<asp:LinkButton OnClientClick="return confirm('Are you sure?');" ID="lbtnDelete"
						runat="server" Text="Delete" CommandName="DeleteContentToContent" CssClass="grid_icon_link delete" ToolTip="Delete"></asp:LinkButton>
				</ItemTemplate>
			</asp:TemplateField>
		</Columns>
	</asp:GridView>
	<uc3:Pager ID="pgrContentToContent" runat="server" OnPageIndexClickEvent="pgrContentToContent_PageIndexClick" />
	<asp:Label ID="lblInformation" runat="server"></asp:Label>
</asp:Content>
