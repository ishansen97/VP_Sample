<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LeadMaintenance.aspx.cs"
	MasterPageFile="~/MasterPage.Master" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Lead.LeadMaintenance" %>

<%@ Register Src="../Pager.ascx" TagName="Pager" TagPrefix="uc1" %>
<asp:Content ID="conContent" ContentPlaceHolderID="cphContent" runat="server">
	<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>
	<script src="../../Js/Lead/LeadMaintenance.js" type="text/javascript"></script>
	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3><asp:Label ID="lblHeader" runat="server" Text="Lead Maintenance" BackColor="Transparent"></asp:Label></h3>
			<div id="divSearchPane" class="article_srh_pane" style="display: block;">
				<div class="form-horizontal">
					<div class="control-group">
						<label class="control-label">Lead Id</label>
						<div class="controls">
							<asp:TextBox ID="txtLeadId" runat="server" Width="150px" ValidationGroup="FilterList"></asp:TextBox>
							<asp:RegularExpressionValidator  ID="rvLeadId" runat="server" ValidationGroup="FilterList" controltovalidate="txtLeadId"
								ErrorMessage="Please enter a valid lead id." ValidationExpression="^[0-9]*[1-9][0-9]*$" />
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">
							Date</label>
						<div class="controls">
							<div class="input-prepend">
								<span class="add-on">From</span><asp:TextBox CssClass="txtStartDate" ID="txtStartDate"
									runat="server" Width="150px" ValidationGroup="FilterList"></asp:TextBox>
							</div>
							<div class="input-prepend">
								<span class="add-on">To</span><asp:TextBox CssClass="txtEndDate" ID="txtEndDate"
									runat="server" Width="150px" ValidationGroup="FilterList"></asp:TextBox>
							</div>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">Product Id</label>
						<div class="controls">
							<asp:TextBox ID="txtleadProductId" runat="server" Width="150px" ValidationGroup="FilterList"></asp:TextBox>
							<asp:RegularExpressionValidator  ID="rvLeadProductId" runat="server" ValidationGroup="FilterList" ControlToValidate="txtleadProductId" 
								ErrorMessage="Please enter a valid product id." ValidationExpression="^[0-9]*[1-9][0-9]*$" />
						</div>
					</div>
					<!---->
					<div class="form-actions">
						<asp:Button ID="btnfilter" runat="server" Text="Filter" ValidationGroup="FilterList" OnClick="btnfilter_Click" CssClass="btn" />
						<asp:Button ID="btnReset" runat="server" Text="Reset" OnClick="btnReset_Click" CssClass="btn" />
					</div>
				</div>
			</div>
		</div>
		<div class="AdminPanelContent">
			<asp:UpdateProgress ID="UpdateProgress1" runat="server">
				<ProgressTemplate>
					<asp:Image ID="imgProgress" runat="server" ImageUrl="~/Images/Progress.gif" />
				</ProgressTemplate>
			</asp:UpdateProgress>
			<div class="add-button-container">
                <asp:Button ID="btnSendTop" runat="server" Text="Send" OnClick="btnSendTop_Click"
				    CssClass="btn" OnClientClick="return confirm('Are you sure to send the selected leads?')" />&nbsp;
			    <asp:Button ID="btnDeleteTop" runat="server" Text="Delete" OnClick="btnDeleteTop_Click"
				    CssClass="btn" OnClientClick="return confirm('Are you sure to Delete the selected leads?')" />
			</div>
			<asp:GridView ID="gvLeads" runat="server" AutoGenerateColumns="false" OnDataBound="gvLeads_DataBound"
				Width="100%" OnRowCommand="gvLeads_RowCommand" CssClass="common_data_grid table table-bordered">
				<Columns>
					<asp:TemplateField>
						<ItemTemplate>
							<asp:CheckBox ID="chkSelect" runat="server" />
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField HeaderText="ID" ControlStyle-Width="30px">
						<ItemTemplate>
							<asp:Label ID="lblLeadId" runat="server"></asp:Label>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField HeaderText="Created" ControlStyle-Width="50px">
						<ItemTemplate>
							<asp:Label ID="lblCreated" runat="server"></asp:Label>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField HeaderText="Product" ControlStyle-Width="150px">
						<ItemTemplate>
							<asp:Label ID="lblProductName" runat="server"></asp:Label>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField HeaderText="User Name" ControlStyle-Width="100px">
						<ItemTemplate>
							<asp:Label ID="lblUserName" runat="server"></asp:Label>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField HeaderText="Address" ControlStyle-Width="100px">
						<ItemTemplate>
							<asp:Label ID="lblAddress" runat="server"></asp:Label>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField HeaderText="Phone" ControlStyle-Width="100px">
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
							</asp:LinkButton></ItemTemplate>
					</asp:TemplateField>
				</Columns>
				<EmptyDataTemplate>
					No Leads found.
				</EmptyDataTemplate>
			</asp:GridView>
			<uc1:Pager ID="pgLead" runat="server" OnPageIndexClickEvent="pgLead_PageIndexClick" />
			<br />
			<asp:Button ID="btnSendBottom" runat="server" Text="Send" OnClick="btnSendBottom_Click"
				CssClass="common_text_button" OnClientClick="return confirm('Are you sure to send the selected leads?')" />&nbsp;
			<asp:Button ID="btnDeleteBottom" runat="server" Text="Delete" OnClick="btnDeleteBottom_Click"
				CssClass="common_text_button" OnClientClick="return confirm('Are you sure to Delete the selected leads?')" />
		</div>
	</div>
</asp:Content>
