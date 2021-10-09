<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="VendorContactPhone.ascx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Vendors.VendorContactPhone" %>
<div style="width:420px;">
<asp:TextBox ID="txtPhoneNumber" runat="server" ValidationGroup="PhoneNumber"></asp:TextBox>

<asp:Button ID="btnAddPhoneNumber" runat="server" Text="Add Phone Number" 
		OnClick="btnAddPhoneNumber_Click" CssClass="common_text_button" 
		ValidationGroup="PhoneNumber" />
<asp:RequiredFieldValidator ID="rfvPhoneNumber" runat="server" ErrorMessage="Please enter a phone number."
	ControlToValidate="txtPhoneNumber" ValidationGroup="PhoneNumber">*</asp:RequiredFieldValidator>
<br /><br />
<asp:GridView ID="gvPhoneNumber" runat="server" AutoGenerateColumns="false" OnRowCommand="gvPhoneNumber_RowCommand"
	OnRowDataBound="gvPhoneNumber_RowDataBound" CssClass="common_data_grid">
	<Columns>
		<asp:TemplateField HeaderText="Phone Number">
			<ItemTemplate>
				<asp:Label ID="lblPhoneNumber" runat="server"></asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField ItemStyle-Width="30">
			<ItemTemplate>
				<asp:LinkButton ID="lbtnRemove" runat="server" CommandName="RemovePhoneNumber" OnClientClick="return confirm('Are you sure to remove the phone number?');" CssClass="grid_icon_link delete" ToolTip="Delete">Remove</asp:LinkButton>
			</ItemTemplate>
		</asp:TemplateField>
	</Columns>
	<EmptyDataTemplate>
		No phone numbers found.
	</EmptyDataTemplate>
</asp:GridView>
</div>