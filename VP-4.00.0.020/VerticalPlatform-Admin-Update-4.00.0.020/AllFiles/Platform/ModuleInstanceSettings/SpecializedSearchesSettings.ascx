<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SpecializedSearchesSettings.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.SpecializedSearchesSettings" %>

<script src="../../Js/JQuery/jquery.pager.js" type="text/javascript"></script>

<script src="../../Js/ContentPicker.js" type="text/javascript"></script>

<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>

<script type="text/javascript">
		$(document).ready(function(){
				var categoryNameElement = { contentName: "txtDisplayName" };
				var categoryIdOptions = { siteId: VP.SiteId, type: "Category", currentPage: "1",
						 pageSize: "15", bindings: categoryNameElement };
				$("input[type=text][id*=txtSearchCategoryId]").contentPicker(categoryIdOptions);
		});
</script>

<div>
	<table>
		<tr>
			<td>
				Category
			</td>
			<td>
				<asp:TextBox ID="txtSearchCategoryId" runat="server" Width="240"></asp:TextBox>
			</td>
		</tr>
				<tr>
			<td>
				Display Name
			</td>
			<td>
				<asp:TextBox ID="txtDisplayName" runat="server" Width="200"></asp:TextBox>
				<asp:Button ID="btnAddSearchCategory" runat="server" Text="Add" CssClass="common_text_button"
					EnableTheming="true" OnClick="btnAddSearchCategory_Click" Width="37" />
			</td>
		</tr>
		<tr>
			<td>
			</td>
			<td>
				<asp:ListBox ID="lstSearchCategories" runat="server" Width="250"></asp:ListBox>
				<asp:HiddenField ID="hdnSearchCategories" runat="server" />
			</td>
		</tr>
		<tr>
			<td>
			</td>
			<td>
				<asp:Button ID="btnCategoryMoveUp" runat="server" Text="Move Up" CssClass="common_text_button"
					OnClick="btnCategoryMoveUp_Click" />
				<asp:Button ID="btnCategoryMoveDown" runat="server" Text="Move Down" CssClass="common_text_button"
					OnClick="btnCategoryMoveDown_Click" />
				<asp:Button ID="btnCategoryRemove" runat="server" Text="Remove" CssClass="common_text_button"
					OnClick="btnCategoryRemove_Click" />
			</td>
		</tr>
		<tr>
			<td>
				Description
			</td>
			<td>
				<asp:TextBox ID="txtSearchCategoryDescription" Columns="30" Rows="4" MaxLength="800" 
					runat="server" TextMode="MultiLine" Width="240"></asp:TextBox>
				<asp:HiddenField ID="hdnSearchCategoryDescription" runat="server" />
			</td>
		</tr>
	</table>
</div>
