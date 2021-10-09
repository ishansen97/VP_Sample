<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddGuidedBrowseSearchOptions.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Category.AddGuidedBrowseSearchOptions" %>
<%@ Register Src="../Pager.ascx" TagName="Pager" TagPrefix="uc1" %>
<script type="text/javascript">
	RegisterNamespace("VP.AddSearchOptions");

	VP.AddSearchOptions.Initialize = function () {
		$(document).ready(function () {
			$(".article_srh_btn").click(function () {
				$(".article_srh_pane").toggle("slow");
				$(this).toggleClass("hide_icon");
			});
		});
	};
	VP.AddSearchOptions.Initialize();
</script>
<div style="width:500px">
<div runat="server" id="divSelectedOptions">
	<div class="add-button-container">
	<asp:Button runat="server" Text="Add Search Options" CssClass="btn"
		OnClick="btnAddOption_Click" />
	<asp:LinkButton ID="lbtnRemoveAll" runat="server" Text="Remove All Search Options"
		Visible="false" OnClick="lbtnRemoveAll_Click" CssClass="btn"></asp:LinkButton>
	</div>
	<asp:GridView ID="gvSelectedOptionList" runat="server" AutoGenerateColumns="False"
		CssClass="common_data_grid table table-bordered" OnRowDataBound="gvSelectedOptionList_RowDataBound"
		OnRowCommand="gvSelectedOptionList_RowCommand">
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
					<asp:TextBox ID="txtSortOrder" runat="server" Width="60"></asp:TextBox>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField>
				<ItemTemplate>
					<asp:LinkButton OnClientClick="return confirm('Are you sure you want to remove this search option?');"
						ID="lbtnRemove" runat="server" Text="Remove" CssClass="grid_icon_link delete"
						CommandName="DeleteSearchOption"></asp:LinkButton>
					<asp:LinkButton ID="lbtnEditSearchOption" runat="server" CommandName="editSearchOption"
						CssClass="grid_icon_link edit" ToolTip="Edit">Edit</asp:LinkButton>
				</ItemTemplate>
			</asp:TemplateField>
		</Columns>
		<EmptyDataTemplate>
			No search options found.</EmptyDataTemplate>
	</asp:GridView>
	<br />
	<div class="add-button-container">
		<asp:Button ID="btnApplyChanges" Text="Apply Changes to Search Options" runat="server"
			OnClick="btnApplyChanges_Click" Visible="false" CssClass="btn" /></div>
	<br />
</div>
<div runat="server" id="divAddOptions">
	<asp:Button ID="btnBack" runat="server" Text="&laquo; Back" CssClass="btn"
		OnClick="btnBack_Click" />
	<br />
	<br />
	<div class="article_srh_btn">Search</div>
	<br />
	<div id="divSearchPane" class="article_srh_pane" style="display: none;">
			<div class="form-horizontal">
				<div class="control-group">
					<label class="control-label">Search Option Id</label>
					<div class="controls">
						<asp:TextBox runat="server" ID="searchOptionId" Width="140px" MaxLength="200" ></asp:TextBox>
					</div>
				</div>
				<div class="control-group">
					<label class="control-label">Search Option Name</label>
					<div class="controls"><asp:TextBox runat="server" ID="txtOptionName" Width="140px" MaxLength="200" ></asp:TextBox></div>
				</div>
				<div class="form-actions">
					<asp:Button ID="btnApply" runat="server" Text="Search" OnClick="btnApplyFilter_Click" CssClass="btn" />
					<asp:Button ID="btnRestFilter" runat="server" Text="Reset" CssClass="btn" OnClick="btnRestFilter_Click" />
				</div>
			</div>
	</div>
	<br />
	<div class="add-button-container"><asp:LinkButton ID="lbtnAddAll" runat="server" Text="Add All Search Options" OnClick="lbtnAddAll_Click" CssClass="btn"></asp:LinkButton></div>
	<asp:GridView ID="gvSearchOptionList" runat="server" AutoGenerateColumns="False"
		CssClass="common_data_grid table table-bordered" OnRowDataBound="gvSearchOptionList_RowDataBound"
		OnRowCommand="gvSearchOptionList_RowCommand">
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
			<asp:TemplateField HeaderText="Enabled">
				<ItemTemplate>
					<asp:CheckBox ID="chkEnabled" runat="server" Enabled="false"></asp:CheckBox>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField HeaderText="Sort Order">
				<ItemTemplate>
					<asp:TextBox ID="txtSortOrder" Width="60" runat="server" Text="0"></asp:TextBox>
				</ItemTemplate>
			</asp:TemplateField>
			<asp:TemplateField>
				<ItemTemplate>
					<asp:LinkButton runat="server" ID="lbtnAdd" CommandName="AddOption" CssClass="grid_icon_link add">Add</asp:LinkButton>
				</ItemTemplate>
			</asp:TemplateField>
		</Columns>
		<EmptyDataTemplate>
			No search options found.</EmptyDataTemplate>
	</asp:GridView>
	<uc1:Pager ID="pagerOption" runat="server" OnPageIndexClickEvent="pagerOption_PageIndexClick"
		PostBackPager="true" />
	<br />
</div>
</div>