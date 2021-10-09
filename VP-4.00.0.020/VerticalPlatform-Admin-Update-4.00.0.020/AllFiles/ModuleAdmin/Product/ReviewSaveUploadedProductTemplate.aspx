<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
    CodeBehind="ReviewSaveUploadedProductTemplate.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.bulkProductUpload"
    Title="Untitled Page" %>
<%@ Register Src="../Pager.ascx" TagName="Pager" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">

	<script type="text/javascript">
		RegisterNamespace("VP.ReviewProductList");
		$(document).ready(function () {
		    $(".article_srh_btn").click(function () {
		        $(".review_product_srh_pane").toggle("slow");
		        $(this).toggleClass("hide_icon");
		        $("#divSearchCriteria").toggleClass("hide");
		    });

		    $("#divSearchCriteria").append(VP.ReviewProductList.GetSearchCriteriaText());

		    $(".uploaded-products-table tr").click(function () {
		        $this = $(this)
		        $(".uploaded-products-table tr").removeClass("clicked-row");
		        $this.addClass("clicked-row");
		    });

		});

		VP.ReviewProductList.GetSearchCriteriaText = function () {
			var rowStatusList = $("select[id$='productRowStatusList']");

			var searchHtml = "";
			if (rowStatusList.val() != "-1") {
				searchHtml += " ; <b>Type</b> : " + $("option[selected]", rowStatusList).text();
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
				Review/Save Product Template
			</h3>
		</div>
		<div class="AdminPanelContent">
			<div id="divbatchIds" runat="server">
				<asp:Label ID="lblMainMsg" runat="server"></asp:Label>
				<div style="padding-top: 5px; padding-bottom: 5px;">
					<asp:Label ID="Label4" runat="server" Text="Display Tasks of all users"></asp:Label>
					&nbsp;<asp:CheckBox ID="taskAllUsers" AutoPostBack="true" runat="server" OnCheckedChanged="taskAllUsers_CheckedChanged" />
				</div>
				<div class="add-button-container">
					<asp:LinkButton ID="productGridRefresh" runat="server" OnClick="productGridRefresh_Click" CssClass="btn" Text="<i class=icon-refresh ></i>&nbsp;Refresh" />
				</div>
			<asp:GridView ID="gvBatchIds" runat="server" AutoGenerateColumns="False" OnRowDataBound="gvBatchIds_RowDataBound"
				OnRowCommand="gvBatchIds_RowCommand" CssClass="common_data_grid table table-bordered">
				<AlternatingRowStyle CssClass="GridAltItem" />
				<HeaderStyle CssClass="GridHeader"></HeaderStyle>
				<RowStyle CssClass="GridItem" />
				<Columns>
					<asp:TemplateField ItemStyle-Width="150px" ItemStyle-Height="20px" HeaderStyle-Height="25px"
						HeaderText="Batch ID">
						<ItemTemplate>
							<asp:Literal ID="ltlId" runat="server"></asp:Literal>
						</ItemTemplate>
						<HeaderStyle Height="25px" />
						<ItemStyle Height="20px" Width="50px" />
					</asp:TemplateField>
					<asp:TemplateField ItemStyle-Width="150px" ItemStyle-Height="20px" HeaderStyle-Height="25px"
						HeaderText="User Info">
						<ItemTemplate>
							<asp:Literal ID="userId" runat="server"></asp:Literal>
						</ItemTemplate>
						<HeaderStyle Height="25px" />
						<ItemStyle Height="20px" Width="150px" />
					</asp:TemplateField>
					<asp:TemplateField ItemStyle-Width="150px" ItemStyle-Height="20px" HeaderStyle-Height="25px"
						HeaderText="Date">
						<ItemTemplate>
							<asp:Literal ID="ltlDate" runat="server"></asp:Literal>
						</ItemTemplate>
						<HeaderStyle Height="25px" />
						<ItemStyle Height="20px" Width="150px" />
					</asp:TemplateField>
					<asp:TemplateField ItemStyle-Width="150px" ItemStyle-Height="20px" HeaderStyle-Height="25px"
						HeaderText="File Name">
						<ItemTemplate>
							<asp:Literal ID="ltlFileName" runat="server"></asp:Literal>
						</ItemTemplate>
						<HeaderStyle Height="25px" />
						<ItemStyle Height="20px" Width="150px" />
					</asp:TemplateField>
					<asp:TemplateField ItemStyle-Width="150px" ItemStyle-Height="20px" HeaderStyle-Height="25px">
						<ItemTemplate>
							<asp:LinkButton ID="lbtnShowProductDetail" runat="server" CommandName="ViewProductDetails"
								Text="Preview the products and save the batch for final processing." Enabled="true"></asp:LinkButton>
							<asp:Label ID="lblError" runat="server"></asp:Label>
						</ItemTemplate>
					</asp:TemplateField>
					<asp:TemplateField ItemStyle-Width="20" HeaderStyle-Height="25px">
						<ItemTemplate>
							<asp:LinkButton ID="lbtnExcelFile" runat="server" CommandName="ViewExcel" 
							CssClass="grid_icon_link excel">View In Excel</asp:LinkButton>
						</ItemTemplate>
						<HeaderStyle Height="25px" />
						<ItemStyle Height="20px" Width="20px" />
					</asp:TemplateField>
				</Columns>
				<EmptyDataTemplate>
					<b>No Product Batches Available</b>
				</EmptyDataTemplate>
			</asp:GridView>
			<uc1:Pager ID="pgTaskList" runat="server" Visible="true" />
			</div>
			<div id="divProductDetails" runat="server" visible="false">
				<div id="exceptionOccuredWrapper" runat="server" visible="false">
					<div id="exceptionOccured" runat="server" class="alert alert-error"></div>
				</div>
				<div id="filterProductlist" runat="server">
					<div class="article_srh_btn hide_icon">Filter</div>
					<div id="divSearchCriteria"></div>
					<div id="divSearchPane" class="review_product_srh_pane" style="display: block;">
						<div class="form-horizontal">
							<div class="control-group">
								<label class="control-label">Record Status</label>
								<div class="controls">
									<asp:DropDownList ID="productRowStatusList" runat="server"></asp:DropDownList>
								</div>
							</div>
							<div class="form-actions">
								<div class="">
									<asp:Button ID="filterButton" runat="server" OnClick="filter_Click" Text="Apply"
										ValidationGroup="searchGroup" CssClass="btn" />
									<asp:Button ID="showAllProductsButton" runat="server" OnClick="showAll_Click" Text="Reset Filter"
										ValidationGroup="searchGroup" CssClass="btn" />
								</div>
							</div>
						</div>
					</div>
				</div>
				<br />
				<div class="inline-form-content">
					<asp:LinkButton ID="lbtnBackToBatchList" runat="server" OnClick="lbtnBackToBatchList_Click"
						CssClass="btn">&laquo; Back to Batch List</asp:LinkButton>
				</div>
				<br />
				<b>Uploaded Products and Services</b>
                <div class="scroling-container">
				<asp:GridView ID="gvUploadProductView" runat="server" AutoGenerateColumns="False"
					OnRowDataBound="gvUploadProductView_RowDataBound"
					CssClass="table-hover table table-bordered uploaded-products-table" Style="width: auto;">
					<AlternatingRowStyle CssClass="GridAltItem" />
					<HeaderStyle CssClass="GridHeader"></HeaderStyle>
					<RowStyle CssClass="GridItem" />
					<Columns>
						<asp:TemplateField HeaderText="Vendor Id">
							<ItemTemplate>
								<asp:Literal ID="ltlVendorId" runat="server"></asp:Literal>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:BoundField DataField="ProductId" HeaderText="Product ID">
							<HeaderStyle></HeaderStyle>
							<ItemStyle></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="ProductName" HeaderText="Product Name">
							<HeaderStyle></HeaderStyle>
							<ItemStyle></ItemStyle>
						</asp:BoundField>
						<asp:TemplateField HeaderText="Parent&nbsp;Product&nbsp;Name">
							<ItemTemplate>
								<asp:Literal ID="ltlParentProductName" runat="server"></asp:Literal>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:BoundField DataField="CatalogNumber" HeaderText="Catalog Number">
							<HeaderStyle></HeaderStyle>
							<ItemStyle></ItemStyle>
						</asp:BoundField>
						<asp:TemplateField HeaderText="Price">
							<ItemTemplate>
								<asp:Literal ID="ltlPrice" runat="server"></asp:Literal>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Url Name">
							<ItemTemplate>
								<asp:Literal ID="ltlUrlName" runat="server"></asp:Literal>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Url">
							<ItemTemplate>
								<asp:Literal ID="ltlUrl" runat="server"></asp:Literal>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Category&nbsp;Ids">
							<ItemTemplate>
								<asp:Literal ID="ltlCategoryIds" runat="server"></asp:Literal>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Compresion Group">
							<ItemTemplate>
								<asp:Literal ID="ltlCompressionGroup" runat="server"></asp:Literal>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Record Status">
							<ItemTemplate>
								<asp:Label ID="ltlItemStatus" runat="server"></asp:Label>
								<asp:HyperLink ID="lnkException" runat="server" CssClass="aDialog" Text="Exception Occured"></asp:HyperLink>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField>
							<ItemTemplate>
								<asp:HyperLink ID="lnkSpecification" runat="server" CssClass="aDialog" Text="View Details"></asp:HyperLink>
								<asp:Label ID="lblErrorSpecs" runat="server" Text="No Details Available"></asp:Label>
							</ItemTemplate>
							<HeaderStyle></HeaderStyle>
							<ItemStyle></ItemStyle>
						</asp:TemplateField>
					</Columns>
					<EmptyDataTemplate>
						<b>No Products Available</b>
					</EmptyDataTemplate>
				</asp:GridView>
                </div>
				<uc1:Pager ID="pgProductList" runat="server" Visible="true" />
				<br />
				<br />
				<b>Uploaded Models</b>
				<asp:GridView ID="gvUploadedModelsView" runat="server" AutoGenerateColumns="False"
					OnRowDataBound="gvUploadModelView_RowDataBound" CssClass="common_data_grid table table-bordered"
					Style="width: auto;">
					<AlternatingRowStyle CssClass="GridAltItem" />
					<HeaderStyle CssClass="GridHeader"></HeaderStyle>
					<RowStyle CssClass="GridItem" />
					<Columns>
						<asp:BoundField DataField="ModelId" HeaderText="Model ID" ItemStyle-Width="250px"
							ItemStyle-Height="20px" HeaderStyle-Height="25px">
							<HeaderStyle Height="25px" />
							<ItemStyle Height="20px" Width="250px" />
						</asp:BoundField>
						<asp:BoundField DataField="ModelName" HeaderText="Model Name" ItemStyle-Width="250px"
							ItemStyle-Height="20px" HeaderStyle-Height="25px">
							<HeaderStyle Height="25px" />
							<ItemStyle Height="20px" Width="250px" />
						</asp:BoundField>
						<asp:BoundField DataField="DisplayOrder" HeaderText="Display Order" ItemStyle-Width="250px"
							ItemStyle-Height="20px" HeaderStyle-Height="25px">
							<HeaderStyle Height="25px" />
							<ItemStyle Height="20px" Width="250px" />
						</asp:BoundField>
						<asp:BoundField DataField="CatelogNumber" HeaderText="Catalog Number" ItemStyle-Width="250px"
							ItemStyle-Height="20px" HeaderStyle-Height="25px">
							<HeaderStyle Height="25px" />
							<ItemStyle Height="20px" Width="250px" />
						</asp:BoundField>
						<asp:BoundField DataField="ParentProductName" HeaderText="ParentProductName" ItemStyle-Width="250px"
							ItemStyle-Height="20px" HeaderStyle-Height="25px">
							<HeaderStyle Height="25px" />
							<ItemStyle Height="20px" Width="250px" />
						</asp:BoundField>
						<asp:TemplateField HeaderText="Enabled">
							<ItemTemplate>
								<asp:CheckBox ID="chkModelEnabled" runat="server" Enabled="false" />
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField>
							<ItemTemplate>
								<asp:HyperLink ID="lnkModelSpecification" runat="server" CssClass="aDialog" Text="View Details"></asp:HyperLink>
								<asp:Label ID="lblModelErrorSpecs" runat="server" Text="No Details Available"></asp:Label>
							</ItemTemplate>
							<HeaderStyle></HeaderStyle>
							<ItemStyle></ItemStyle>
						</asp:TemplateField>
					</Columns>
					<EmptyDataTemplate>
						<b>No Models Available</b>
					</EmptyDataTemplate>
				</asp:GridView>
				<uc1:Pager ID="pgModelList" runat="server" Visible="true" />
				<asp:Panel ID="Panel1" runat="server" Style="display: none">
					<div class="tablediv">
						<div class="rowdiv">
							<div class="celldiv">
								<asp:Label ID="Label1" runat="server" Text="Vendor"></asp:Label>
							</div>
							<div class="celldiv">
								<asp:DropDownList ID="ddlVendor" runat="server">
								</asp:DropDownList>
							</div>
						</div>
						<div class="rowdiv">
							<div class="celldiv">
								<asp:Label ID="Label2" runat="server" Text="Manufacturer/Seller" Visible="False"></asp:Label></div>
							<div class="celldiv">
								<asp:DropDownList ID="ddlManuSeller" runat="server" Visible="False">
									<asp:ListItem>Manufacturer</asp:ListItem>
									<asp:ListItem>Seller</asp:ListItem>
								</asp:DropDownList>
							</div>
						</div>
					</div>
				</asp:Panel>
				<asp:Button ID="btnSaveBatch" runat="server" OnClick="btnSaveBatch_Click" Text="Save this batch"
					CssClass="btn" />
				<asp:Button ID="btnDeleteBatch" runat="server" OnClick="btnDeleteBatch_Click" Text="Delete this batch"
					CssClass="btn" />
				<asp:Label ID="lblErrorView" runat="server" CssClass="errordisplayMsg"></asp:Label>
			</div>
		</div>
	</div>
</asp:Content>
