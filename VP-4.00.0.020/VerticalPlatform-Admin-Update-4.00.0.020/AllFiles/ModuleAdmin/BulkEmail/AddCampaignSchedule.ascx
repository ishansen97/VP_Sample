<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddCampaignSchedule.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.BulkEmail.AddCampaignSchedule" %>

<script type="text/javascript">
	$(document).ready(function() {
		$("input[type=text][id*=txtDate]").datepicker({ changeYear: true, dateFormat: 'yy/mm/dd' });
		$("input[type=text][id*=txtStartDate]").datepicker({ changeYear: true, dateFormat: 'yy/mm/dd' });
		$("input[type=text][id*=txtEndDate]").datepicker({ changeYear: true, dateFormat: 'yy/mm/dd' });
	});
</script>
<style type="text/css">
    .form-horizontal .controls{margin-left:120px;}
    .form-horizontal .control-label{width:100px;}
</style>
<div class="AdminPanelContent clearfix">
	<div class="schedule_popup_div clearfix">
		<div class="left_div">
			<asp:RadioButtonList ID="rblCampaignScheduleType" runat="server" OnSelectedIndexChanged="rblCampaignScheduleType_SelectedIndexChanged"
				AutoPostBack="true">
				<asp:ListItem Value="1" Selected="True">Once</asp:ListItem>
				<asp:ListItem Value="2">Daily</asp:ListItem>
				<asp:ListItem Value="3">Weekly</asp:ListItem>
				<asp:ListItem Value="4">Monthly</asp:ListItem>
			</asp:RadioButtonList>
		</div>
		<div class="right_div">
			<asp:MultiView ID="mvCampaignSchedule" runat="server" ActiveViewIndex="0">
				<asp:View ID="viewOnetimeSchedule" runat="server">
                    <div class="form-horizontal">
                        <div class="control-group">
                            <label class="control-label">Date</label>
                            <div class="controls">
                                <asp:TextBox ID="txtDate" runat="server" Width="128px"></asp:TextBox>
						        <asp:RequiredFieldValidator ID="rfvDate" runat="server" ControlToValidate="txtDate"
							        ErrorMessage="Please enter the date.">*</asp:RequiredFieldValidator>
                            </div>
                        </div>
					</div>
				</asp:View>
				<asp:View ID="vwCampaignDailySchedule" runat="server">
                    <div class="form-horizontal">
                        <div class="control-group">
                            <label class="control-label">Every</label>
                            <div class="controls">
                                <asp:TextBox ID="txtDailyRecurringPeriod" runat="server" MaxLength="3"></asp:TextBox>
						        <asp:RequiredFieldValidator ID="rfvDailyRecurringPeriod" runat="server" ControlToValidate="txtDailyRecurringPeriod"
							        ErrorMessage="Please enter number of days.">*</asp:RequiredFieldValidator>
                                <label>Days</label>
                                <asp:CompareValidator ID="cvDailyRecurringPeriod" runat="server" ControlToValidate="txtDailyRecurringPeriod"
							        ErrorMessage="Please enter a valid integer for number of days. " Operator="GreaterThan"
							        Type="Integer" ValueToCompare="0">*</asp:CompareValidator>
                            </div>
                        </div>
					</div>
                    
				</asp:View>
				<asp:View ID="vwWeeklySchedule" runat="server">
                    <div class="form-horizontal">
                        <div class="control-group">
                            <label class="control-label">Every</label>
                            <div class="controls">
                                <asp:TextBox ID="txtWeeklyRecurringPeriod" runat="server" MaxLength="3"></asp:TextBox>
                                <label>Weeks</label>
                                <asp:RequiredFieldValidator ID="rfvWeeksWeeklySchedule" runat="server" ControlToValidate="txtWeeklyRecurringPeriod"
							        ErrorMessage="Please enter number of weeks.">*</asp:RequiredFieldValidator>
						        <asp:CompareValidator ID="cvWeeklyRecurringPeriod" runat="server" ControlToValidate="txtWeeklyRecurringPeriod"
							        ErrorMessage="Please enter a valid integer for number of weeks. " Operator="GreaterThan"
							        Type="Integer" ValueToCompare="0">*</asp:CompareValidator>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">Day of Week</label>
                            <div class="controls">
                                <asp:DropDownList ID="ddlDayOfWeek" runat="server" style="width:auto;">
							        <asp:ListItem Value="0" Text="Sunday"></asp:ListItem>
							        <asp:ListItem Value="1" Text="Monday"></asp:ListItem>
							        <asp:ListItem Value="2" Text="Tuesday"></asp:ListItem>
							        <asp:ListItem Value="3" Text="Wednesday"></asp:ListItem>
							        <asp:ListItem Value="4" Text="Thursday"></asp:ListItem>
							        <asp:ListItem Value="5" Text="Friday"></asp:ListItem>
							        <asp:ListItem Value="6" Text="Saturday"></asp:ListItem>
						        </asp:DropDownList>
                            </div>
                        </div>
                    </div>
                    
					
				</asp:View>
				<asp:View ID="vwMonthlySchedule" runat="server">
                    <div class="form-horizontal">
                        <div class="control-group">
                            <label class="control-label">Every</label>
                            <div class="controls">
                                <asp:TextBox ID="txtMonthlyRecurringPeriod" runat="server" MaxLength="3"></asp:TextBox>
                                <label>Months</label>
                                <asp:RequiredFieldValidator ID="rfvRecurringMonths" runat="server" 
									ControlToValidate="txtMonthlyRecurringPeriod" 
									ErrorMessage="Please enter number of months.">*</asp:RequiredFieldValidator>
								<asp:CompareValidator ID="cvMonthlyRecurringPeriod" runat="server" ErrorMessage="Please enter a valid integer for number of months. "
									Operator="GreaterThan" Type="Integer" ValueToCompare="0" ControlToValidate="txtMonthlyRecurringPeriod">*</asp:CompareValidator>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">Day of Month</label>
                            <div class="controls">
                                <asp:DropDownList ID="ddlDayOfMonth" runat="server" Width="119px"></asp:DropDownList>
								<asp:RequiredFieldValidator ID="rfvDayOfMonth" runat="server" ControlToValidate="ddlDayOfMonth"
									ErrorMessage="Please enter day of the month.">*</asp:RequiredFieldValidator>
                            </div>
                        </div>
                    </div>
					
				</asp:View>
			</asp:MultiView>
		</div>
	</div>
	<div class="schedule_time_div">
        <div class="form-horizontal">
            <div class="control-group">
                <label class="control-label">Deploy Time</label>
                <div class="controls">
                    <asp:DropDownList ID="ddlHour" runat="server" style="width:100px;">
						<asp:ListItem Value="1">01</asp:ListItem>
						<asp:ListItem Value="2">02</asp:ListItem>
						<asp:ListItem Value="3">03</asp:ListItem>
						<asp:ListItem Value="4">04</asp:ListItem>
						<asp:ListItem Value="5">05</asp:ListItem>
						<asp:ListItem Value="6">06</asp:ListItem>
						<asp:ListItem Value="7">07</asp:ListItem>
						<asp:ListItem Value="8">08</asp:ListItem>
						<asp:ListItem Value="9">09</asp:ListItem>
						<asp:ListItem Value="10">10</asp:ListItem>
						<asp:ListItem Value="11">11</asp:ListItem>
						<asp:ListItem Value="12">12</asp:ListItem>
					</asp:DropDownList>
					<asp:Label ID="lblTimeSeparator" runat="server" Text=" : "></asp:Label>
					<asp:DropDownList ID="ddlMinute" runat="server" style="width:100px;">
						<asp:ListItem Value="0">00</asp:ListItem>
						<asp:ListItem Value="5">05</asp:ListItem>
						<asp:ListItem Value="10">10</asp:ListItem>
						<asp:ListItem Value="15">15</asp:ListItem>
						<asp:ListItem Value="20">20</asp:ListItem>
						<asp:ListItem Value="25">25</asp:ListItem>
						<asp:ListItem Value="30">30</asp:ListItem>
						<asp:ListItem Value="35">35</asp:ListItem>
						<asp:ListItem Value="40">40</asp:ListItem>
						<asp:ListItem Value="45">45</asp:ListItem>
						<asp:ListItem Value="50">50</asp:ListItem>
						<asp:ListItem Value="55">55</asp:ListItem>
					</asp:DropDownList>
					<asp:DropDownList ID="ddlTime" runat="server" style="width:100px;">
						<asp:ListItem Text="AM" Value="AM"></asp:ListItem>
						<asp:ListItem Text="PM" Value="PM"></asp:ListItem>
					</asp:DropDownList>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">Time Zone</label>
                <div class="controls">
                    <asp:DropDownList ID="ddlTimeZone" runat="server">
					</asp:DropDownList>
                </div>
            </div>
            <div class="control-group">
                <asp:Label ID="lblStartDate" runat="server" Text="Start Date" class="control-label"></asp:Label>
                <div class="controls">
                    <asp:TextBox ID="txtStartDate" runat="server"></asp:TextBox>
					<asp:RequiredFieldValidator ID="rfvStartDate" runat="server" ControlToValidate="txtStartDate"
						ErrorMessage="Please enter the start date.">*</asp:RequiredFieldValidator>
                </div>
            </div>
            <div class="control-group">
                <asp:Label ID="lblEndDate" runat="server" Text="End Date" class="control-label"></asp:Label>
                <div class="controls">
                    <asp:TextBox ID="txtEndDate" runat="server"></asp:TextBox>
					<asp:RequiredFieldValidator ID="rfvEndDate" runat="server" ControlToValidate="txtEndDate"
						ErrorMessage="Please enter the end date.">*</asp:RequiredFieldValidator>
                </div>
            </div>
        </div>
		
	</div>
</div>
