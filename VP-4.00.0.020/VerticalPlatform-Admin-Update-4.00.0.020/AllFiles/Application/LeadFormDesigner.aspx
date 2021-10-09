<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="LeadFormDesigner.aspx.cs" Inherits="VerticalPlatformAdminWeb.Application.LeadFormDesigner" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">

	<script src="../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>

	<script src="../Js/JQuery/jquery.json-1.3.min.js" type="text/javascript"></script>

	<script src="../Js/FormDesigner/ApplicationLeadFormDesigner.js" type="text/javascript"></script>

	<script src="../Js/FormDesigner/FormDesignerBase.js" type="text/javascript"></script>

	<script src="../Js/FormDesigner/Canvas.js" type="text/javascript"></script>

	<script src="../Js/FormDesigner/Designer.js" type="text/javascript"></script>

	<script src="../Js/FormDesigner/Container.js" type="text/javascript"></script>

	<script src="../Js/FormDesigner/Form.js" type="text/javascript"></script>

	<script src="../Js/FormDesigner/List.js" type="text/javascript"></script>

	<script src="../Js/FormDesigner/DropDownList.js" type="text/javascript"></script>

	<script src="../Js/FormDesigner/TextBox.js" type="text/javascript"></script>

	<script src="../Js/FormDesigner/CheckBoxList.js" type="text/javascript"></script>

	<script src="../Js/FormDesigner/Panel.js" type="text/javascript"></script>

	<script src="../Js/FormDesigner/Html.js" type="text/javascript"></script>

	<script src="../Js/FormDesigner/TextArea.js" type="text/javascript"></script>

	<script src="../Js/FormDesigner/RadioButtonList.js" type="text/javascript"></script>

	<script src="../Js/FormDesigner/Label.js" type="text/javascript"></script>

	<script src="../Js/FormDesigner/Button.js" type="text/javascript"></script>

	<script src="../Js/FormDesigner/Break.js" type="text/javascript"></script>

	<script src="../Js/FormDesigner/DatePicker.js" type="text/javascript"></script>

	<script src="../Js/FormDesigner/Page.js" type="text/javascript"></script>

	<script src="../Js/FormDesigner/PlaceHolder.js" type="text/javascript"></script>

	<script src="../Js/JQuery/jquery.modal.js" type="text/javascript"></script>

	<script src="../Js/FormDesigner/Description.js" type="text/javascript"></script>

	<script src="../Js/FormDesigner/CheckBox.js" type="text/javascript"></script>

    <script type="text/javascript">
        $(document).ready(function () {

            var top = 100;
            $(window).scroll(function (event) {
                var y = $(this).scrollTop();
                if (y >= top) {
                    $('#toolbox').addClass('toolBoxFixed');
                } else {
                    $('#toolbox').removeClass('toolBoxFixed');
                }
            });
            $("#closeDialog").click(function () {
                $("#propertyDialog").jqmHide();
            });
        });
	</script>

	<asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
    		<Services>
			<asp:ServiceReference Path="~/Services/FormService.asmx" />
		</Services>
	</asp:ScriptManagerProxy>
	<div class="AdminPanelHeader">
		<h3>
			<asp:Label ID="lblHeader" runat="server" Font-Bold="True"></asp:Label></h3>
	</div>
	<div class="container lead_form_container  lead_form_designer">
		<div class="leftColumn">
			<div id="toolbox">
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
				<div class="toolboxItem radiobtn">
					RadioButtonList</div>
				<div class="toolboxItem text-area">
					TextArea</div>
				<div class="toolboxItem text-box">
					TextBox</div>
				<div class="toolboxItem chekbox_1">
					CheckBox</div>
				<div style="clear: both; width: 100%; height:5px;">
					</div>
				<input id="btnSave" type="button" value="Save" class="btn" />
				<input id="btnCancel" type="button" value="Cancel" onclick="window.location.href='javascript:history.back()'"
					class="btn" />
			</div>
			<div class="clear">
			</div>
		</div>
		<div class="rightColumn">
			<div id="canvas">
			</div>
			<table>
				<tr>
					<td>
						Thank you message
					</td>
					<td>
						<asp:TextBox ID="txtThanksMsg" CssClass="txtThanksMsg" runat="server" Height="50px"
							TextMode="MultiLine" Width="400px"></asp:TextBox>
					</td>
				</tr>
				<tr>
					<td>
						Confirmation email subject
					</td>
					<td>
						<asp:TextBox ID="txtSubject" CssClass="txtSubject" runat="server" Width="400px"></asp:TextBox>
					</td>
				</tr>
				<tr>
					<td>
						Confirmation email body
					</td>
					<td>
						<asp:TextBox ID="txtBody" CssClass="txtBody" runat="server" Height="50px" TextMode="MultiLine"
							Width="400px"></asp:TextBox>
					</td>
				</tr>
			</table>
			<div class="clear">
			</div>
		</div>
	</div>
	<div class="jqmWindow clearfix  register-form-popup" id="propertyDialog">
		<div class="jqmContent">
			<div class="dialog_container">
				<div class="dialog_content1">
                    <div id="closeDialog" class="dialog_close">
				        x
			        </div>
					<div id="custom">
					</div>
					<div class="clear">
					</div>
					<div class="dialog_buttons" style="padding-left: 5px; padding-right: 5px;">
						<input type="button" id="propertySave" value="Ok" class="common_text_button" />
						<input type="button" id="propertyCancel" value="Cancel" class="common_text_button" />
					</div>
				</div>
				<div class="dialog_footer">
				</div>
			</div>
		</div>
	</div>
</asp:Content>
