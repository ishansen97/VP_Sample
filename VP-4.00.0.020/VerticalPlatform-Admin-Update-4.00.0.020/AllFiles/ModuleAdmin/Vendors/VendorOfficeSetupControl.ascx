<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="VendorOfficeSetupControl.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Vendors.VendorOfficeSetupControl" %>
<div class="actionList">
	<div class="header">
		<h3>Vendor Office Setup Actions<h3>
	</div>
	<br />
	<div id="divOfficeSetupActions">
		<asp:GridView ID="gvOfficeSetupAction" runat="server" AutoGenerateColumns="False"
			OnRowDataBound="gvOfficeSetupAction_RowDataBound" CssClass="common_data_grid table table-bordered"
			Style="width: auto;">
			<Columns>
				<asp:TemplateField HeaderText="Name">
					<ItemTemplate>
						<asp:Literal ID="ltlName" runat="server"></asp:Literal>
						<asp:HiddenField ID="hdnActionId" runat="server" />
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Enabled">
					<ItemTemplate>
						<asp:CheckBox ID="chkEnabled" runat="server" CssClass="" />
					</ItemTemplate>
				</asp:TemplateField>
						<asp:TemplateField HeaderText="Description">
					<ItemTemplate>
						<asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Width="250px"
						Height="75px"></asp:TextBox>
					</ItemTemplate>
				</asp:TemplateField>
			</Columns>
		</asp:GridView>
	</div>
</div>
