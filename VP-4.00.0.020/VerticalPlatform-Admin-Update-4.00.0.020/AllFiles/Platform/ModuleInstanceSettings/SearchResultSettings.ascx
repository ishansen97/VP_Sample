<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SearchResultSettings.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.SearchResultSettings" %>
<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>
<script src="../../Js/ContentPicker.js" type="text/javascript"></script>

<script language="javascript" type="text/javascript">
	RegisterNamespace("VP.ElasticSearchResult");
	$(document).ready(function () {
		RegisterNamespace("VP.ArticleList");
		var articleTypeFilterOptions = { siteId: VP.SiteId, type: "Article Type", currentPage: "1", pageSize: "15", displaySites: true };
		$("input[type=text][id*=txtArticleTypeFilter]").contentPicker(articleTypeFilterOptions);
	});
</script>

<table>
	<tr>
		<td>
			Search Header Link Text
		</td>
		<td>
			<asp:TextBox ID="searchHeaderLinkText" runat="server"></asp:TextBox>
			<asp:HiddenField ID="searchHeaderLinkTextHidden" runat="server" />
			<asp:RequiredFieldValidator ID="searchHeaderLinkTextValidator" runat="server" ErrorMessage="Please provide a link text." 
					ControlToValidate="searchHeaderLinkText">*</asp:RequiredFieldValidator>
		</td>
	</tr>
	<tr>
		<td>
			Content Type
		</td>
		<td>
			<asp:DropDownList ID="ddlContentType" runat="server" 
				AppendDataBoundItems="True" AutoPostBack="true" 
				onselectedindexchanged="ddlContentType_SelectedIndexChanged" Width="210">
				<asp:ListItem Text="--Select--" Value=""></asp:ListItem>
			</asp:DropDownList>
			<asp:RequiredFieldValidator ID="rfvContentType" runat="server" ErrorMessage="*" ControlToValidate="ddlContentType"></asp:RequiredFieldValidator>
			<asp:HiddenField ID="hdnContentType" runat="server" />
		</td>
	</tr>
	<tr>
		<td>
			Number of Results to Retrieve from Database
		</td>
		<td>
			<asp:TextBox ID="txtDatabaseResults" runat="server"></asp:TextBox>
			<asp:HiddenField ID="hdnDatabaseResults" runat="server" />
			<asp:CompareValidator ID="cpvDatabaseResults" runat="server" ErrorMessage="Numbers only" ControlToValidate="txtDatabaseResults"
			Type="Integer" Operator="DataTypeCheck" SetFocusOnError="True"
			></asp:CompareValidator>
		</td>
	</tr>
	<tr>
		<td>
			Number of Results to show in Module
		</td>
		<td>
			<asp:TextBox ID="txtModuleResults" runat="server"></asp:TextBox>
			<asp:HiddenField ID="hdnModuleResults" runat="server" />
			<asp:CompareValidator ID="cpvModuleResults" runat="server" ErrorMessage="Numbers only" ControlToValidate="txtModuleResults"
			Type="Integer" Operator="DataTypeCheck" SetFocusOnError="True"
			></asp:CompareValidator>
		</td>
	</tr>
	<tr>
		<td>
			<asp:Literal ID="ltlGroupByType" runat="server" Text="Group By Article Type" ></asp:Literal>
		</td>
		<td>
			<asp:CheckBox ID="chkGroupByType" runat="server" />
			<asp:HiddenField ID="hdnGroupByType" runat="server" />
		</td>
	</tr>
	<tr>
		<td valign="top">
			<asp:Literal ID="ltlArticleType" runat="server" Text="Enabled Article Types" ></asp:Literal>
		</td>
		<td>
			<div>
				<asp:TextBox ID="txtArticleTypeFilter" runat="server" Style="width: 154px" />
				<asp:Button ID="btnAddArticleType" runat="server" Text="Add" OnClick="btnAddArticleType_Click"
					CausesValidation="false" CssClass="common_text_button" Width="40px" />
			</div>
			<div style="padding-top:4px" >
				<asp:ListBox ID="lstArticleType" runat="server" Width="210px" Height="70px">
				</asp:ListBox>
				<asp:HiddenField ID="hdnArticleType" runat="server" />&nbsp;
						
				<div class="common_form_row_div clearfix">
					<asp:Button ID="btnMoveUp" runat="server" OnClick="btnMoveUp_Click" Text="Move Up"
						CssClass="common_text_button" CausesValidation="False" Width="60" />
					<asp:Button ID="btnMoveDown" runat="server" Text="Move Down" OnClick="btnMoveDown_Click"
						CssClass="common_text_button" CausesValidation="False" Width="85" />
					<asp:Button ID="btnRemoveArticleType" Text="Remove" runat="server" OnClick="btnRemoveArticleType_Click"
					CssClass="common_text_button" CausesValidation="False" Width="60" />
				</div>
			</div>
		</td>
	</tr>
</table>
