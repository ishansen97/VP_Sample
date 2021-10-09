<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SearchGroupList.aspx.cs" MasterPageFile="~/MasterPage.Master"
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Search.SearchGroupList" %>

<%@ Register Src="../Pager.ascx" TagName="Pager" TagPrefix="uc1" %>

<asp:Content ID="content" ContentPlaceHolderID="cphContent" runat="server">
	
	<script type="text/javascript">
		RegisterNamespace("VP.SearchGroupList");

		VP.SearchGroupList.Initialize = function() {
			$(document).ready(function() {
				$(".article_srh_btn").click(function() {
					$(".article_srh_pane").toggle("slow");
					$(this).toggleClass("hide_icon");
					$("#divSearchCriteria").toggleClass("hide");
				});

				$("#divSearchCriteria").append(VP.SearchGroupList.GetSearchCriteriaText());
			});
		}

		VP.SearchGroupList.GetSearchCriteriaText = function() {
			var txtSearchId = $("input[id$='txtGroupId']");
			var txtSearchText = $("input[id$='txtGroupName']");
			var searchHtml = "";

			if (txtSearchId.val().trim().length > 0) {
				searchHtml += " ; <b>Id: </b> " + txtSearchId.val().trim();
			}
			
			if (txtSearchText.val().trim().length > 0) {
				searchHtml += " ; <b>Name: </b> " + txtSearchText.val().trim();
			}

			searchHtml = searchHtml.replace(' ;', '(');
			if (searchHtml != "") {
				searchHtml += " )";
			}
			return searchHtml;
		};

		VP.SearchGroupList.Initialize();
	</script>
	
	<div class="AdminPanelHeader">
		<h3>Search Group List</h3>
	</div>
	<div class="AdminPanelContent">
		<div style="padding-bottom:15px;">
			<div class="article_srh_btn" style="display:inline;">Search</div>
			<div id="divSearchCriteria" style="display:inline;"></div>
			<div id="divSearchPane" class="article_srh_pane" style="display: none;">
                <div class="form-horizontal">
                    <div class="control-group">
                        <label class="control-label">Id</label>
                        <div class="controls">
                            <asp:TextBox runat="server" ID="txtGroupId" Width="188px" MaxLength="200"></asp:TextBox>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Name</label>
                        <div class="controls">
                            <asp:TextBox runat="server" ID="txtGroupName" Width="188px" MaxLength="200"></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-actions">
                        <asp:Button ID="btnApplyFilter" runat="server" Text="Search" onclick="btnApplyFilter_Click"
							CssClass="btn"/>
						<asp:Button ID="btnRestFilter" runat="server" Text="Reset" 
							CssClass="btn" onclick="btnRestFilter_Click" />
                    </div>
                </div>
				
			</div>
		</div>
		<div class="add-button-container"><asp:HyperLink ID="lnkAddSearchGroup" runat="server" CssClass="aDialog btn">Add Search Group</asp:HyperLink></div>
		<asp:GridView ID="gvSearchGroupList" runat="server" AutoGenerateColumns="False" 
			CssClass="common_data_grid table table-bordered" onrowdatabound="gvSearchGroupList_RowDataBound" 
			onrowcommand="gvSearchGroupList_RowCommand" style="width:auto;">
			<Columns>
				<asp:TemplateField HeaderText="ID">
					<ItemTemplate>
						<asp:Label ID="lblId" runat="server"></asp:Label>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Name">
					<ItemTemplate>
						<asp:Label ID="lblName" runat="server"></asp:Label>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Description">
					<ItemTemplate>
						<asp:Label ID="lblDescription" runat="server"></asp:Label>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Add Options Automatically">
					<ItemTemplate>
						<asp:CheckBox ID="chkAddOptionsAutomatically" runat="server" Enabled="false"></asp:CheckBox>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Search Enabled">
					<ItemTemplate>
						<asp:CheckBox ID="searchEnabledCheckBox" runat="server" Enabled="false"></asp:CheckBox>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Locked">
					<ItemTemplate>
						<asp:CheckBox ID="lockedCheckBox" runat="server" Enabled="false"></asp:CheckBox>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Prefix">
					<ItemTemplate>
						<asp:Label ID="lblPrefix" runat="server"></asp:Label>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Suffix">
					<ItemTemplate>
						<asp:Label ID="lblSuffix" runat="server"></asp:Label>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Parent Group">
					<ItemTemplate>
						<asp:Label ID="lblParentGroup" runat="server"></asp:Label>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Parent Group Id">
					<ItemTemplate>
						<asp:Label ID="lblParentGroupId" runat="server"></asp:Label>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField>
					<ItemTemplate>
						<asp:HyperLink ID="lnkOptions" runat="server">Options</asp:HyperLink>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField ItemStyle-Width="50">
					<ItemTemplate>
						<asp:HyperLink ID="lnkEdit" runat="server" CssClass="aDialog grid_icon_link edit" ToolTip="Edit">Edit</asp:HyperLink>
						<asp:LinkButton runat="server" ID="lbtnDelete" CommandName="DeleteGroup" CssClass="grid_icon_link delete" ToolTip="Delete">Delete</asp:LinkButton>
					</ItemTemplate>
				</asp:TemplateField>
			</Columns>
			<EmptyDataTemplate>No search groups found.</EmptyDataTemplate>
		</asp:GridView>
		<uc1:Pager ID="pagerGroup" runat="server" RecordsPerPage="10" PostBackPager="true"
			OnPageIndexClickEvent="pagerGroup_PageIndexClick"/>
	</div>
</asp:Content>
