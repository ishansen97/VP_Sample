<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="RandomizeProductsForArticlesSettings.ascx.cs" 
Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.RandomizeProductsForArticlesSettings" %>

<script type="text/javascript">
		$(document).ready(function() {
			var txtProductId = {contentId:"txtFixedProducts"};
			var productNameOptions = {siteId: VP.SiteId, type: "Product", currentPage: "1", pageSize: "15", showName: "true", bindings: txtProductId};
			$("input[type=text][id*=txtFixedProducts]").contentPicker(productNameOptions);
		});
	</script>

<ul class="common_form_area">
	<li class="common_form_row clearfix">
		<div class="common_form_row_lable">
			Number of Display Slots</div>
		<div class="common_form_row_data">
			<asp:HiddenField ID="hdnDisplaySlots" runat="server" />
			<asp:TextBox ID="txtDisplaySlots" runat="server" />
			<asp:CompareValidator ID="cpvDisplaySlots" runat="server" Operator="DataTypeCheck"
			Type="Integer" ControlToValidate="txtDisplaySlots" ErrorMessage="Please enter an integer for 'Display Slots'."> * </asp:CompareValidator>
		</div>
	</li>
	
	<li class="common_form_row clearfix group_row">
		<div class="common_form_row_lable">
			Product List Display Settings
		</div>
		<div class="common_form_row_data">
			<asp:DropDownList ID="ddlProductListDisplaySetting" runat="server" Height="20px"
				Width="144px">
			</asp:DropDownList>
			<asp:Button ID="btnAddDisplaySettings" runat="server" OnClick="btnAddDisplaySettings_Click"
				Text="Add" CssClass="common_text_button" CausesValidation="False" />
			<div class="common_form_row_div clearfix">
				<asp:ListBox ID="lstProductListDisplaySetting" runat="server" Width="247px"></asp:ListBox>
			</div>
			<div class="common_form_row_div clearfix">
				<asp:Button ID="btnMoveUp" runat="server" OnClick="btnMoveUp_Click" Text="Move Up"
					CssClass="common_text_button" CausesValidation="False" />
				<asp:Button ID="btnMoveDown" runat="server" Text="Move Down" OnClick="btnMoveDown_Click"
					CssClass="common_text_button" CausesValidation="False" />
				<asp:Button ID="btnRemove" runat="server" OnClick="btnRemove_Click" Text="Remove"
					CssClass="common_text_button" CausesValidation="False" />
				<asp:HiddenField ID="hdnProductDisplaySettingsValue" runat="server" />
			</div>
		</div>
	</li>
	
	<li class="common_form_row clearfix group_row">
		<div class="common_form_row_lable">
			Fixed Product Listing
		</div>
		<div class="common_form_row_data">
		 <div class="FixedProductList">
			<asp:TextBox ID="txtFixedProducts" runat="server"></asp:TextBox>
		</div>
			<asp:Button ID="btnAddProduct" runat="server" Text="Add" 
				CausesValidation="false" CssClass="common_text_button" onclick="btnAddProduct_Click" />
			<div class="common_form_row_div clearfix">
				<asp:ListBox ID="lstFixedProducts" runat="server" Height="70px" Width="220px"></asp:ListBox>
			</div>
			<div class="common_form_row_div clearfix">
				<asp:Button ID="btnRemoveProduct" runat="server" Text="Remove" 
					CssClass="common_text_button" onclick="btnRemoveProduct_Click" />
				<asp:Button ID="btnUp" runat="server" OnClick="btnUp_Click" Text="Move Up" CssClass="common_text_button"  />
				<asp:Button ID="btnDown" runat="server" OnClick="btnDown_Click" Text="Move Down" CssClass="common_text_button"  />
				<asp:HiddenField ID="hdnFixedProductListing" runat="server" />
			</div>
		</div>
	</li>
	
	<%--<li class="common_form_row clearfix" style="padding-top: 10px;">
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
			<asp:DropDownList ID="ddlCssClasses" runat="server"
				AutoPostBack="true">
			</asp:DropDownList>
			<asp:HiddenField ID="hdnCssClasses" runat="server" />
		</div>
	</li>--%>
	
	<li class="common_form_row clearfix" style="padding-top: 10px;">
		<div class="common_form_row_lable">
			Number of Associated Product Slots
		</div>
		<div class="common_form_row_data">
			<asp:TextBox ID="txtAssociatedProductSlots" runat="server" MaxLength="100" Width="220px" />
			<asp:HiddenField ID="hdnAssociatedProductSlots" runat="server" />
			<asp:CompareValidator ID="cpvAssociatedProductSlots" runat="server" Operator="DataTypeCheck"
				Type="Integer" ControlToValidate="txtAssociatedProductSlots" 
				ErrorMessage="Please enter an integer for 'Number of Associated Product Slots'."> * </asp:CompareValidator>
		</div>
	</li>
	<li class="common_form_row clearfix" style="padding-top: 10px;">
		<div class="common_form_row_lable">
			Product Thumbnail Size
		</div>
		<div class="common_form_row_data">
			<asp:DropDownList ID="ddlThumbnailSize" runat="server"></asp:DropDownList>
			<asp:HiddenField ID="hdnThumbnailSize" runat="server" />
		</div>
	</li>
	
	<li class="common_form_row clearfix"><span class="label_span" style="width: 170px;">
		Redirect Product Links to</span>
		<asp:RadioButton ID="rdoProductDetails" runat="server" Text="Product Details Page"
			GroupName="RedirectionPage" Checked="true" />
		<asp:RadioButton ID="rdoLeadForm" runat="server" Text="Lead Form" GroupName="RedirectionPage" />
		<asp:HiddenField ID="hdnRedirectionPageSettingId" runat="server" />
	</li>
	<li class="common_form_row clearfix"><span class="label_span" style="width: 170px;">
		Product Description Length</span>
		<asp:TextBox ID="txtDescriptionLength" runat="server" />
		<asp:HiddenField ID="hdnDescriptionLength" runat="server" />
		<asp:CompareValidator ID="cpvDescriptionLength" runat="server" Operator="DataTypeCheck"
			Type="Integer" ControlToValidate="txtDescriptionLength" ErrorMessage="Please enter an integer for 'Product description length'."> * </asp:CompareValidator>
	</li>
</ul>
