<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddEditClickthrough.ascx.cs" 
		Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Product.AddEditClickthrough" %>
<div>
	<asp:GridView ID="gvClickthrough" runat="server" AutoGenerateColumns="False" 
		onrowdatabound="gvClickthrough_RowDataBound" CssClass="common_data_grid" style="width:auto;">
		<Columns>
			<asp:TemplateField HeaderText="Click Through Type">
				<ItemTemplate>
					<asp:Literal ID="ltlActionTitle" runat="server"></asp:Literal>
					<asp:HiddenField ID="hdnActionId" runat="server" />
				</ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField HeaderText="URL">
				<ItemTemplate>
					<asp:TextBox ID="txtActionUrl" runat="server" Width="250px"></asp:TextBox>
					<asp:HiddenField ID="hdnActionUrlId" runat="server" />
					<asp:RegularExpressionValidator ID="revUrl" runat="server" ControlToValidate="txtActionUrl"
							ErrorMessage="Invalid Url." 
							ValidationExpression="((https?|ftp|gopher|telnet|file|notes|ms-help):((//)|(\\\\))+([\w-]+\.)+[\w\d:#@%/;$()~_?\+-=\\\.&]*)">*
					</asp:RegularExpressionValidator>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField HeaderText="New Window">
				<ItemTemplate>
					<asp:CheckBox ID="chkNewWindow" runat="server" />
				</ItemTemplate>
			</asp:TemplateField>
		</Columns>
		<EmptyDataTemplate>No Clickthroughs defined.</EmptyDataTemplate>
	</asp:GridView>
</div>