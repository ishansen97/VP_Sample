<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ContentParameterSetting.ascx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Content.ContentParameterSetting" %>
<div class="AdminPanelContent">
	<asp:GridView ID="gvListItems" runat="server" AutoGenerateColumns="False" OnRowDataBound="gvListItems_RowDataBound"
				CssClass="common_data_grid table table-bordered" style="width:auto;">
		<Columns>
			<asp:TemplateField HeaderText="Parameter type" >
				<ItemTemplate>
					<asp:Label id="parametertype" runat="server"></asp:Label>
				</ItemTemplate>
			</asp:TemplateField>
				
			<asp:TemplateField HeaderText="Parameter Value">
				<ItemTemplate>
					<asp:TextBox ID="parameterVal" runat="server"> </asp:TextBox>
				</ItemTemplate>
			</asp:TemplateField>
		</Columns>
	</asp:GridView>
</div>