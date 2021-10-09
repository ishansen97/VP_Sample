<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ProductDisplayStatusDetail.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Product.ProductDisplayStatusDetail" %>
<h4>
	Manage Product Display Status List</h4>
<hr />
<div class="dsDescription">
	<asp:Literal ID="ltlDescription" runat="server"></asp:Literal>
</div>
<div>
	<ul class="dsDefaltValues">
		<li>
			<asp:Literal ID="ltlDefaultRank" runat="server"></asp:Literal>
		</li>
		<li>
			<asp:Literal ID="ltlDefaultSearchRank" runat="server"></asp:Literal>
		</li>
	</ul>
</div>
<hr />
<div class="add-button-container">
	<asp:HyperLink ID="lnkAddDisplayStatus" runat="server" CssClass="aDialog btn">Add Display Status</asp:HyperLink></div>
<asp:GridView ID="gvProductDisplayStatus" runat="server" AutoGenerateColumns="False"
	Width="100%" OnRowDataBound="gvProductDisplayStatus_RowDataBound" CssClass="common_data_grid vender_details table table-bordered"
	EnableViewState="false" OnRowCommand="gvProductDisplayStatus_RowCommand">
	<Columns>
		<asp:BoundField HeaderText="Start Date" DataField="StartDate" DataFormatString="{0:d}" />
		<asp:BoundField HeaderText="End Date" DataField="EndDate" DataFormatString="{0:d}" />
		<asp:TemplateField HeaderText="New Product Rank">
			<ItemTemplate>
				<asp:Literal ID="ltlNewRank" runat="server"></asp:Literal>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="New Search Rank">
			<ItemTemplate>
				<asp:Literal ID="ltlNewSearchRank" runat="server"></asp:Literal>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField ShowHeader="False" ItemStyle-Width="50">
			<ItemTemplate>
				<asp:HyperLink ID="lnkEdit" runat="server" CssClass="aDialog grid_icon_link edit"
					ToolTip="Edit">Edit</asp:HyperLink>
				<asp:LinkButton ID="lbtnRemove" runat="server" CausesValidation="False" CommandName="Remove"
					OnClientClick="return confirm(&quot;Are you sure you want to remove this Display Status?&quot;);"
					Text="Remove" CssClass="grid_icon_link delete" ToolTip="Remove"></asp:LinkButton>
			</ItemTemplate>
		</asp:TemplateField>
	</Columns>
	<HeaderStyle HorizontalAlign="Center" />
	<EmptyDataTemplate>
		No Product Display Statuses.</EmptyDataTemplate>
</asp:GridView>
