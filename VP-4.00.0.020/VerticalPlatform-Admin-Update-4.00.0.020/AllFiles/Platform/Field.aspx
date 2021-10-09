<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="false"
	CodeBehind="Field.aspx.cs" Inherits="VerticalPlatformAdminWeb.Platform.Field" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
    <style type="text/css">
         .dialogOption:before,.dialogOption:after {content: " ";display: table; }
         .dialogOption:after {clear: both;}
         .dialogOption{margin-bottom:10px;}
         .dialogOption > span{display:block; float:left;}
         .dialogOption input[type=checkbox]{margin-left:5px;margin-right:5px;}
         .dialogOption > span a{display:block; float:left; margin-top:7px; margin-right:2px;}
         .dialogOption > span a.deleteIcon{margin-right:0px;}
    </style>

	<script src="../Js/JQuery/jquery.modal.js" type="text/javascript"></script>

	<script src="../Js/JQuery/jquery.json-1.3.min.js" type="text/javascript"></script>

	<script src="../Js/Field.js" type="text/javascript"></script>

	<asp:ScriptManagerProxy ID="ScriptManagerProxy1" runat="server">
		<Services>
			<asp:ServiceReference Path="~/Services/FormService.asmx" />
		</Services>
	</asp:ScriptManagerProxy>
	<div>
	<div class="AdminPanelHeader">
		<h3>
			<asp:Label ID="lblTitle" runat="server" /></h3></div>
		<asp:Literal ID="ltlLeadType" runat="server" Text="Lead Type :"></asp:Literal>
		<asp:DropDownList ID="ddlLeadType" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlLeadType_SelectedIndexChanged">
		</asp:DropDownList>
		<br />
		<asp:GridView ID="gvField" runat="server" AutoGenerateColumns="False" OnRowDataBound="gvField_RowDataBound"
			OnRowCommand="gvField_RowCommand" CssClass="common_data_grid table table-bordered">
			<Columns>
				<asp:TemplateField ItemStyle-Width="50px">
					<ItemTemplate>
						<asp:LinkButton ID="lbtnEnable" runat="server" CommandName="EnableField">
							<asp:Image ID="imgEnable" runat="server" />
						</asp:LinkButton>
					</ItemTemplate>
					<ItemStyle Width="50px"></ItemStyle>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Field ID" ItemStyle-Width="75px">
					<ItemTemplate>
						<asp:Literal ID="ltlFieldId" runat="server"></asp:Literal>
					</ItemTemplate>
					<ItemStyle Width="75px"></ItemStyle>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Field Name" ItemStyle-Width="100px">
					<ItemTemplate>
						<asp:Literal ID="ltlFieldText" runat="server"></asp:Literal>
					</ItemTemplate>
					<ItemStyle Width="100px" />
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Abbreviation" ItemStyle-Width="100px">
					<ItemTemplate>
						<asp:Literal ID="ltlFieldTextAbbreviation" runat="server"></asp:Literal>
					</ItemTemplate>
					<ItemStyle Width="100px" />
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Description" ItemStyle-Width="100px">
					<ItemTemplate>
						<asp:Literal ID="ltlFieldDescription" runat="server"></asp:Literal>
					</ItemTemplate>
					<ItemStyle Width="125px" />
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Field Type" ItemStyle-Width="100px">
					<ItemTemplate>
						<asp:Literal ID="ltlFieldType" runat="server"></asp:Literal>
					</ItemTemplate>
					<ItemStyle Width="100px"></ItemStyle>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Type ID" ItemStyle-Width="50px">
					<ItemTemplate>
						<asp:Literal ID="ltlLeadType" runat="server"></asp:Literal>
					</ItemTemplate>
					<ItemStyle Width="75px"></ItemStyle>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Predefined Field" ItemStyle-Width="75px">
					<ItemTemplate>
						<asp:Literal ID="ltlPredefinedField" runat="server"></asp:Literal>
					</ItemTemplate>
					<ItemStyle Width="100px"></ItemStyle>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Enabled" ItemStyle-Width="75px">
					<ItemTemplate>
						<asp:CheckBox ID="chkEnabled" runat="server" />
					</ItemTemplate>
					<ItemStyle Width="75px"></ItemStyle>
				</asp:TemplateField>
				<asp:TemplateField>
					<ItemTemplate>
						<asp:Literal ID="ltlEdit" runat="server"></asp:Literal>
					</ItemTemplate>
					<ItemStyle Width="50px"></ItemStyle>
				</asp:TemplateField>
			</Columns>
		</asp:GridView>
		<br />
		<div class="inline-form-container"><input id="btnAddNew" type="button" value="New" class="btn" />
		<asp:Button ID="btnHidden" runat="server" Text="Button" OnClick="btnHidden_Click"
			Style="display: none;" CssClass="hiddenFieldButton" />
			<asp:HyperLink ID="lnkDesign" runat="server" CssClass="btn">Design Lead Form</asp:HyperLink>
			<asp:HyperLink ID="lnkDesignForLoggedInUser" runat="server" CssClass="btn">Design Lead Form for logged in user</asp:HyperLink>
		</div>
	</div>
	<div class="jqmWindow" id="dialog">
		<div id="custom" class="customFieldDialog jqmContent">
			<div class="dialog_container">
				<div class="dialog_header clearfix">
					<h2>
						Title
					</h2>
					<div id="closeDialog" class="dialog_close">
						<input type="button" id="btnCancel" value="x" class="common_text_button" /></div>
				</div>
			</div>
			<div class="dialog_content">
				<div class="form-horizontal">
					<div class="control-group" id='fieldTypes'>
						<label class="control-label">Field Types</label>
						<div class="controls">
							<select id='ddlFieldType'>
								<option value='0'>-Select-</option>
								<option value='8'>Button</option>
								<option value='3'>CheckBoxList</option>
								<option value='12'>DatePicker</option>
								<option value='1'>DropDownList</option>
								<option value='14'>PlaceHolder</option>
								<option value='6'>RadioButtonList</option>
								<option value='5'>TextArea</option>
								<option value='2'>TextBox</option>
								<option value='15'>Checkbox</option>
								<option value='16'>FileUpload</option>
								<option value='17'>Rating</option>
								<option value='18'>ContentPicker</option>
							</select>
						</div>
					</div>
					<div id='fieldProperties'>
						<div class="control-group" id='predefinedFields'>
							<label class="control-label">Predefined Fields</label>
							<div class="controls" id='preFieldsContainer'></div>
						</div>
						<div id='field'>
							<div class="control-group">
								<label class="control-label">Field Name</label>
								<div class="controls">
									<input id="txtFieldName" type="text" size="30" />
								</div>
							</div>
							<div class="control-group">
								<label class="control-label">Field Name Abbreviation</label>
								<div class="controls">
									<input id="txtFieldNameAbbreviation" type="text" size="30" maxlength="20" />
								</div>
							</div>
							<div class="control-group">
								<label class="control-label">Field Description</label>
								<div class="controls">
									<textarea id="txtFieldDescription"style="height:60px;width:170px;" cols="20" rows="2" ></textarea>
								</div>
							</div>
							<div class="control-group">
								<label class="control-label">Enabled</label>
								<div class="controls"><input id="chkEnabled" type="checkbox" /></div>
							</div>
						</div> 
					</div>
					<div class="control-group" id='fieldOptionsContainer'>
						<div class="controls">
							<div class="inline-form-container" id='fieldOptions'></div>
						</div>
					</div>
					<div class="control-group" id="addNewFieldOptions">
						<div class="controls">
							<input type="button" id="btnNewOption" value="Add New Option" class="btn" />
						</div><br />
					</div>
						<input id="hdnFieldId" type="hidden" />
					</div>
					<div class="dialog_buttons" class="clearfix">
						<input type="button" id="btnSave" value="Save" class="btn" />
						<input type="button" id="btnCancelBottom" value="Cancel" class="btn" />
					</div>
			</div>
			<div class="dialog_footer">
			</div>
		</div>
	</div>
</asp:Content>
