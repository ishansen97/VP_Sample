<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CitationsSettings.ascx.cs" 
		Inherits="VerticalPlatformAdminWeb.Platform.ModuleInstanceSettings.CitationsSettings" %>

<div class="citationsSettings">
	<ul class="common_form_area">
		<li class="common_form_row clearfix">
			<div class="common_form_row_lable">
				Display Citations From
			</div>
			<div class="common_form_row_data">
				<asp:TextBox ID="duration" runat="server"></asp:TextBox> Months Ago
				<asp:HiddenField ID="durationHidden" runat="server" />
				<asp:RequiredFieldValidator ID="durationRequiredValidator" ControlToValidate="duration" 
						ErrorMessage="Duration is Required. " runat="server">*</asp:RequiredFieldValidator>
				<asp:RangeValidator id="durationRangeValidator" ControlToValidate="duration" MinimumValue="1" MaximumValue="1000" 
						Type="Integer" ErrorMessage="The duration must be integer and greater than 0." runat="server">*</asp:RangeValidator>
			</div>
		</li>
	</ul>
	<ul class="common_form_area">
		<li class="common_form_row clearfix">
			<div class="common_form_row_lable">
				Sort By
			</div>
			<div class="common_form_row_data">
				<asp:DropDownList ID="citationSortBy" runat="server">
					<asp:ListItem Value="title" Text="Title" Selected="True" />
					<asp:ListItem Value="journal_name" Text="Journal Name" />
					<asp:ListItem Value="published_date" Text="Published Date" />
				</asp:DropDownList>
				<asp:HiddenField ID="citationSortByHidden" runat="server" />
			</div>
		</li>
	</ul>
	<ul class="common_form_area">
		<li class="common_form_row clearfix">
			<div class="common_form_row_lable">
				Sort Order
			</div>
			<div class="common_form_row_data">
				<asp:RadioButtonList ID="citationSortOrder" runat="server">
					<asp:ListItem Value="asc" Text="Ascending" Selected="True" />
					<asp:ListItem Value="desc" Text="Descending" />
				</asp:RadioButtonList>
				<asp:HiddenField ID="citationSortOrderHidden" runat="server" />
			</div>
		</li>
	</ul>
	<ul class="common_form_area">
		<li class="common_form_row clearfix">
			<div class="common_form_row_lable">
				Page Size
			</div>
			<div class="common_form_row_data">
				<asp:TextBox ID="pageSize" runat="server"></asp:TextBox>
				<asp:HiddenField ID="pageSizeHidden" runat="server" />
				<asp:RequiredFieldValidator ID="pageSizeRequiredValidator" ControlToValidate="pageSize" 
						ErrorMessage="Page Size is Required. " runat="server">*</asp:RequiredFieldValidator>
				<asp:RangeValidator id="pageSizeRangeValidator" ControlToValidate="pageSize" MinimumValue="1" MaximumValue="1000" 
						Type="Integer" ErrorMessage="The page size must be integer and greater than 0." runat="server">*</asp:RangeValidator>
			</div>
		</li>
	</ul>
</div>