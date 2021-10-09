<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CategorySpecification.ascx.cs"
		Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Product.CategorySpecification" %>
<script src="../../Js/textareaExpander.js" type="text/javascript"></script>
<h4>Add or Edit Category Related Specification</h4>
<div class="specification_table">

				<div class="add-button-container"><asp:Button ID="btnAddCategoryRelatedSpecificationTop" Text="Apply Changes to Specifications"
					runat="server" onclick="btnAddCategoryRelatedSpecification_Click" CssClass="btn" /></div>
				<asp:GridView ID="gvCategoryRelatedSpecification" runat="server" AutoGenerateColumns="False"
					OnRowDataBound="gvCategoryRelatedSpecification_RowDataBound" OnRowCommand="gvCategoryRelatedSpecification_RowCommand"
					CssClass="common_data_grid expand_txt table table-bordered">
					<Columns>
					    <asp:TemplateField HeaderText="Specification Type Id">
							<ItemTemplate>
								<asp:Literal ID="ltlSpecificationTypeId" runat="server"></asp:Literal>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Specification Type">
							<ItemTemplate>
								<asp:Literal ID="ltlSpecificationType" runat="server"></asp:Literal>
								<asp:HiddenField ID="hdnCategorySpecificationId" runat="server" />
								<asp:HiddenField ID="hdnSpecificationTypeId" runat="server" />
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Specification" ControlStyle-Width="400" ControlStyle-Height="65">
							<ItemTemplate>
								<asp:TextBox ID="txtSpecificationValue" runat="server" TextMode="MultiLine" Width="95%"></asp:TextBox>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Display Options" ItemStyle-Width="250">
							<ItemTemplate>
								<asp:CheckBox ID="chkShowInVerticalMatrix" Text="Vertical Matrix/Column Based Matrix" runat="server"/>
								<br />
								<asp:CheckBox ID="chkShowInComparePage" Text="Compare Page" runat="server"/>
								<br />
								<asp:CheckBox ID="chkShowInProductDetail"  Text="Product Detail" runat="server"/>
								<br />
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Enable">
							<ItemTemplate>
								<asp:CheckBox ID="chkEnabled" runat="server" />
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField>
							<ItemTemplate>
								<asp:LinkButton ID="lbtnEditSpecification" runat="server" CommandName="editSpecification" CssClass="grid_icon_link edit" ToolTip="Edit">Edit</asp:LinkButton>
							</ItemTemplate>
						</asp:TemplateField>
					</Columns>
				</asp:GridView>
		        <br />

				<asp:Button ID="btnAddCategoryRelatedSpecificationBottom" Text="Apply Changes to Specifications"
					runat="server" onclick="btnAddCategoryRelatedSpecification_Click" CssClass="btn" />
</div>