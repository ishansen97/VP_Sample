<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="AddSearchOptions.ascx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Product.AddSearchOptions" %>
<%@ Register Src="../Pager.ascx" TagName="Pager" TagPrefix="uc1" %>
<script type="text/javascript">
		RegisterNamespace("VP.AddSearchOptions");

		VP.AddSearchOptions.Initialize = function() {
			$(document).ready(function() {
				$(".article_srh_btn").click(function() {
					$(".article_srh_pane").toggle("slow");
					$(this).toggleClass("hide_icon");
				});
			});
		};
		VP.AddSearchOptions.Initialize();
	</script>
<table cellpadding="0" cellspacing="0" width="400">
    <tr>
        <td>
            <div class="inline-form-container">
                <label>Option Group</label>
                <asp:DropDownList ID="ddlOptionGroup" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlOptionGroup_SelectedIndexChanged">
                </asp:DropDownList>
            </div>
        </td>
    </tr>
    <tr>
		<td colspan="5">
			<div class="article_srh_btn">Search</div>
			<br />
			<div id="divSearchPane" class="article_srh_pane" style="display: none;">
                <div class="inline-form-container">
				<label>Search Option Name</label>
                    <div class="input-append">
					<asp:TextBox runat="server" ID="txtOptionName" Width="188px" MaxLength="200"></asp:TextBox>
					<asp:Button ID="btnApply" runat="server" Text="Search" onclick="btnApplyFilter_Click"
						CssClass="btn"/>
					<asp:Button ID="btnRestFilter" runat="server" Text="Reset" 
						CssClass="btn" onclick="btnRestFilter_Click" />
		        </div>
            </div>
        </div>
		<br />
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
				<asp:TemplateField HeaderText="Enabled">
					<ItemTemplate>
						<asp:CheckBox ID="chkEnabled" runat="server" Enabled="false"></asp:CheckBox>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField>
					<ItemTemplate>
						<asp:LinkButton runat="server" ID="lbtnAdd" CommandName="AddOption" CssClass="grid_icon_link add">Add</asp:LinkButton>
					</ItemTemplate>
				</asp:TemplateField>
			</Columns>
			<EmptyDataTemplate>No search options found.</EmptyDataTemplate>
		</asp:GridView>
		<uc1:Pager ID="pagerOption" runat="server" PostBackPager="true"
				OnPageIndexClickEvent="pagerOption_PageIndexClick"/>
		<br />
    </td>
    </tr>
</table>
