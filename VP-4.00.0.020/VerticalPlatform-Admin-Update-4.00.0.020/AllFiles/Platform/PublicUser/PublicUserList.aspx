<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="PublicUserList.aspx.cs" Inherits="VerticalPlatformAdminWeb.Platform.PublicUser.PublicUserList" %>

<%@ Register src="~/ModuleAdmin/Pager.ascx" tagname="Pager" tagprefix="uc1" %>

<asp:Content ID="cntPublicUserList" ContentPlaceHolderID="cphContent" runat="server">

<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>
<script type="text/javascript">

	RegisterNamespace("VP.PublicUserList");

			VP.PublicUserList.Initialize = function() {
			$(document).ready(function() {
				$("#divSearch .searchPublicUserTextBox").keypress(function(event) {
					if (event.which == 13) {
						$(".publicUserLoginSearchButton").click();
						event.returnValue = false;
						event.cancel = true;
						event.keyCode = 0;
						return false;
					}
				});

				$("#divSearch .searchPublicUserTextBox").autocomplete(
				{
					source: function(request, response) {
						var search = $("#divSearch .searchPublicUserTextBox").val();
						$.ajax({
							type: "POST",
							async: false,
							cache: false,
							url: VP.AjaxWebServiceUrl + "/GetPublicUserLogins",
							data: "{'siteId' : '" + VP.SiteId + "', 'email' : '" + search + "'}",
							contentType: "application/json; charset=utf-8",
							dataType: "json",
							success: function(msg) {
								response($.map(msg.d, function(item) {
									return {
										value: item.Name,
										label: item.Name
									}
								}))
							},
							error: function(XMLHttpRequest, textStatus, errorThrown) {
								var error = XMLHttpRequest;
							}
						});
					},
					minLength: 3
				});
			});
		}

		VP.PublicUserList.Initialize();

</script>

	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>
				<asp:Label ID="lblPublicUser" runat="server" Font-Bold="True">Public Users</asp:Label></h3>
		</div>
		<div class="AdminPanelContent">
			<div id="divSearch" class="add-button-container inline-form-container">
			<asp:TextBox ID="txtPublicUserSearch" runat="server" CssClass="searchPublicUserTextBox"></asp:TextBox>
			<asp:Button ID="btnPublicUserSearch" runat="server" Text="Search" 
					onclick="btnPublicUserSearch_Click"  CssClass="btn"/>
			<asp:Button ID="btnPublicUserSearchAll" runat="server" Text="All Users" 
					onclick="btnPublicUserSearchAll_Click" CssClass="btn" />
		    </div>
			
			<asp:GridView ID="gvUserList" runat="server" AutoGenerateColumns="False" 
				onrowdatabound="gvUserList_RowDataBound" onsorting="gvUserList_Sorting" 
				AllowSorting="True" CssClass="common_data_grid table table-bordered" onrowcommand="gvUserList_RowCommand" EnableViewState="false" style="width:auto;">
				<Columns>
					<asp:TemplateField HeaderText="Login ID" SortExpression="id">
						<ItemTemplate>
							<asp:Literal ID="ltlLoginId" runat="server"></asp:Literal>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField HeaderText="E mail" SortExpression="email">
						<ItemTemplate>
							<asp:Literal ID="ltlEmail" runat="server"></asp:Literal>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField HeaderText="User ID">
						<ItemTemplate>
							<asp:Literal ID="ltlUserId" runat="server"></asp:Literal>
						</ItemTemplate>
					</asp:TemplateField>
                    <asp:TemplateField HeaderText="Unlocked">
                        <ItemTemplate>
                            <asp:ImageButton ID="btnUnlockUser" runat="server" OnClick="UnlockUser_Click"
                                CssClass="enable_disable_button" />
                        </ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField>
						<ItemTemplate>
							<asp:LinkButton ID="lbtnDelete" runat="server" CommandName="DeleteUserInfo" CssClass="grid_icon_link delete" ToolTip="Delete">Delete</asp:LinkButton>
						</ItemTemplate>
					</asp:TemplateField>
				</Columns>
			</asp:GridView>
			<asp:Label ID="lblMessage" runat="server"></asp:Label>
			<uc1:Pager ID="publicUserPager" runat="server" />
		</div>
	</div>
</asp:Content>
