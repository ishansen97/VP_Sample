<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="AdvertisementType.aspx.cs" Inherits="VerticalPlatformAdminWeb.Platform.Advertisement.AdvertisementType"
	Title="Untitled Page" %>
	
<asp:Content ID="conContent" ContentPlaceHolderID="cphContent" runat="server">
	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>
				<asp:Label ID="lblHeader" runat="server" BackColor="Transparent">Advertisement Type</asp:Label></h3>
		</div>
		<div class="AdminPanelContent">
		<div class="add-button-container"><asp:HyperLink ID="lnkAddAdType" runat="server" CssClass="aDialog btn" >Add Advertisement Type</asp:HyperLink></div>
		
			<asp:UpdateProgress ID="UpdateProgress1" runat="server">
				<ProgressTemplate>
					<asp:Image ID="imgProgress" runat="server" ImageUrl="~/Images/Progress.gif" />
				</ProgressTemplate>
			</asp:UpdateProgress>
			<asp:GridView ID="gvAdType" runat="server" AutoGenerateColumns="false" OnRowDataBound="gvAdType_RowDataBound" 
				CssClass="common_data_grid  table table-bordered" style="width:auto;">
				<Columns>
					<asp:BoundField DataField="Id" HeaderText="ID" ItemStyle-Width="40" />
					<asp:BoundField DataField="AdvertisementTypeName" HeaderText="Name" ItemStyle-Width="200" />
					<asp:BoundField DataField="Width" HeaderText="Width"/>
					<asp:BoundField DataField="Height" HeaderText="Height"/>
					<asp:CheckBoxField DataField="Enabled" HeaderText="Enabled"/>
					<asp:TemplateField ItemStyle-Width="20">
						<ItemTemplate>
							<asp:HyperLink ID="lnkEditAdType" runat="server" CssClass="aDialog grid_icon_link edit" ToolTip="Edit">Edit</asp:HyperLink>
						</ItemTemplate>
					</asp:TemplateField>
				</Columns>
			</asp:GridView>
		</div>
	</div>
</asp:Content>
