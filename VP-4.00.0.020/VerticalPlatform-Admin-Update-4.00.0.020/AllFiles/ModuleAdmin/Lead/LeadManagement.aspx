<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="LeadManagement.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Lead.LeadManagement"
	Title="Untitled Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
    <script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            $("input[class$='txtStartDate']").datepicker(
                {
                    changeYear: true
                });

            $("input[class$='txtEndDate']").datepicker(
                {
                    changeYear: true
                });
        });
    </script>

	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>
				<asp:Label ID="lblHeader" runat="server" Text="Lead Management" BackColor="Transparent"></asp:Label></h3>
		</div>

		<div class="AdminPanelContent">
			<div>
				Email Addresses</div>
			<br />
			<asp:GridView ID="gvEmails" runat="server" AutoGenerateColumns="false"
				OnRowCommand="gvEmails_RowCommand" OnRowCreated="gvEmails_RowCreated"
				CssClass="common_data_grid table table-bordered" style="width:auto;">
				<Columns>
					<asp:BoundField DataField="Id" HeaderText="ID" ControlStyle-Width="50px" />
					<asp:BoundField DataField="EmailAddress" HeaderText="Email" ControlStyle-Width="200px" />
					<asp:CheckBoxField DataField="Enabled" ControlStyle-Width="50px" />
					<asp:TemplateField >
						<ItemTemplate>
							<asp:HyperLink ID="lnkEdit" runat="server" CssClass="aDialog grid_icon_link Edit" ToolTip="Edit">Edit</asp:HyperLink>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField>
						<ItemTemplate>
							<asp:LinkButton ID="lbtnDeleteEmail" runat="server" CommandName="DeleteEmail" CausesValidation="false" CssClass="grid_icon_link delete" ToolTip="Delete">Delete</asp:LinkButton>
						</ItemTemplate>
					</asp:TemplateField>
				</Columns>
				<EmptyDataTemplate>
					No Emails exist for the Vendor.
				</EmptyDataTemplate>
			</asp:GridView>
			<br />
			<asp:HiddenField ID="hdnEmailId" runat="server" />

            <div class="form-horizontal">
                <strong>Filter Leads By</strong>
                <div id="divSearch">
                    <div class="control-group">
                        <label class="control-label">
                            Lead ID</label>
                        <div class="controls">
                            <asp:TextBox ID="txtSearchLeadId" runat="server" CssClass=""
                                Width="180"></asp:TextBox>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">
                            Product ID</label>
                        <div class="controls">
                            <asp:TextBox ID="txtSearchProductId" runat="server" CssClass=""
                                Width="180"></asp:TextBox>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">
                            Date</label>
                        <div class="controls">
                            <div class="input-prepend">
                                <span class="add-on">From</span><asp:TextBox CssClass="txtStartDate" ID="txtStartDate"
                                    runat="server" Width="150px"></asp:TextBox>
                            </div>
                            <div class="input-prepend">
                                <span class="add-on">To</span><asp:TextBox CssClass="txtEndDate" ID="txtEndDate"
                                    runat="server" Width="150px"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                    <div class="form-actions">
                        <asp:Button ID="btnSearchLeads" runat="server" Text="Search"
                            CssClass="btn" ValidationGroup="VendorSearch" OnClick="btnSearchLeads_Click" />
                        <asp:Button ID="btnResetLeads" runat="server" Text="Reset"
                            CssClass="btn" OnClick="btnResetLeads_Click" />
                    </div>
                </div>
            </div>
        
		    <br />
			<div>
				<asp:CheckBox ID="chkShowAll" runat="server" AutoPostBack="True" OnCheckedChanged="chkShowAll_CheckedChanged"
					Text="Show all deployed and non deployed leads" /></div>
			<br />
			<asp:GridView ID="gvLeads" runat="server" AutoGenerateColumns="false" Width="100%"
				CssClass="common_data_grid table table-bordered" OnRowDataBound="gvLeads_RowDataBound"
				OnRowCommand="gvLeads_RowCommand">
				<Columns>
					<asp:TemplateField HeaderText="ID" ControlStyle-Width="40px">
						<ItemTemplate>
							<asp:Label ID="lblLeadId" runat="server"></asp:Label>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField HeaderText="Status">
						<ItemTemplate>
							<asp:Label ID="lblLeadStatus" runat="server"></asp:Label>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField HeaderText="Created" ControlStyle-Width="50px">
						<ItemTemplate>
							<asp:Label ID="lblCreated" runat="server"></asp:Label>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField HeaderText="Product" ControlStyle-Width="100px">
						<ItemTemplate>
							<asp:Label ID="lblProductName" runat="server"></asp:Label>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField HeaderText="User name" ControlStyle-Width="100px">
						<ItemTemplate>
							<asp:Label ID="lblUserName" runat="server"></asp:Label>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField HeaderText="Address" ControlStyle-Width="100px">
						<ItemTemplate>
							<asp:Label ID="lblAddress" runat="server"></asp:Label>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField HeaderText="Phone" ControlStyle-Width="60px">
						<ItemTemplate>
							<asp:Label ID="lblPhone" runat="server"></asp:Label>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField HeaderText="Email">
						<ItemTemplate>
							<asp:Label ID="lblEmail" runat="server"></asp:Label>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField>
						<ItemTemplate>
							<asp:LinkButton ID="lbtnVerify" runat="server" CommandName="Verify" CausesValidation="false">
								<asp:Image ID="imgVerify" runat="server" ImageUrl="~/Images/Verify.gif" AlternateText="Verify"
									Width="16" Height="16" />
							</asp:LinkButton>
							<asp:LinkButton ID="lbtnDelete" runat="server" CommandName="DeleteLead" CausesValidation="false">
								<asp:Image ID="imgDelete" runat="server" ImageUrl="~/Images/Delete.gif" AlternateText="Delete"
									Width="16" Height="16" />
							</asp:LinkButton>
						</ItemTemplate>
					</asp:TemplateField>
				</Columns>
				<EmptyDataTemplate>
					There aren’t any pending Leads.
				</EmptyDataTemplate>
			</asp:GridView>
			<asp:Panel ID="pnlPaging" runat="server">
				<asp:LinkButton ID="lbtnStart" runat="server" OnClick="lbtnStart_Click" CausesValidation="false"><<</asp:LinkButton>
				<asp:LinkButton ID="lbtnPrev" runat="server" OnClick="lbtnPrev_Click" CausesValidation="false"><</asp:LinkButton>
				<asp:Label ID="lblCurrent" runat="server"></asp:Label>
				<asp:LinkButton ID="lbtnNext" runat="server" OnClick="lbtnNext_Click" CausesValidation="false">></asp:LinkButton>
				<asp:LinkButton ID="lbtnEnd" runat="server" OnClick="lbtnEnd_Click" CausesValidation="false">>></asp:LinkButton>
                <asp:HiddenField runat="server" ID="hdnCurrentPage"/>
			</asp:Panel>
			<asp:LinkButton ID="lbtnDeployLeads" runat="server" CausesValidation="False" OnClick="lbtnDeployLeads_Click">Deploy Leads</asp:LinkButton>
		</div>
	</div>
	<asp:LinkButton ID="lbtnClose" runat="server" Visible="false" CssClass="button">Close</asp:LinkButton>
</asp:Content>
