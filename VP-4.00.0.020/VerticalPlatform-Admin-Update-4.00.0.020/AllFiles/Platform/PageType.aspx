<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="PageType.aspx.cs" Inherits="VerticalPlatformAdminWeb.Platform.PageType" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">

	<script type="text/javascript">
		RegisterNamespace("VP.PageType");
		$(document).ready(function() {
			$(".pagetype_search_btn").click(function() {
				$(".pagetype_search_pane").toggle("slow");
				$(this).toggleClass("hide_icon");
				$("#divSearchCriteria").toggleClass("hide");
			});

			$("#divSearchCriteria").append(VP.PageType.GetSearchCriteriaText());
		});

		VP.PageType.GetSearchCriteriaText = function() {
			var ddlPageCategory = $("input[id$='ddlPageCategory'] option:selected");
			var searchHtml = "";

			if (ddlPageCategory.text().trim().length > 0) {
				searchHtml += " ; <b>Page Category</b> : " + ddlPageCategory.val().trim();
			}

			searchHtml = searchHtml.replace(' ;', '(');
			if (searchHtml) {
				searchHtml += " )";
			}
			
			return searchHtml;
		};
	</script>
	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>
				<asp:Label ID="lblHeader" runat="server" BackColor="Transparent">Page Type List</asp:Label></h3>
		</div>
		<div class="AdminPanelContent">
			<div class="pagetype_search_btn">Filter</div>
			<div id="divSearchCriteria"></div>
			<br />
			<div id="divSearchPane" class="pagetype_search_pane" style="display: none;">
                <div class="inline-form-container">
                    <span class="title">Page Category</span>
                    <asp:DropDownList ID="ddlPageCategory" runat="server"></asp:DropDownList>
                    <asp:Button ID="btnFilter" runat="server" Text="Filter" 
						ValidationGroup="FilterList" CssClass="btn" onclick="btnFilter_Click"
						 />
					<asp:Button ID="btnReset" runat="server" Text="Reset" 
						CssClass="btn" onclick="btnReset_Click" />
                </div>
				
			</div>
            <br />
				<div class="add-button-container"><asp:HyperLink ID="lnkAddPageType" runat="server" Text="Add Page Type" CssClass="aDialog btn"></asp:HyperLink></div>
				
				<asp:GridView ID="gvPageType" runat="server" AutoGenerateColumns="False" DataKeyNames="PageId"
								OnRowDataBound="gvPageType_RowDataBound" Width="100%" CssClass="common_data_grid table table-bordered" 
				onrowcommand="gvPageType_RowCommand">
					<AlternatingRowStyle CssClass="DataTableRowAlternate" />
					<RowStyle CssClass="DataTableRow" />
					<Columns>
						<asp:BoundField HeaderText="ID" DataField="Id" />
						<asp:BoundField DataField="SiteId" HeaderText="Site Id" />
						<asp:TemplateField HeaderText="Page Category">
							<ItemTemplate>
								<asp:Label ID="lblPageCategory" runat="server"/>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Page">
							<ItemTemplate>
								<asp:Label ID="lblPage" runat="server"/>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:BoundField DataField="Created" HeaderText="Created" />
						<asp:BoundField DataField="Modified" HeaderText="Modified" />
						<asp:TemplateField HeaderText="Enabled">
							<ItemTemplate>
								<asp:CheckBox ID="chkEnabled" runat="server" Enabled="false" />
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField>
							<ItemTemplate>
								<asp:HiddenField ID="hdnPageTypeId" runat="server" />
								<asp:HyperLink ID="lnkEdit" Text="Edit" runat="server" CssClass="aDialog grid_icon_link edit" ToolTip="Edit"></asp:HyperLink>
								<asp:LinkButton OnClientClick="return confirm('Are you sure?');" ID="lbtnDelete"
										runat="server" Text="Delete" CommandName="DeletePageType" CssClass="grid_icon_link delete" ToolTip="Delete"></asp:LinkButton>
							</ItemTemplate>
						</asp:TemplateField>
					</Columns>
				</asp:GridView>
		</div>
	</div>
</asp:Content>
