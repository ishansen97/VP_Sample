<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ArticleTypeParameters.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Articles.ArticleTypeParameters" %>

<script language="javascript" type="text/javascript">
	$(document).ready(function() {
		var txtProductId = {contentId:"txtFixedProducts"};
		var productNameOptions = {siteId: VP.SiteId, type: "Product", currentPage: "1", pageSize: "15", showName: "true", bindings: txtProductId};
		$("input[type=text][id*=txtFixedProducts]").contentPicker(productNameOptions);
	});
	
	function EableDisableOrder(checkbox, txtOrder) {
		document.getElementById(txtOrder).disabled = !document.getElementById(checkbox).checked;

		if (document.getElementById(txtOrder).disabled) {
			document.getElementById(txtOrder).value = "0";
		}
	}
</script>

<table border="0" cellpadding="0" cellspacing="0" id="tblArticleTypeParameters" runat="server">
	<tr>
		<td style="width: 260px;">
			Article Comments Enabled
		</td>
		<td style="width: 100px">
			<asp:CheckBox ID="chkArticleCommentsEnabled" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Require User Registration to Comment on Article
		</td>
		<td>
			<asp:CheckBox ID="chkRegistrationRequiredToComment" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Allow to Add Comments From the Same Page
		</td>
		<td>
			<asp:CheckBox ID="chkArticleCommentsAddInline" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Display Article Comments on Same Page
		</td>
		<td>
			<asp:CheckBox ID="chkArticleCommentsInline" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Enable Article Rating
		</td>
		<td>
			<asp:CheckBox ID="chkArticleRatingEnabled" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Require User Registration to Rate an Article
		</td>
		<td>
			<asp:CheckBox ID="chkRegistrationRequiredToRate" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Enable Article Short Title
		</td>
		<td>
			<asp:CheckBox ID="chkArticleShortTitleEnabled" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Enable Article Tools
		</td>
		<td>
			<asp:CheckBox ID="chkArticleToolsEnabled" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Display Date Published
		</td>
		<td>
			<asp:CheckBox ID="chkDisplayDatePublished" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Display Synopsis
		</td>
		<td>
			<asp:CheckBox ID="chkSynopsis" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Enable Auto Playing Video Articles</td>
		<td>
			<asp:CheckBox ID="enableAutoPlayingVideoArticlesCheckBox" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Enable NoFollow in Text Resource</td>
		<td>
			<asp:CheckBox ID="enableNoFollowInTextResource" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			&nbsp;</td>
		<td>
			&nbsp;</td>
	</tr>
	<tr>
		<td>
			URL Prefix</td>
		<td>
			<asp:TextBox ID="txtUrlPrefix" runat="server" Width="236px"></asp:TextBox>
		</td>
	</tr>
	<tr>
		<td>
			&nbsp;
		</td>
		<td>
			&nbsp;
			<asp:RegularExpressionValidator ID="revURLPrefix" runat="server" 
				ControlToValidate="txtUrlPrefix" 
				ErrorMessage="Url should start with '/', end with '/' and should only contain alpha numeric characters ,'-'. example '/id-article-name/'"
				ValidationExpression="^((?:\/[a-zA-Z0-9]+(?:_[a-zA-Z0-9]+)*(?:\-[a-zA-Z0-9]+)*)+)/$">*</asp:RegularExpressionValidator>
		</td>
	</tr>
	<tr>
		<td valign="top">
			Article Type Custom Properties</td>
		<td>
			<div style="width:300px;">
				<asp:CheckBoxList ID="chklCustomProperties" runat="server">
				</asp:CheckBoxList>
			</div>
			<br />
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<table border="0">
				<tr>
					<td  width="260">
						Author Display Settings
					</td>
					<td>
						<asp:DropDownList ID="ddlAuthorDisplaySetting" runat="server" Width="144px" Height="30px">
						</asp:DropDownList>
						<asp:Button ID="btnAddDisplaySettings" runat="server" OnClick="btnAddDisplaySettings_Click"
							Text="Add" CssClass="common_text_button" />
					</td>
				</tr>
				<tr>
					<td  width="260">
						&nbsp;
					</td>
					<td>
						<asp:ListBox ID="lstAuthorDisplaySetting" runat="server" Width="247px"></asp:ListBox>
					</td>
				</tr>
				<tr>
					<td  width="260">
						&nbsp;
					</td>
					<td><br />
						<asp:Button ID="btnMoveUp" runat="server" OnClick="btnMoveUp_Click" Text="Move Up" CssClass="common_text_button" />
						<asp:Button ID="btnMoveDown" runat="server" Text="Move Down" OnClick="btnMoveDown_Click" CssClass="common_text_button" />
						<asp:Button ID="btnRemove" runat="server" OnClick="btnRemove_Click" Text="Remove" CssClass="common_text_button" />
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<table border="0">
				<tr>
					<td width="260">
						Products Associated to fixed Article Type
					</td>
					<td>
						<asp:TextBox ID="txtFixedProducts" runat="server"></asp:TextBox>
						<asp:Button ID="btnAddFixedProduct" runat="server" Text="Add" 
							CssClass="common_text_button" onclick="btnAddFixedProduct_Click" />
					</td>
				</tr>
				<tr>
					<td  width="260">
						&nbsp;
					</td>
					<td>
						<asp:ListBox ID="lstFixedProducts" runat="server" Width="247px"></asp:ListBox>
					</td>
				</tr>
				<tr>
					<td width="260">
						&nbsp;
					</td>
					<td><br />
						<asp:Button ID="btnFixedProductUp" runat="server" Text="Move Up" 
							CssClass="common_text_button" onclick="btnFixedProductUp_Click" />
						<asp:Button ID="btnFixedProductDown" runat="server" Text="Move Down" 
							CssClass="common_text_button" onclick="btnFixedProductDown_Click" />
						<asp:Button ID="btnFixedProductRemove" runat="server" Text="Remove" 
							CssClass="common_text_button" onclick="btnFixedProductRemove_Click" />
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="2">
			&nbsp;
		</td>
	</tr>
	<tr>
		<td>
			Article Caption</td>
		<td>
			<asp:TextBox ID="articleCaptionText" runat="server" Width="236px"></asp:TextBox>
		</td>
	</tr>
    <tr>
		<td colspan="2">
			&nbsp;
		</td>
	</tr>
	<tr>
		<td colspan="2">
			&nbsp;
		</td>
	</tr>
	<tr>
		<td>
			Enable Click Through Tracking</td>
		<td>
			<asp:CheckBox ID="enabledClickThroughsCheckBox" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			&nbsp;
		</td>
	</tr>
	<tr>
		<td>
			Clickthrough Type for Article Detail
		</td>
		<td>
			<asp:DropDownList ID="clickthroughTypesDropDown" runat="server" Width="200px" Height="30px" AppendDataBoundItems="true">
				<asp:ListItem Text="- None - " Value="0" Selected="True"></asp:ListItem>
			</asp:DropDownList>
		</td>
	</tr>
	<tr>
		<td colspan="2">
			&nbsp;
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<asp:HiddenField ID="hdnArticleTypeId" runat="server" />
		</td>
	</tr>
	<tr>
	<td></td>
		<td>
			<br />
			<asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" CssClass="common_text_button" Visible="False" />
		</td>
	</tr>
</table>
