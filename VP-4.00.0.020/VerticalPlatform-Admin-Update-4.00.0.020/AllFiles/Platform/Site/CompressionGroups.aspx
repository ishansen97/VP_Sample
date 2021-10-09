<%@ Page Title="Compression Group List" Language="C#" MasterPageFile="~/MasterPage.Master"
	AutoEventWireup="true" CodeBehind="CompressionGroups.aspx.cs" Inherits="VerticalPlatformAdminWeb.Platform.Site.CompressionGroups" %>

<%@ Register TagPrefix="ajaxToolkit" Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" %>
<%@ Register Src="../../ModuleAdmin/Pager.ascx" TagName="Pager" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
	<script src="../../Js/JQuery/jquery.pager.js" type="text/javascript"></script>
	<script src="../../Js/ContentPicker.js" type="text/javascript"></script>
	<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>
	<script type="text/javascript">
		RegisterNamespace("VP.CompressionGroupList");

		VP.CompressionGroupList.Initialize = function () {
			$(document).ready(function () {
				var groupIdElement = { contentId: "txtGroupId" };
				var groupNameElement = { contentName: "txtGroupName" };
				var groupNameOptions = { siteId: VP.SiteId, type: "ProductCompressionGroup", currentPage: "1", pageSize: "15", showName: "true", bindings: groupIdElement };
				var groupIdOptions = { siteId: VP.SiteId, type: "ProductCompressionGroup", currentPage: "1", pageSize: "15", bindings: groupNameElement };
				$("input[type=text][id*=txtGroupName]").contentPicker(groupNameOptions);
				$("input[type=text][id*=txtGroupId]").contentPicker(groupIdOptions);

				$(".article_srh_btn").click(function () {
					$(".article_srh_pane").toggle("slow");
					$(this).toggleClass("hide_icon");
					$("#divSearchCriteria").toggleClass("hide");
				});

				$("#divSearchCriteria").append(VP.CompressionGroupList.GetSearchCriteriaText());
			});
		}

		VP.CompressionGroupList.GetSearchCriteriaText = function () {
			var txtGroupNameValue = $("input[id$='txtGroupName']");
			var txtGroupIdValue = $("input[id$='txtGroupId']");

			var searchHtml = "";
			if (txtGroupNameValue.length && txtGroupNameValue.val().trim().length > 0) {
				searchHtml += " ; <b>Name : </b> " + txtGroupNameValue.val().trim();
			}

			if (txtGroupIdValue.length && txtGroupIdValue.val().trim().length > 0) {
				searchHtml += " ; <b>Id : </b> " + txtGroupIdValue.val().trim();
			}

			searchHtml = searchHtml.replace(' ;', '(');
			if (searchHtml != "") {
				searchHtml += " )";
			}
			return searchHtml;
		};

		VP.CompressionGroupList.Initialize();
	</script>
	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>
				<asp:Label ID="lblTitle" runat="server"></asp:Label>
			</h3>
		</div>
		<div class="AdminPanelContent">
			<asp:Panel ID="pnlCompressionGroupList" runat="server">
				<div class="article_srh_btn">
					Search</div>
				<div id="divSearchCriteria">
				</div>
				<br />
				<div id="divCompressionGroupSearch" runat="server" class="article_srh_pane" style="display: none;">
					<div class="inline-form-container">
                    <span class="title">Group Name</span>
					    <asp:TextBox ID="txtGroupName" runat="server"></asp:TextBox>
					    <asp:TextBox ID="txtGroupId" runat="server"></asp:TextBox>
					    <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click"
						    CssClass="btn" />
					    <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="btn"
						   OnClick="btnReset_Click" />
				    </div>
                </div>
				<br />
				<div class="add-button-container"><asp:HyperLink ID="lnkAddGroup" runat="server" Text="Add Compression Group" CssClass="aDialog btn"></asp:HyperLink></div>
				<asp:GridView ID="gvCompressionGroups" runat="server" AutoGenerateColumns="False"
					OnRowCommand="gvCompressionGroups_RowCommand" OnRowDataBound="gvCompressionGroups_RowDataBound"
					CssClass="common_data_grid table table-bordered">
					<AlternatingRowStyle CssClass="DataTableRowAlternate" />
					<RowStyle CssClass="DataTableRow" />
					<Columns>
						<asp:TemplateField ItemStyle-Width="30px">
							<ItemTemplate>
								<asp:LinkButton ID="lbtnGroupEnable" runat="server" CommandName="EnableGroup" CommandArgument='<%#Eval("Id") %>'>
									<asp:Image ID="imgEnabledState" runat="server" />
								</asp:LinkButton>
							</ItemTemplate>
							<ItemStyle Width="30px" />
						</asp:TemplateField>
						<asp:BoundField DataField="Id" HeaderText="ID" ItemStyle-Width="75px">
							<ItemStyle Width="75px" />
						</asp:BoundField>
						<asp:BoundField DataField="GroupName" HeaderText="Group Name" ItemStyle-Width="150px">
							<ItemStyle Width="150px" />
						</asp:BoundField>
						<asp:BoundField DataField="GroupTitle" HeaderText="Group Title" ItemStyle-Width="150px">
							<ItemStyle Width="150px" />
						</asp:BoundField>
						<asp:TemplateField ItemStyle-Width="100px" HeaderText="Created" SortExpression="Created">
							<ItemTemplate>
								<asp:Label ID="lblCreatedDate" runat="server"></asp:Label>
							</ItemTemplate>
							<ItemStyle Width="100px" />
						</asp:TemplateField>
						<asp:TemplateField ItemStyle-Width="100px" HeaderText="Modified" SortExpression="Modified">
							<ItemTemplate>
								<asp:Label ID="lblModifiedDate" runat="server"></asp:Label>
							</ItemTemplate>
							<ItemStyle Width="100px" />
						</asp:TemplateField>
						<asp:TemplateField ItemStyle-Width="100px" HeaderText="Sort Order">
							<ItemTemplate>
								<asp:Label ID="lblSortOrder" runat="server"></asp:Label>
							</ItemTemplate>
							<ItemStyle Width="100px" />
						</asp:TemplateField>
						<asp:TemplateField ItemStyle-Width="100px" HeaderText="Add Product">
							<ItemTemplate>
								<asp:HyperLink ID="lnkProducts" runat="server">Products</asp:HyperLink>
							</ItemTemplate>
							<ItemStyle Width="100px" />
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Default Group">
							<ItemTemplate>
								<asp:CheckBox ID="chkIsDefaultGroup" runat="server"></asp:CheckBox>
							</ItemTemplate>
							<ItemStyle Width="100px" />
						</asp:TemplateField>
						<asp:TemplateField ItemStyle-Width="50px" Visible="true">
							<ItemTemplate>
								<asp:HyperLink ID="lnkEditCompressionGroup" runat="server" CssClass="aDialog grid_icon_link edit"
									ToolTip="Edit">Edit</asp:HyperLink>
								<asp:LinkButton ID="lbtnDelete" runat="server" CommandName="DeleteGroup" CssClass="grid_icon_link delete"
									OnClientClick="return confirm('Are you sure to delete the compression group?');"
									ToolTip="Delete">Delete</asp:LinkButton>
							</ItemTemplate>
							<ItemStyle Width="50px" />
						</asp:TemplateField>
					</Columns>
					<EmptyDataTemplate>
						No Compression Groups Found.
					</EmptyDataTemplate>
				</asp:GridView>
				<br />
				<uc1:Pager ID="CompressionGroupListPager" runat="server" />
				<br />
			</asp:Panel>
		</div>
	</div>
</asp:Content>
