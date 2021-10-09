<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="LocationControl.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Vendors.LocationControl" %>

<script src="../../Js/Location.js" type="text/javascript"></script>

<div class="locations">
	<div class="header">
		Location Type</div>
    <div class="inline-form-content bottom-space">
        <div class="form-inline">
            <label class="radio">
                <asp:RadioButton ID="rdbRegion" runat="server" GroupName="Location" Checked="true" /> Region
            </label>
            <span class="content region">
			    <asp:DropDownList ID="ddlRegion" runat="server" AppendDataBoundItems="true">
				    <asp:ListItem Text="Select" Value=""></asp:ListItem>
			    </asp:DropDownList>
                <label class="checkbox">
                    <asp:CheckBox ID="chkExcludeRegion" runat="server" /> Exclude
                </label> 
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
                <label class="checkbox">
                    <asp:CheckBox ID="chkExcludeCountry" runat="server" /> Exclude
                </label>
            </span>
        </div>
    </div>

	<div style="display: none;">
		<asp:RadioButton ID="rdbState" runat="server" GroupName="Location" />
		<asp:DropDownList ID="ddlStateCountry" runat="server">
		</asp:DropDownList>
		<asp:CheckBox ID="chkExcludeState" runat="server" />
	</div>	
	</div>
	
</div>
<div class="add-button-container"><asp:Button ID="btnAddLocation" runat="server" Text="Add Location" CssClass="btn location_btn"
	OnClick="btnAddLocation_Click" /><asp:HiddenField ID="hdnAddLocation" runat="server"
		Value="false" />
	 <label class="checkbox" style="display:inline-block"><asp:CheckBox ID="chkUpdateAllProducts" runat="server" Text="Update All Products" /></label>	
		
</div>

<asp:GridView ID="gvLocation" runat="server" AutoGenerateColumns="false" CssClass="common_data_grid table table-bordered"
	OnRowCommand="gvLocation_RowCommand" OnRowDataBound="gvLocation_RowDataBound" style="width:auto">
	<Columns>
		<asp:BoundField HeaderText="Location Type" DataField="LocationType" />
		<asp:TemplateField HeaderText="Location">
			<ItemTemplate>
				<asp:Label ID="lblLocationName" runat="server"></asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:BoundField HeaderText="Location Id" DataField="LocationId" />
		<asp:CheckBoxField HeaderText="Excluded" DataField="Exclude" />
		<asp:TemplateField ItemStyle-Width="30">
			<ItemTemplate>
				<asp:LinkButton ID="lbtnDelete" runat="server" CommandName="DeleteLocation" CssClass="deleteLocation grid_icon_link delete" ToolTip="Delete"
					OnClientClick="return confirm('Are you sure to delete the location?');">Delete</asp:LinkButton>
			</ItemTemplate>
		</asp:TemplateField>
	</Columns>
	<EmptyDataTemplate>
		No locations defined.
	</EmptyDataTemplate>
</asp:GridView>
<br />
