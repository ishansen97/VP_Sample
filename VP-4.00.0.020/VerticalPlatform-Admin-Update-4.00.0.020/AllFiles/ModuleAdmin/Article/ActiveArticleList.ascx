﻿<%@ Control Language="C#" AutoEventWireup="true" 
	CodeBehind="ActiveArticleList.ascx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Articles.ActiveArticleList" %>

<%@ Register TagPrefix="ajaxToolkit" Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" %>
<%@ Register Src="../Pager.ascx" TagName="Pager" TagPrefix="uc1" %>
<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>
<script src="../../Js/ArticleEditor/ArticleList.js" type="text/javascript"></script>
<script type="text/javascript">

	RegisterNamespace("VP.Article");
	$(document).ready(function () {
		$(".article_srh_btn").click(function () {
			$(".article_srh_pane").toggle("slow");
			$(this).toggleClass("hide_icon");
			$("#divSearchCriteria").toggleClass("hide");
		});

		$("#divSearchCriteria").append(VP.Article.GetSearchCriteriaText());

	});

	VP.Article.GetSearchCriteriaText = function () {
		var ddlType = $("select[id$='ddlArticleType']");
		var txtTitle = $("input[id$='txtArticleTitle']");
		var txtDateFrom = $("input[id$='txtStartDate']");
		var txtDateTo = $("input[id$='txtEndDate']");
		var txtArticleId = $("input[id$='txtArticleId']");
		var authorList = $("select[id$='authorList']");

		var searchHtml = "";
		if (ddlType.val() != "-1") {
			searchHtml += " ; <b>Type</b> : " + $("option[selected]", ddlType).text();
		}
		if (txtTitle.val().trim().length > 0) {
			searchHtml += " ; <b>Title</b> : " + txtTitle.val().trim();
		}
		if (txtDateFrom.val().trim().length > 0) {
			searchHtml += " ; <b>From</b> : " + txtDateFrom.val().trim();
		}
		if (txtDateTo.val().trim().length > 0) {
			searchHtml += " ; <b>To</b> : " + txtDateTo.val().trim();
		}
		if (txtArticleId.val().trim().length > 0) {
			searchHtml += " ; <b>Article Id</b> : " + txtArticleId.val().trim();
		}
		if (authorList.val() != "-1") {
			searchHtml += " ; <b>Author</b> : " + $("option[selected]", authorList).text();
		}
		searchHtml = searchHtml.replace(' ;', '(');
		if (searchHtml != "") {
			searchHtml += " )";
		}
		return searchHtml;
	};
</script>
<div class="AdminPanelContent">
	<div class="article_srh_btn hide_icon">
		Filter</div>
	<div id="divSearchCriteria">
	</div>
	<br />
	<div id="divSearchPane" class="article_srh_pane" style="display: block;">
		<div class="form-horizontal">
			<div class="control-group">
				<label class="control-label">
					Article Type</label>
				<div class="controls">
					<asp:DropDownList ID="ddlArticleType" runat="server" AppendDataBoundItems="true">
						<asp:ListItem Text="All" Value="-1"></asp:ListItem>
					</asp:DropDownList>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">
					Title</label>
				<div class="controls">
					<asp:TextBox ID="txtArticleTitle" runat="server" Width="385" ValidationGroup="FilterList"></asp:TextBox>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">
					Date</label>
				<div class="controls">
					<div class="input-prepend">
						<span class="add-on">From</span><asp:TextBox CssClass="txtStartDate" ID="txtStartDate"
							runat="server" Width="150px" ValidationGroup="FilterList"></asp:TextBox>
					</div>
					<div class="input-prepend">
						<span class="add-on">To</span><asp:TextBox CssClass="txtEndDate" ID="txtEndDate"
							runat="server" Width="150px" ValidationGroup="FilterList"></asp:TextBox>
					</div>
				</div>
			</div>
			<div class="control-group">
				<label class="control-label">
					Article Id</label>
				<div class="controls">
					<asp:TextBox ID="txtArticleId" runat="server" Width="150px" ValidationGroup="FilterList"></asp:TextBox>
					<asp:CompareValidator ID="cvArticleId" runat="server" ControlToValidate="txtArticleId"
						ValidationGroup="FilterList" ErrorMessage="Please enter a number for article id."
						Type="Integer" Operator="DataTypeCheck">*</asp:CompareValidator>
				</div>
			</div>
			<!---->
			<div class="control-group">
				<label class="control-label">
					Author</label>
				<div class="controls">
					<asp:DropDownList ID="authorList" runat="server" AppendDataBoundItems="true">
						<asp:ListItem Text="Select" Value="-1"></asp:ListItem>
					</asp:DropDownList>
				</div>
			</div>
			<!---->
			<div class="control-group">
				<label class="control-label">
					Featured Level</label>
				<div class="controls">
					<asp:CheckBoxList ID="chklFeaturedSettingsFilter" runat="server" RepeatDirection="Horizontal"
						CssClass="check_box_table">
						<asp:ListItem Value="1">Level 1</asp:ListItem>
						<asp:ListItem Value="2">Level 2</asp:ListItem>
						<asp:ListItem Value="3">Level 3</asp:ListItem>
						<asp:ListItem Value="4">No Levels</asp:ListItem>
					</asp:CheckBoxList>
				</div>
			</div>
			<div class="form-actions">
				<asp:Button ID="btnfilter" runat="server" Text="Filter" ValidationGroup="FilterList"
					OnClick="btnfilter_Click" CssClass="btn" />
				<asp:Button ID="btnReset" runat="server" Text="Reset" OnClick="btnReset_Click" CssClass="btn" />
			</div>
		</div>
	</div>
	<br />
	<div class="add-button-container">
		<a href="AddArticle.aspx" runat="server" id="lnkAddArticle" class="btn">Add New Article</a>
		<a href="../Content/ContentToContentManagement.aspx" runat="server" id="lnkAssociate"
			class="btn">Associate Articles</a>
	</div>
	<asp:GridView ID="gvArticles" runat="server" DataKeyNames="Id" AutoGenerateColumns="False"
		OnDataBound="gvArticles_DataBound" OnRowCommand="gvArticles_RowCommand" AllowPaging="True"
		CssClass="common_data_grid table table-bordered" OnRowDataBound="gvArticles_RowDataBound"
		AllowSorting="True" OnSorting="gvArticles_Sorting" Style="width: 100%">
		<AlternatingRowStyle CssClass="DataTableRowAlternate" />
		<RowStyle CssClass="DataTableRow" />
		<Columns>
			<asp:BoundField DataField="Id" HeaderText="ID" />
			<asp:BoundField DataField="TypeId" HeaderText="Type" ItemStyle-Width="120">
				<ItemStyle Width="120px"></ItemStyle>
			</asp:BoundField>
			<asp:BoundField HeaderText="Title" DataField="Title" ItemStyle-Width="200px" SortExpression="article_title">
				<ItemStyle Width="200px"></ItemStyle>
			</asp:BoundField>
			<asp:TemplateField HeaderText="Author Name">
				<ItemTemplate>
					<asp:Label ID="authorName" runat="server"></asp:Label>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField HeaderText="Featured Level" SortExpression="featured_identifier">
				<ItemTemplate>
					<asp:CheckBoxList ID="chklFeaturedSettings" runat="server" RepeatDirection="Vertical"
						CssClass="check_box_table">
						<asp:ListItem Value="1">Level 1</asp:ListItem>
						<asp:ListItem Value="2">Level 2</asp:ListItem>
						<asp:ListItem Value="3">Level 3</asp:ListItem>
					</asp:CheckBoxList>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:BoundField HeaderText="Created" DataField="Created" DataFormatString="{0:d}"
				SortExpression="Created" ItemStyle-Width="60">
				<ItemStyle Width="60px"></ItemStyle>
			</asp:BoundField>
			<asp:BoundField HeaderText="Modified" DataField="Modified" DataFormatString="{0:d}"
				SortExpression="Modified" ItemStyle-Width="60">
				<ItemStyle Width="60px"></ItemStyle>
			</asp:BoundField>
			<asp:CheckBoxField HeaderText="Published" DataField="Published" ItemStyle-Width="60">
				<ItemStyle Width="60px"></ItemStyle>
			</asp:CheckBoxField>
			<asp:CheckBoxField HeaderText="Enabled" DataField="Enabled" ItemStyle-Width="40">
				<ItemStyle Width="40px"></ItemStyle>
			</asp:CheckBoxField>
			<asp:TemplateField>
				<ItemTemplate>
					<asp:HyperLink Text="Edit" runat="server" ID="lnkEdit" CssClass="grid_icon_link edit"
						ToolTip="Edit"></asp:HyperLink>
					<asp:LinkButton ID="lbtnDelete" runat="server" CommandName="DeleteArticle" CssClass="grid_icon_link delete"
						ToolTip="Delete">Delete</asp:LinkButton>
					<ajaxToolkit:ConfirmButtonExtender ID="cbeDelete" runat="server" TargetControlID="lbtnDelete"
						ConfirmText="Are you sure you want to temporarily delete the article and sections?">
					</ajaxToolkit:ConfirmButtonExtender>
					<%--<asp:LinkButton ID="lbtnClone" runat="server" CommandName="CloneArticle" CssClass="grid_icon_link duplicate"
						ToolTip="Clone">Clone</asp:LinkButton>--%>
					<asp:HyperLink Text="Clone" runat="server" ID="lbtnClone" CssClass="aDialog grid_icon_link duplicate" 
					ToolTip="Clone"></asp:HyperLink>
				</ItemTemplate>
			</asp:TemplateField>
		</Columns>
	</asp:GridView>
	<asp:Label ID="lblMessage" runat="server"></asp:Label>
	<uc1:Pager ID="pagerArticleList" runat="server" OnPageIndexClickEvent="pagerArticleList_PageIndexClick" />
</div>
