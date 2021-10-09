<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="VendorContactEmail.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Vendors.VendorContactEmail" %>
<div style="width:420px;">
<asp:TextBox ID="txtEmail" runat="server" ValidationGroup="addemailGroup"></asp:TextBox>
<asp:Button ID="btnAddEmail" runat="server" Text="Add Email" OnClick="btnAddEmail_Click" CssClass="common_text_button" ValidationGroup="addemailGroup"/>
<asp:CustomValidator ID="emailAddressValidator" runat="server" ControlToValidate="txtEmail" ErrorMessage="Invalid email address." 
	ValidationGroup="addemailGroup" ValidateEmptyText="true" ClientValidationFunction="VP.ValidateEmail">*</asp:CustomValidator>
<br /><br />
<asp:GridView ID="gvEmail" runat="server" AutoGenerateColumns="false" OnRowCommand="gvEmail_RowCommand"
	OnRowDataBound="gvEmail_RowDataBound" CssClass="common_data_grid">
	<Columns>
		<asp:TemplateField HeaderText="Email">
			<ItemTemplate>
				<asp:Label ID="lblEmail" runat="server"></asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField ItemStyle-Width="30">
			<ItemTemplate>
				<asp:LinkButton ID="lbtnRemove" runat="server" CommandName="RemoveEmail" CssClass="grid_icon_link delete" ToolTip="Delete">Remove</asp:LinkButton>
			</ItemTemplate>
		</asp:TemplateField>
	</Columns>
	<EmptyDataTemplate>
		No email addresses found.
	</EmptyDataTemplate>
</asp:GridView>
</div>