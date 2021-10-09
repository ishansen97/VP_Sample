<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ModelDetail.ascx.cs"
		Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Product.ModelDetail" %>
		
<h4>Add Models to the Product</h4>
<div class="add-button-container">
	<asp:HyperLink ID="lnkAddModel" runat="server" CssClass="aDialog btn">Add Model</asp:HyperLink>
</div>

<div id="divModel" runat="server">
	<asp:GridView ID="gvModels" runat="server" AutoGenerateColumns="False" OnRowDataBound="gvModels_RowDataBound" 
		OnRowDeleting="gvModels_RowDeleting" CssClass="common_data_grid table table-bordered" Width="100%" EnableViewState="false" 
		onpageindexchanging="gvModels_PageIndexChanging" onpageindexchanged="gvModels_PageIndexChanged" onrowcommand="gvModels_RowCommand">
		<Columns>
			<asp:TemplateField HeaderText="Model Id">
				<ItemTemplate>
					<asp:Literal ID="ltlModelId" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "Model.Id") %>'></asp:Literal>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField HeaderText="Model Name">
				<ItemTemplate>
					<asp:Literal ID="ltlModelName" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "Model.Name") %>'>
					</asp:Literal>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField HeaderText="Catalog Number">
				<ItemTemplate>
					<asp:Literal ID="ltlCatalogNumber" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "Model.CatalogNumber") %>'>
					</asp:Literal>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField HeaderText="Display Order">
				<ItemTemplate>
					<asp:Literal ID="ltlDisplayOrder" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "Model.DisplayOrder") %>'>
					</asp:Literal>&nbsp&nbsp
					<asp:LinkButton runat="server" alt="Up" ID="MoveUp" CommandName ="MoveUpButton" 
						CommandArgument="<%# Container.DataItemIndex %>" CssClass="moveUpBtn" ToolTip="Up"/>
					<asp:LinkButton runat="server" alt="Down" ID="MoveDown" CommandName ="MoveDownButton" 
						CommandArgument="<%# Container.DataItemIndex %>" CssClass="moveDownBtn" ToolTip="Down"/>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField HeaderText="Enabled" ItemStyle-HorizontalAlign="Center">
				<ItemTemplate>
					<asp:CheckBox ID="chkEnabled" runat="server" Checked='<%# DataBinder.Eval(Container.DataItem,"Model.Enabled") %>'
						Enabled="False" />
				</ItemTemplate>
				<ItemStyle Width="60px" />
			</asp:TemplateField>
			<asp:TemplateField HeaderText="Specifications">
				<ItemTemplate>
					<asp:HyperLink ID="lnkModelSpecification" runat="server" CausesValidation="False"
						Text="Add/Edit" CssClass="aDialog"></asp:HyperLink>
				</ItemTemplate>
				<ItemStyle Width="105px" />
			</asp:TemplateField>
			<asp:TemplateField>
				<ItemTemplate>
					<asp:HyperLink ID="lnkClickThrough" runat="server" CssClass="aDialog">Click&nbsp;Through</asp:HyperLink>
				</ItemTemplate>
			<ItemStyle Width="5%" />
			</asp:TemplateField>
			<asp:TemplateField>
				<ItemTemplate>
					<asp:HyperLink ID="lnkActionList" runat="server" CssClass="aDialog">Action&nbsp;List</asp:HyperLink>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField ShowHeader="False">
				<ItemTemplate>
					<asp:HyperLink ID="lnkLeadForm" runat="server" CssClass="grid_icon_link form" ToolTip="Lead Form">Lead Form</asp:HyperLink>
					<asp:HyperLink ID="lnkEdit" runat="server"  CssClass="aDialog grid_icon_link edit" ToolTip="Edit">Edit</asp:HyperLink>
					<asp:LinkButton ID="lbtnRemove" runat="server" CausesValidation="False" CommandName="Delete"
						Text="Remove" OnClientClick="return confirm(&quot;Are you sure to remove the model? &quot;);" 
						CssClass="grid_icon_link delete" ToolTip="Delete"></asp:LinkButton>
				</ItemTemplate>
				<ItemStyle Width="70px" />
			</asp:TemplateField>
		</Columns>
		<HeaderStyle HorizontalAlign="Center" />
	</asp:GridView>
</div>
