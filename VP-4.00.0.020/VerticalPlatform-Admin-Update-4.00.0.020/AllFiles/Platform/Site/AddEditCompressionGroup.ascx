<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddEditCompressionGroup.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.Site.AddEditCompressionGroup" %>
<div id="compressionGroup">
	<ul class="common_form_area">
		<li class="common_form_row clearfix group_row">
			<div class="common_form_row_lable">
				Group Name
			</div>
			<div class="common_form_row_data">
				<asp:TextBox ID="txtGroupName" runat="server" Width="200px" CssClass="common_text_box"
					MaxLength="100"></asp:TextBox>
				<asp:RequiredFieldValidator ID="rfvGroupName" runat="server" ControlToValidate="txtGroupName"
					ErrorMessage="Please enter the group name.">*</asp:RequiredFieldValidator>
			</div>
		</li>
		<li class="common_form_row clearfix group_row">
			<div class="common_form_row_lable">
				Display Title
			</div>
			<div class="common_form_row_data">
				<asp:TextBox ID="txtGroupTitle" runat="server" Width="200px" CssClass="common_text_box"
					MaxLength="100"></asp:TextBox>
				<asp:RequiredFieldValidator ID="rfvGroupTitle" runat="server" ControlToValidate="txtGroupTitle"
					ErrorMessage="Please enter the group title.">*</asp:RequiredFieldValidator>
			</div>
		</li>
		<li class="common_form_row clearfix group_row">
			<div class="common_form_row_lable">
				Sort Order
			</div>
			<div class="common_form_row_data">
				<asp:TextBox ID="txtSortOrder" runat="server" Width="200px" CssClass="common_text_box"
					MaxLength="100"></asp:TextBox>
				<asp:RequiredFieldValidator ID="rfvSortOrder" runat="server" ControlToValidate="txtSortOrder"
					ErrorMessage="Please enter the sort order.">*</asp:RequiredFieldValidator>
				<asp:RegularExpressionValidator ID="revSortOrder" runat="server" ControlToValidate="txtSortOrder"
					ErrorMessage="Please enter a positive numeric value as the sort order." ValidationExpression="^[0-9][0-9]*$">*</asp:RegularExpressionValidator>
			</div>
		</li>
		<li class="common_form_row clearfix group_row">
			<div class="common_form_row_lable">
				Show In Matrix
			</div>
			<div class="common_form_row_data">
				<asp:CheckBox ID="chkShowInMatrix" runat="server" />
			</div>
		</li>
		<li class="common_form_row clearfix group_row">
			<div class="common_form_row_lable">
				Show Product Count
			</div>
			<div class="common_form_row_data">
				<asp:CheckBox ID="chkShowProductCount" runat="server" />
			</div>
		</li>
		<li class="common_form_row clearfix group_row">
			<div class="common_form_row_lable">
				Expand Products
			</div>
			<div class="common_form_row_data">
				<asp:CheckBox ID="chkExpandProducts" runat="server" />
			</div>
		</li>
		<li class="common_form_row clearfix group_row">
			<div class="common_form_row_lable">
				Display Specification Types
			</div>
			<div class="common_form_row_data">
				<asp:DropDownList ID="ddlSpecificationType" runat="server" Width="144px">
				</asp:DropDownList>
				<asp:Button ID="btnAddSpecificationType" runat="server" OnClick="btnAddSpecificationType_Click"
					Text="Add" CssClass="common_text_button" CausesValidation="False" />
				<div class="common_form_row_div clearfix">
					<asp:ListBox ID="lstSpecificationType" runat="server" Width="247px"></asp:ListBox>
				</div>
				<div class="common_form_row_div clearfix">
					<asp:Button ID="btnRemove" runat="server" OnClick="btnRemove_Click" Text="Remove"
						CssClass="common_text_button" CausesValidation="False" />
					<asp:HiddenField ID="hdnbtnSpecificationTypeValue" runat="server" />
				</div>
			</div>
		</li>
		<li class="common_form_row clearfix group_row">
			<div class="common_form_row_lable">
				&nbsp;
			</div>
			<div class="common_form_row_data">
				<asp:Label ID="lblMessage" runat="server"></asp:Label>
			</div>
		</li>
	</ul>
</div>
