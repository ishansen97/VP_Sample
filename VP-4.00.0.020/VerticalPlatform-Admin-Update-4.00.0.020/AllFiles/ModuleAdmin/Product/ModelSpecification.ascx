<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ModelSpecification.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Product.ModelSpecification" %>
<div>
	<table class="specification_table">
		<tr>
			<td>
				<asp:GridView ID="gvModelSpecification" runat="server" AutoGenerateColumns="False"
					OnRowDataBound="gvModelSpecification_RowDataBound" OnRowCommand="gvModelSpecification_RowCommand"
					CssClass="common_data_grid">
					<Columns>
						<asp:TemplateField HeaderText="Specification Type">
							<ItemTemplate>
								<asp:Literal ID="ltlSpecificationType" runat="server"></asp:Literal>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Specification">
							<ItemTemplate>
								<asp:Literal ID="ltlSpecification" runat="server"></asp:Literal>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Enable">
							<ItemTemplate>
								<asp:CheckBox ID="chkEnabled" runat="server" />
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField ItemStyle-Width="50">
							<ItemTemplate>
								<asp:LinkButton ID="lbtnEditSpecification" runat="server" CommandName="editSpecification" CssClass="grid_icon_link edit" ToolTip="Edit">Edit</asp:LinkButton>
								<asp:LinkButton ID="lbtnRemoveSpecification" runat="server" CommandName="RemoveSpecification"
									OnClientClick="return confirm('Are you sure to delete the model specification?');" CssClass="grid_icon_link delete" ToolTip="Delete">Remove</asp:LinkButton>
							</ItemTemplate>
						</asp:TemplateField>
					</Columns>
				</asp:GridView>
			</td>
		</tr>
		<tr>
			<td>
				<div>
					<table>
						<tr>
							<td>
								<asp:Literal ID="ltlSpecificationTypeLabel" runat="server" Text="Specification Type"></asp:Literal>
							</td>
							<td>
								<asp:DropDownList ID="ddlSpecificationType" runat="server">
								</asp:DropDownList>
								<asp:RequiredFieldValidator ID="rfvSpecificationType" runat="server" 
									ControlToValidate="ddlSpecificationType" ErrorMessage="Please select specification type." 
									InitialValue="-100" 
									ValidationGroup="ProductSpecification">*</asp:RequiredFieldValidator>
							</td>
						</tr>
						<tr>
							<td>
								<asp:Literal ID="ltlSpecificationLabel" runat="server" Text="Specification"></asp:Literal>
							</td>
							<td>
								<asp:TextBox ID="txtSpecification" runat="server" Width="400px" TextMode="MultiLine"
									Height="80px" CausesValidation="True"></asp:TextBox>
								<asp:RequiredFieldValidator ID="rfvSpecificationValue" runat="server" 
									ControlToValidate="txtSpecification" 
									ErrorMessage="Please enter valied specification value." 
									ValidationGroup="ProductSpecification">*</asp:RequiredFieldValidator>
							</td>
						</tr>
						<tr>
							<td>
								<asp:Literal ID="ltlEnableSpecLable" runat="server" Text="Enabled"></asp:Literal>
							</td>
							<td>
								<asp:CheckBox ID="chkSpecEnable" runat="server" Checked="True" Text=" " />
							</td>
						</tr>
						<tr>
							<td colspan="2">
								<asp:Button ID="btnAddSpecification" runat="server" Text="Save Changes to Specifications" 
									onclick="btnAddSpecification_Click" CssClass="common_text_button" 
									ValidationGroup="ProductSpecification" style="width:210px;" />
							</td>
						</tr>
					</table>
				</div>
			</td>
		</tr>
	</table>
</div>
<asp:HiddenField ID="hdnSelectedSpecification" runat="server" />
