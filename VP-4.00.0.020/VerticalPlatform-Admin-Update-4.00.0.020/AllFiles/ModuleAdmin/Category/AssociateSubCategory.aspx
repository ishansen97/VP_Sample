<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="AssociateSubcategory.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Category.AssociateSubcategory" %>

<asp:Content ID="Content2" ContentPlaceHolderID="cphContent" runat="server">
	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>
				Categories</h3>
		</div>
		<div class="AdminPanelContent">
			<asp:GridView ID="gvCategories" runat="server" AutoGenerateColumns="false" OnDataBound="gvCategories_DataBound"
				CssClass="common_data_grid">
				<AlternatingRowStyle CssClass="DataTableRowAlternate" />
				<RowStyle CssClass="DataTableRow" />
				<Columns>
					<asp:BoundField DataField="Id" HeaderText="ID" />
					<asp:TemplateField>
						<HeaderTemplate>
							Name</HeaderTemplate>
						<ItemTemplate>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField>
						<ItemTemplate>
							<asp:CheckBox ID="chkEnabled" runat="server" />
						</ItemTemplate>
					</asp:TemplateField>
				</Columns>
			</asp:GridView>
		</div>
		<div>
		<br />
			<asp:Button ID="btnAssociate" runat="server" Text="Associate" 
				OnClick="btnAssociate_Click" Width="100px" CssClass="common_text_button"  />
			<asp:Button ID="btnCancel" runat="server" onclick="btnCancel_Click" 
				Text="Cancel" Width="100px" CssClass="common_text_button"  />
			<br />
		</div>
	</div>
</asp:Content>
