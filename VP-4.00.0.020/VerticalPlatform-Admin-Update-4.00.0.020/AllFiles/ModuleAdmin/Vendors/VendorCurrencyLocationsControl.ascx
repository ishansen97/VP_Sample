<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="VendorCurrencyLocationsControl.ascx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Vendors.VendorCurrencyLocationsControl" %>

<script src="../../Js/Location.js" type="text/javascript"></script>
<div class="locations">
	<div class="header">Location Type</div>
    <div class="inline-form-content bottom-space">
        <div class="form-inline">
             <label class="radio"><asp:RadioButton ID="rdbRegion" runat="server" GroupName="Location" Checked="true" /> Region</label>
            <span class="content region">
			    <asp:DropDownList ID="ddlRegion" runat="server" AppendDataBoundItems="true">
				    <asp:ListItem Text="Select" Value=""></asp:ListItem>
			    </asp:DropDownList>
		    </span>
        </div>
    </div>
    <div class="inline-form-content bottom-space">
        <div class="form-inline">
             <label class="radio">
                <asp:RadioButton ID="rdbCountry" runat="server" GroupName="Location" /> Country
             </label>
             <span class="content country" style="display: none">
			    <asp:DropDownList ID="ddlCountry" runat="server" AppendDataBoundItems="true" Width="265">
				    <asp:ListItem Text="Select" Value=""></asp:ListItem>
			    </asp:DropDownList>
		    </span>
        </div>
    </div>
    <div style="display: none;">
		<asp:RadioButton ID="rdbState" runat="server" GroupName="Location" />
		<asp:DropDownList ID="ddlStateCountry" runat="server">
		</asp:DropDownList>
		<asp:CheckBox ID="chkExcludeState" runat="server" />
	</div>
	<div class="header">Currency</div>
    <div class="inline-form-content bottom-space">
        <div class="form-inline">
             <span class="title">Currency</span>
             <asp:DropDownList ID="ddlCurrency" runat="server" AppendDataBoundItems="true">
			    <asp:ListItem Text="Select" Value=""></asp:ListItem>
		    </asp:DropDownList>
        </div>
    </div>
</div>
<br />
<div class="add-button-container"><asp:Button ID="btnAddCurrencyLocation" runat="server" Text="Add Currency Location" CssClass="btn location_btn"
	OnClick="btnAddCurrencyLocation_Click" /><asp:HiddenField ID="hdnAddCurrencyLocation" runat="server"
		Value="false" />
		
</div>
<asp:GridView ID="gvVendorCurrencyLocation" runat="server" AutoGenerateColumns="false" CssClass="common_data_grid table table-bordered"
	OnRowCommand="gvVendorCurrencyLocation_RowCommand" OnRowDataBound="gvVendorCurrencyLocation_RowDataBound" style="width:auto">
	<Columns>
		<asp:BoundField HeaderText="Location Type" DataField="LocationType" />
		<asp:TemplateField HeaderText="Location">
			<ItemTemplate>
				<asp:Label ID="lblLocationName" runat="server"></asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:BoundField HeaderText="Location Id" DataField="LocationId" />
		<asp:TemplateField HeaderText="Currency">
			<ItemTemplate>
				<asp:Label ID="lblCurrency" runat="server"></asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField ItemStyle-Width="30">
			<ItemTemplate>
				<asp:LinkButton ID="lbtnDelete" runat="server" CommandName="DeleteCurrencyLocation" CssClass="deleteLocation grid_icon_link delete" ToolTip="Delete"
					OnClientClick="return confirm('Are you sure to delete the vendor currency location?');">Delete</asp:LinkButton>
			</ItemTemplate>
		</asp:TemplateField>
	</Columns>
	<EmptyDataTemplate>
		No currency locations defined.
	</EmptyDataTemplate>
</asp:GridView>
<label class="checkbox" style="display:inline-block"><asp:CheckBox ID="chkUpdateAllProducts" runat="server" Text="Update All Products" /></label>
<br />