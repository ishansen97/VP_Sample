<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="IPAddressList.aspx.cs"
	MasterPageFile="~/MasterPage.Master" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.SpiderManagement.IPAddressList" %>

<%@ Register Src="../Pager.ascx" TagName="Pager" TagPrefix="uc1" %>
<asp:Content ID="cntIPAddressList" ContentPlaceHolderID="cphContent" runat="server">
	<script type="text/javascript">
		$(document).ready(function () {
			$(".article_srh_btn").click(function () {
				$(".article_srh_pane").toggle("slow");
				$(this).toggleClass("hide_icon");
			});
		});
	</script>

	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>IP Address List</h3>
		</div>
		<div class="AdminPanelContent">
			<div class="article_srh_btn hide_icon">Filter</div>
			<br />
			<div id="divSearchPane" class="article_srh_pane" style="display: block;">
				<div class="form-horizontal">
					<div class="control-group">
						<label class="control-label"><asp:Literal ID="ltlIPGroup" runat="server" Text="IP Group"></asp:Literal></label>
						<div class="controls">
							<asp:DropDownList ID="ddlGroup" runat="server" ValidationGroup="searchGroup" 
								Width="150" AppendDataBoundItems="True">
								<asp:ListItem Value="-1">- Select Group -</asp:ListItem>
							</asp:DropDownList>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label"><asp:Literal ID="ltlStatus" runat="server" Text="Status"></asp:Literal></label>
						<div class="controls">
							<asp:DropDownList ID="ddlStatus" runat="server" ValidationGroup="searchGroup" 
								Width="150" AppendDataBoundItems="True">
								<asp:ListItem Value="-1">- Select Status -</asp:ListItem>
							</asp:DropDownList>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label"><asp:Literal ID="ltlPeriod" runat="server" Text="Period"></asp:Literal></label>
						<div class="controls">
							<asp:DropDownList ID="ddlPeriod" runat="server" ValidationGroup="searchGroup" 
								Width="150" AppendDataBoundItems="True">
								<asp:ListItem Value="-1">- Select Period -</asp:ListItem>
							</asp:DropDownList>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label"><asp:Literal ID="ltlIpAddress" runat="server" Text="IP Address/Numeric"></asp:Literal></label>
						<div class="controls">
							<asp:Textbox ID="txtIPAddress" runat="server" ValidationGroup="searchGroup" 
								Width="139">
							</asp:Textbox>
							<asp:RegularExpressionValidator ID="revIPAddress" runat="server"
								ErrorMessage="Please enter a valid IP Address or it's first two or three octet values or a IP Numeric." ControlToValidate="txtIPAddress" validationGroup = "searchGroup"
								ValidationExpression="\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){1,3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b|(\+)?[1-9][0-9]*\b">*</asp:RegularExpressionValidator>
						</div>
					</div>
					<div class="form-actions">
						<asp:Button ID="btnSearch" runat="server" OnClick="btnSearch_Click" Text="Search"
								ValidationGroup="searchGroup" CssClass="btn" />
							<asp:Button ID="btnReset" runat="server" OnClick="btnReset_Click" Text="Reset Filter"
								CssClass="btn" />
					</div>
				</div>
			</div>
			<br />
			<div class="add-button-container">
				<asp:HyperLink ID="lnkAddNewIP" runat="server" CssClass="aDialog btn" 
					Style="margin-right: 5px;">Add New IP Address</asp:HyperLink>
			</div>
			<asp:GridView ID="gvIPAddressList" runat="server" AutoGenerateColumns="false" OnRowDataBound="gvIPAddressList_RowDataBound"
				OnRowCommand="gvIPAddressList_RowCommand" CssClass="common_data_grid table table-bordered" EnableViewState="false">
				<AlternatingRowStyle CssClass="DataTableRowAlternate" />
				<RowStyle CssClass="DataTableRow" />
				<Columns>
					<asp:BoundField HeaderText="IP Address" DataField="IpAddress" ItemStyle-Width="150">
					</asp:BoundField>
					<asp:TemplateField HeaderText="IP Group" ItemStyle-Width="150">
						<ItemTemplate>
							<asp:Literal ID="ltlIPGroup" runat="server"></asp:Literal>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField HeaderText="Status" ItemStyle-Width="100">
						<ItemTemplate>
							<asp:Literal ID="ltlStatus" runat="server"></asp:Literal>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:BoundField HeaderText="Description" DataField="Description" ItemStyle-Width="150">
					</asp:BoundField>
					<asp:BoundField HeaderText="Created" DataField="Created" DataFormatString="{0:d}"
						SortExpression="Created" ItemStyle-Width="60"></asp:BoundField>
					<asp:BoundField HeaderText="Modified" DataField="Modified" DataFormatString="{0:d}"
						SortExpression="Modified" ItemStyle-Width="60"></asp:BoundField>
					<asp:TemplateField ItemStyle-Width="50">
						<ItemTemplate>
							<asp:HyperLink ID="lnkEdit" runat="server" CssClass="aDialog grid_icon_link edit"
								ToolTip="Edit">Edit</asp:HyperLink>&nbsp;
							<asp:LinkButton ID="lbtnDelete" runat="server" CommandName="DeleteRow" CssClass="deleteLocation grid_icon_link delete"
								ToolTip="Delete" OnClientClick="return confirm('Are you sure to delete the IP address?');">Delete</asp:LinkButton>
						</ItemTemplate>
					</asp:TemplateField>
				</Columns>
				<EmptyDataTemplate>
					No IP Addresses found.
				</EmptyDataTemplate>
			</asp:GridView>
			<asp:HiddenField ID="hdnIPId" runat="server" />
			<br />
			<uc1:Pager ID="pagerIPAddresses" runat="server" />
			<br />
		</div>
	</div>
</asp:Content>
