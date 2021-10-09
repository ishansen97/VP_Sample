<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SearchOptionList.aspx.cs" MasterPageFile="~/MasterPage.Master"
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Search.SearchOptionList" %>

<%@ Register Src="../Pager.ascx" TagName="Pager" TagPrefix="uc1" %>

<asp:Content ID="content" ContentPlaceHolderID="cphContent" runat="server">

	<script type="text/javascript">
		RegisterNamespace("VP.SearchOptionList");

		VP.SearchOptionList.Initialize = function() {
			$(document).ready(function() {
				$(".article_srh_btn").click(function() {
					$(".article_srh_pane").toggle("slow");
					$(this).toggleClass("hide_icon");
					$("#divSearchCriteria").toggleClass("hide");
				});

				$("#divSearchCriteria").append(VP.SearchOptionList.GetSearchCriteriaText());
			});
		}

		VP.SearchOptionList.GetSearchCriteriaText = function() {
			var txtSearchText = $("input[id$='txtOptionName']");
			var searchHtml = "";
			if (txtSearchText.val().trim().length > 0) {
				searchHtml += " ; <b>Search By : </b> " + txtSearchText.val().trim();
			}

			searchHtml = searchHtml.replace(' ;', '(');
			if (searchHtml != "") {
				searchHtml += " )";
			}
			return searchHtml;
		};

		VP.SearchOptionList.Initialize();
	</script>
	
	<div class="AdminPanelHeader">
		<h3><asp:Label ID="lblTitle" runat="server"></asp:Label></h3>
	</div>
	<div class="AdminPanelContent">
		<div class="article_srh_btn">Search</div>
		<div id="divSearchCriteria"></div>
		<br />
		<div id="divSearchPane" class="article_srh_pane" style="display: none;">
			<div class="form-horizontal">
				<div class="control-group">
					<label class="control-label">Search Option Id</label>
					<div class="controls">
						<asp:TextBox runat="server" ID="searchOptionId" Width="188px" MaxLength="200" ></asp:TextBox>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Search Option Name</label>
					<div class="controls">
						<asp:TextBox runat="server" ID="txtOptionName" Width="188px" MaxLength="200"></asp:TextBox>
					</div>
				</div>
				<div class="form-actions">
					<asp:Button ID="btnApply" runat="server" Text="Search" onclick="btnApplyFilter_Click" CssClass="btn"/>
					<asp:Button ID="btnRestFilter" runat="server" Text="Reset" CssClass="btn" onclick="btnRestFilter_Click" />
				</div>
			</div>
			<ul class="common_form_area">
				<li class="common_form_row clearfix">
				<span class="label_span"></span>
				<span>
					
				</span>
				</li>
			</ul>
		</div>
		<br />
		<div class="add-button-container">
			<asp:HyperLink ID="lnkAddSearchOption" runat="server" CssClass="aDialog btn">Add Search Option</asp:HyperLink>
			<asp:Button runat="server" ID="exportToExcel" CssClass="btn" OnClick="exportToExcel_OnClick" Text="Export To Excel" Visible="False"/>
		</div>
		<asp:GridView ID="gvSearchOptionList" runat="server" AutoGenerateColumns="False" 
			CssClass="common_data_grid table table-bordered" onrowdatabound="gvSearchOptionList_RowDataBound" 
			onrowcommand="gvSearchOptionList_RowCommand">
			<Columns>
				<asp:TemplateField HeaderText="Id">
					<ItemTemplate>
						<asp:Label ID="lblId" runat="server"></asp:Label>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Name">
					<ItemTemplate>
						<asp:Label ID="lblName" runat="server"></asp:Label>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Sort Order">
					<ItemTemplate>
						<asp:Label ID="lblSortOrder" runat="server"></asp:Label>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Enabled">
					<ItemTemplate>
						<asp:CheckBox ID="chkEnabled" runat="server" Enabled="false"></asp:CheckBox>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Parent Group">
					<ItemTemplate>
						<asp:Label ID="lblParentGroup" runat="server"></asp:Label>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Parent Options">
					<ItemTemplate>
						<asp:Label ID="lblParentOptions" runat="server"></asp:Label>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField>
					<ItemTemplate>
						<asp:HyperLink ID="lnkEdit" runat="server" CssClass="aDialog grid_icon_link edit">Edit</asp:HyperLink>
						<asp:Hyperlink ID="settingsLink" runat="server" CssClass="aDialog grid_icon_link settings" ToolTip="Settings">Settings</asp:Hyperlink>
						<asp:LinkButton runat="server" ID="lbtnDelete" CommandName="DeleteOption" CssClass="grid_icon_link delete">Delete</asp:LinkButton>
					</ItemTemplate>
				</asp:TemplateField>
			</Columns>
			<EmptyDataTemplate>No search options found.</EmptyDataTemplate>
		</asp:GridView>
		<uc1:Pager ID="pagerOption" runat="server" RecordsPerPage="10" PostBackPager="true"
				OnPageIndexClickEvent="pagerOption_PageIndexClick"/>
		<asp:HyperLink ID="lnkBack" CssClass="btn" runat="server">&laquo; Back</asp:HyperLink>
	</div>
</asp:Content>
