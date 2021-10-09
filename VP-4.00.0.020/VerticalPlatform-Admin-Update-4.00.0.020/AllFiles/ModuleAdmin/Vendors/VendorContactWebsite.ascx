<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="VendorContactWebsite.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Vendors.VendorContactWebsite" %>

<div style="width:420px;">
<style type="text/css">
    .website-td{word-break: break-all !important;}
</style>
<table>
	<tr>
        <td>Website Type</td>
        <td>
			<asp:DropDownList ID="DdlWebsiteTypeList" runat="server">
				<asp:ListItem Text="Select" Value=""></asp:ListItem>
			</asp:DropDownList>
        </td>
    </tr>
    <tr>
        <td>Website Display Name</td>
        <td><asp:TextBox ID="txtWebsiteDisplayName" runat="server" ValidationGroup="AddWebsite"></asp:TextBox>
            <asp:RequiredFieldValidator ID="rfvWebsiteDisplayName" ControlToValidate="txtWebsiteDisplayName"
	runat="server" ValidationGroup="AddWebsite" ErrorMessage="Please enter a display name. ">*</asp:RequiredFieldValidator>
        </td>
    </tr>
    <tr>
        <td>Website</td> 
        <td>
            <asp:TextBox ID="txtWebsite" runat="server" ValidationGroup="AddWebsite"></asp:TextBox>
<asp:RequiredFieldValidator ID="rfvWebsite" ControlToValidate="txtWebsite" ValidationGroup="AddWebsite" runat="server"
	ErrorMessage="Please enter a website." Display="Dynamic">*</asp:RequiredFieldValidator>
<asp:RegularExpressionValidator ID="revWebsite" runat="server" ValidationGroup="AddWebsite" ErrorMessage="Not a valid url."
	ValidationExpression="http(s)?://([\w-]+\.)+[\w-]+(/[\w- ./?%&=;]*)?" ControlToValidate="txtWebsite">*</asp:RegularExpressionValidator>
        </td>
    </tr>
</table>
<br />
<asp:Button ID="BtnAddWebsite" runat="server" Text="Add Website" 
		OnClick="BtnAddWebsite_Click" CssClass="common_text_button" 
		ValidationGroup="AddWebsite" />
<br />
<br />

<asp:GridView ID="GVWebsites" runat="server" AutoGenerateColumns="false" OnRowCommand="GVWebsites_RowCommand"
	OnRowDataBound="GVWebsites_RowDataBound" CssClass="common_data_grid">
	<Columns>
		<asp:TemplateField HeaderText="Website Type">
			<ItemTemplate>
				<asp:Label ID="lblWebsiteType" runat="server"></asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Display Name">
			<ItemTemplate>
				<asp:Label ID="lblWebsiteDisplayName" runat="server"></asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Website" ItemStyle-CssClass="website-td">
			<ItemTemplate>
				<asp:Label ID="lblWebsite" runat="server"></asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField ItemStyle-Width="25">
			<ItemTemplate>
				<asp:LinkButton ID="lbtnRemove" runat="server" CommandName="RemoveWebsite" OnClientClick="return confirm('Are you sure to remove the website?');" CssClass="grid_icon_link delete" ToolTip="Delete">Remove</asp:LinkButton>
			</ItemTemplate>
		</asp:TemplateField>
	</Columns>
	<EmptyDataTemplate>
		No websites found.
	</EmptyDataTemplate>
</asp:GridView>
</div>