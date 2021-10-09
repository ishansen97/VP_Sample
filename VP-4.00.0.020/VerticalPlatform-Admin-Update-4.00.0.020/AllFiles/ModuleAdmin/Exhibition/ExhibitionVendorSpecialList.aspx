<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ExhibitionVendorSpecialList.aspx.cs" 
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Exhibition.ExhibitionVendorSpecialList" 
MasterPageFile="~/MasterPage.Master"%>

<%@ Register src="Pager.ascx" tagname="Pager" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
	<div class="AdminPanelHeader">
		<h3>
			<asp:Literal ID="ltlTitle" runat="server"></asp:Literal>
		</h3>
	</div>
	<div class="AdminPanelContent">
	<asp:HyperLink ID="lnkAddSpecial" runat="server" CssClass="aDialog common_text_button">Add</asp:HyperLink>
	<br />
	<br />
		<asp:GridView runat="server" ID="gvSpecials" 
			AutoGenerateColumns="false" onrowdatabound="gvSpecials_RowDataBound" 
			onrowcommand="gvSpecials_RowCommand" CssClass="common_data_grid">
			<Columns>
				<asp:BoundField HeaderText="ID" DataField="Id" />
				<asp:BoundField HeaderText="Title" DataField="Title" />
				<asp:BoundField HeaderText="Description" DataField="Description" />
				<asp:BoundField HeaderText="Image Name" DataField="ImageName" />
				<asp:CheckBoxField HeaderText="Enabled" DataField="Enabled" ReadOnly="true"/>
				<asp:TemplateField>
					<ItemTemplate>
						<asp:HyperLink ID="lnkEdit" runat="server" CssClass="aDialog grid_icon_link edit">Edit</asp:HyperLink>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField>
					<ItemTemplate>
						<asp:LinkButton ID="lbtnDelete" CommandName="DeleteSpecial" runat="server" CssClass="grid_icon_link delete">Delete</asp:LinkButton>
					</ItemTemplate>
				</asp:TemplateField>
			</Columns>
			<EmptyDataTemplate>
				No Exhibition Vendor Special found .
			</EmptyDataTemplate>
		</asp:GridView>
		<uc1:Pager ID="pagerVendors" runat="server" />
		
		
		<asp:HiddenField runat="server" ID="hdnExhibitionVendorSpecialId" />
		<asp:Label ID="lblMessage" runat="server"></asp:Label>
		<br />
		<asp:Button runat="server" Text="Back" ID="btnBack" onclick="btnBack_Click" 
			style="height: 26px" CssClass="common_text_button" />
	</div>
</asp:Content>

