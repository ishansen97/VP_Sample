<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="VendorSettingsTemplateControl.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Vendors.VendorSettingsTemplateControl" %>
<script type="text/javascript">
	RegisterNamespace("VP.VendorSettingsTemplateList");

	VP.VendorSettingsTemplateList.Initialize = function () {
		$(document).ready(function () {
			$(".article_srh_btn").click(function () {
				$(".article_srh_pane").toggle("slow");
				$(this).toggleClass("hide_icon");
				$("#divSearchCriteria").toggleClass("hide");
			});

			$("#divSearchCriteria").append(VP.VendorSettingsTemplateList.GetSearchCriteriaText());
		});
	}

	VP.VendorSettingsTemplateList.GetSearchCriteriaText = function () {
		var txtSearchText = $("input[id$='txtSettingsTemplateName']");
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

	VP.VendorSettingsTemplateList.Initialize();
</script>
<div class="vendorSettingsTemplateList">
	<div class="vendorSettingsTemplateHeader">
		<h3>
			<asp:Label ID="lblTitle" runat="server"></asp:Label></h3>
	</div>
	<div class="vendorSettingsTemplateContent">
		<div class="article_srh_btn">
			Search</div>
		<div id="divSearchCriteria">
		</div>
		<br />
		<div id="divSearchPane" class="article_srh_pane" style="display: none;">
			<div class="inline-form-content">
				<span class="title"><asp:Literal ID="ltlSettingsTemplateName" runat="server" Text="Vendor Settings Template"></asp:Literal></span>
				<div class="input-append">
					<asp:TextBox runat="server" ID="txtSettingsTemplateName" Width="188px" MaxLength="200"></asp:TextBox><asp:Button ID="btnApply" runat="server" Text="Search" OnClick="btnApplyFilter_Click"
						CssClass="btn" /><asp:Button ID="btnRestFilter" runat="server" Text="Reset" CssClass="btn"
						OnClick="btnRestFilter_Click" />
				</div>
			</div>			
		</div>
		<br />
		<div class="add-button-container"><asp:HyperLink ID="lnkAddSettingsTemplate" runat="server" CssClass="aDialog btn">Add Vendor Settings Template</asp:HyperLink></div>
		<asp:GridView ID="gvSetttingsTemplate" runat="server" AutoGenerateColumns="False"
			Width="100%" OnRowCommand="gvSetttingsTemplate_RowCommand" OnRowDataBound="gvSetttingsTemplate_RowDataBound"
			CssClass="common_data_grid table table-bordered">
			<AlternatingRowStyle CssClass="DataTableRowAlternate" />
			<RowStyle CssClass="DataTableRow" />
			<Columns>
				<asp:TemplateField HeaderText="Id">
					<ItemTemplate>
						<asp:Label ID="lblSettingsTemplateId" runat="server"></asp:Label>
					</ItemTemplate>
					<ItemStyle HorizontalAlign="Left" Width="75px" />
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Template Name">
					<ItemTemplate>
						<asp:Label ID="lblSettingsTemplateName" runat="server"></asp:Label>
					</ItemTemplate>
					<ItemStyle HorizontalAlign="Left" Width="200px" />
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Sort Order">
					<ItemTemplate>
						<asp:Label ID="lblSortOrder" runat="server"></asp:Label>
					</ItemTemplate>
					<ItemStyle HorizontalAlign="Left" Width="50px" />
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Enabled">
					<ItemTemplate>
						<asp:CheckBox ID="chkEnabled" runat="server" Enabled="false"></asp:CheckBox>
					</ItemTemplate>
					<ItemStyle HorizontalAlign="Center" Width="50px" />
				</asp:TemplateField>
				<asp:TemplateField>
					<ItemTemplate>
						<asp:HyperLink ID="lnkCategory" runat="server" CssClass="aDialog">Categories</asp:HyperLink>
					</ItemTemplate>
					<ItemStyle HorizontalAlign="Center" Width="75px" />
				</asp:TemplateField>
				<asp:TemplateField>
					<ItemTemplate>
						<asp:HyperLink ID="lnkCurrency" runat="server" CssClass="aDialog">Add Price Group</asp:HyperLink>
						<asp:PlaceHolder ID="phCurrencyLocation" runat="server"></asp:PlaceHolder>
					</ItemTemplate>
					<ItemStyle Wrap="true" HorizontalAlign="Right" Width="150px" />
				</asp:TemplateField>
				<asp:TemplateField>
					<ItemTemplate>
						<asp:HyperLink ID="lnkLocalization" runat="server" CssClass="aDialog">Locations</asp:HyperLink>
					</ItemTemplate>
					<ItemStyle HorizontalAlign="Center" Width="75px" />
				</asp:TemplateField>
				<asp:TemplateField>
					<ItemTemplate>
						<asp:HyperLink ID="lnkActionList" runat="server" CssClass="aDialog">Action List</asp:HyperLink>
					</ItemTemplate>
					<ItemStyle HorizontalAlign="Center" Width="75px" />
				</asp:TemplateField>
				<asp:TemplateField>
					<ItemTemplate>
						<asp:HyperLink ID="lnkActionLocations" runat="server" CssClass="aDialog">Action Locations</asp:HyperLink>
					</ItemTemplate>
					<ItemStyle HorizontalAlign="Center" Width="75px" />
				</asp:TemplateField>
				<asp:TemplateField ItemStyle-Width="50">
					<ItemTemplate>
						<asp:HyperLink ID="lnkEdit" runat="server" CssClass="aDialog grid_icon_link edit" ToolTip="Edit">Edit</asp:HyperLink>
						<asp:LinkButton ID="lbtnDelete" runat="server" CommandName="DeleteSettingsTemplate"
							CssClass="deleteSettingTemplate grid_icon_link delete" ToolTip="Delete" OnClientClick="return confirm('Are you sure to delete the vendor settings template?');">Delete</asp:LinkButton>
					</ItemTemplate>
				</asp:TemplateField>
			</Columns>
			<EmptyDataTemplate>
				No vendor settings templates found.</EmptyDataTemplate>
		</asp:GridView>
		<br />
		<br />
	</div>
</div>
