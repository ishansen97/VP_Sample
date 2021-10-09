<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="CurrencyList.aspx.cs" Inherits="VerticalPlatformAdminWeb.Platform.Currency.CurrencyList" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
<div class="AdminPanelHeader">
		<h3>Currency List</h3>
	</div>
	<div class="AdminPanelContent">
		
		<div class="add-button-container"><asp:HyperLink ID="lnkAddCurrency" runat="server" CssClass="aDialog btn">Add Currency</asp:HyperLink></div>

		<div> 
    	<asp:GridView ID="gvCurrency" runat="server" AutoGenerateColumns="False" 
				CssClass="common_data_grid table table-bordered" onrowcommand="gvCurrency_RowCommand" 
				onrowdatabound="gvCurrency_RowDataBound" style="width:auto">
			<Columns>
				<asp:BoundField DataField="Id" HeaderText="ID" />
				<asp:BoundField DataField="Description" HeaderText="Description" />
				<asp:BoundField DataField="LocalSymbol" HeaderText="Local Symbol" />
				<asp:BoundField DataField="InternationalSymbol" 
					HeaderText="International Symbol" />
				<asp:TemplateField ItemStyle-Width="50">
					<ItemTemplate>
						<asp:HyperLink ID="lnkEdit" runat="server" CssClass="aDialog grid_icon_link edit" ToolTip="Edit">Edit</asp:HyperLink>
						<asp:LinkButton ID="lbtnDelete" runat="server" CommandName="DeleteCurrency" CssClass="grid_icon_link delete" ToolTip="Delete">Delete</asp:LinkButton>
					</ItemTemplate>
				</asp:TemplateField>
			</Columns>
		</asp:GridView>
		</div>
		<br />
	</div>
</asp:Content>
