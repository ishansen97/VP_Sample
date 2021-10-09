<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="ReviewFormDesigner.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Articles.ReviewFormDesigner" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">

	<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>

	<script src="../../Js/JQuery/jquery.json-1.3.min.js" type="text/javascript"></script>

	<script src="../../Js/ReviewFormDesigner/ReviewFormDesigner.js" type="text/javascript"></script>

	<script src="../../Js/FormDesigner/Designer.js" type="text/javascript"></script>

	<script src="../../Js/ReviewFormDesigner/ReviewFormCanvas.js" type="text/javascript"></script>

	<script src="../../Js/FormDesigner/Container.js" type="text/javascript"></script>

	<script src="../../Js/FormDesigner/Form.js" type="text/javascript"></script>

	<script src="../../Js/FormDesigner/List.js" type="text/javascript"></script>

	<script src="../../Js/FormDesigner/DropDownList.js" type="text/javascript"></script>

	<script src="../../Js/FormDesigner/TextBox.js" type="text/javascript"></script>

	<script src="../../Js/FormDesigner/CheckBoxList.js" type="text/javascript"></script>

	<script src="../../Js/FormDesigner/Panel.js" type="text/javascript"></script>

	<script src="../../Js/FormDesigner/Html.js" type="text/javascript"></script>

	<script src="../../Js/FormDesigner/TextArea.js" type="text/javascript"></script>

	<script src="../../Js/FormDesigner/RadioButtonList.js" type="text/javascript"></script>

	<script src="../../Js/FormDesigner/Label.js" type="text/javascript"></script>

	<script src="../../Js/FormDesigner/Button.js" type="text/javascript"></script>

	<script src="../../Js/FormDesigner/Break.js" type="text/javascript"></script>

	<script src="../../Js/FormDesigner/DatePicker.js" type="text/javascript"></script>

	<script src="../../Js/FormDesigner/Page.js" type="text/javascript"></script>

	<script src="../../Js/FormDesigner/PlaceHolder.js" type="text/javascript"></script>

	<script src="../../Js/JQuery/jquery.modal.js" type="text/javascript"></script>

	<script src="../../Js/FormDesigner/Description.js" type="text/javascript"></script>

	<script src="../../Js/FormDesigner/CheckBox.js" type="text/javascript"></script>

	<script src="../../Js/FormDesigner/FileUpload.js" type="text/javascript"></script>

	<script src="../../Js/FormDesigner/Rating.js" type="text/javascript"></script>

	<script src="../../Js/FormDesigner/ContentPicker.js" type="text/javascript"></script>
	
	<script type="text/javascript">
		$(document).ready(function () {

			var top = $('#toolbox').offset().top - parseFloat($('#toolbox').css('margin-top').replace(/auto/, 0));
			$(window).scroll(function (event) {
				var y = $(this).scrollTop();
				if (y >= top) {
				    $('#toolbox').addClass('toolBoxFixed');
				    $designerRightArea = $('.lead_form_container .rightColumn');
				    $('.toolbox-buttons').width($designerRightArea.width());
				} else {
				    $('#toolbox').removeClass('toolBoxFixed');
				    $('.toolbox-buttons').width('auto');
				}
			});
			$("#closeDialog").click(function () {
				$("#propertyDialog").jqmHide();
			});
           
		});

		var formId = '<%=FormId %>';
		var siteId = '<%=SiteId %>';
		var contentTypeId = '<%=ContentTypeId %>';
		var contentId = '<%=ContentId %>';
		var fieldContentTypeId = '<%=FieldContentTypeId %>';

	</script>

	<asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
		<Services>
			<asp:ServiceReference Path="~/Services/FormService.asmx" />
		</Services>
	</asp:ScriptManagerProxy>

	<div class="AdminPanelHeader">
		<h3>
			<asp:Label ID="headerLabel" runat="server" Font-Bold="True"></asp:Label></h3>
	</div>
	<div class="container lead_form_container lead_form_designer">
		<div class="leftColumn">
			<div id="toolbox">
				<div class="toolbox-buttons">
					<asp:HyperLink ID="lnkField" runat="server" CssClass="btn" style="margin-bottom:5px;">Add New Field</asp:HyperLink>
					<input id="btnSave" type="button" value="Save" class="btn" style="margin-bottom:5px;" />
					<input id="deleteForm" type="button" value="Delete" class="btn" style="margin-bottom:5px;" />
				</div>
				<div class="toolboxItem break_1">
					Break</div>
				<div class="toolboxItem button_1">
					Button</div>
				<div class="toolboxItem chekbox_1">
					CheckBoxList</div>
				<div class="toolboxItem date_pick">
					DatePicker</div>
				<div class="toolboxItem discription">
					Description</div>
				<div class="toolboxItem dropdown_1">
					DropDownList</div>
				<div class="toolboxItem html_1">
					Html</div>
				<div class="toolboxItem label_1">
					Label</div>
				<div class="toolboxItem panel_1">
					Panel</div>
				<div class="toolboxItem panel_1">
					PlaceHolder</div>
				<div class="toolboxItem radiobtn">
					RadioButtonList</div>
				<div class="toolboxItem text-area">
					TextArea</div>
				<div class="toolboxItem text-box">
					TextBox</div>
				<div class="toolboxItem chekbox_1">
					CheckBox</div>
				<div class="toolboxItem fileupload">
				FileUpload</div>
				<div class="toolboxItem rating">
				Rating</div>
				<div class="toolboxItem contentPicker">
				ContentPicker</div>
				<div style="clear: both; width: 100%; height:5px;">
					</div>

                
			</div>
		</div>
		<div class="rightColumn">
			<div id="canvas">
			</div>			
		</div>

		<div class="jqmWindow register-form-popup" id="propertyDialog">
			<div class="dialog_container">
				<div class="dialog_content1">
                    <div id="closeDialog" class="dialog_close">
				        x
			        </div>
					<div id="custom">
					</div>
					<div class="clear">
					</div>
					<div class="dialog_buttons" style="padding-left: 10px; padding-right: 5px;">
						<input type="button" id="propertySave" value="Ok" class="btn" />
						<input type="button" id="propertyCancel" value="Cancel" class="btn" />
					</div>
				</div>
				<div class="dialog_footer">
				</div>
			</div>
		</div>
	</div>
</asp:Content>
