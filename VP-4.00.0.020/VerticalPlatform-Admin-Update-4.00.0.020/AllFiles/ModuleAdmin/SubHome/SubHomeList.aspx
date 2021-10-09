<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="SubHomeList.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.SubHome.SubHomeList"
	Title="Subhome List" %>
	

<asp:Content ID="cntSubHomeList" ContentPlaceHolderID="cphContent" runat="server">
<script type="text/javascript">
	$(document).ready(function() {

	$(".up").live('click', function() {
			
			var current = $(this).parents('tr[class*="row_"]');
			var prev = $(this).parents('tr').prev('tr[class*="row_"]');
			if(prev.length != 0) {
				var curent_row_class = $(this).parents('tr').attr('class');
				var swap_row_class = $(this).parents('tr').prev('tr').attr('class');
				var curent_row = curent_row_class.split('_');
				var swap_row = swap_row_class.split('_');
				
				$.ajax({
						type: "POST",
						async: false,
						cache: false,
						url: VP.AjaxWebServiceUrl + "/UpdateSubhomeOrderSort",
						dataType: "json",
						contentType: "application/json; charset=utf-8",
						data: "{'currentSubhomeId' : " + parseInt(curent_row[1]) + ", 'swapSubhomeId' : " + parseInt(swap_row[1]) + "}",
						success: function(msg) {
							
							var current_sort_order = current.children('td')[3].innerHTML.trim();
							current.children('td')[3].innerHTML = prev.children('td')[3].innerHTML.trim();
							prev.children('td')[3].innerHTML = current_sort_order;
							
							current.after(prev);
						},
						error: function(xmlHttpRequest, textStatus, errorThrown) {
							document.location("../../Error.aspx");
						}
				});
				
			}
		});

		$(".down").live('click', function() {
			
			var current = $(this).parents('tr[class*="row_"]');
			var next = $(this).parents('tr').next('tr[class*="row_"]');
			if(next.length != 0) {
				var curent_row_class = $(this).parents('tr').attr('class');
				var swap_row_class = $(this).parents('tr').next('tr').attr('class');
				var curent_row = curent_row_class.split('_');
				var swap_row = swap_row_class.split('_');
				
				$.ajax({
						type: "POST",
						async: false,
						cache: false,
						url: VP.AjaxWebServiceUrl + "/UpdateSubhomeOrderSort",
						dataType: "json",
						contentType: "application/json; charset=utf-8",
						data: "{'currentSubhomeId' : " + parseInt(curent_row[1]) + ", 'swapSubhomeId' : " + parseInt(swap_row[1]) + "}",
						success: function(msg) {
							var current_sort_order = current.children('td')[3].innerHTML.trim();
							current.children('td')[3].innerHTML = next.children('td')[3].innerHTML.trim();
							next.children('td')[3].innerHTML = current_sort_order;
							current.before(next);
						},
						error: function(xmlHttpRequest, textStatus, errorThrown) {
							document.location("../../Error.aspx");
						}
				});
			}
		});

	});
	</script>

	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3 style="text-transform:none;">
				<asp:Label ID="lblHeader" runat="server" BackColor="Transparent">List of Subhomes</asp:Label>
			</h3>
		</div>
		<div class="AdminPanelContent">
			<asp:Panel ID="pnlSubHomeList" runat="server">
				<div class="add-button-container"><asp:HyperLink ID="lnkAdd" runat="server" CssClass="aDialog btn">Add Subhome</asp:HyperLink></div>
				
				<asp:GridView ID="gvSubHomes" runat="server" AutoGenerateColumns="False" Width="100%"
					OnRowCommand="gvSubHomes_RowCommand" OnRowDataBound="gvSubHomes_RowDataBound"
					AllowSorting="True" OnSorting="gvSubHomes_Sorting" CssClass="common_data_grid table table-bordered" EnableViewState="false">
					<AlternatingRowStyle CssClass="DataTableRowAlternate" />
					<RowStyle CssClass="DataTableRow" />
					<Columns>
						<asp:BoundField HeaderText="ID" DataField="id" SortExpression="Id"/>
						<asp:BoundField HeaderText="Name" DataField="Name" />
						<asp:BoundField HeaderText="Display Name" DataField="DisplayName" SortExpression="Name" />
						<asp:TemplateField HeaderText="Display Order">
							<ItemTemplate>
								<asp:Label ID="lblSortOrder" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "SubHomeOrder") %>'></asp:Label>&nbsp;&nbsp;
								<a class="up common_link moveUpBtn" title="Up">&nbsp;</a><a class="down common_link moveDownBtn" title="Down">&nbsp;</a>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:BoundField HeaderText="Category ID" DataField="CategoryId" SortExpression="CatId" />
						<asp:TemplateField HeaderText="Category Name">
							<ItemTemplate>
								<asp:Label ID="lblCategoryName" runat="server"></asp:Label>
							</ItemTemplate>
							<ItemStyle Width="160px" />
						</asp:TemplateField>
						<asp:CheckBoxField HeaderText="Enabled" DataField="Enabled" />
						<asp:TemplateField ShowHeader="False">
							<ItemTemplate>
								<asp:HyperLink ID="lnkEdit" runat="server" CssClass="aDialog grid_icon_link edit" ToolTip="Edit">Edit</asp:HyperLink>
							    <asp:LinkButton ID="lbtnDelete" runat="server" CommandName="DeleteSubHome" CssClass="grid_icon_link delete" ToolTip="Delete">Delete</asp:LinkButton>
							</ItemTemplate>
							<ItemStyle HorizontalAlign="Left" />
						</asp:TemplateField>
						
					</Columns>
					<EmptyDataTemplate>
						No Subhomes found.
					</EmptyDataTemplate>
				</asp:GridView>
			</asp:Panel>
		</div>
	</div>
</asp:Content>
