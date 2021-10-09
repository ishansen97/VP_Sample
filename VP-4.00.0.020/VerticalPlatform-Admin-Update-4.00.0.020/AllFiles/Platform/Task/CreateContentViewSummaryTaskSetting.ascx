<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CreateContentViewSummaryTaskSetting.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.Platform.Task.CreateContentViewSummaryTaskSetting" %>
<ul class="common_form_area">
	<li class="common_form_row clearfix">
		<span class="label_span" style="width: 160px;">
			<label>
				Create Weekly Summary
			</label>
		</span>
		<span>
			<asp:CheckBox ID="chkWeeklySummary" runat="server" />
		</span>
	</li>
	<li class="common_form_row clearfix">
		<span class="label_span" style="width: 160px;">
			<label>
				Create Monthly Summary
			</label>
		</span>
		<span>
			<asp:CheckBox ID="chkMonthlySummary" runat="server" />
		</span>
	</li>
	<li class="common_form_row clearfix">
		<span class="label_span" style="width: 160px;">
			<label>
				Create All Time Summary
			</label>
		</span>
		<span>
			<asp:CheckBox ID="chkAllTimeSummary" runat="server" />
		</span>
	</li>
	<li class="common_form_row clearfix">
		<span class="label_span" style="width: 160px;">
			<label>
				Delete Records Older Than 3 Months
			</label>
		</span>
		<span>
			<asp:CheckBox ID="chkDeleteOldRecords" runat="server" />
		</span>
	</li>
	<li class="common_form_row clearfix">
		<span class="label_span" style="width: 160px;">
			<label>
				Update Batch Size
			</label>
		</span>
		<span>
			<asp:TextBox runat="server" ID="txtUpdateBatchSize" ToolTip="Update batch size" MaxLength="5" Width="200"></asp:TextBox>
			<asp:CompareValidator ID="cvUpdateBatchSize" runat="server" Operator="DataTypeCheck" Type="Integer" ControlToValidate="txtUpdateBatchSize" ErrorMessage="Not a valid value."></asp:CompareValidator>
		</span>
	</li>
	<li class="common_form_row clearfix">
		<span class="label_span" style="width: 160px;">
			<label>
				Delete Batch Size
			</label>
		</span>
		<span>
			<asp:TextBox runat="server" ID="txtDeleteBatchSize" ToolTip="Delete batch size" MaxLength="5" Width="200"></asp:TextBox>
			<asp:CompareValidator ID="cvDeleteBatchSize" runat="server" Operator="DataTypeCheck" Type="Integer" ControlToValidate="txtDeleteBatchSize" ErrorMessage="Not a valid value."></asp:CompareValidator>
		</span>
	</li>
	<li class="common_form_row clearfix">
		<span class="label_span" style="width:160px;">
			<label>
				Exclude Internal IP Addresses
			</label>
		</span>
		<asp:CheckBox ID="excludeInternalIPAddresses" runat="server" Checked="true" ToolTip="Whether to exclude internal IP addresses from content view summary " />
	</li>
	<li class="common_form_row clearfix">
		<span class="label_span" style="width:160px;">
			<label>
				Internal IP Addresses <br />to Exclude <br/>(comma separated)
			</label>
		</span>
		<asp:TextBox ID="internalIpAddresses" TextMode="MultiLine" runat="server" Height="100px" ToolTip="Comma Seperated list of IP addresses to exclude when calculating content view summary  " />
	</li>
</ul>
