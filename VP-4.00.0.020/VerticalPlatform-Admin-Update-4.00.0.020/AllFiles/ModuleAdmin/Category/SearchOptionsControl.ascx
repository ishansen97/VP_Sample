<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SearchOptionsControl.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Category.SearchOptionsControl" %>

	<script src="../../Js/JQuery/jquery.pager.js" type="text/javascript"></script>

	<script src="../../Js/ContentPicker.js" type="text/javascript"></script>

	<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>

	<script type="text/javascript">
		RegisterNamespace("VP.SearchOptionsControl");

		VP.SearchOptionsControl.Initialize = function () {
			$(document).ready(function() {
				var searchOptionIdElement = { contentId: "searchOptionIdText" };
				var searchOptionNameElement = { contentName: "searchOptionNameText" };
				var searchOptionNameOptions = { siteId: VP.SiteId, type: "search option", currentPage: "1", pageSize: "15", showName: "true", bindings: searchOptionIdElement };
				var searchOptionIdOptions = { siteId: VP.SiteId, type: "search option", currentPage: "1", pageSize: "15", bindings: searchOptionNameElement };
				$("input[type=text][id*=searchOptionNameText]").contentPicker(searchOptionNameOptions);
				$("input[type=text][id*=searchOptionIdText]").contentPicker(searchOptionIdOptions);
			});
		}

		VP.SearchOptionsControl.Initialize();
	</script>
<div class="form-horizontal">
    <div class="control-group">
        <label class="control-label">Search Option Id</label>
        <div class="controls">
            <asp:TextBox runat="server" ID="searchOptionIdText"></asp:TextBox>
			<asp:TextBox runat="server" ID="searchOptionNameText"></asp:TextBox>
        </div>
    </div>
    <div class="control-group">
        <div class="controls">
            <asp:Button ID="addSearchOption" runat="server" Text="Add Search Option" CssClass="btn" OnClick="addSearchOption_Click" />
        </div>
    </div>
</div>
<br />
<br />
<asp:GridView ID="searchOptionsGrid" runat="server" AutoGenerateColumns="False" OnRowDataBound="searchOptionsGrid_RowDataBound"
	OnRowDeleting="searchOptionsGrid_RowDeleting" EnableViewState="False" CssClass="common_data_grid table table-bordered" style="width:auto;">
	<Columns>
		<asp:TemplateField HeaderText="Option Id">
			<ItemTemplate>
				<asp:Literal ID="optionId" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "SearchOptionId") %>'></asp:Literal>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="Option Name" SortExpression="Option">
			<ItemTemplate>
				<asp:Literal ID="optionName" runat="server"></asp:Literal>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField ShowHeader="False">
			<ItemTemplate>
				<asp:LinkButton ID="remove" runat="server" CausesValidation="False" CommandName="Delete"
					Text="Remove" CssClass="grid_icon_link delete" ToolTip="Delete"></asp:LinkButton>
			</ItemTemplate>
			<ItemStyle Width="30" />
		</asp:TemplateField>
		
	</Columns>
</asp:GridView>
