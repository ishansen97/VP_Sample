<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="UploadSpecificationInformation.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Product.UploadSpecificationInformation" %>
<div>
	<table class="specification_table">
		<tr>
			<td>
				<asp:GridView ID="gvUploadProductDetailsView" runat="server" AutoGenerateColumns="False"
					CssClass="common_data_grid">
					<AlternatingRowStyle CssClass="GridpopupRowAltItem" />
					<HeaderStyle CssClass="GridHeader"></HeaderStyle>
					<RowStyle CssClass="GridpopupRowItem" />
					<Columns>
						<asp:BoundField DataField="SpecificationName" HeaderText="Specification Name" ItemStyle-Width="150px"
							ItemStyle-Height="20px" HeaderStyle-Height="25px" />
						<asp:BoundField DataField="SpecificationValue" HeaderText="Specification Value" ItemStyle-Width="350px"
							ItemStyle-Height="20px" HeaderStyle-Height="25px" />
					</Columns>
					<EmptyDataTemplate>
						No data found
					</EmptyDataTemplate>
				</asp:GridView>
			</td>
		</tr>
	</table>
</div>
