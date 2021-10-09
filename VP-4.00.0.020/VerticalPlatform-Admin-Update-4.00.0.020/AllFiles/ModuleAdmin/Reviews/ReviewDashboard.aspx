<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" CodeBehind="ReviewDashboard.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Reviews.ReviewDashboard" %>
<%@ Register Src="../Pager.ascx" TagName="Pager" TagPrefix="uc1" %>  

<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
 <script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>
 <script type="text/javascript">
	$(document).ready(function () {
		$(".article_srh_btn").click(function () {
			$(".article_srh_pane").toggle("hide");
			$(this).toggleClass("hide_icon");
			$("#divSearchCriteria").toggleClass("show");
		});

		$("#divSearchCriteria").append(GetSearchCriteriaText());

		$("input[id$='fromDate']").datepicker(
		{
			changeYear: true
		});
		
		$("input[id$='toDate']").datepicker(
		{
			changeYear: true
		});
	}); 
	
	GetSearchCriteriaText = function () {
		var sortByColumnList = $("select[id$='sortByColumnList']");
		var reviewTitle = $("input[id$='reviewTitle']");
		var fromDate = $("input[id$='fromDate']");
		var toDate = $("input[id$='toDate']");
		var articleId = $("input[id$='article_Id']");

		var searchHtml = "";

		var article_id = articleId.val().trim();
		if (article_id.length > 0) {
		    searchHtml += " ; <b>Article Id</b> : " + article_id;
		}

		var title = reviewTitle.val().trim();
		if (title.length > 0) {
			searchHtml += " ; <b>Title</b> : " + title;
		}
			
		var startDate = fromDate.val().trim();
		if (startDate.length > 0) {
			searchHtml += " ; <b>From</b> : " + startDate;
		}
			
		var endDate  = toDate.val().trim();
		if (endDate.length > 0) {
			searchHtml += " ; <b>To</b> : " + endDate;
		}
			
		searchHtml += " ; <b>Sort By</b> : " + $("option[selected]", sortByColumnList).text();
			
		return searchHtml;
	};
</script>
	 
	<div class="AdminPanel">
		<div class="AdminPanelHeader">
			<h3>Review Dashboard</h3>
		</div>
		<div class="AdminPanelContent">
			<div class="article_srh_btn hide_icon">
				Filter</div>
			<div id="divSearchCriteria">
			</div>
			<br />
			<div id="divSearchPane" class="article_srh_pane" style="display: block;">
				<div class="form-horizontal">
                    <div class="control-group">
						<label class="control-label">Article ID </label>
						<div class="controls">
							<asp:TextBox runat="server" ID="article_Id"></asp:TextBox>
						</div>
					</div> 
					<div class="control-group">
						<label class="control-label">Sort By</label>
						<div class="controls">
							<asp:DropDownList ID="sortByColumnList" runat="server" AppendDataBoundItems="true">
							<asp:ListItem Text="Author" Value="Author"></asp:ListItem>
								<asp:ListItem Text="Title" Value="Title"></asp:ListItem>
								<asp:ListItem Text="Created Date" Value="Created" Selected="True"></asp:ListItem>
							</asp:DropDownList>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">Title </label>
						<div class="controls">
							<asp:TextBox runat="server" ID="reviewTitle"></asp:TextBox>
						</div>
					</div> 
					<div class="control-group">
						<label class="control-label">
							Author</label>
						<div class="controls">
							<asp:DropDownList ID="authorList" runat="server" AppendDataBoundItems="true">
								<asp:ListItem Text="Select" Value="-1"></asp:ListItem>
							</asp:DropDownList>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label">Date</label>
						<div class="controls">
							 <asp:TextBox runat="server" ID="fromDate"  CssClass="date_picker"></asp:TextBox> to 
							 <asp:TextBox runat="server" ID="toDate" CssClass="date_picker"></asp:TextBox>
						</div>
					</div>
					<div class="form-actions">
						<asp:Button ID="filterButton" runat="server" Text="Filter" ValidationGroup="FilterList"
							CssClass="btn" OnClick="FilterButton_Click" />
						<asp:Button ID="restButton" runat="server" Text="Reset" CssClass="btn" OnClick="RestButton_Click" />
					</div>
				</div>
			</div>
			<div class="add-button-container">
				<a href="../Article/AddArticle.aspx" id="addArticleLink" class="btn">Add New Review Article</a>
			</div>

			<asp:GridView runat="server" ID="reviewArticleList" AutoGenerateColumns="False"
				onrowdatabound="reviewArticleList_RowDataBound" CssClass="common_data_grid table table-bordered review-table"
				OnRowCommand="reviewArticleList_RowCommand">
				<AlternatingRowStyle CssClass="DataTableRowAlternate" />
				<RowStyle CssClass="DataTableRow" />
				<Columns>
                    <asp:TemplateField HeaderText="Article ID">
						<ItemTemplate>
							 <asp:Label runat="server" ID="articleIdLabel"></asp:Label>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField HeaderText="Created">
						<ItemTemplate>
							 <asp:Label runat="server" ID="createdDateLabel"></asp:Label>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField HeaderText="Email Verified">
						<ItemTemplate>
							<asp:Label runat="server" ID="emailVerified"></asp:Label>
						</ItemTemplate>
						<ItemStyle CssClass="verified-td" />
					</asp:TemplateField> 
					<asp:TemplateField HeaderText="Status">
						<ItemTemplate>
							<asp:Label runat="server" ID="reviewStatus"></asp:Label>
						</ItemTemplate>
						<ItemStyle CssClass="status-td" />
					</asp:TemplateField>
					<asp:TemplateField HeaderText="Review Article Type">
						<ItemTemplate>
							<asp:Label runat="server" ID="reviewArticleType"></asp:Label>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField HeaderText="Author">
						<ItemTemplate>
							<asp:Label runat="server" ID="reviewAuthor"></asp:Label>
						</ItemTemplate>
					</asp:TemplateField> 
					<asp:TemplateField>
						<ItemTemplate>
							<asp:Label runat="server" ID="titleLabel"></asp:Label>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField>
						<ItemTemplate>
							<asp:HyperLink runat="server" ID="editButton" Text="Edit" CssClass="grid_icon_link edit"></asp:HyperLink>
							<asp:LinkButton CssClass="grid_icon_link delete" runat="server" ID="deleteReviewButton" Text="Delete" CommandName="DeleteReview" OnClientClick="return confirm('Are you sure you want To delete this review?')"></asp:LinkButton>
						</ItemTemplate>
					</asp:TemplateField>
				</Columns>
			</asp:GridView>
			<asp:Label ID="messageLabel" runat="server"></asp:Label>
			<uc1:Pager ID="reviewListPager" runat="server" OnPageIndexClickEvent="ReviewListPager_PageIndexClick" />
		</div>
	</div>
</asp:Content>
