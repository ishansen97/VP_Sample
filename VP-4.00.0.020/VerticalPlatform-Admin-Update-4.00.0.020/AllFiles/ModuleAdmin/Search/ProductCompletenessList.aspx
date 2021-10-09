<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProductCompletenessList.aspx.cs" MasterPageFile="~/MasterPage.Master" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Search.ProductCompletenessList" %>
<%@ Register Src="../Pager.ascx" TagName="Pager" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">

	<script type="text/javascript">
		RegisterNamespace("VP.Completeness");
		$(document).ready(function() {
			$(".completeness_srh_btn").click(function() {
				$(".completeness_srh_pane").toggle("slow");
				$(this).toggleClass("hide_icon");
				$("#divSearchCriteria").toggleClass("hide");
			});

			$("#divSearchCriteria").append(VP.Completeness.GetSearchCriteriaText());
		});

		VP.Completeness.GetSearchCriteriaText = function() {
			var ddlContentType = $("select[id$='ddlContentType']");
			var txtSearchText = $("input[id$='txtSearchText']");
			
			var searchHtml = "";
			if (ddlContentType.val() != "-1") {
				searchHtml += " ; <b>ContentType</b> : " + $("option[selected]", ddlContentType).text();
			}

			if (txtSearchText.val().trim().length > 0) {
				searchHtml += " ; <b>Property Name</b> : " + txtSearchText.val().trim();
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
			<h3>Product Completeness</h3>
		</div>
		<div class="completeness_srh_btn">Filter</div>
			<div id="divSearchCriteria"></div>
			<br />
			<div id="divSearchPane" class="completeness_srh_pane" style="display: none;">
                <div class="form-horizontal">
                    <div class="control-group">
                        <label class="control-label">Content Type</label>
                        <div class="controls">
                            <asp:DropDownList ID="ddlContentType" runat="server" AppendDataBoundItems="true">
							</asp:DropDownList>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label"><label for="txtSearchProperty" >Property Name </label></label>
                        <div class="controls">
                            <asp:TextBox ID="txtSearchText" runat="server"></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-actions">
                        <asp:Button ID="btnFilter" runat="server" Text="Filter" ValidationGroup="FilterList"
								OnClick="btnFilter_Click" CssClass="btn" />
						<asp:Button ID="btnReset" runat="server" Text="Reset" OnClick="btnReset_Click"
								CssClass="btn" />
                    </div>
                </div>
				
			</div>
            <br />
		<div class="AdminPanelContent">
			<div class="add-button-container"><asp:HyperLink ID="lnkAddNewProperty" runat="server" CssClass="aDialog btn">Add New Property</asp:HyperLink></div>
			
			<asp:GridView ID="gvProductCompletenessList" runat="server" AutoGenerateColumns="False" 
					CssClass="common_data_grid table table-bordered" OnRowDataBound="gvProductCompletenessList_RowDataBound" 
					onrowcommand="gvProductCompletenessList_RowCommand" style="width:auto">
				<Columns>
						<asp:TemplateField HeaderText="Content Type" >
							<ItemTemplate>
								<asp:Literal ID="ltlContentType" runat="server"></asp:Literal>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Property Name">
							<ItemTemplate>
								<asp:Literal ID="ltlPropertyName" runat="server"></asp:Literal>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Completeness Weight">
							<ItemTemplate>
								<asp:Literal ID="ltlCompletenessWeight" runat="server"></asp:Literal>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Incompleteness Weight">
							<ItemTemplate>
								<asp:Literal ID="ltlIncompletenessWeight" runat="server"></asp:Literal>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField ItemStyle-Width="50">
							<ItemTemplate>
								<asp:HyperLink ID="lnkEdit" runat="server" CommandName="EditCompleteness" 
									ToolTip="Edit" CssClass="aDialog grid_icon_link edit" Text=""></asp:HyperLink>
								<asp:LinkButton ID="lbtnDelete" runat="server" CommandName="DeleteCompleteness" 
									CssClass="grid_icon_link delete" ToolTip="Delete"></asp:LinkButton>
							</ItemTemplate>
						</asp:TemplateField>
					</Columns>
					<EmptyDataTemplate>No Product Completness records found.</EmptyDataTemplate>
			</asp:GridView>
			<uc1:Pager ID="pgrCompleteness" runat="server" />
		</div>
	</div>
</asp:Content>
