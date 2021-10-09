<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddMultimediaItem.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Product.AddMultimediaItem" %>
	
	<script type="text/javascript">
		$(document).ready(function() {

			$(".up").live('click', function() {

				var current = $(this).parents('tr[class*="row_"]');
				var prev = $(this).parents('tr').prev('tr[class*="row_"]');
				var upDownEnabled = $('[id*=hdnEnabledUpDown]').val();

				if (prev.length != 0 && upDownEnabled == 'true') {
					var curent_row_class = $(this).parents('tr').attr('class');
					var swap_row_class = $(this).parents('tr').prev('tr').attr('class');
					var curent_row = curent_row_class.split('_');
					var swap_row = swap_row_class.split('_');

					$.ajax({
						type: "POST",
						async: false,
						cache: false,
						url: VP.AjaxWebServiceUrl + "/UpdateMultimediaItemSort",
						dataType: "json",
						contentType: "application/json; charset=utf-8",
						data: "{'currentItemId' : " + parseInt(curent_row[1]) + ", 'swapItemId' : " + parseInt(swap_row[1]) + "}",
						success: function(msg) {
							var current_sort_order = current.children('td')[8].innerHTML.trim();
							current.children('td')[8].innerHTML = prev.children('td')[8].innerHTML.trim();
							prev.children('td')[8].innerHTML = current_sort_order;

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
				var upDownEnabled = $('[id*=hdnEnabledUpDown]').val();

				if (next.length != 0 && upDownEnabled == 'true') {
					var curent_row_class = $(this).parents('tr').attr('class');
					var swap_row_class = $(this).parents('tr').next('tr').attr('class');
					var curent_row = curent_row_class.split('_');
					var swap_row = swap_row_class.split('_');

					$.ajax({
						type: "POST",
						async: false,
						cache: false,
						url: VP.AjaxWebServiceUrl + "/UpdateMultimediaItemSort",
						dataType: "json",
						contentType: "application/json; charset=utf-8",
						data: "{'currentItemId' : " + parseInt(curent_row[1]) + ", 'swapItemId' : " + parseInt(swap_row[1]) + "}",
						success: function(msg) {
							var current_sort_order = current.children('td')[8].innerHTML.trim();
							current.children('td')[8].innerHTML = next.children('td')[8].innerHTML.trim();
							next.children('td')[8].innerHTML = current_sort_order;
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
<div>
	<table>
		<tr>
			<td>
				Multimedia Type
			</td>
			<td>
				<asp:DropDownList ID="ddlMultimediaType" runat="server" OnSelectedIndexChanged="ddlMultimediaType_SelectedIndexChanged"
					AutoPostBack="True">
				</asp:DropDownList>
			</td>
		</tr>
		<tr>
			<td>
				<asp:Literal ID="ltlMediaItem" Text="Image Name" runat="server"></asp:Literal>
			</td>
			<td>
				<asp:TextBox ID="txtName" runat="server" Width="400px"></asp:TextBox>
				<asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName"
					ErrorMessage="Please enter media item name." Font-Bold="True" ValidationGroup="save">*</asp:RequiredFieldValidator>
			</td>
		</tr>
		<tr>
			<td>
				Title
			</td>
			<td>
				<asp:TextBox ID="txtTitle" runat="server" Width="400px"></asp:TextBox>
			</td>
		</tr>
		<tr>
			<td>
				Thumbnail Image Link
			</td>
			<td>
				<asp:TextBox ID="txtThumbnailLink" runat="server" Width="400px"></asp:TextBox>
				<asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtThumbnailLink"
					ErrorMessage="Please enter thumbnail link." Font-Bold="True" ValidationGroup="save">*</asp:RequiredFieldValidator>
			</td>
		</tr>
		<tr>
			<td>
				Link Type
			</td>
			<td>
				<asp:DropDownList ID="ddlLinkType" runat="server">
				</asp:DropDownList>
			</td>
		</tr>
		<tr>
			<td>
				Target Link
			</td>
			<td>
				<asp:TextBox ID="txtTargetLink" runat="server" Width="400px"></asp:TextBox>
			</td>
		</tr>
		<tr>
			<td>
				Sort Order
			</td>
			<td>
				<asp:TextBox ID="txtSortOrder" runat="server" ></asp:TextBox>
				<asp:RequiredFieldValidator ID="rfvSortOrder" runat="server" ControlToValidate="txtSortOrder"
					ErrorMessage="Please enter sort order." Font-Bold="True" ValidationGroup="save">*</asp:RequiredFieldValidator>
				<asp:CompareValidator ID="cvSortOrder" ControlToValidate="txtSortOrder" Operator="DataTypeCheck"
					Type="Integer" runat="server" ErrorMessage="Sort order should be a number." ValidationGroup="save">*</asp:CompareValidator>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<asp:Button ID="btnSave" runat="server" Text="Save" ValidationGroup="save" onclick="btnSave_Click" CssClass="common_text_button" />
				<asp:Button ID="btnReset" runat="server" Text="Reset" 
					onclick="btnReset_Click" CssClass="common_text_button" />
				<asp:HiddenField ID="hdnEnabledUpDown" runat="server" Value="true" />
			</td>
		</tr>
	</table>
	<br />
	<asp:GridView ID="gvMultimediaItems" runat="server" AutoGenerateColumns="False"
		OnRowDataBound="gvMultimediaItems_RowDataBound" OnRowCommand="gvMultimediaItems_RowCommand"
		CssClass="common_data_grid">
		<Columns>
			<asp:TemplateField HeaderText="Id">
				<ItemTemplate>
					<asp:Literal ID="ltlId" runat="server"></asp:Literal>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField HeaderText="Multimedia Type">
				<ItemTemplate>
					<asp:Literal ID="ltlType" runat="server"></asp:Literal>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:BoundField DataField="MediaItemName" HeaderText="Item Name" />
			<asp:BoundField DataField="Title" HeaderText="Title" />
			<asp:BoundField DataField="ThumbnailImageLink" HeaderText="Thumbnail Link" />
			<asp:TemplateField HeaderText="Link Type">
				<ItemTemplate>
					<asp:Literal ID="ltlLinkType" runat="server"></asp:Literal>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:BoundField DataField="TargetLink" HeaderText="Target Link" />
			<asp:TemplateField>
				<ItemTemplate>
					<asp:LinkButton ID="lbtnEdit" runat="server" CommandName="ItemEdit">Edit | </asp:LinkButton>
					<asp:LinkButton ID="lbtnDelete" runat="server" CommandName="ItemDelete">Delete</asp:LinkButton>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField HeaderText="Sort Order">
				<ItemTemplate>
					<asp:Literal ID="ltlSortOrder" runat="server"></asp:Literal>&nbsp;&nbsp;
					<a class="up common_link moveUpBtn" title="Up">&nbsp;</a> <a class="down common_link moveDownBtn" title="Down">&nbsp;</a>
				</ItemTemplate>
			</asp:TemplateField>
		</Columns>
	</asp:GridView>
</div>