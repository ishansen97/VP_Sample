<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ProductTrackingSettings.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.ProductTrackingSettings" %>
<%@ Register Src="../../Controls/PopupDialogSmartScroller.ascx" TagName="SmartScroller"
	TagPrefix="uc2" %>
<style type="text/css">
	*:first-child + html .ui-tabs-nav
	{
		width: auto;
		float: none;
		margin-left: -5px;
		position: static;
	}
	*:first-child + html .ui-tabs .ui-tabs-nav li
	{
		position: static;
	}
	.ui-widget input, .ui-widget select, .ui-widget textarea, .ui-widget button
	{
		font-size: 10px;
	}
</style>
<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>
<script src="../../Js/ContentPicker.js" type="text/javascript"></script>

<script language="javascript" type="text/javascript">
	$(document).ready(function () {
		RegisterNamespace("VP.ArticleList");
	   
	});


</script>

<div id="tabs" style="width: 650px">

	<div id="tabs-1">
		<ul class="common_form_area">
			


			
			<li class="common_form_row clearfix group_row">
				<div class="common_form_row_lable">
					Allowed Url
				</div>
				<div class="common_form_row_data">
					<div class="ProductCategoryList">
						<asp:TextBox ID="txtAllowedUrl" runat="server" Width="450px" ></asp:TextBox>					
						
					</div>
					<asp:Button ID="btnAddUrl" runat="server" Text="Add" OnClick="btnAddUrl_Click"
						CausesValidation="false" CssClass="common_text_button" />
					<div class="common_form_row_div clearfix" style="clear:both">
						<asp:ListBox ID="lstUrls" runat="server" Height="70px" Width="464px"></asp:ListBox>
					</div>
					<div class="common_form_row_div clearfix">
						<asp:Button ID="btnRemoveUrl" runat="server" OnClick="btnRemoveUrl_Click"
							Text="Remove" CssClass="common_text_button" />
						<asp:HiddenField ID="hdnAllowedUrls" runat="server" />
					</div>
				</div>
			</li>




			
		</ul>
	</div>
	
	
	
	
</div>


