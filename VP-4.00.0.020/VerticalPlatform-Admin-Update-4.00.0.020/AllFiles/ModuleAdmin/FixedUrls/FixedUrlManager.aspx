<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="FixedUrlManager.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.FixedUrls.FixedUrlManager"
	Title="Fixed URL Manager" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">

	<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>

	<script src="../../Js/JQuery/jquery.pager.js" type="text/javascript"></script>

	<script src="../../Js/ContentPicker.js" type="text/javascript"></script>

	<script type="text/javascript">
		$(document).ready(function(){
			var element = $("#<%=ddlContentType.ClientID %>");
			var options = { siteId: VP.SiteId, currentPage: "1", pageSize: "10", getFixUrl: "false", displaySites: true, externalType: "true", typeElement: element };
			$("input[type=text][id*=txtContentId]").contentPicker(options);
		});
	</script>

<div class="inline-form-container">
    <span class="title">Content Type</span>
    <asp:DropDownList ID="ddlContentType" runat="server" Width="130px"></asp:DropDownList>
    <span class="title right">Content ID</span>
    <asp:TextBox ID="txtContentId" runat="server"></asp:TextBox>
    <asp:Button ID="btnRetrieve" runat="server" Text="Retrieve" OnClick="btnRetrieve_Click" CssClass="btn" />
</div>

	<br />
	<asp:GridView ID="gvFixedUrl" runat="server" AutoGenerateColumns="false" OnRowDataBound="gvFixedUrl_RowDataBound"
		CssClass="common_data_grid table table-bordered" style="width:auto;">
		<Columns>
			<asp:BoundField HeaderText="ID" DataField="Id" />
			<asp:BoundField HeaderText="URL" DataField="Url" />
			<asp:TemplateField HeaderText="Page Name">
				<ItemTemplate>
					<asp:Label ID="lblPageName" runat="server"></asp:Label>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:BoundField HeaderText="Query String" DataField="QueryString" />
			<asp:TemplateField ItemStyle-Width="50px">
				<ItemTemplate>
					<asp:HyperLink ID="lnkEdit" runat="server" CssClass="aDialog grid_icon_link edit" ToolTip="Edit">Edit</asp:HyperLink>
					<asp:HyperLink ID="lnkSettings" runat="server" CssClass="aDialog grid_icon_link settings" ToolTip="Settings">Settings</asp:HyperLink>
				</ItemTemplate>
			</asp:TemplateField>
		</Columns>
	</asp:GridView>
</asp:Content>
