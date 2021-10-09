<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="RandomizeArticlesForProductsSettings.ascx.cs" 
	Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.RandomizeArticlesForProductsSettings" %>

<%@ Register src="../../Controls/PopupDialogSmartScroller.ascx" tagname="SmartScroller" tagprefix="uc2" %>

<script src="../../Js/ContentPicker.js" type="text/javascript"></script>

	<script type="text/javascript">
		$(document).ready(function() {
			var txtArticleId = { contentId: "txtFixedArticles" };
			var articleNameOptions = {siteId: VP.SiteId, type: "Article", currentPage: "1", pageSize: "15", showName: "true", bindings: txtArticleId};
			$("input[type=text][id*=txtFixedArticles]").contentPicker(articleNameOptions);
		});
	</script>
	


<ul class="common_form_area">
	<li class="common_form_row clearfix">
		<div class="common_form_row_lable">
			Number of Display Slots</div>
		<div class="common_form_row_data">
			<asp:HiddenField ID="hdnDisplaySlots" runat="server" />
			<asp:TextBox ID="txtDisplaySlots" runat="server" />
		</div>
	</li>
	
	<li class="common_form_row clearfix group_row">
		<div class="common_form_row_lable">
			Article List Display Settings
		</div>
		<div class="common_form_row_data">
			<asp:DropDownList ID="ddlArticleListDisplaySetting" runat="server" Height="20px"
				Width="144px">
			</asp:DropDownList>
			<asp:Button ID="btnAddDisplaySettings" runat="server" OnClick="btnAddDisplaySettings_Click"
				Text="Add" CssClass="common_text_button" CausesValidation="False" />
			<div class="common_form_row_div clearfix">
				<asp:ListBox ID="lstArticleListDisplaySetting" runat="server" Width="247px"></asp:ListBox>
			</div>
			<div class="common_form_row_div clearfix">
				<asp:Button ID="btnMoveUp" runat="server" OnClick="btnMoveUp_Click" Text="Move Up"
					CssClass="common_text_button" CausesValidation="False" />
				<asp:Button ID="btnMoveDown" runat="server" Text="Move Down" OnClick="btnMoveDown_Click"
					CssClass="common_text_button" CausesValidation="False" />
				<asp:Button ID="btnRemove" runat="server" OnClick="btnRemove_Click" Text="Remove"
					CssClass="common_text_button" CausesValidation="False" />
				<asp:HiddenField ID="hdnArticleDisplaySettingsValue" runat="server" />
			</div>
		</div>
	</li>
	
	<li class="common_form_row clearfix group_row">
		<div class="common_form_row_lable">
			Fixed Article Listing
		</div>
		<div class="common_form_row_data">
		 <div class="FixedArticleList">
			<asp:TextBox ID="txtFixedArticles" runat="server"></asp:TextBox>
		</div>
			<asp:Button ID="btnAddArticle" runat="server" Text="Add"
				CausesValidation="false" CssClass="common_text_button" onclick="btnAddArticle_Click" />
			<div class="common_form_row_div clearfix">
				<asp:ListBox ID="lstFixedArticles" runat="server" Height="70px" Width="220px"></asp:ListBox>
			</div>
			<div class="common_form_row_div clearfix">
				<asp:Button ID="btnRemoveArticle" runat="server"
					Text="Remove" CssClass="common_text_button" onclick="btnRemoveArticle_Click" />
				<asp:Button ID="btnUp" runat="server" OnClick="btnUp_Click" Text="Move Up" CssClass="common_text_button"  />
				<asp:Button ID="btnDown" runat="server" OnClick="btnDown_Click" Text="Move Down" CssClass="common_text_button"  />
				<asp:HiddenField ID="hdnFixedArticleListing" runat="server" />
			</div>
		</div>
	</li>
	
	<li class="common_form_row clearfix" style="padding-top: 10px;">
		<div class="common_form_row_lable">
			Enable Paging
		</div>
		<div class="common_form_row_data">
			<asp:CheckBox ID="chkEnablePaging" runat="server" />
			<asp:HiddenField ID="hdnEnablePaging" runat="server" />
		</div>
	</li>
	
	<li class="common_form_row clearfix" style="padding-top: 10px;">
		<div class="common_form_row_lable">
			CSS Class
		</div>
		<div class="common_form_row_data">
			<asp:TextBox ID="txtCssClass" runat="server"></asp:TextBox>
			<asp:DropDownList ID="ddlCssClasses" runat="server" OnSelectedIndexChanged="ddlCssClasses_SelectedIndexChanged"
				AutoPostBack="true">
			</asp:DropDownList>
			<asp:HiddenField ID="hdnCssClasses" runat="server" />
		</div>
	</li>
	
	<li class="common_form_row clearfix" style="padding-top: 10px;">
		<div class="common_form_row_lable">
			Number of Associated Article Slots
		</div>
		<div class="common_form_row_data">
			<asp:TextBox ID="txtAssociatedArticleSlots" runat="server" MaxLength="100" Width="220px" />
			<asp:HiddenField ID="hdnAssociatedArticleSlots" runat="server" />
		</div>
	</li>
	<li class="common_form_row clearfix" style="padding-top: 10px;">
		<div class="common_form_row_lable">
			Article Thumbnail Size
		</div>
		<div class="common_form_row_data">
			<asp:DropDownList ID="ddlThumbSize" runat="server">
				<asp:ListItem Text="Extra Large Image – 400 x 300" Value="1"></asp:ListItem>
				<asp:ListItem Text="Featured Image – 187 x 140" Value="2"></asp:ListItem>
				<asp:ListItem Text="Thumbnail Image – 134 x 100" Value="3"></asp:ListItem>
				<asp:ListItem Text="Micro Image – 52 x 39" Value="4"></asp:ListItem>
			</asp:DropDownList>
			<asp:HiddenField ID="hdnThumbSize" runat="server" />
		</div>
	</li>
</ul>
