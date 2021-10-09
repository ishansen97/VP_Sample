<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ReviewUploadedSpecifications.ascx.cs" 
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Product.ReviewUploadedSpecifications" %>

<div>
	<table class="specification_table">
		<tr>
			<td>
				<asp:GridView ID="gvUploadedProductDetailsView" runat="server" AutoGenerateColumns="False"
					CssClass="common_data_grid" OnRowDataBound = "gvUploadedProductDetailsView_RowBound">
					<AlternatingRowStyle CssClass="GridpopupRowAltItem" />
					<HeaderStyle CssClass="GridHeader"></HeaderStyle>
					<RowStyle CssClass="GridpopupRowItem" />
					<Columns>
						<asp:TemplateField HeaderText = "Specification Name">
							<ItemTemplate>
								<asp:Literal ID = "ltlSpecificationName" runat="server"></asp:Literal>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText = "Specification Value">
							<ItemTemplate>
								<asp:Literal ID = "ltlSpecificationValue" runat="server"></asp:Literal>
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
