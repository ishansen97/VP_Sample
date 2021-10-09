<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SearchRelevanceList.aspx.cs" MasterPageFile="~/MasterPage.Master"
 Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Search.SearchRelevanceList" %>
 <%@ Register Src="../Pager.ascx" TagName="Pager" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
		<script type="text/javascript">
		RegisterNamespace("VP.Content");
		$(document).ready(function() {
			$(".article_srh_btn").click(function() {
				$(".article_srh_pane").toggle("slow");
				$(this).toggleClass("hide_icon");
				$("#divSearchCriteria").toggleClass("hide");
			});
				
			$("#divSearchCriteria").append(VP.Content.GetSearchCriteriaText());

		});

		VP.Content.GetSearchCriteriaText = function() {
			var ddlType = $("select[id$='ddlContentType']");
			var txtTitle = $("input[id$='txtSearchProperty']");
			
			var searchHtml = "";
			if (ddlType.val() != "-1") {
				searchHtml += " ; <b>Content Type</b> : " + $("option[selected]", ddlType).text();
			}
			if (txtTitle.val().trim().length > 0) {
				searchHtml += " ; <b>Property Name</b> : " + txtTitle.val().trim();
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
			<h3>Content Relevancy</h3>
		</div>
		<div class="AdminPanelContent">
			
			<div class="article_srh_btn">
				Filter</div>
			<div id="divSearchCriteria">
			</div>
			<br />
			<div id="divSearchPane" class="article_srh_pane" style="display: none;padding-top:0px;">
                <div class="form-horizontal">
                    <div class="control-group">
                        <label class="control-label">Content Type</label>
                        <div class="controls">
                            <asp:DropDownList ID="ddlContentType" runat="server" onselectedindexchanged="ddlContentType_SelectedIndexChanged" CssClass="ContentType" >
					        </asp:DropDownList>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">Property Name</label>
                        <div class="controls">
                            <asp:TextBox ID="txtSearchProperty" runat="server" CssClass="ContentType"></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-actions">
                        <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn" onclick="btnSearchClick" />
					    <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="btn" onclick="btnResetClick" />
                    </div>
                </div>
				
			</div>
			<br />
			<div class="add-button-container">
                <asp:HyperLink ID="lnkAddNewProperty" runat="server" CssClass="aDialog btn"  style="margin-right:5px;">Add New Property</asp:HyperLink>
			</div>
			<asp:GridView ID="gvRelevancyList" runat="server" AutoGenerateColumns="False" 
					CssClass="common_data_grid table table-bordered" onrowdatabound="gvRelevancyList_RowDataBound" 
					onrowcommand="gvRelevancyList_RowCommand" style="width:auto">
				<Columns>
						<asp:TemplateField HeaderText="Content Type" SortExpression="name">
							<ItemTemplate>
								<asp:Literal ID="ltlContentType" runat="server"></asp:Literal>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Property Name" SortExpression="name">
							<ItemTemplate>
								<asp:Literal ID="ltlPropertyName" runat="server"></asp:Literal>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField HeaderText="Relevancy Weight">
							<ItemTemplate>
								<asp:Literal ID="ltlRelevanceWeight" runat="server"></asp:Literal>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField ItemStyle-Width="50">
							<ItemTemplate>
								<asp:HyperLink ID="lnkEdit" runat="server" CommandName="EditRelevancy" 
										ToolTip="Edit" CssClass="aDialog grid_icon_link edit" Text=""></asp:HyperLink>
								<asp:LinkButton ID="lbtnDelete" runat="server" CommandName="DeleteRelevancy" 
										CssClass="grid_icon_link delete" ToolTip="Delete"></asp:LinkButton>
							</ItemTemplate>
						</asp:TemplateField>
					</Columns>
					<EmptyDataTemplate>No Relevancy Records found.</EmptyDataTemplate>
			</asp:GridView>
			
			<uc1:Pager ID="contentPager" runat="server" />
		</div>
	</div>
</asp:Content>

