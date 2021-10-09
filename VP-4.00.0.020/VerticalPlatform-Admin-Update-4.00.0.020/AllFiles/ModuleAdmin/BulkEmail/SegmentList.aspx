<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SegmentList.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.BulkEmail.SegmentList"
	MasterPageFile="~/MasterPage.Master" %>

<%@ Register Src="../Pager.ascx" TagName="Pager" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
	<div class="AdminPanelHeader">
		<h3>
			Segment List</h3>
	</div>
	<div class="AdminPanelContent">
		<div id="divSearchPane">
            <div class="form-horizontal">
                <div class="control-group">
                    <label class="control-label">Type</label>
                    <div class="controls">
                        <asp:DropDownList ID="ddlSegmentType" runat="server" Width="200px" AppendDataBoundItems="true">
						<asp:ListItem Selected="True" Text="-Select Segment Type-" Value="-1"></asp:ListItem>
					    </asp:DropDownList>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">Name</label>
                    <div class="controls">
                        <asp:TextBox runat="server" ID="txtSegmentName" Width="188px" MaxLength="200"></asp:TextBox>
                    </div>
                </div>
				<div class="control-group">
				<label class="control-label">Status</label>
					<div class="controls">
						<asp:DropDownList ID="campaignStatus" runat="server" Width="200px" AppendDataBoundItems="true">
						</asp:DropDownList>
					</div>
				</div>
                <div class="form-actions">
                    <asp:Button ID="btnApply" runat="server" Text="Apply" OnClick="btnApplyFilter_Click"
						CssClass="btn" />
					<asp:Button ID="btnRestFilter" runat="server" Text="Reset Filter" CssClass="btn"
						OnClick="btnRestFilter_Click" />
                </div>
                
            </div>
			
		</div>

		<div class="add-button-container">
			<asp:HyperLink ID="lnkAddSegment" runat="server" CssClass="aDialog btn">Add Segment</asp:HyperLink>
			<asp:HyperLink ID="lnkReSaveSegment" runat="server" CssClass="aDialog btn">Merge Segments</asp:HyperLink>
		</div>

		<asp:GridView ID="gvSegmentList" runat="server" AutoGenerateColumns="False" CssClass="common_data_grid table table-bordered"
			OnRowDataBound="gvSegmentList_RowDataBound" OnRowCommand="gvSegmentList_RowCommand" style="width:auto"
			AllowSorting="True" OnSorting="gvSegmentList_Sorting" >
			<Columns>
				<asp:TemplateField HeaderText="ID" SortExpression="id">
					<ItemTemplate>
							<asp:Label ID="lblSegmentId" runat="server"></asp:Label>
						</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Segment Name" SortExpression="name">
					<ItemTemplate>
						<asp:Label ID="lblSegmentName" runat="server"></asp:Label>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Segment Type" SortExpression="type">
					<ItemTemplate>
						<asp:Label ID="lblSegmentType" runat="server"></asp:Label>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Created" SortExpression="created">
					<ItemTemplate>
						<asp:Label ID="lblSegmentCreated" runat="server"></asp:Label>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField HeaderText="Modified" SortExpression="modified">
					<ItemTemplate>
						<asp:Label ID="lblSegmentModified" runat="server"></asp:Label>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField>
					<ItemTemplate>
						<asp:HyperLink ID="lnkSegmentRules" runat="server">Rules</asp:HyperLink>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField>
					<ItemTemplate>
						<asp:HyperLink ID="lnkDownload" runat="server" CssClass="aDialog">Download Recipients</asp:HyperLink>
					</ItemTemplate>
				</asp:TemplateField>
				<asp:TemplateField ItemStyle-Width="50px">
					<ItemTemplate>
						<asp:HyperLink ID="lnkEdit" runat="server" CssClass="aDialog grid_icon_link edit" ToolTip="Edit">Edit</asp:HyperLink>
						<asp:LinkButton runat="server" ID="lbtnDelete" CommandName="DeleteSegment" CssClass="grid_icon_link delete" ToolTip="Delete">Delete</asp:LinkButton>
						<asp:LinkButton ID="cloneLinkButton" CssClass="grid_icon_link duplicate" 
								runat="server" ToolTip="Clone" CommandName="clone">Clone</asp:LinkButton>
					</ItemTemplate>
				</asp:TemplateField>
			</Columns>
			<EmptyDataTemplate>
				No Segments found.</EmptyDataTemplate>
		</asp:GridView>
		<uc1:Pager ID="pagerSegments" runat="server" RecordsPerPage="10" PostBackPager="true" OnPageIndexClickEvent="pagerSegment_PageIndexClick" />
	</div>
</asp:Content>
