<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AssociateContentToContent.ascx.cs"
    Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Content.AssociateContentToContent" %>
<%@ Register Src="../Pager.ascx" TagName="Pager" TagPrefix="uc3" %>

<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>

<script src="../../Js/JQuery/jquery.pager.js" type="text/javascript"></script>

<script src="../../Js/ContentPicker.js" type="text/javascript"></script>

<script type="text/javascript" language="javascript">
		RegisterNamespace("VP.ContentToContentManagement");
</script>

<table>	
	<tr>
		<td>
			<h4>
				<asp:Label ID="lblHeader" runat="server" Text='Associate Content to the Product' Visible="false"></asp:Label>
			</h4>
		</td>
	</tr>
	<tr>
		<td class="common_form_label">
			Content Type</td>
		<td class="common_form_content">
			<asp:DropDownList ID="ddlAssociatedContentType" runat="server" 
				AutoPostBack="True" 
				onselectedindexchanged="ddlAssociatedContentType_SelectedIndexChanged"></asp:DropDownList>
		</td>
	</tr>
	<tr>
		<td class="common_form_label">
			Content Id</td>
		<td class="common_form_content">
			<asp:TextBox runat="server" ID="txtAssociatedContentId"></asp:TextBox>
		</td>
	</tr>
	<tr runat="server" id="trAssociateVendor">
		<td class="common_form_label" >Associate Product Vendors</td>
		<td class="common_form_content">
			<asp:CheckBox ID="chkAssociateVendors" runat="server" Checked="true" />
		</td>
	</tr>
	<tr runat="server" id="trAssociateProductCategories">
		<td class="common_form_label" >Associate Product Categories</td>
		<td class="common_form_content">
			<asp:CheckBox ID="ProductCategories" runat="server" Checked="true" />
            <asp:HiddenField ID="sortOrderHdn" Value="-1" runat="server"/>
		</td>
	</tr>
	<tr id="trTwoWayAssociation" runat="server">
		<td class="common_form_label">
			Create Association Both Way</td>
		<td class="common_form_content">
			<asp:CheckBox ID="chkTwoWayAssociation" runat="server" Checked="true" />
		</td>
	</tr>
	<tr>
		<td class="common_form_label">
			&nbsp;</td>
		<td class="common_form_content">
			<asp:Button ID="btnAssociate" runat="server" Text="Associate" CssClass="common_text_button"
				onclick="btnAssociate_Click" ValidationGroup="AssociateContent" />
		</td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="2">
			<asp:GridView ID="gvContentAssociation" runat="server" 
				AutoGenerateColumns="False" onrowdatabound="gvContentAssociation_RowDataBound" 
				CssClass="common_data_grid" onrowcommand="gvContentAssociation_RowCommand">
			<Columns>
				<asp:BoundField HeaderText="Site Id" DataField="SiteId" />
				<asp:TemplateField HeaderText="Content Id">
							<ItemTemplate>
								<asp:Label ID="lblContentId" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "ContentId") %>'></asp:Label>
							</ItemTemplate>
				</asp:TemplateField>
				<asp:BoundField HeaderText="Content Type" DataField="ContentType" />
				<asp:BoundField HeaderText="Associated Site Id" DataField="AssociatedSiteId" />
				<asp:TemplateField HeaderText="Associated Site">
					<ItemTemplate>
						<asp:Label ID="lblAssociatedSite" runat="server" ></asp:Label>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:BoundField HeaderText="Associated Content Type" DataField="AssociatedContentType" />
				<asp:BoundField HeaderText="Associated Content Id" DataField="AssociatedContentId" />
				<asp:TemplateField HeaderText="Associated Content Name">
					<ItemTemplate>
						<asp:Label ID="lblAssociatedContentName" runat="server"></asp:Label>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField>
					<ItemTemplate>
						<asp:LinkButton OnClientClick="return confirm('Are you sure you want to delete this contetnt?');" ID="lbtnDelete"
							runat="server" Text="Delete" CommandName="DeleteContentToContent" CssClass="grid_icon_link delete" ToolTip="Delete"></asp:LinkButton>
					</ItemTemplate>
				</asp:TemplateField>
			</Columns>
			</asp:GridView>
			</td>
	</tr>
	<tr>
		<td colspan="2">
			<uc3:Pager ID="pgrContentToContent" runat="server" OnPageIndexClickEvent="pgrContentToContent_PageIndexClick" />
			<asp:Label ID="lblInformation" runat="server"></asp:Label>
		</td>
	</tr>
</table>
