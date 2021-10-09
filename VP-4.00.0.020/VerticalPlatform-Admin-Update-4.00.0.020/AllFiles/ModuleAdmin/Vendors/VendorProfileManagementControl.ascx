<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="VendorProfileManagementControl.ascx.cs" 
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Vendors.VendorProfileManagementControl" %>

<script src="../../Js/JQuery/jquery.pager.js" type="text/javascript"></script>
<script src="../../Js/ContentPicker.js" type="text/javascript"></script>
<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>

<script type="text/javascript">
	RegisterNamespace("VP.VendorProfile");

	VP.VendorProfile.Initialize = function () {
		$(document).ready(function () {
			var articleIdElement = { contentId: "vendorArticleId" };
			var articleNameElement = { contentName: "vendorArticleName" };
			var articleNameOptions = { siteId: VP.SiteId, type: "Article", currentPage: "1", pageSize: "15", showName: "true",
					bindings: articleIdElement, displayArticleTypes: true
					};

			var articleIdOptions = { siteId: VP.SiteId, type: "Article", currentPage: "1", pageSize: "15", bindings: articleNameElement,
					displayArticleTypes: true
					};

			$("input[type=text][id*=vendorArticleName]").contentPicker(articleNameOptions);
			$("input[type=text][id*=vendorArticleId]").contentPicker(articleIdOptions);
		});
	}

	VP.VendorProfile.Initialize();
</script>

<div class="vendorProfileManagement">
	<div class="vendorProfileManagementHeader">
		<h3>Vendor Profile Management</h3>
	</div>
	<div class="vendorProfileManagementContent">
		<div class="form-horizontal">
			<div class="control-group">
				<label class="control-label">Vendor Summary</label>
				<div class="controls">
					<asp:TextBox id="vendorSummaryText" runat="server" Width="400px" Height="200px" TextMode="MultiLine" 
						CssClass="vendorSummary"></asp:TextBox>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">Vendor Article</label>
				<div class="controls">
					<asp:TextBox ID="vendorArticleName" runat="server"></asp:TextBox>
					<asp:TextBox ID="vendorArticleId" runat="server"></asp:TextBox>
					<asp:Label class="control-label" style="float: none;color: red;font-size: small;" ID="articleIsArchivedLabel" runat="server"></asp:Label>
				</div>
				
			</div>
			<div class="control-group">
				<label class="control-label">Vendor Detail Display Settings</label>
				<div class="controls">
					<asp:CheckBoxList ID="vendorProfileDisplay" runat="server"></asp:CheckBoxList>
				</div>
			</div>
			<br />
			<div class="control-group">
				<h3>Top Content</h3>
			</div>
			<div class="add-button-container"><asp:HyperLink ID="lnkTopTenContentAssociate" runat="server" CssClass="aDialog btn">Add Top Content</asp:HyperLink></div>
			<asp:GridView ID="vendorTopTenGrid" runat="server" AutoGenerateColumns="False" CssClass="common_data_grid table table-bordered"
					OnRowCommand="vendorTopTenGrid_RowCommand" OnRowDataBound="vendorTopTenGrid_RowDataBound">
			<Columns>
				<asp:TemplateField HeaderText="Content Id">
					<ItemTemplate>
						<asp:Label ID="vendorTopTenContentId" runat="server"></asp:Label>
					</ItemTemplate>
				</asp:TemplateField>

				<asp:TemplateField HeaderText="Content Type">
					<ItemTemplate>
						<asp:Label ID="vendorTopTenContentType" runat="server"></asp:Label>
					</ItemTemplate>
				</asp:TemplateField>
		
				<asp:TemplateField HeaderText="Content Name">
					<ItemTemplate>
						<asp:Label ID="vendorTopTenContentName" runat="server"></asp:Label>
					</ItemTemplate>
				</asp:TemplateField>

				<asp:TemplateField HeaderText="Article Type">
					<ItemTemplate>
						<asp:Label ID="vendorTopTenArticleType" runat="server"></asp:Label>
					</ItemTemplate>
				</asp:TemplateField>

				<asp:TemplateField HeaderText="Sort Order">
					<ItemTemplate>
						<asp:Label ID="vendorTopTenSortOrder" runat="server"></asp:Label>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField>
					<ItemTemplate>
						<asp:HyperLink ID="editButtonTopContent" runat="server" CommandName="EditAssociation" Text="Edit" CssClass="grid_icon_link edit aDialog" ToolTip="Edit"></asp:HyperLink>
							<asp:LinkButton ID="removeButtonTopContent" runat="server" CommandName="RemoveAssociation" 
								OnClientClick="return confirm('Are you sure you want to remove this association?');" 
								Text="Remove" CssClass="grid_icon_link delete" ToolTip="Remove"></asp:LinkButton>
					</ItemTemplate>
				</asp:TemplateField>
			</Columns>
			<EmptyDataTemplate>
				No Top Content associations were found.</EmptyDataTemplate>
			</asp:GridView>

			<h3>Related Product Categories</h3>
			<div>
				<div class="add-button-container">
					<asp:HyperLink ID="addCategory" runat="server" CssClass="aDialog btn">Add Category</asp:HyperLink>
				</div>
			</div>
			<asp:GridView ID="categoryAssociationGrid" runat="server" AutoGenerateColumns="False" CssClass="common_data_grid table table-bordered"
				OnRowCommand="categoryAssociationGrid_RowCommand" OnRowDataBound="categoryAssociationGrid_RowDataBound">
				<Columns>
					<asp:TemplateField HeaderText="Category Id">
						<ItemTemplate>
							<asp:Label ID="categoryId" runat="server"></asp:Label>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField HeaderText="Category Name">
						<ItemTemplate>
							<asp:Label ID="categoryName" runat="server"></asp:Label>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField HeaderText="Sort Order">
						<ItemTemplate>
							<asp:Label ID="sortOrder" runat="server"></asp:Label>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField>
						<ItemTemplate>
							<asp:HyperLink ID="editButton" runat="server" CommandName="EditAssociation" Text="Edit" CssClass="grid_icon_link edit aDialog" ToolTip="Edit"></asp:HyperLink>
							<asp:LinkButton ID="removeButton" runat="server" CommandName="RemoveAssociation" 
								OnClientClick="return confirm('Are you sure you want to remove this association?');" 
								Text="Remove" CssClass="grid_icon_link delete" ToolTip="Remove"></asp:LinkButton>
						</ItemTemplate>
					</asp:TemplateField>
					</Columns>
					<EmptyDataTemplate>
						No manual categories were found.</EmptyDataTemplate>
			</asp:GridView>
	</div>
</div>
