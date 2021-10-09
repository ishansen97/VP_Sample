<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LeadSchedule.aspx.cs" MasterPageFile="~/MasterPage.Master"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Lead.LeadSchedule" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>
				<asp:Label ID="lblHeader" runat="server" BackColor="Transparent">Lead Deploy Schedule</asp:Label></h3>
		</div>
		<div class="AdminPanelContent">
			<asp:UpdateProgress ID="UpdateProgress1" runat="server">
				<ProgressTemplate>
					<asp:Image ID="imgProgress" runat="server" ImageUrl="~/Images/Progress.gif" />
				</ProgressTemplate>
			</asp:UpdateProgress>
            <div class="form-horizontal">
                <div class="control-group">
                    <label class="control-label">Weekday</label>
                    <div class="controls"><asp:ListBox ID="lbWeekday" runat="server" Height="100px" SelectionMode="Multiple"
							Width="250px"></asp:ListBox></div>
                </div>
                <div class="control-group">
                    <label class="control-label">Time</label>
                    <div class="controls"><asp:ListBox ID="lbTime" runat="server" Height="250px" SelectionMode="Multiple" Width="250px">
						</asp:ListBox></div>
                </div>
                <div class="control-group">
                    <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" CssClass="btn" />
                </div>
            </div>
			
		</div>
	</div>
</asp:Content>
