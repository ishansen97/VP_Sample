<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true" 
CodeBehind="SegmentAdditionalEmailList.aspx.cs" 
Inherits="VerticalPlatformAdminWeb.ModuleAdmin.BulkEmail.SegmentAdditionalEmailList" %>
<%@ Register Src="../Pager.ascx" TagName="Pager" TagPrefix="uc1" %>
<asp:Content ID="contentPane" ContentPlaceHolderID="cphContent" runat="server">
	<div class="AdminPanelHeader">
		<h3><asp:Label runat="server" ID="lblPageTitle"></asp:Label></h3>
	</div>
	<div class="AdminPanelContent">
		<asp:HyperLink ID="lnkAddEmails" runat="server" Text="Add Emails" CssClass="common_text_button aDialog"></asp:HyperLink>
		<br />
		<br />
		<asp:GridView ID="gvEmails" runat="server" AutoGenerateColumns="False" CssClass="common_data_grid"
			OnRowDataBound="gvEmails_RowDataBound" AllowSorting="True"
			OnSorting="gvEmails_Sorting" OnRowCommand="gvEmails_RowCommand" style="width:auto;">
			<Columns>
				<asp:TemplateField HeaderText="Email" SortExpression="email">
					<ItemTemplate>
						<asp:Literal ID="ltlEmail" runat="server"></asp:Literal>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField>
					<ItemTemplate>
							<asp:LinkButton ID="lbtnDelete" runat="server" CommandName="DeleteEmail" CssClass="grid_icon_link delete" ToolTip="Delete">
							Delete</asp:LinkButton>
					</ItemTemplate>
				</asp:TemplateField>
			</Columns>
			<EmptyDataTemplate>No Emails Found.</EmptyDataTemplate>
		</asp:GridView>
		<uc1:Pager ID="emailsPager" runat="server" OnPageIndexClickEvent="pageIndex_Click" />
	</div>
	<br />
	<br />
	<asp:HyperLink ID="lnkBack" CssClass="common_text_button" NavigateUrl="./SegmentList.aspx" runat="server">Back</asp:HyperLink>
	<asp:HiddenField ID="hdnSegmentId" runat="server" />
</asp:Content>
