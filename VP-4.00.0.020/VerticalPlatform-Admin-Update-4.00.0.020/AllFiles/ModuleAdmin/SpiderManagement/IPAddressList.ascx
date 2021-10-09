<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="IPAddressList.ascx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.SpiderManagement.IPAddressList" %>

<%@ Register Src="../Pager.ascx" TagName="Pager" TagPrefix="uc1" %>


<div class="AdminPanel">
	<div class="AdminPanelContent">
		<asp:GridView ID="gvIPList" runat="server" AutoGenerateColumns="false"
			 CssClass="common_data_grid inner_table" EmptyDataText="There is no data to display." 
		 onrowdatabound="gvIPList_RowDataBound">
			<RowStyle CssClass="DataTableRow" />
			<AlternatingRowStyle CssClass="DataTableRowAlternate" />
			<Columns>
				<asp:BoundField HeaderText="IP Address" DataField="IpAddress" ItemStyle-Width="150" >
					<ItemStyle Width="150px" />
				</asp:BoundField>
				<asp:TemplateField HeaderText="Status">
						<ItemTemplate>
							<asp:Literal ID="ltlStatus" runat="server"></asp:Literal>
						</ItemTemplate>
					</asp:TemplateField>
				<asp:BoundField HeaderText="Description" DataField="Description">
					<ItemStyle/>
				</asp:BoundField>
				<asp:TemplateField ItemStyle-Width="50px" >
					<ItemTemplate>
						<asp:HyperLink ID="lnkEdit" runat="server" CssClass="aDialog" >Edit</asp:HyperLink>&nbsp;
						<asp:HyperLink ID="lnkDelete" runat="server" CssClass="aDialog" >Delete</asp:HyperLink>
					</ItemTemplate>
					<ItemStyle Width="100px" />
				</asp:TemplateField>
			</Columns>
		</asp:GridView>
		<asp:HiddenField ID="hdnIPId" runat="server" />
		<br/>
		<uc1:Pager ID="pagerIPAddresses" runat="server" RecordsPerPage="10" PostBackPager = "true" 
			OnPageIndexClickEvent="PagerIPAddresses_PagerIndexClick" />
	</div>
</div>