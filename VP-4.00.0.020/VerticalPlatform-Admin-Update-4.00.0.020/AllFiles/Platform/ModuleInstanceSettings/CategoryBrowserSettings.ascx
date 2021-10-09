<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CategoryBrowserSettings.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.CategoryBrowserSettings" %>
<script type="text/javascript">
	$(document).ready(function () {
		RegisterNamespace("VP.CategoryBrowser");
		var categoryFilterOptions = { siteId: VP.SiteId, type: "Category", currentPage: "1", pageSize: "6" };
		$("input[type=text][id*=categoryId]").contentPicker(categoryFilterOptions);

		$(".categoryList").click(function () {
			$(".displayName").val($(".categoryList option:selected").text());
		});
	});
</script>
<div>
	<ul>
		<li class="common_form_row clearfix">
			<div class="common_form_row_lable">
				Category
			</div>
			<div class="common_form_row_data">
				<div class="CategoryList">
					<asp:TextBox ID="categoryIdTextbox" runat="server" MaxLength = "7"></asp:TextBox>
				</div>
				<asp:Button ID="addCategory" runat="server" Text="Add" OnClick="addCategory_Click"
						CausesValidation="false" CssClass="common_text_button" />
				<div class="common_form_row_div clearfix" style="clear:both">
					<asp:ListBox ID="categoryList" class="categoryList" runat="server" Width="250px"></asp:ListBox>
				</div>
				<div class="common_form_row_div clearfix">
					<asp:Button ID="removeCategory" runat="server" OnClick="removeCategory_Click"
						Text="Remove" CssClass="common_text_button" />
					<asp:Button ID="up" runat="server" OnClick="up_Click" Text="Move Up" CssClass="common_text_button" />
					<asp:Button ID="down" runat="server" OnClick="down_Click" Text="Move Down"
						CssClass="common_text_button" />
					<asp:HiddenField ID="hdnCategoryList" runat="server" />
				</div>
			</div>
		</li>
		<li class="common_form_row clearfix">
			<div class="common_form_row_lable">
				Category Display Name
			</div>
			<div class="common_form_row_data">
				<div class="categoryDisplayName">
					<asp:TextBox ID="displayName" class= "displayName" runat="server"></asp:TextBox>
					<asp:Button ID="update" runat="server" Text="Update" OnClick="update_Click" CssClass="common_text_button"/>
				</div>
			</div>
		</li>
	</ul>
</div>