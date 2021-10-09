<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddEditCampaignContentData.aspx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.BulkEmail.AddEditCampaignContentData"
	MasterPageFile="~/MasterPage.Master" Title="Campaign Content Data" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">

	<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>
	<script src="../../Js/ContentPicker.js" type="text/javascript"></script>
	<script src="../../Js/JQuery/jquery.pager.js" type="text/javascript"></script>
	<script src="../../Js/Knockout/knockout-2.2.0.js" type="text/javascript"></script>
	<script src="../../Js/MultiColumnContentPicker.js" type="text/javascript"></script>

<script type="text/javascript">

	$(document).ready(function() {
		var selectedButton = $("input[id$='hdnSelectedRow']").val();
		if (selectedButton != '') {
			$("#" + selectedButton).parents('tr').css("background-color", "#eeeeee");
		}
	});
</script>

	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>
				Campaign Content Data</h3>
		</div>
		<div class="AdminPanelContent">
		</div>
	</div>
	<div class="AdminPanelContent">
        <div class="form-horizontal">
            <div class="control-group">
                <label class="control-label">Campaign Type Content Group</label>
                <div class="controls">
                    <asp:DropDownList ID="ddlContentGroups" runat="server" OnSelectedIndexChanged="ddlContentGroups_SelectedIndexChanged"
						AutoPostBack="true">
					</asp:DropDownList>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">Content ID</label>
                <div class="controls">
                    <asp:TextBox ID="txtContentId" runat="server" Width="200px" ValidationGroup="saveContent"></asp:TextBox>
					<asp:RequiredFieldValidator ID="rfvContentId" runat="server" ErrorMessage="Please enter content id."
						ControlToValidate="txtContentId" ValidationGroup="saveContent">*</asp:RequiredFieldValidator>
					<asp:CompareValidator ID="cvContentId" runat="server" ErrorMessage="Content id should be a numeric value."
						ControlToValidate="txtContentId" Operator="DataTypeCheck" Type="Integer" ValidationGroup="saveContent">*</asp:CompareValidator>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">Sort Order</label>
                <div class="controls">
                    <asp:TextBox ID="txtSortOrder" runat="server" Width="200px" ValidationGroup="saveContent"></asp:TextBox></span>
					<asp:RequiredFieldValidator ID="rfvSortOrder" runat="server" ErrorMessage="Please enter sort order."
						ControlToValidate="txtSortOrder" ValidationGroup="saveContent">*</asp:RequiredFieldValidator>
					<asp:CompareValidator ID="cvSortOrder" runat="server" ErrorMessage="Sort order should be a numeric value."
						ControlToValidate="txtSortOrder" Operator="DataTypeCheck" Type="Integer" ValidationGroup="saveContent">*</asp:CompareValidator>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">Enabled</label>
                <div class="controls"><asp:CheckBox ID="chkEnabled" runat="server" /></div>
            </div>
            <div  class="control-group">
                <asp:Button ID="btnSaveContent" runat="server" Text="Save Content Data"
				OnClick="btnSaveContent_Click" ValidationGroup="saveContent" CssClass="btn"
				 />
			    <asp:Button ID="btnReset" runat="server" Text="Reset" OnClick="btnReset_Click"
				CssClass="btn" />
			    <asp:Button ID="btnClose" runat="server" Text="Close" OnClick="btnClose_Click"
				CssClass="btn" />
            </div>
        </div>
		<br />
		<asp:Repeater runat="server" ID="rptrCampaignTypeContentGroup" OnItemDataBound="rptrCampaignTypeContentGroup_ItemDataBound">
			<ItemTemplate>
				<asp:Label ID="lblContentGroup" runat="server"></asp:Label>
				<asp:GridView ID="gvCampaignContentData" runat="server" AutoGenerateColumns="False"
					CssClass="common_data_grid table table-bordered" OnRowDataBound="gvCampaignContentData_RowDataBound"
					OnRowCommand="gvCampaignContentData_RowCommand" width="70%">
					<AlternatingRowStyle CssClass="DataTableRowAlternate" />
					<RowStyle CssClass="DataTableRow" />
					<Columns>
						<asp:BoundField HeaderText="Content Id" DataField="ContentId" ItemStyle-Width="70" />
						<asp:TemplateField HeaderText="Content">
							<ItemTemplate>
								<asp:Label ID="lblContent" runat="server"></asp:Label>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:BoundField HeaderText="Sort Order" DataField="SortOrder" ItemStyle-Width="60" />
						<asp:TemplateField HeaderText="Site">
							<ItemTemplate>
								<asp:Label ID="lblSite" runat="server"></asp:Label>
							</ItemTemplate>
							<ItemStyle Width="120" />
						</asp:TemplateField>
						<asp:TemplateField>
							<ItemTemplate>
								<asp:HyperLink ID="lnkAssociateContent" runat="server" CssClass="aDialog" Text="Associate&nbsp;Content"></asp:HyperLink>
							</ItemTemplate>
							<ItemStyle Width="120" />
						</asp:TemplateField>
						<asp:TemplateField>
							<ItemTemplate>
								<asp:LinkButton ID="lbtnEdit" runat="server" CommandName="EditCampaignContentData"
									ValidationGroup="CampaignContentData" CausesValidation="false" CssClass="grid_icon_link edit" ToolTip="Edit">Edit</asp:LinkButton>
								<asp:LinkButton ID="lbtnDelete" runat="server" CommandName="DeleteCampaignContentData"
									ValidationGroup="CampaignContentData" OnClientClick="return confirm('Are you sure to delete campaign content data?');"
									CausesValidation="false" CssClass="grid_icon_link delete" ToolTip="Delete">Delete</asp:LinkButton>
							</ItemTemplate>
							<ItemStyle Width="50" />
						</asp:TemplateField>
					</Columns>
					<EmptyDataTemplate>
						No campaign content data found.</EmptyDataTemplate>
				</asp:GridView>
				<br />
			</ItemTemplate>
		</asp:Repeater>
		<asp:HiddenField ID="hdnSelectedRow" runat="server" />
	</div>
</asp:Content>
