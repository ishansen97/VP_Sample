<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ContactControl.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Vendors.ContactControl" %>
<script type="text/javascript" language="javascript">
$(document).ready(function(){
    $(".common_data_grid td").each(function(){
        $("a",this).wrapAll("<div class='links' />");
    });
});
</script>	

<div class="add-button-container"><asp:HyperLink ID="lnkAddContact" runat="server" CssClass="aDialog btn">Add Contact</asp:HyperLink></div>

<asp:GridView ID="gvContact" runat="server" AutoGenerateColumns="false" OnRowCommand="gvContact_RowCommand"
	OnRowDataBound="gvContact_RowDataBound" CssClass="common_data_grid table table-bordered">
	<Columns>
		<asp:TemplateField HeaderText="Contact Type">
			<ItemTemplate>
				<asp:Literal ID="ltlContactType" runat="server"></asp:Literal>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Locations">
			<ItemTemplate>
			<asp:HyperLink ID="lnkAddLocation" runat="server" CssClass="aDialog grid_icon_link add_content" ToolTip="Add">Add</asp:HyperLink>
				<asp:PlaceHolder ID="phLocation" runat="server"></asp:PlaceHolder>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Address">
			<ItemTemplate>
				<asp:HyperLink ID="lnkAddAddress" runat="server" CssClass="aDialog grid_icon_link add_content" ToolTip="Add">Add</asp:HyperLink>
				<asp:PlaceHolder ID="phAddress" runat="server"></asp:PlaceHolder>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Emails">
			<ItemTemplate>
				<asp:HyperLink ID="lnkAddEmail" runat="server" CssClass="aDialog grid_icon_link add_content" ToolTip="Add">Add</asp:HyperLink>
				<asp:PlaceHolder ID="phEmail" runat="server"></asp:PlaceHolder>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Phone Numbers">
			<ItemTemplate>
				<asp:HyperLink ID="lnkAddPhoneNumber" runat="server" CssClass="aDialog grid_icon_link add_content" ToolTip="Add">Add</asp:HyperLink>
				<asp:PlaceHolder ID="phPhoneNumber" runat="server"></asp:PlaceHolder>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Websites">
			<ItemTemplate>
				<asp:HyperLink ID="lnkAddWebsite" runat="server" CssClass="aDialog grid_icon_link add_content" ToolTip="Add">Add</asp:HyperLink>
				<asp:PlaceHolder ID="phWebsite" runat="server"></asp:PlaceHolder>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField>
			<ItemTemplate>
				<asp:LinkButton ID="lbtnRemove" runat="server" CommandName="RemoveContact" CssClass="grid_icon_link delete" ToolTip="Remove">Remove</asp:LinkButton>
			</ItemTemplate>
		</asp:TemplateField>
	</Columns>
	<EmptyDataTemplate>
		No contact details found for vendor.
	</EmptyDataTemplate>
</asp:GridView>
