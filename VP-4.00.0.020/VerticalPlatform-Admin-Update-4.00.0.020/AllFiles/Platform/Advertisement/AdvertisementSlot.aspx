<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="AdvertisementSlot.aspx.cs" Inherits="VerticalPlatformAdminWeb.Platform.Advertisement.AdvertisementSlot" %>

<asp:Content ID="conContent" runat="server" ContentPlaceHolderID="cphContent">
	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>
				<asp:Label ID="lblHeader" runat="server" BackColor="Transparent">Advertisement Slots</asp:Label>
			</h3>
		</div>
		<div class="AdminPanelContent">
		<div class="add-button-container"><asp:HyperLink ID="lnkAddNew" runat="server" Text="Add Ad Slot" CssClass="aDialog btn"></asp:HyperLink></div>
		<asp:UpdateProgress ID="UpdateProgress1" runat="server">
				<ProgressTemplate>
					<asp:Image ID="imgProgress" runat="server" ImageUrl="~/Images/Progress.gif" />
				</ProgressTemplate>
			</asp:UpdateProgress>

			<div id="AdSlotContent" runat="server">
				<div class="inline-form-container">
					<span class="title">
						<asp:Label ID="lblAdvertisementType" runat="server" Text="Advertisement Type"></asp:Label>
					</span>
					<asp:DropDownList ID="ddlAdvertisementType" runat="server" AutoPostBack="True" 
						OnSelectedIndexChanged="ddlAdvertisementType_SelectedIndexChanged"></asp:DropDownList>
				</div>
				<br />
				<asp:GridView ID="gvAdSlot" runat="server" AutoGenerateColumns="False" OnRowDataBound="gvAdSlot_RowDataBound"
					OnRowCommand="gvAdSlot_RowCommand" CssClass="common_data_grid table table-bordered">
					<Columns>
						<asp:BoundField HeaderText="ID" DataField="Id" ItemStyle-Width="50" />
						<asp:TemplateField HeaderText="Vendor" ControlStyle-Width="140">
							<ItemTemplate>
								<asp:Label ID="lblVendor" runat="server"></asp:Label>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Url" ControlStyle-Width="140">
							<ItemTemplate>
								<asp:Label ID="lblUrl" runat="server"></asp:Label>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:BoundField HeaderText="Description" DataField="Description" ItemStyle-Width="100" />
						<asp:TemplateField HeaderText="Start Date" ControlStyle-Width="75">
							<ItemTemplate>
								<asp:Label ID="lblStartDate" runat="server"></asp:Label>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText="End Date" ControlStyle-Width="75">
							<ItemTemplate>
								<asp:Label ID="lblEndDate" runat="server"></asp:Label>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:BoundField HeaderText="Target" DataField="ImpressionTarget" ItemStyle-Width="50" />
						<asp:CheckBoxField HeaderText="Enabled" DataField="Enabled" ItemStyle-Width="50" />
						<asp:TemplateField ItemStyle-Width="50px">
							<ItemTemplate>
								<asp:HyperLink ID="lnkEdit" runat="server" Text="Edit" CssClass="aDialog grid_icon_link edit" ToolTip="Edit"></asp:HyperLink>
								<asp:LinkButton ID="lbtnDelete" runat="server" CausesValidation="false" CommandName="DeleteAdSlot" CssClass="grid_icon_link delete" ToolTip="Delete"
									Text="Delete"></asp:LinkButton>
							</ItemTemplate>
						</asp:TemplateField>
					</Columns>
				</asp:GridView>
				<asp:HiddenField ID="hdnAdSlotId" runat="server" />
				<asp:HiddenField ID="hdnUrlId" runat="server" />
			</div>
		</div>
	</div>
</asp:Content>
