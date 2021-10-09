	<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ProductSummaryControl.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Vendors.ProductSummaryControl" %>

	<%@ Register Src="../Pager.ascx" TagName="Pager" TagPrefix="uc1" %>

	<script src="../../Js/JQuery/jquery.pager.js" type="text/javascript"></script>
	<script type="text/javascript">
	var ipList = null;
	$(document).ready(function() {
		$(".minimized_btn", this).click(function() {
			$(".minimized_div").toggleClass("expanded");
			$(this).toggleClass("collaps_icon");
		});
	});
	</script>


	<div class="campaign_summary clearfix">
	<div class="left reports">
		<ul>
			<li>
				<asp:LinkButton runat="server" Id="lbtnMiniized" onclick="lbtn_Click" 
							CommandArgument="1" Text="Minimized Products"></asp:LinkButton>
							<asp:Label ID="lblMinimized" runat="server" Text="0"></asp:Label>
			</li> 
			<li>
				<asp:LinkButton runat="server" Id="lbtnStandard" onclick="lbtn_Click" 
							CommandArgument="2" Text="Standard Products"></asp:LinkButton>
							<asp:Label ID="lblStandard" runat="server" Text="0"></asp:Label>
			</li>
			<li>
				<asp:LinkButton runat="server" Id="lbtnFeatured" onclick="lbtn_Click" 
							CommandArgument="3" Text="Featured Products"></asp:LinkButton>
							<asp:Label ID="lblFeatured" runat="server" Text="0"></asp:Label>
			</li>
			<li>
				<asp:LinkButton runat="server" Id="lbtnFeaturedPlus" onclick="lbtn_Click" 
							CommandArgument="4" Text="Featured Plus Products"></asp:LinkButton>
							<asp:Label ID="lblFeaturedPlus" runat="server" Text="0"></asp:Label>
			</li>
			<li>
				<asp:LinkButton runat="server" Id="lbtnTotal" onclick="lbtn_Click" 
							CommandArgument="5" Text="Total Products"></asp:LinkButton>
							<asp:Label ID="lblTotal" runat="server" Text="0"></asp:Label>
			</li>
			<li>
					<asp:LinkButton runat="server" Id="lbtnLive" onclick="lbtn_Click" 
							CommandArgument="6" Text="Total Live Products"></asp:LinkButton>
							<asp:Label ID="lblLive" runat="server" Text="0"></asp:Label>    
			</li>
		</ul>
		<br />
		<asp:Button ID="btnAddProduct" runat="server" Text="Add Product"
					Width="105px" CssClass="btn" 
					onclick="btnAddProduct_Click" />
	</div>
	<div class="content">
			<div><asp:Label ID = "lblGridTitle" runat="server" Font-Bold="true"></asp:Label></div>
			<br />	
			<asp:GridView ID="gvProducts" runat="server" AutoGenerateColumns="False" 
				AllowSorting="True" EnableViewState="False" CssClass="common_data_grid auto_width" 
				onrowdatabound="gvProducts_RowDataBound">
				<SelectedRowStyle HorizontalAlign="Left" />
				<AlternatingRowStyle CssClass="DataTableRowAlternate" />
				<RowStyle CssClass="DataTableRow" />
				<Columns>
					<asp:TemplateField>
						<ItemTemplate>
							<asp:ImageButton ID="ibtnProductEnable" runat="server" OnClick="ibtnProductEnable_Click"
								CssClass="enable_disable_button"/>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField HeaderText="Product Id">
						<ItemTemplate>
							<asp:Literal ID="ltlProductIdColumn" runat="server"></asp:Literal>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:BoundField HeaderText="Catalog Number" DataField="CatalogNumber">
					
					</asp:BoundField>
					<asp:BoundField HeaderText="Product Name" DataField="Name">
					</asp:BoundField>
					<asp:TemplateField>
						<ItemTemplate>
							<asp:HyperLink ID="lnkMultimediaItem" runat="server" CssClass="aDialog">Multimedia</asp:HyperLink>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField>
						<ItemTemplate>
							<asp:HyperLink ID="lnkLeadForm" runat="server" CssClass="grid_icon_link form" ToolTip="Lead Form">Lead&nbsp;Form</asp:HyperLink>
							<asp:HyperLink ID="lnkEdit" runat="server" CssClass="grid_icon_link edit" ToolTip="Edit">Edit</asp:HyperLink>
						</ItemTemplate>
						
					</asp:TemplateField>
					
				</Columns>
				<EmptyDataTemplate>
					No Vendor Associated Products Found.
				</EmptyDataTemplate>
			</asp:GridView>
			<br />
			<uc1:Pager ID="pagerProducts" runat="server" OnPageIndexClickEvent="pagerProducts_PageIndexClick"/>
			<asp:HiddenField Id="hdnSelectedStatus" runat="server" />
		</div>
	</div>
