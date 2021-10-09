<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="VendorList.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Lead.VendorList"
	Title="Untitled Page" %>

<%@ Register src="../Pager.ascx" tagname="Pager" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">

	<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>
	
	<script src="../../Js/JQuery/jquery.pager.js" type="text/javascript"></script>

	<script src="../../Js/ContentPicker.js" type="text/javascript"></script>
	
	<script type="text/javascript">
		$(document).ready(function() {
		var vendorNameOptions = { siteId: VP.SiteId, type: "Vendor", currentPage: "1", pageSize: "15", showName: "true" };
		$("input[type=text][id*=txtSearchVendors]").contentPicker(vendorNameOptions);
		});
	</script>

	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>
				<asp:Label ID="lblHeader" runat="server" Text="Vendors" BackColor="Transparent"></asp:Label></h3>
		</div>
		<div class="AdminPanelContent">
		<div class="inline-form-container" id="divSearch">
					<span class="title">Search</span>
					<asp:TextBox ID="txtSearchVendors" runat="server" 
						CssClass="searchVendorTextBox"></asp:TextBox><asp:RequiredFieldValidator
						ID="rfvSearchVendors" runat="server" ErrorMessage="Please enter vendor name." ControlToValidate="txtSearchVendors"
						ValidationGroup="VendorSearch">*</asp:RequiredFieldValidator>
					<asp:Button ID="btnSearchVendors" runat="server" Text="Search" OnClick="btnSearchVendors_Click"
						ValidationGroup="VendorSearch" CssClass="btn" />
					<asp:Button ID="btnAllVendors" runat="server" Text="All Vendors" OnClick="btnAllVendors_Click" CssClass="btn" />
				</div>
				<br />
			<asp:GridView ID="gvVendors" runat="server" AutoGenerateColumns="False" OnRowDataBound="gvVendors_DataBound" AllowSorting="True" OnSorting="gvVendors_Sorting" CssClass="common_data_grid table table-bordered" style="width:auto">
				<Columns>
					<asp:BoundField DataField="Id" HeaderText="ID" ItemStyle-Width="50px" SortExpression="id">
						<ItemStyle Width="50px"></ItemStyle>
					</asp:BoundField>
					<asp:TemplateField HeaderText="Vendor" ControlStyle-Width="200px" SortExpression="Name">
						<ItemTemplate>
							<asp:HyperLink ID="lnkVendor" runat="server"></asp:HyperLink>
						</ItemTemplate>
						<ControlStyle Width="200px"></ControlStyle>
					</asp:TemplateField>
					<asp:TemplateField HeaderText="Created Leads">
						<ItemTemplate>
							<asp:Literal ID="ltlCreated" runat="server"></asp:Literal>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField HeaderText="Confirmed Leads">
						<ItemTemplate>
							<asp:Literal ID="ltlConfirmed" runat="server"></asp:Literal>
						</ItemTemplate>
					</asp:TemplateField>
				</Columns>
			</asp:GridView>
			<br />
			<uc1:Pager ID="Pager1" runat="server" />
		</div>
	</div>
</asp:Content>
