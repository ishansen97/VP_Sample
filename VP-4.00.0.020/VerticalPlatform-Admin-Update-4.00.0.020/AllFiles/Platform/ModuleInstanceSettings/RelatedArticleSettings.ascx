<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="RelatedArticleSettings.ascx.cs" Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.RelatedArticleSettings" %>
<style type="text/css">
		.form-horizontal .control-group{margin-bottom:5px;}
	</style>
	<script src="../../Js/ContentPicker.js" type="text/javascript"></script>

<script type="text/javascript">
		$(document).ready(function() {
			var manualSearchOptions = { siteId: VP.SiteId, type: "Search Option", currentPage: "1", pageSize: "15", displaySearchGroups: true };
				
			$("input[type=text][id*=txtSearchOptionFilter]").contentPicker(manualSearchOptions);
		});
</script>

	<div class="form-horizontal">
    <div class="control-group">
			<label class="control-label" Style="margin-right: 2px">Show Published And Unpublished Articles&nbsp;</label>
			<div class="controls" >
				<asp:CheckBox ID="chkOnlyPublished" runat="server" />
				<asp:HiddenField ID="hdnOnlyPublished" runat="server" />
			</div>
		</div>
    <div class="control-group">
			<label class="control-label">Thumbnail Size&nbsp;</label>
			<div class="controls" >
				<asp:DropDownList ID="ddlThumbSize" runat="server"></asp:DropDownList>
				<asp:HiddenField ID="hdnThumbSize" runat="server" />
			</div>
		</div>
    <div class="control-group">
			<label class="control-label">Article Limit&nbsp;</label>
			<div class="controls" >
				<asp:TextBox ID="txtRelatedArticleLimit" runat="server" Style="margin-left: 0px" Width="75px"></asp:TextBox>
				<asp:HiddenField ID="hdnRelatedArticleLimit" runat="server" />
				<asp:RegularExpressionValidator ID="revRelatedArticleLimit" runat="server" ControlToValidate="txtRelatedArticleLimit"
					ErrorMessage="Limit should be a number." ValidationExpression="^[0-9]*$">*</asp:RegularExpressionValidator>
			</div>
		</div>
    <div class="control-group">
      <label class="control-label">Article Types&nbsp;</label>
			<div class="controls" >
				<asp:DropDownList ID="ddlArticleType" runat="server"></asp:DropDownList>
				<asp:Button ID="btnAddArticleType" runat="server" Text="Add" OnClick="btnAddArticleType_Click" CausesValidation="false" CssClass="common_text_button" />
				<div class="">
					<table Style="float: right;">
						<tr>
							<td>
								<asp:ListBox ID="lstArticleType" runat="server" Width="220px" Height="54px" Style="margin-right:192px;"></asp:ListBox>
							</td>
						</tr>
						<tr>
							<td>
								<asp:Button ID="btnRemoveArticleType" Text="Remove" runat="server" OnClick="btnRemoveArticleType_Click" CssClass="common_text_button" CausesValidation="False" 
									Style="margin-right:40px;"/>
							</td>
						</tr>
					</table>
				</div>
				<asp:HiddenField ID="hdnRelatedArticleTypes" runat="server" />
			</div>
		</div>
    <div class="control-group">
      <label class="control-label">Search Options&nbsp;</label>
			<div class="controls" >
				<asp:TextBox ID="txtSearchOptionFilter" runat="server" Style="width: 210px" />
				<asp:Button ID="btnAddSerachOption" runat="server" Text="Add" OnClick="btnAddSearchOption_Click" CausesValidation="false" CssClass="common_text_button" />
				<div class="">
					<table Style="float: right;">
						<tr>
							<td>
								<asp:ListBox ID="lstSearchOption" runat="server" Width="220px" Height="54px" Style="margin-right:192px;"></asp:ListBox>
							</td>
						</tr>
						<tr>
							<td>
									<asp:Button ID="btnRemoveSearchOption" Text="Remove" runat="server" OnClick="btnSearchOptionRemove_Click" CssClass="common_text_button" CausesValidation="False" 
										Style="margin-right:40px;"/>
							</td>
						</tr>
					</table>
				</div>
				<asp:HiddenField ID="hdnSearchOption" runat="server" />
			</div>
	  </div>
    <br />
    <div class="control-group">
			<label class="control-label">Show Article Synopsis&nbsp;</label>
			<div class="controls">
				<asp:CheckBox ID="chkSynopsis" runat="server" AutoPostBack ="true" OnCheckedChanged="chkSynopsis_CheckedChanged"/>
				<asp:HiddenField ID="hdnSynopsis" runat="server" />
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">Show Article Types&nbsp;</label>
			<div class="controls">
				<asp:CheckBox ID="chkArticleTypeNames" runat="server" AutoPostBack ="true" OnCheckedChanged="chkArticleTypeNames_CheckedChanged"/>
				<asp:HiddenField ID="hdnArticleTypeNames" runat="server" />
			</div>
		</div>
    <div class="control-group">
			<label class="control-label">Custom Property To Show Instead Of Article Type&nbsp;</label>
			<div class="controls" >
				<asp:DropDownList ID="ddlCustomProperty" runat="server" Enabled="false"></asp:DropDownList>
				<asp:HiddenField ID="hdnCustomProperty" runat="server" />
			</div>
		</div>
    <div class="control-group">
			<label class="control-label" ID="lblSynopsisLimit" runat="server">Synopsis Text Limit&nbsp;</label>
			<div class="controls" >
				<asp:TextBox ID="txtSynopsisLimit" runat="server" Style="margin-left: 0px" Width="75px"></asp:TextBox>
				<asp:HiddenField ID="hdnSynopsisLimit" runat="server" />
				<asp:RegularExpressionValidator ID="revSynopsisLimit" runat="server" ControlToValidate="txtSynopsisLimit"
					ErrorMessage="Synopsis limit should be a number." ValidationExpression="^[0-9]*$">*</asp:RegularExpressionValidator>
			</div>
		</div>

    <div class="control-group">
			<label class="control-label">Button Text For New User&nbsp;</label>
			<div class="controls" >
				<asp:TextBox ID="txtSubmitNewUserText" runat="server" Style="margin-left: 0px" Width="210px"></asp:TextBox>
				<asp:HiddenField ID="hdnSubmitNewUserText" runat="server" />
				<asp:RegularExpressionValidator ID="revSubmitNewUserText" runat="server" ControlToValidate="txtSubmitNewUserText"
					ErrorMessage="Only text and spaces allowed" ValidationExpression="^[a-zA-Z\s]*$">*</asp:RegularExpressionValidator>
			</div>
		</div>
    <div class="control-group">
			<label class="control-label">Button Text For Existing User&nbsp;</label>
			<div class="controls" >
				<asp:TextBox ID="txtSubmitOldUserText" runat="server" Style="margin-left: 0px" Width="210px"></asp:TextBox>
				<asp:HiddenField ID="hdnSubmitOldUserText" runat="server" />
				<asp:RegularExpressionValidator ID="revSubmitOldUserText" runat="server" ControlToValidate="txtSubmitOldUserText"
					ErrorMessage="Only text and spaces allowed" ValidationExpression="^[a-zA-Z\s]*$">*</asp:RegularExpressionValidator>
			</div>
		</div>
    <div class="control-group">
			<label class="control-label">First Page Message&nbsp;</label>
			<div class="controls" >
				<asp:TextBox ID="txtFirstPageText" runat="server" Width="400px" Height="213px" TextMode="MultiLine"></asp:TextBox>
				<asp:HiddenField ID="hdnFirstPageText" runat="server" />
			</div>
		</div>
     <div class="control-group">
			<label class="control-label">Second Page Message&nbsp;</label>
			<div class="controls" >
				<asp:TextBox ID="txtPostbackText" runat="server" Width="400px" Height="213px" TextMode="MultiLine"></asp:TextBox>
				<asp:HiddenField ID="hdnPostbackText" runat="server" />
			</div>
		</div>
	</div>