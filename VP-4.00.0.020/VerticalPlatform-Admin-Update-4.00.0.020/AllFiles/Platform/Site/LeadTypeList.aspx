<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="LeadTypeList.aspx.cs" Inherits="VerticalPlatformAdminWeb.Platform.Site.LeadTypeList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
	<script type="text/javascript">
		RegisterNamespace("VP.LeadTypeList");

		VP.LeadTypeList.View = function (leadFormIdKey, leadFormId) {
			var viewWindow = window.open('LeadEmailTemplateView.aspx?' + leadFormIdKey + '=' + leadFormId, 
				'View Template', 'location=0,status=1,scrollbars=1,width=700,height=600,toolbar=0,menubar=0,resizable=1');
			if (viewWindow) {
				viewWindow.focus();
			}
		};
	</script>
	<br />
	<div class="add-button-container"><asp:HyperLink ID="lnkAddLeadType" runat="server" CssClass="aDialog btn">Add lead type</asp:HyperLink></div>
	<h4><asp:Label ID="lblTitle" runat="server"></asp:Label></h4>
	<asp:GridView ID="gvLeadTypes" runat="server" AutoGenerateColumns="False" OnRowDataBound="gvLeadTypes_RowDataBound"
		OnRowCommand="gvLeadTypes_RowCommand" CssClass="common_data_grid table table-bordered" AlternatingRowStyle-CssClass="GridAltItem">
		<Columns>
			<asp:BoundField DataField="Id" HeaderText="ID" ItemStyle-Width="75px">
			</asp:BoundField>
			<asp:BoundField DataField="Name" HeaderText="Lead Name" ItemStyle-Width="200px">
			</asp:BoundField>
			<asp:BoundField DataField="Title" HeaderText="Lead Title" ItemStyle-Width="200px">
			</asp:BoundField>
			<asp:TemplateField ItemStyle-Width="100px" HeaderText="Add Field">
				<ItemTemplate>
					<asp:HyperLink ID="lnkField" runat="server">Fields</asp:HyperLink>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField ItemStyle-Width="75px" HeaderText="Lead Form">
				<ItemTemplate>
					<asp:HyperLink ID="lnkDesign" runat="server">Design</asp:HyperLink>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField HeaderText="Import" ItemStyle-Width="75px">
				<ItemTemplate>
					<asp:LinkButton ID="lnkImport" runat="server">Import</asp:LinkButton>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField HeaderText="View" ItemStyle-Width="75px">
				<ItemTemplate>
					<asp:HyperLink ID="lnkView" runat="server">View</asp:HyperLink>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField ItemStyle-Width="75px" HeaderText="Logged&nbsp;In&nbsp;Lead&nbsp;Form">
				<ItemTemplate>
					<asp:HyperLink ID="lnkDesignForLoggedUsers" runat="server">Design</asp:HyperLink>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField HeaderText="Import" ItemStyle-Width="75px">
				<ItemTemplate>
					<asp:LinkButton ID="lnkImportForLoggedUsers" runat="server">Import</asp:LinkButton>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField HeaderText="View" ItemStyle-Width="75px">
				<ItemTemplate>
					<asp:HyperLink ID="lnkViewForLoggedUsers" runat="server">View</asp:HyperLink>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:BoundField DataField="AlternateLinkText" HeaderText="Alternative Link Text"  ItemStyle-Width="200px"/>
			<asp:TemplateField HeaderText="Confirmation E-Mail Template">
				<ItemTemplate>
					<asp:LinkButton ID="viewConfirmationTemplate" Text="" runat="server" 
						CommandName="viewConfirmation" CssClass="grid_icon_link preview" ToolTip="Preview"></asp:LinkButton>
					<asp:HyperLink ID="editConfirmationTemplate" runat="server" Text="" ToolTip="Edit" 
						CssClass="grid_icon_link edit"></asp:HyperLink>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField ItemStyle-Width="30px" Visible="true">
				<ItemTemplate>
					<asp:HyperLink ID="lnkEditLeadType" runat="server" CommandName="EditLeadType" CssClass="aDialog grid_icon_link edit" 
						ToolTip="Edit">Edit</asp:HyperLink>
				</ItemTemplate>
			</asp:TemplateField>
		</Columns>
	</asp:GridView>
	<br />
	<br />
	<div class="add-button-container"><asp:HyperLink ID="lnkClickthroughType" runat="server" CssClass="aDialog btn">Add Clickthrough Type</asp:HyperLink></div>
	<h4><asp:Label ID="lblClickThrough" runat="server"></asp:Label></h4>
	<asp:GridView ID="gvClickthrough" runat="server" AutoGenerateColumns="False" OnRowDataBound="gvClickthrough_RowDataBound"
		OnRowCommand="gvClickthrough_RowCommand" CssClass="common_data_grid table table-bordered" AlternatingRowStyle-CssClass="GridAltItem" style="width:auto;">
		<Columns>
			<asp:BoundField DataField="Id" HeaderText="ID">
			</asp:BoundField>
			<asp:BoundField DataField="Name" HeaderText="Click Through Name">
			</asp:BoundField>
			<asp:BoundField DataField="Title" HeaderText="Click Through Title">
			</asp:BoundField>
			<asp:BoundField DataField="AlternateLinkText" HeaderText="Alternative Link Text"  ItemStyle-Width="200px"/>
			<asp:TemplateField ItemStyle-Width="30px" Visible="true">
				<ItemTemplate>
					<asp:HyperLink ID="lnkEditClickThrough" runat="server" CommandName="EditClickThroughType" CssClass="aDialog grid_icon_link edit" ToolTip="Edit">Edit</asp:HyperLink>
				</ItemTemplate>
			</asp:TemplateField>
		</Columns>
		<EmptyDataTemplate>No Clickthrough Types Defined.</EmptyDataTemplate>
	</asp:GridView>
</asp:Content>
