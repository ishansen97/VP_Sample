<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="VendorAnalyticsLanding.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Vendors.VendorAnalyticsLanding"
	Title="Untitled Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">

	<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>

	<script type="text/javascript">
		$(document).ready(function() {
			$(".vendorAnalyticsDatePicker").datepicker(
			{
				changeYear: true
			});
			
			$('.toggleLables').live('click', function() {
				$(this).next().slideToggle("slow");
			});
		});

	</script>

	<div id="analyticsDiv" runat="server">
		<asp:HyperLink ID="lnkBackToVendorList" runat="server" class="displayMsg" NavigateUrl="~/ModuleAdmin/Vendors/VendorList.aspx"><< Back to vendor Page</asp:HyperLink>
		<br />
		<br />
		<div class="tablediv">
			<br />
			<div>
				<asp:Label ID="lblVendorName" Text="Vendor Analytics" class="displayMsgHeader" runat="server" />
			</div>
			<br />
			<table>
				<tr>
					<td>
						<asp:Label ID="Label1" runat="server" Text="From Date :" class="displayMsg"></asp:Label>
					</td>
					<td>
						<asp:TextBox ID="txtFromDate" runat="server" class="displayMsg vendorAnalyticsDatePicker"></asp:TextBox>
						
					</td>
				</tr>
				<tr>
					<td>
						<asp:Label ID="Label2" runat="server" Text="To Date :" class="displayMsg"></asp:Label>
					</td>
					<td>
						<asp:TextBox ID="txtToDate" runat="server" class="displayMsg vendorAnalyticsDatePicker"></asp:TextBox>
						
					</td>
				</tr>
			</table>
			<br />
			<div>
				<asp:Button ID="btnProcess" runat="server" Text="Process" OnClick="btnProcess_Click"
					CssClass="common_text_button" />
			</div>
			<br />
		</div>
		<br />
		<div id="divResults" visible="false" runat="server">
							<div class="toggleLables"><asp:Label ID="lblContactLeads" runat="server" Text="" CssClass=""></asp:Label></div>
							<div class="AdminPanelContent" id="divContactLeads">
								<asp:GridView ID="gvContactLeads" runat="server" AutoGenerateColumns="False" DataKeyNames="ProductId"
									OnDataBound="gvContactLeads_DataBound" CssClass="common_data_grid" style="width:auto; min-width:300px;">
									<AlternatingRowStyle CssClass="GridAltItem" />
									<HeaderStyle CssClass="GridHeader"></HeaderStyle>
									<RowStyle CssClass="GridItem" />
									<Columns>
										<asp:TemplateField HeaderText="Product Name" HeaderStyle-Height="25px" ItemStyle-CssClass="accordionGridItemOneStyle">
											<ItemTemplate>
												<asp:Label ID="lblProductName" runat="server" Text="Label"></asp:Label>
											</ItemTemplate>
										</asp:TemplateField>
										<asp:BoundField DataField="Total" ItemStyle-CssClass="accordionGridItemTwoStyle"
											HeaderStyle-Height="25px" />
									</Columns>
									<EmptyDataTemplate>
										<div class="displayMsg">
											There are "0" contact lead details...</div>
									</EmptyDataTemplate>
								</asp:GridView>
							</div><br />
					
							<div class="toggleLables"><asp:Label ID="lblClickthroughs" runat="server" Text="" CssClass=""></asp:Label></div>
							<div class="AdminPanelContent" id="divClickthroughs">
								<asp:GridView ID="gvClickthroughs" runat="server" AutoGenerateColumns="False" DataKeyNames="UrlId"
									OnDataBound="gvClickthroughs_DataBound" CssClass="common_data_grid" style="width:auto; min-width:300px;">
									<AlternatingRowStyle CssClass="GridAltItem" />
									<HeaderStyle CssClass="GridHeader"></HeaderStyle>
									<RowStyle CssClass="GridItem" />
									<Columns>
										<asp:TemplateField HeaderText="URL Name" ItemStyle-CssClass="accordionGridItemOneStyle"
											HeaderStyle-Height="25px">
											<ItemTemplate>
												<asp:Label ID="lblUrlName" runat="server" Text="Label"></asp:Label>
											</ItemTemplate>
										</asp:TemplateField>
										<asp:BoundField DataField="Total" ItemStyle-CssClass="accordionGridItemTwoStyle"
											HeaderStyle-Height="25px" />
									</Columns>
									<EmptyDataTemplate>
										<div class="displayMsg">
											There are "0" click through details...</div>
									</EmptyDataTemplate>
								</asp:GridView>
							</div><br />

							<div class="toggleLables"><asp:Label ID="lblItemDetailsPageViews" runat="server" Text="" CssClass=""></asp:Label></div>
							<div class="AdminPanelContent" id="divItemDetailsPageViews">
								<asp:GridView ID="gvItemDetailPageViews" runat="server" AutoGenerateColumns="False"
									OnDataBound="gvItemDetailPageViews_DataBound" DataKeyNames="ProductId" CssClass="common_data_grid" style="width:auto; min-width:300px;">
									<AlternatingRowStyle CssClass="GridAltItem" />
									<HeaderStyle CssClass="GridHeader"></HeaderStyle>
									<RowStyle CssClass="GridItem" />
									<Columns>
										<asp:TemplateField HeaderText="Product Name" ItemStyle-CssClass="accordionGridItemOneStyle"
											HeaderStyle-Height="25px">
											<ItemTemplate>
												<asp:Label ID="lblProductName" runat="server" Text="Label"></asp:Label>
											</ItemTemplate>
										</asp:TemplateField>
										<asp:BoundField DataField="Total" ItemStyle-CssClass="accordionGridItemTwoStyle"
											HeaderStyle-Height="25px" />
									</Columns>
									<EmptyDataTemplate>
										<div class="displayMsg">
											There are "0" Item Detail Page View details...</div>
									</EmptyDataTemplate>
								</asp:GridView>
							</div><br />
		</div>
	</div>
</asp:Content>
