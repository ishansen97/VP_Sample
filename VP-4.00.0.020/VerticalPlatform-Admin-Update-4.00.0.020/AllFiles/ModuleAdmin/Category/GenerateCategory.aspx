<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="GenerateCategory.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Category.GenerateCategory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>Generate Categories</h3>
		</div>
		<div class="AdminPanelContent">
			<div class="form-horizontal">
				<div class="control-group">
					<label class="control-label">Search Category</label>
					<div class="controls">
						<asp:DropDownList ID="searchCategoryList" runat="server" Width="250" AutoPostBack="True" onselectedindexchanged="searchCategoryList_SelectedIndexChanged" />
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Fixed Guided Browse</label>
					<div class="controls">
						<asp:DropDownList ID="fixedGuidedBrowseList" runat="server" Width="250" AutoPostBack="True" onselectedindexchanged="fixedGuidedBrowseList_SelectedIndexChanged" />
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Fixed Guided Browse Permutation</label>
					<div class="controls">
						<asp:DropDownList ID="fixedGuidedBrowsePermutation" runat="server" Width="250" />
					</div>
				</div>
				<div class="form-actions">
					<asp:Button ID="generate" runat="server" Text="Generate" OnClick="generate_Click" CssClass="btn" />
				</div>
			</div>
		</div>
	</div>
</asp:Content>
