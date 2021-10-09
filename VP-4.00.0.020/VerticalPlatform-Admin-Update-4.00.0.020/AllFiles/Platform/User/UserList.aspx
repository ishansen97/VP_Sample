<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserList.aspx.cs" MasterPageFile="~/MasterPage.Master"
	Inherits="VerticalPlatformAdminWeb.Platform.User.UserList" %>
<%@ Register Src="../../ModuleAdmin/Pager.ascx" TagName="Pager" TagPrefix="uc1" %>
<asp:Content ID="cntUserList" runat="server" ContentPlaceHolderID="cphContent">

	<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>

	<script type="text/javascript">
		RegisterNamespace("VP.AdminUserList");
		$(document).ready(function () {
			$(".article_srh_btn").click(function () {
				$(".adminUser_srh_pane").toggle("slow");
				$(this).toggleClass("hide_icon");
				$("#divSearchCriteria").toggleClass("hide");
			});

			$("#divSearchCriteria").append(VP.AdminUserList.GetSearchCriteriaText());
		});

		VP.AdminUserList.GetSearchCriteriaText = function () {
			var txtFirstName = $("input[id$='txtFirstName']");
			var txtLastName = $("input[id$='txtLastName']");

			var searchHtml = "";
			if (txtFirstName.val().trim().length > 0) {
				searchHtml += " ; <b>First Name</b> : " + txtFirstName.val().trim();
			}
			if (txtLastName.val().trim().length > 0) {
				searchHtml += " ; <b>Last Name</b> : " + txtLastName.val().trim();
			}

			searchHtml = searchHtml.replace(' ;', '(');
			if (searchHtml != "") {
				searchHtml += " )";
			}
			return searchHtml;
		};
	</script>
	
	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>
				<asp:Label ID="lblHeader" runat="server">Admin User Management</asp:Label>
			</h3>
		</div>
		<div class="AdminPanelContent">
			
			<div class="article_srh_btn">
				Filter
			</div>
			<div id="divSearchCriteria">
			</div>
			<br />
			<div id="divSearchPane" class="adminUser_srh_pane" style="display: none;">
				<div class="form-horizontal">
                    <div class="control-group">
                        <label class="control-label">Admin Name</label>
                        <div class="controls">
                            <div class="input-prepend">
                                <span class="add-on">First Name</span><asp:TextBox ID="txtFirstName" runat="server" Width="200px" ValidationGroup="FilterList"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                    <div class="control-group">
                        <div class="controls">
                            <div class="input-prepend">
                                <span class="add-on">Last Name</span>
                                <asp:TextBox ID="txtLastName" runat="server" Width="200px" ValidationGroup="FilterList"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                    <div class="form-actions">
                        <asp:Button ID="btnfilter" runat="server" Text="Filter" ValidationGroup="FilterList"
								OnClick="btnfilter_Click" CssClass="btn" />
                        <asp:Button ID="btnReset" runat="server" Text="Reset" OnClick="btnReset_Click"
								CssClass="btn" />
                    </div>
                </div>
               
			</div>
			<br />
			<div class="add-button-container"><asp:HyperLink ID="lnkAddUser" runat="server" CssClass="aDialog btn">Add User</asp:HyperLink></div>
			
			
			<asp:GridView ID="gvUser" runat="server" AutoGenerateColumns="False" OnRowDataBound="gvUser_RowDataBound"
				OnRowCommand="gvUser_RowCommand" CssClass="common_data_grid table table-bordered" EnableViewState="false" style="width:auto"
				AllowSorting = "true" OnSorting="gvUser_Sorting">
				<AlternatingRowStyle />
				<RowStyle CssClass="DataTableRow" />
				<Columns>
				<asp:TemplateField HeaderText="ID" SortExpression="Id">
						<ItemTemplate>
							<asp:Literal ID="ltlId" runat="server"></asp:Literal>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField HeaderText="First Name" SortExpression="FirstName">
						<ItemTemplate>
							<asp:Literal ID="ltlFirstName" runat="server"></asp:Literal>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField HeaderText="Last Name" SortExpression="LastName">
						<ItemTemplate>
							<asp:Literal ID="ltlLastName" runat="server"></asp:Literal>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField HeaderText="User Name">
						<ItemTemplate>
							<asp:Label ID="lblUserName" runat="server"></asp:Label>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField HeaderText="Assigned Roles">
						<ItemTemplate>
							<asp:Literal ID="ltlAssignedRoles" runat="server"></asp:Literal>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField HeaderText="Locked">
						<ItemTemplate>
							<asp:CheckBox ID="chkLocked" runat="server" Enabled="false" />
							<asp:LinkButton ID="lbtnUnlock" runat="server" CssClass="unlock" CommandName="UnlockUser">Unlock</asp:LinkButton>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField HeaderText="Change Password">
						<ItemTemplate>
							<asp:HyperLink ID="lnkResetPassword" runat="server" CssClass="aDialog">Change Password</asp:HyperLink>
						</ItemTemplate>
					</asp:TemplateField>		
					<asp:TemplateField>
						<ItemTemplate>
							<asp:HyperLink ID="lnkRoles" runat="server" CssClass="aDialog">Roles</asp:HyperLink>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField>
						<ItemTemplate>
							<asp:LinkButton ID="lbtnDelete" CausesValidation="false" CommandName="DeleteUser"
								runat="server" OnClientClick="return confirm('Are you sure to delete the user?');" CssClass="grid_icon_link delete" ToolTip="Delete">Delete</asp:LinkButton>
                            
                            <asp:LinkButton ID="lbtnDisableTwoFactor" CausesValidation="false" CommandName="DisableTwoFactor"
                                            runat="server" OnClientClick="return confirm('Are you sure you want to disable Two Factor Authentication?');" CssClass="grid_icon_link disable" ToolTip="Disable Two-Factor">Disable Two-Factor</asp:LinkButton>
						</ItemTemplate>
					</asp:TemplateField>
				</Columns>
				<EmptyDataTemplate>No Admin Users Found</EmptyDataTemplate>
			</asp:GridView>
			<uc1:Pager ID="pgUserList" runat="server" visible="true"/>
			<br />
			<asp:Label ID="lblMessage" runat="server"></asp:Label>
			<asp:Panel ID="pnlSuperUser" runat="server">
			<br />
				<h4>Super User List</h4>
				<div class="add-button-container"><asp:HyperLink ID="lnkAddSuperUser" runat="server" CssClass="aDialog btn">Add Super User</asp:HyperLink></div>
				
				<asp:GridView ID="gvSuperUser" runat="server" AutoGenerateColumns="false" OnRowDataBound="gvSuperUser_RowDataBound"
					OnRowCommand="gvSuperUser_RowCommand" CssClass="common_data_grid table table-bordered" style="width:auto">
					<AlternatingRowStyle />
					<RowStyle CssClass="DataTableRow" />
					<Columns>
						<asp:BoundField DataField="Id" HeaderText="ID" />
						<asp:BoundField DataField="FirstName" HeaderText="First Name" />
						<asp:BoundField DataField="LastName" HeaderText="Last Name" />
						<asp:TemplateField HeaderText="User Name">
							<ItemTemplate>
								<asp:Label ID="lblUserName" runat="server"></asp:Label>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Locked">
							<ItemTemplate>
								<asp:CheckBox ID="chkLocked" runat="server" Enabled="false" />
								<asp:LinkButton ID="lbtnUnlock" runat="server" CssClass="unlock" CommandName="UnlockSuperUser">Unlock</asp:LinkButton>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Change Password">
							<ItemTemplate>
								<asp:HyperLink ID="lnkResetPassword" runat="server" CssClass="aDialog">Change Password</asp:HyperLink>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField>
						<ItemTemplate>
							<asp:LinkButton ID="lbtnDelete" CausesValidation="false" CommandName="DeleteSuperUser"
								runat="server" OnClientClick="return confirm('Are you sure to delete the super user?');" CssClass="grid_icon_link delete" ToolTip="Delete">Delete</asp:LinkButton>
							<asp:LinkButton runat="server" ID="lbtnDisableSuperUserTwoFactor" CausesValidation="false" CommandName="DisableSuperUserTwoFactorAuth"
                                            OnClientClick="return confirm('Are you sure you want to disable Two Factor Authentication?');" CssClass="grid_icon_link disable" ToolTip="Disable Two-Factor">Disable Two-Factor</asp:LinkButton>
						</ItemTemplate>
					</asp:TemplateField>
					</Columns>
				</asp:GridView>
				<asp:Label ID="lblSuperUserMessage" runat="server"></asp:Label>
			</asp:Panel>
		</div>
	</div>
</asp:Content>
