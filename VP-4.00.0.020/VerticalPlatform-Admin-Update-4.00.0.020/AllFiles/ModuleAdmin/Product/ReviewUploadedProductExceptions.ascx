<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ReviewUploadedProductExceptions.ascx.cs" 
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Product.ReviewUploadedProductExceptions" %>

<div>
	<table class="exception_table">
		<tr>
			<td>
				<asp:GridView ID="gvProductExceptions" runat="server" AutoGenerateColumns="False"
					CssClass="common_data_grid" OnRowDataBound = "gvProductExceptions_RowBound">
					<AlternatingRowStyle CssClass="GridpopupRowAltItem" />
					<HeaderStyle CssClass="GridHeader"></HeaderStyle>
					<RowStyle CssClass="GridpopupRowItem" />
					<Columns>
						<asp:TemplateField HeaderText = "Occured Exception">
							<ItemTemplate>
								<asp:Label ID="lblException" runat="server"></asp:Label>
							</ItemTemplate>
						</asp:TemplateField>
					</Columns>
					<EmptyDataTemplate>
						No data found
					</EmptyDataTemplate>
				</asp:GridView>
			</td>
		</tr>
	</table>
</div>
