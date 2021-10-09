<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="FileManagement.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Files.FileManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>
				File List</h3>
		</div>
		<div class="AdminPanelContent">
			<div class="add-button-container"><asp:HyperLink ID="lnkAddFile" runat="server" CssClass="aDialog btn">Add File</asp:HyperLink></div>
			
			<asp:GridView ID="gvFile" runat="server" AutoGenerateColumns="False" OnRowDataBound="gvFile_RowDataBound"
				CssClass="common_data_grid table table-bordered" style="width:auto;">
				<Columns>
					<asp:BoundField DataField="Id" HeaderText="ID" />
					<asp:BoundField DataField="FileName" HeaderText="Name" />
					<asp:BoundField DataField="MimeType" HeaderText="MimeType" />
					<asp:CheckBoxField DataField="Enabled" HeaderText="Enabled" />
					<asp:TemplateField ItemStyle-Width="20px">
						<ItemTemplate>
							<asp:HyperLink ID="lnkEdit" runat="server" CssClass="aDialog grid_icon_link edit" ToolTip="Edit">Edit</asp:HyperLink>
						</ItemTemplate>
					</asp:TemplateField>
				</Columns>
			</asp:GridView>
		</div>
	</div>
</asp:Content>
