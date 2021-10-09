<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddEditCustomProperty.ascx.cs" Inherits="VerticalPlatformAdminWeb.Platform.Site.AddEditCustomProperty" %>
<style type="text/css">
    .form-horizontal .control-label{width:100px;}
    .form-horizontal .controls{margin-left:120px;}
    .form-horizontal .control-group{margin-bottom:10px;}
</style>
<div>
    <div class="form-horizontal">
        <div class="control-group">
            <label class="control-label">Property Name</label>
            <div class="controls">
                <asp:TextBox ID="txtPropertyName" runat="server" CssClass="common_text_box" MaxLength="100"></asp:TextBox>
				<asp:RequiredFieldValidator ID="rfvPropertyName" runat="server" 
					ControlToValidate="txtPropertyName" ErrorMessage="Please enter the property name.">*</asp:RequiredFieldValidator>
				<asp:RegularExpressionValidator ID="revPropertyName" runat="server" 
					ControlToValidate="txtPropertyName" 
					ErrorMessage="Property name cannot contain '['or ']'." 
					ValidationExpression="[^\[^\]]*">*</asp:RegularExpressionValidator>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">Data Type</label>
            <div class="controls">
                <asp:DropDownList ID="ddlDataType" runat="server">
				</asp:DropDownList>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">Null Allowed</label>
            <div class="controls">
                <asp:CheckBox ID="chkIsNullable" runat="server" />
            </div>
        </div>
        <div class="control-group">
            <div class="controls"><asp:Label ID="lblMessage" runat="server"></asp:Label></div>
        </div>
    </div>

</div>
