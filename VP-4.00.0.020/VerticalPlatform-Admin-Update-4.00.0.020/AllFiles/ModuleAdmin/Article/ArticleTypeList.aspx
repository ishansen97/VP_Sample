<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="ArticleTypeList.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Articles.ArticleTypeList" %>
<asp:Content ID="conContent" ContentPlaceHolderID="cphContent" runat="server">
	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>
				Article Type List</h3>
		</div>
		<div class="AdminPanelContent">
			<div class="add-button-container">
				<asp:HyperLink ID="lnkAddArticleType" runat="server" CssClass="aDialog btn" style="margin-right:5px;">
					Add Article Type</asp:HyperLink>
				<asp:HyperLink runat="server" ID="lnkChangeArticleType" CssClass="aDialog btn">Change Article Type</asp:HyperLink>
			</div>

			<asp:UpdateProgress ID="UpdateProgress1" runat="server">
				<ProgressTemplate>
					<asp:Image ID="imgProgress" runat="server" ImageUrl="~/Images/Progress.gif" />
				</ProgressTemplate>
			</asp:UpdateProgress>

			<asp:GridView ID="gvArticleTypes" runat="server" AutoGenerateColumns="false"
				OnRowDataBound="gvArticleTypes_RowDataBound" CssClass="common_data_grid table table-bordered">
				<RowStyle CssClass="DataTableRow" />
				<AlternatingRowStyle CssClass="DataTableRowAlternate" />
				<Columns>
					<asp:BoundField HeaderText="ID" DataField="Id" ItemStyle-Width="50" />
					<asp:BoundField HeaderText="Name" DataField="ArticleTypeName" ItemStyle-Width="200" />
					<asp:BoundField HeaderText="Created" DataField="Created" DataFormatString="{0:d}"
						ItemStyle-Width="50" />
					<asp:BoundField HeaderText="Modified" DataField="Modified" DataFormatString="{0:d}"
						ItemStyle-Width="50" />
					<asp:CheckBoxField HeaderText="Content Based" DataField="ContentBased" ItemStyle-Width="50" />
					<asp:CheckBoxField HeaderText="Enabled" DataField="Enabled" ItemStyle-Width="50" />
					<asp:TemplateField ItemStyle-Width="50px" >
						<ItemTemplate>
							<asp:HyperLink ID="lnkParameter" runat="server" CssClass="aDialog" >Parameters</asp:HyperLink>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField ItemStyle-Width="20px" >
						<ItemTemplate>
							<asp:HyperLink ID="lnkEdit" runat="server" CssClass="aDialog grid_icon_link edit" ToolTip="Edit">Edit
								</asp:HyperLink>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField ItemStyle-Width="20px" >
						<ItemTemplate>
							<asp:HyperLink ID="articleTypeTemplateLink" runat="server" CssClass="grid_icon_link templates" ToolTip="Manage Templates">Templates
								</asp:HyperLink>
						</ItemTemplate>
					</asp:TemplateField>
				</Columns>
			</asp:GridView>

			<asp:HiddenField ID="hdnArticleTypeId" runat="server" />
			<asp:LinkButton ID="lbtnHiddenParameter" runat="server" Style="display: none;"></asp:LinkButton>
		</div>
	</div>
</asp:Content>
