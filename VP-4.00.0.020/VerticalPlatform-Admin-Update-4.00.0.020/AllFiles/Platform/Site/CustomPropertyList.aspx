<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="CustomPropertyList.aspx.cs" Inherits="VerticalPlatformAdminWeb.Platform.Site.CustomPropertyList" Title="Untitled Page" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
	<div class="AdminPanelHeader"><h3>Custom Property</h3></div>
	<div class="add-button-container"><asp:HyperLink ID="lnkAddCustomProperty" runat="server" Text="Add Custom Property" CssClass="aDialog btn"></asp:HyperLink></div> 
	<asp:GridView ID="gvCustomProperty" runat="server" AutoGenerateColumns="False" 
		onrowdatabound="gvCustomProperty_RowDataBound" 
		onrowcommand="gvCustomProperty_RowCommand" CssClass="common_data_grid table table-bordered" style="width:auto">
		<Columns>
			<asp:TemplateField HeaderText="ID">
				<ItemTemplate>
					<asp:Label ID="lblCustomPropertyId" runat="server"></asp:Label>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField HeaderText="Custom Property Name">
				<ItemTemplate>
					<asp:Label ID="lblCustomPropertyName" runat="server"></asp:Label>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField HeaderText="Data Type">
				<ItemTemplate>
					<asp:Label ID="lblDataType" runat="server"></asp:Label>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField HeaderText="Null Allowed">
				<ItemTemplate>
					<asp:CheckBox ID="chkIsNullable" runat="server" />
				</ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField>
				<ItemTemplate>
					<asp:HyperLink ID="lnkEdit" runat="server" Text="Edit" CssClass="aDialog grid_icon_link edit" ToolTip="Edit"></asp:HyperLink>
					<asp:LinkButton ID="lbtnDelete" runat="server" Text="Delete" CommandName="DeleteCommand"
					 OnClientClick="return confirm('Deleting the custom property will also delete the property values entered against the custom property. Are you sure you want to delete this custom property');" CssClass=" grid_icon_link delete" ToolTip="Delete"></asp:LinkButton>
				</ItemTemplate>
			</asp:TemplateField>
		</Columns>
	</asp:GridView>
	</asp:Content>
