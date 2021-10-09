<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ProductListSettings.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.ProductListSettings" %>

<script type="text/javascript">
	$(document).ready(function() {
		var options = { siteId: VP.SiteId, type: "Product", currentPage: "1", pageSize: "10" };
		$("input[type=text][id*=txtFeaturedProducts]").contentPicker(options);

		options = { siteId: VP.SiteId, type: "Category", currentPage: "1", pageSize: "10", categoryType:"Leaf" };
		$("input[type=text][id*=txtCategory]").contentPicker(options);
	});
</script>

<div style="padding-left:20px;">
<div class="GroupItems" runat="server" style="margin-bottom: 10px;" id="divMode" >
	<ul class="common_form_area">
		<li class="common_form_row clearfix"><span class="label_span" style="width: 170px;">
			Filtering Mode</span>
			<asp:DropDownList runat="server" ID="ddlFilteringMode" AutoPostBack="True" 
				onselectedindexchanged="ddlFilteringMode_SelectedIndexChanged">
			</asp:DropDownList>
			<span class="label_span" style="width: 170px;">
				<asp:HiddenField ID="hdnFilteringMode" runat="server" />
			</span>
		</li>
	</ul>
</div>
<div class="GroupItems" runat="server" id="divAutomaticFiltering" style="margin-bottom: 10px;">
	<ul class="common_form_area">
		<li class="common_form_row clearfix"><span class="label_span" style="width: 170px;">
			Automatic Filtering</span>
			<asp:CheckBoxList runat="server" ID="chklstAutomaticFilter" RepeatDirection="Horizontal">
			</asp:CheckBoxList>
			<asp:HiddenField ID="hdnAutomaticFilter" runat="server" />
		</li>
	</ul>
</div>

<div class="GroupItems" runat="server" id="divManualFiltering"  visible="false">
	<ul class="common_form_area">
		<li class="common_form_row clearfix"><span class="label_span" style="width: 170px;">
			Display Focus Products</span>
			<asp:CheckBox ID="chkDisplayFeaturedProducts" runat="server" OnCheckedChanged="chkDisplayFeaturedProducts_CheckedChanged"
				AutoPostBack="True" />
			<asp:HiddenField ID="hdnDisplayFeaturedProducts" runat="server" />
		</li>
		<li class="common_form_row clearfix">
			<div class="GroupItems" runat="server" id="divFeaturedProducts" style="margin-bottom: 10px;"
				visible="false">
				<table border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td style="width: 170px;">
							Focus Products to Display
						</td>
						<td>
							<asp:TextBox ID="txtFeaturedProducts" runat="server"></asp:TextBox>
							<asp:Button ID="btnAddFeaturedProducts" runat="server" Text="Add" CssClass="btn"
								EnableTheming="True" OnClick="btnAddFeaturedProducts_Click" />
						</td>
					</tr>
					<tr>
						<td class="style5">
							&nbsp;
						</td>
						<td style="padding-top: 5px;">
							<asp:ListBox ID="lstFeaturedProducts" runat="server" Width="247px"></asp:ListBox>
							<asp:HiddenField ID="hdnFeaturedProducts" runat="server" />
						</td>
					</tr>
					<tr>
						<td class="style5">
							&nbsp;
						</td>
						<td style="padding-top: 5px;">
							<asp:Button ID="btnFeaturedMoveUp" runat="server" Text="Move Up" CssClass="btn"
								OnClick="btnFeaturedMoveUp_Click" />
							<asp:Button ID="btnFeaturedMoveDown" runat="server" Text="Move Down" CssClass="btn"
								OnClick="btnFeaturedMoveDown_Click" />
							<asp:Button ID="btnFeaturedRemove" runat="server" Text="Remove" CssClass="btn"
								OnClick="btnFeaturedRemove_Click" />
						</td>
					</tr>
				</table>
			</div>
		</li>
		<li class="common_form_row clearfix">
		<div class="GroupItems" runat="server" id="divFilterCategories">
			<table border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td style="width: 170px;">
						Filter Categories
					</td>
					<td><div class="inline-form-container">
						<asp:TextBox runat="server" ID="txtCategory" Width="175"></asp:TextBox>
						<asp:Button runat="server" ID="btnAddCategory" Text="Add" OnClick="btnAddCategory_Click"
							CssClass="btn" />
                        </div>
					</td>
				</tr>
				<tr>
					<td class="style5">
						&nbsp;
					</td>
					<td style="padding-top: 5px;">
						<asp:ListBox ID="lstCategories" runat="server" Width="247px"></asp:ListBox>
						<asp:HiddenField ID="hdnCategories" runat="server" />
					</td>
				</tr>
				<tr>
					<td class="style5">
						&nbsp;
					</td>
					<td style="padding-top: 5px;">
						<asp:Button runat="server" ID="btnRemoveCategory" Text="Remove" OnClick="btnRemoveCategory_Click"
							CssClass="btn" />
					</td>
				</tr>
			</table>
			<ul class="common_form_area" style="margin-top:10px;">
				<li class="common_form_row clearfix"><span class="label_span" style="width: 170px;">
				Filter Rank</span>
				<asp:CheckBoxList runat="server" ID="chklstRank" RepeatDirection="Horizontal">
				</asp:CheckBoxList>
				<asp:HiddenField ID="hdnRank" runat="server" />
				</li>
			</ul>
			</div>
		</li>
	</ul>
</div>

<div class="GroupItems" runat="server" id="divPaging">
	<ul  class="common_form_area">
		<li class="common_form_row clearfix">
			<span class="label_span" style="width: 170px;">
				Enable Paging
			</span>
			<asp:CheckBox runat="server" ID="chkEnablePaging">
			</asp:CheckBox>
			<asp:HiddenField ID="hdnEnablePaging" runat="server" />
		</li>
		<li class="common_form_row clearfix"><span class="label_span" style="width: 170px;">
			Page Size</span>
			<asp:TextBox ID="txtPageSize" runat="server" />
			<asp:HiddenField ID="hdnPagingSize" runat="server" />
			<asp:CompareValidator ID="cpvPagingSize" runat="server" Operator="DataTypeCheck"
				Type="Integer" ControlToValidate="txtPageSize" ErrorMessage="Please enter an integer for 'Page size'."> * </asp:CompareValidator>
		</li>
	</ul>
</div>

<div class="GroupItems" runat="server" id="divSubhomes" style="margin-bottom: 10px;">
	<ul class="common_form_area">
		<li class="common_form_row clearfix"><span class="label_span" style="width: 170px;">
			Enable Subhome Filtering</span>
			<asp:CheckBox runat="server" ID="chkSubHomeFilter" />
			<asp:HiddenField ID="hdnSubHomeFilter" runat="server" />
		</li>
		<li class="common_form_row clearfix"><span class="label_span" style="width: 170px;">
			Display Title with Subhome Name</span>
			<asp:CheckBox runat="server" ID="chkSubhomeTitle">
			</asp:CheckBox>
			<asp:HiddenField ID="hdnSubhomeTitle" runat="server" />
		</li>
		<li class="common_form_row clearfix"><span class="label_span" style="width: 170px;">
			Default Title Prefix</span>
			<asp:TextBox ID="txtDefaultTitlePrefix" runat="server" Width="220px"></asp:TextBox>
			<asp:HiddenField ID="hdnDefaultTitlePrefix" runat="server" />
		</li>
	</ul>
</div>

<div class="GroupItems" runat="server" id="divSettings" style="margin-bottom: 10px;">
	<table border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td style="width: 170px;">
				Product Listing Display Settings
			</td>
			<td>
				<asp:DropDownList ID="ddlProductListSetting" runat="server" Width="144px">
				</asp:DropDownList>
				<asp:Button ID="btnAddProductListSetting" runat="server" Text="Add" CssClass="btn"
					EnableTheming="True" OnClick="btnAddProductListSetting_Click" />
			</td>
		</tr>
		<tr>
			<td class="style5">
				&nbsp;
			</td>
			<td style="padding-top: 5px;">
				<asp:ListBox ID="lstProductListDisplaySetting" runat="server" Width="247px"></asp:ListBox>
				<asp:HiddenField ID="hdnProductListDisplaySettings" runat="server" />
			</td>
		</tr>
		<tr>
			<td class="style5">
				&nbsp;
			</td>
			<td style="padding-top: 5px;">
				<asp:Button ID="btnMoveUp" runat="server" Text="Move Up" CssClass="btn"
					OnClick="btnMoveUp_Click" />
				<asp:Button ID="btnMoveDown" runat="server" Text="Move Down" CssClass="btn"
					OnClick="btnMoveDown_Click" />
				<asp:Button ID="btnRemove" runat="server" Text="Remove" CssClass="btn"
					OnClick="btnRemove_Click" />
			</td>
		</tr>
	</table>
	<br />
	<ul class="common_form_area">
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
		<li class="common_form_row clearfix"><span class="label_span" style="width: 170px;">
			Image Size</span>
			<asp:DropDownList runat="server" ID="ddlThumbnailSize">
			</asp:DropDownList>
			<asp:HiddenField ID="hdnThumbnailSize" runat="server" />
		</li>
	</ul>
</div>
</div>
<div class="GroupItems well" runat="server" id="divSorting" style="margin-bottom: 10px;">
	<table border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td style="width: 170px;">
				Sorting Parameters
			</td>
			<td>
				<asp:DropDownList ID="ddlProductSorting" runat="server">
				</asp:DropDownList>
				<asp:HiddenField ID="hdnSortParameter" runat="server" />
			</td>
		</tr>
		<tr>
			<td style="width: 170px;"></td>
			<td></td>
		</tr>
		<tr>
			<td style="width: 170px;padding-top: 3px">
				Max Number of Products
			</td>
			<td>
				<asp:TextBox ID="maxNumberOfProducts" runat="server"></asp:TextBox>
				<asp:HiddenField ID="hiddenFieldMaxProducts" runat="server" />
				<asp:CompareValidator ID="cpvMaxProducts" runat="server" ErrorMessage="Please enter a numeric value greater than zero for 'Max number of products'."
					ControlToValidate="maxNumberOfProducts" Type="Integer" Operator="DataTypeCheck" SetFocusOnError="True">*</asp:CompareValidator>
			</td>
		</tr>
	</table>
</div>
