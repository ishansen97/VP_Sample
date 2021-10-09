<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddEditProductDisplayStatus.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Product.AddEditProductDisplayStatus" %>

<script type="text/javascript">
	$(document).ready(function() {
	$("input[id*=txtStartDate]").datepicker({ changeYear: true, dateFormat: 'mm/dd/yy' });
	$("input[id*=txtEndDate]").datepicker({ changeYear: true, dateFormat: 'mm/dd/yy' });
	});
</script>
	<div>
		<ul class="common_form_area">
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					Start Date
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtStartDate" runat="server" Width="179px" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					End Date
				</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtEndDate" runat="server" Width="179px" />
				</div>
			</li>
			<li class="common_form_row clearfix" style="padding-top: 10px;">
				<div class="common_form_row_lable">
					New Product Rank
				</div>
				<div class="common_form_row_data">
					<asp:DropDownList ID="ddlNewRank" runat="server" Width="179px" 
						AppendDataBoundItems="True">
						<asp:ListItem Value="-1">--SELECT--</asp:ListItem>
					</asp:DropDownList>
				</div>
			</li>
			<li class="common_form_row clearfix">
				<div class="common_form_row_lable">
					New Search Rank</div>
				<div class="common_form_row_data">
					<asp:TextBox ID="txtSearchRank" ValidationGroup="saveGroup" runat="server" Width="179px"></asp:TextBox>					<asp:RangeValidator ID="RangeValidator1" ControlToValidate="txtSearchRank"
						Type="Double" MinimumValue="1" MaximumValue="500" runat="server" 
						ErrorMessage="Featured Search Rank should be between 1 and 500.">*</asp:RangeValidator>
				</div>
			</li>
		</ul>
	</div>
