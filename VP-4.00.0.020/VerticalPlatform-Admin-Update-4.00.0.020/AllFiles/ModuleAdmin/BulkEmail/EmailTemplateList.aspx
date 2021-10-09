<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EmailTemplateList.aspx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.BulkEmail.EmailTemplateList" MasterPageFile="~/MasterPage.Master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
	<script type="text/javascript">
		RegisterNamespace("VP.EmailTemplate");

		VP.EmailTemplate.View = function(emailTemplateId, emailTemplateIdKey) {
			var viewWindow = window.open('EmailTemplateView.aspx?' + emailTemplateIdKey + '=' + emailTemplateId,
					'View', 'location=0,status=1,scrollbars=1,width=700,height=600,toolbar=0,menubar=0,resizable=1');
			if (viewWindow) {
				viewWindow.focus();
			}
		};
	</script>
	
	<div class="AdminPanelHeader">
		<h3>
			Email Template List</h3>
	</div>
	<div class="AdminPanelContent">
		<div class="add-button-container"><asp:HyperLink ID="lnkAddTemplate" runat="server" CssClass="aDialog btn">Add Email Template</asp:HyperLink></div>
		
		<asp:GridView ID="gvEmailTemplate" runat="server" CssClass="common_data_grid table table-bordered" AutoGenerateColumns="False"
			OnRowDataBound="gvEmailTemplate_RowDataBound" 
			onrowcommand="gvEmailTemplate_RowCommand" AllowSorting="True" 
			onsorting="gvEmailTemplate_Sorting" >
			<AlternatingRowStyle CssClass="DataTableRowAlternate" />
			<RowStyle CssClass="DataTableRow" />
			<Columns>
				<asp:TemplateField HeaderText="ID" SortExpression="id">
					<ItemTemplate>
						<asp:Literal ID="ltlId" runat="server" Text="test"></asp:Literal>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Template Name" SortExpression="name">
					<ItemTemplate>
						<asp:Literal ID="ltlTemplateName" runat="server"></asp:Literal>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Enabled">
					<ItemTemplate>
						<asp:CheckBox ID="chkEnabled" runat="server" Enabled="false" />
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Template HTML">
					<ItemTemplate>
						<asp:LinkButton ID="lbtnView" Text="" runat="server" CommandName="templateView"
								CssClass="grid_icon_link preview" ToolTip="Preview"></asp:LinkButton>
						<asp:HyperLink ID="lnkEdit" runat="server" Text="" ToolTip="Edit" CssClass="aDialog grid_icon_link edit_content"></asp:HyperLink>
					</ItemTemplate>
				</asp:TemplateField>
				
				<asp:TemplateField HeaderText="Content Panes">
					<ItemTemplate>
						<asp:HyperLink ID="lnkPanes" runat="server" Text="Edit" CssClass="aDialog grid_icon_link edit_content" ToolTip="Edit"></asp:HyperLink>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Template Clone">
					<ItemTemplate>
						<asp:LinkButton ID="lbtnClone" runat="server"
							CommandName="CloneTemplate" Text="" CssClass="grid_icon_link duplicate" ToolTip="Clone"></asp:LinkButton>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Created"  SortExpression="created">
					<ItemTemplate>
						<asp:Literal ID="ltlCreated" runat="server"></asp:Literal>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Last Modified"  SortExpression="modified">
					<ItemTemplate>
						<asp:Literal ID="ltlModified" runat="server"></asp:Literal>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField>
					<ItemTemplate>
						<asp:LinkButton ID="lbtnDelete" runat="server" CommandName="DeleteTemplate" CssClass="grid_icon_link delete" ToolTip="Delete">Delete</asp:LinkButton>
					</ItemTemplate>
				</asp:TemplateField>
			</Columns>
			<EmptyDataTemplate>No Email Templates found.</EmptyDataTemplate>
		</asp:GridView>
	</div>
</asp:Content>
