<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CategoryMatrix.ascx.cs"
	Inherits="VerticalPlatformWeb.Modules.Matrix.CategoryMatrix" %>
<div class="matrixModule">
	<div class="categoryMatrixModule module">
		<asp:GridView id="gvCategories" runat="server" AutoGenerateColumns="False" CssClass="dataGrid"
			OnRowDataBound="gvCategories_RowDataBound">
			<Columns>
				<asp:TemplateField HeaderText="Product Category">
					<ItemTemplate>
						<asp:Literal id="ltlProductCategory" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"Category.Name") %>'></asp:Literal>
					</ItemTemplate>
					<HeaderStyle CssClass="dataGridHeader" />
					<ItemStyle CssClass="categoryColumn" />
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Specification">
					<ItemTemplate>
						<asp:Literal id="ltlSpecification" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"Category.Specification") %>'></asp:Literal>
					</ItemTemplate>
					<HeaderStyle CssClass="dataGridHeader" />
					<ItemStyle CssClass="specificationColumn" />
				</asp:TemplateField>
				<asp:TemplateField HeaderText="More Information">
					<ItemTemplate>
						<asp:Literal id="ltlInformation" runat="server"></asp:Literal>
					</ItemTemplate>
					<HeaderStyle CssClass="dataGridHeader" />
					<ItemStyle CssClass="informationColumn" />
				</asp:TemplateField>
			</Columns>
			<AlternatingRowStyle CssClass="alternatingRow"/>
		</asp:GridView>
	</div>
</div>
