<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="ReviewTypeList.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.ReviewType.ReviewTypeList" %>
<%@ Register Src="../Pager.ascx" TagName="Pager" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
	<script type="text/javascript">
			RegisterNamespace("VP.ReviewList");

			VP.ReviewList.View = function (reviewTypeIdKey, reviewTypeId, emailTypeKey, emailType) {
				var viewWindow = window.open('ReviewEmailTemplateView.aspx?' + reviewTypeIdKey + '=' + reviewTypeId + '&' + emailTypeKey + 
					'=' + emailType, 'View Template', 'location=0,status=1,scrollbars=1,width=700,height=600,toolbar=0,menubar=0,resizable=1');
				if (viewWindow) {
					viewWindow.focus();
				}
			};
	</script>
	<div class="AdminPanelHeader">
		<h3>Review Type List</h3>
	</div>
	<div class="add-button-container"><asp:HyperLink ID="addReviewTypeHyperLink" runat="server" CssClass="aDialog btn">Add Review Type</asp:HyperLink></div>
		<asp:GridView ID="gvReviewType" runat="server" AutoGenerateColumns="False"
			Width="100%" OnRowCommand="gvReviewType_RowCommand" OnRowDataBound="gvReviewType_RowDataBound"
			CssClass="common_data_grid table table-bordered">
			<AlternatingRowStyle CssClass="DataTableRowAlternate" />
			<RowStyle CssClass="DataTableRow" />
			<Columns>
				<asp:TemplateField HeaderText="Id">
					<ItemTemplate>
						<asp:Label ID="reviewTypeIdLabel" runat="server"></asp:Label>
					</ItemTemplate>
					<ItemStyle HorizontalAlign="Left" Width="25px" />
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Name">
					<ItemTemplate>
						<asp:Label ID="nameLabel" runat="server"></asp:Label>
					</ItemTemplate>
					<ItemStyle HorizontalAlign="Left" Width="150px" />
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Title">
					<ItemTemplate>
						<asp:Label ID="titleLabel" runat="server"></asp:Label>
					</ItemTemplate>
					<ItemStyle HorizontalAlign="Left" Width="150px" />
				</asp:TemplateField>
					<asp:TemplateField HeaderText="Description">
					<ItemTemplate>
						<asp:Label ID="descriptionLabel" runat="server"></asp:Label>
					</ItemTemplate>
					<ItemStyle HorizontalAlign="Left" Width="150px" />
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Article Type">
					<ItemTemplate>
						<asp:Label ID="articleTypeLabel" runat="server"></asp:Label>
					</ItemTemplate>
					<ItemStyle HorizontalAlign="Left" Width="150px" />
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Article Template">
					<ItemTemplate>
						<asp:Label ID="articleTemplateName" runat="server"></asp:Label>
					</ItemTemplate>
					<ItemStyle HorizontalAlign="Left" Width="150px" />
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Sort Order">
					<ItemTemplate>
						<asp:Label ID="sortOrder" runat="server"></asp:Label>
					</ItemTemplate>
					<ItemStyle HorizontalAlign="Left" Width="40px" />
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Enabled">
					<ItemTemplate>
						<asp:CheckBox ID="enabledCheckBox" runat="server" Enabled="false"></asp:CheckBox>
					</ItemTemplate>
					<ItemStyle HorizontalAlign="Left" Width="25px" />
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Email Templates">
					<ItemTemplate>
						<table>
							<tr>
								<td>
									Review Confirmation Email<br />
									<asp:LinkButton ID="viewConfirmationTemplate" Text="" runat="server" 
										CommandName="viewConfirmation" CssClass="grid_icon_link preview" ToolTip="Preview"></asp:LinkButton>
									<asp:HyperLink ID="editConfirmationTemplate" runat="server" Text="" ToolTip="Edit" 
										CssClass="grid_icon_link edit"></asp:HyperLink>
								</td>
							</tr>
							<tr>
								<td>
									Review Published Email<br />
									<asp:LinkButton ID="viewPublishedTemplate" Text="" runat="server" CommandName="viewPublished"
										CssClass="grid_icon_link preview" ToolTip="Preview"></asp:LinkButton>
									<asp:HyperLink ID="editPublishedTemplate" runat="server" Text="" ToolTip="Edit" 
										CssClass="grid_icon_link edit"></asp:HyperLink>
								</td>
							</tr>
						</table>
					</ItemTemplate>
					<ItemStyle HorizontalAlign="Left" Width="25px" />
				</asp:TemplateField>
				<asp:TemplateField ShowHeader="False" ItemStyle-Width="50px">
						<ItemTemplate>
							<asp:HyperLink ID="designFormHyperLink" runat="server" CssClass="grid_icon_link form" 
								ToolTip="Design Form">Design&nbsp;Form</asp:HyperLink>
							<asp:HyperLink ID="editReviewTypeHyperLink" runat="server" CssClass="aDialog grid_icon_link edit"
								ToolTip="Edit">Edit</asp:HyperLink>
							<asp:HyperLink ID="cloneFormHyperLink" runat="server" CssClass="aDialog grid_icon_link duplicate" 
								ToolTip="Copy Form">Clone</asp:HyperLink>
						</ItemTemplate>
					</asp:TemplateField>
			</Columns>
			<EmptyDataTemplate>
				No Review Types found.</EmptyDataTemplate>
		</asp:GridView>
		<br />
		<uc1:Pager ID="reviewTypePager" runat="server" />
		<br />
		<br />
</asp:Content>
