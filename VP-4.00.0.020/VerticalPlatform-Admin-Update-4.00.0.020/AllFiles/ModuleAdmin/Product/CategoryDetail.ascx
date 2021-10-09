<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CategoryDetail.ascx.cs"
		Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Product.CategoryDetail" %>

<script src="../../Js/ContentPicker.js" type="text/javascript"></script>


	<h4>Associate Categories to the Product</h4>

				<asp:GridView ID="gvCategory" runat="server" AutoGenerateColumns="False" OnRowDataBound="gvCategory_RowDataBound"
					OnRowDeleting="gvCategory_RowDeleting" CssClass="common_data_grid table table-bordered" style="width:auto">
					<Columns>
						<asp:TemplateField>
							<ItemTemplate>
								<asp:ImageButton ID="ibtnEnable" runat="server" OnClick="ibtnEnable_Click" />
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Category Id">
							<ItemTemplate>
								<asp:Literal ID="ltlCategoryId" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "Category.Id") %>'></asp:Literal>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Category Name">
							<ItemTemplate>
								<asp:Literal ID="ltlCategoryName0" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "Category.Name") %>'></asp:Literal>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField ShowHeader="False">
							<ItemTemplate>
								<asp:LinkButton ID="lbtnRemove1" runat="server" CausesValidation="False" CommandName="Delete"
									Text="Remove" OnClientClick="return confirm(&quot;Are you sure to remove the category? &quot;);" CssClass="grid_icon_link delete" ToolTip="Remove"></asp:LinkButton>
							</ItemTemplate>
							<ItemStyle Width="20px" />
						</asp:TemplateField>
					</Columns>
				</asp:GridView>
				<br />
            <div class="inline-form-container">
                <span class="title"><asp:Literal ID="ltlCategoryName" runat="server" Text="Category"></asp:Literal>&nbsp;ID</span>
                <asp:TextBox ID="txtCategoryId" runat="server"></asp:TextBox>
                <asp:Button ID="btnAssociateCategory" runat="server" CssClass="btn" OnClick="btnAssociateCategory_Click" Text="Associate Category" ValidationGroup="categoryGroup" />
            </div>
      

