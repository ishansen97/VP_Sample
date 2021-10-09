<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddEditSearchAspectContent.ascx.cs"
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Category.AddEditSearchAspectContent" %>

<table>
	<tr>
		<td>
			Content Type
		</td>
		<td>
			<asp:DropDownList ID="ddlContentType" runat="server" style="padding:3px;"  Width="150"
				AutoPostBack="true" OnSelectedIndexChanged="ddlContentType_SelectedIndexChanged"></asp:DropDownList>
		</td>
	</tr>
	<tr>
		<td>
			Content
		</td>
		<td>
			<asp:DropDownList ID="ddlContent" runat="server" style="padding:3px;"  Width="150"></asp:DropDownList>
		</td>
	</tr>
	<tr>
		<td>
			Omit Norms
		</td>
		<td>
			<asp:CheckBox ID="chkOmitNorms" runat="server" />
		</td>
		<td>
			<asp:Button ID="btnAddContent" runat="server" Text="Add Content" OnClick="btnAddContent_Click"
				CssClass="common_text_button" />
		</td>
	</tr>
</table>
<br />
<asp:GridView ID="gvContents" runat="server" AutoGenerateColumns="False" OnRowCommand="gvContents_RowCommand"
	OnRowDataBound="gvContents_RowDataBound" CssClass="common_data_grid">
	<Columns>
		<asp:TemplateField HeaderText="Content Type">
			<ItemTemplate>
				<asp:Literal ID="ltlContentType" runat="server"></asp:Literal>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Content Name">
			<ItemTemplate>
				<asp:Literal ID="ltlContentName" runat="server"></asp:Literal>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Omit Norms">
			<ItemTemplate>
				<asp:CheckBox ID="chkOmitNormsValue" runat="server" Enabled="false"/>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Action">
			<ItemTemplate>
				<asp:LinkButton ID="lbtnDelete" CommandName="DeleteContent" runat="server" CausesValidation="false">Delete</asp:LinkButton>
			</ItemTemplate>
		</asp:TemplateField>
	</Columns>
	<EmptyDataTemplate>
		No contents found.
	</EmptyDataTemplate>
</asp:GridView>
