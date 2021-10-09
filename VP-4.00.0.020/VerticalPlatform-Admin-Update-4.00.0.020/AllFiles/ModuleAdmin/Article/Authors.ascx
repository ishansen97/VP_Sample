<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Authors.ascx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Articles.Authors" %>
<style type="text/css">
    .dialog_content_inner {
        padding-bottom: 30px;
    }
</style>
<div>
    <ul class="common_form_area">
        <li class="common_form_row clearfix" style="padding-top: 10px;">
            <div class="common_form_row_lable">
                Title
            </div>
            <div class="common_form_row_data">
                <asp:DropDownList ID="ddlTitle" runat="server">
                </asp:DropDownList>
            </div>
        </li>
        <li class="common_form_row clearfix" style="padding-top: 10px;">
            <div class="common_form_row_lable">
                First Name
            </div>
            <div class="common_form_row_data">
                <asp:TextBox ID="txtFirstName" runat="server" MaxLength="100"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvFirstName" runat="server"
                    ErrorMessage="Please enter 'First Name'." ControlToValidate="txtFirstName">*</asp:RequiredFieldValidator>
            </div>
        </li>
        <li class="common_form_row clearfix" style="padding-top: 10px;">
            <div class="common_form_row_lable">
                Last Name
            </div>
            <div class="common_form_row_data">
                <asp:TextBox ID="txtLastName" runat="server" MaxLength="100"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvLastName" runat="server"
                    ErrorMessage="Please enter 'Last Name'." ControlToValidate="txtLastName">*</asp:RequiredFieldValidator>
            </div>
        </li>
        <li class="common_form_row clearfix" style="padding-top: 10px;">
            <div class="common_form_row_lable">
                Email
            </div>
            <div class="common_form_row_data">
                <asp:TextBox ID="txtEmail" runat="server" MaxLength="100"></asp:TextBox>
                <asp:CustomValidator ID="emailAddressValidator" runat="server" ControlToValidate="txtEmail"
                    ErrorMessage="Invalid email address." ValidateEmptyText="true"
                    ClientValidationFunction="VP.ValidateEmail">*</asp:CustomValidator>
            </div>
        </li>
        <li class="common_form_row clearfix" style="padding-top: 10px;">
            <div class="common_form_row_lable">
                Country
            </div>
            <div class="common_form_row_data">
                <asp:DropDownList ID="ddlCountry" runat="server" AppendDataBoundItems="true">
                    <asp:ListItem Text="" Value=""></asp:ListItem>
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="rfvCountry" runat="server"
                    ErrorMessage="Select country" ControlToValidate="ddlCountry">*</asp:RequiredFieldValidator>
            </div>
        </li>
        <li class="common_form_row clearfix" style="padding-top: 10px;">
            <div class="common_form_row_lable">
                Organization
            </div>
            <div class="common_form_row_data">
                <asp:TextBox ID="txtOrganization" runat="server" MaxLength="250"></asp:TextBox>
            </div>
        </li>

        <li class="common_form_row clearfix" style="padding-top: 10px;">
            <div class="common_form_row_lable">
                Position
            </div>
            <div class="common_form_row_data">
                <asp:DropDownList ID="posiotnDropdown" AutoPostBack="true" runat="server" AppendDataBoundItems="true" OnSelectedIndexChanged="posiotnDropdown_SelectedIndexChanged">
                    <asp:ListItem Text="" Value=""></asp:ListItem>
                </asp:DropDownList>
                <div>
                    <asp:TextBox ID="txtPosition" runat="server" MaxLength="100" Visible="false"></asp:TextBox>
                </div>
            </div>
        </li>

        <li class="common_form_row clearfix" style="padding-top: 10px;">
            <div class="common_form_row_lable">
                Department
            </div>
            <div class="common_form_row_data">
                <asp:TextBox ID="txtDepartment" runat="server" MaxLength="100"></asp:TextBox>
            </div>
        </li>
		<li class="common_form_row clearfix" style="padding-top: 10px;">
            <div class="common_form_row_lable">
                Degree
            </div>
            <div class="common_form_row_data">
                <asp:TextBox ID="txtDegree" runat="server" MaxLength="100"></asp:TextBox>
            </div>
        </li>
		<li class="common_form_row clearfix" style="padding-top: 10px;">
            <div class="common_form_row_lable">
                Speaker's title/position
            </div>
            <div class="common_form_row_data">
                <asp:TextBox ID="txtSpeakerTitle" runat="server" MaxLength="100"></asp:TextBox>
            </div>
        </li>
		 <li class="common_form_row clearfix" style="padding-top: 10px;">
            <div class="common_form_row_lable">
                Author Type
            </div>
            <div class="common_form_row_data">
               	<asp:DropDownList ID="ddlAuthorType" runat="server" AutoPostBack="False" ></asp:DropDownList>
            </div>
        </li>
        <li class="common_form_row clearfix" style="padding-top: 10px;">
            <div visible="false" id="fixedUrlRow" runat="server">
                <div class="common_form_row_lable">
                    Fixed URL
                </div>
                <div class="common_form_row_data">
                    <asp:TextBox ID="txtFixedUrl" runat="server"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvFixedUrl" runat="server" ErrorMessage="Please enter fixed url."
                        ControlToValidate="txtFixedUrl" Display="Dynamic">*</asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revFixedUrl" runat="server" ErrorMessage="Url should start with '/', end with '/' and should only contain alpha numeric characters ,'-'. example '/id-author-name/'."
                        ControlToValidate="txtFixedUrl" ValidationExpression="^((?:\/[a-zA-Z0-9]+(?:_[a-zA-Z0-9]+)*(?:\-[a-zA-Z0-9]+)*)+)/$"
                        Display="Static">*</asp:RegularExpressionValidator>
                </div>
            </div>
        </li>
        <li class="common_form_row clearfix" style="padding-top: 10px;">
            <div class="common_form_row_lable">
                Profile Html
            </div>
            <div class="common_form_row_data">
                <asp:TextBox ID="txtProfileHtml" runat="server" TextMode="MultiLine" Width="300" Height="100"></asp:TextBox>
            </div>
        </li>
        <li class="common_form_row clearfix" style="padding-top: 10px;">
            <div class="common_form_row_lable">
                Has Image
            </div>
            <div class="common_form_row_data">
                <asp:CheckBox ID="chkHasImage" runat="server" />
            </div>
        </li>
        <li class="common_form_row clearfix" style="padding-top: 10px;">
            <div class="common_form_row_lable">
                Image
            </div>
            <div class="common_form_row_data">
                <asp:FileUpload ID="fuImage" runat="server" />
                <asp:HiddenField ID="hdnHasImage" runat="server" />
                &nbsp;&nbsp; Create Standard Image Sizes &nbsp;
					<asp:CheckBox ID="chkResizeImage" runat="server" />
            </div>
        </li>
        <li class="common_form_row clearfix" style="padding-top: 10px;">
            <div class="common_form_row_lable">
                &nbsp;
            </div>
            <div class="common_form_row_data">
                <asp:Image ID="imgAuthor" runat="server" Height="70px" Width="70px" />
            </div>
        </li>
        <li class="common_form_row clearfix" style="padding-top: 10px;">
            <div class="common_form_row_lable">
                Enabled
            </div>
            <div class="common_form_row_data">
                <asp:CheckBox ID="chkEnabled" Checked="true" runat="server" />
            </div>
        </li>
    </ul>
	<asp:HiddenField ID="duplicateAuthor" Value="" runat="server" />
</div>
