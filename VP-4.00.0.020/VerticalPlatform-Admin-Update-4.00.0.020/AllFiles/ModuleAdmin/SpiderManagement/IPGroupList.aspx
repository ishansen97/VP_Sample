<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="IPGroupList.aspx.cs" MasterPageFile="~/MasterPage.Master" 
		Inherits="VerticalPlatformAdminWeb.ModuleAdmin.SpiderManagement.IPGroupList"%>
		
<%@ Register TagPrefix="ajaxToolkit" Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" %>
<%@ Register Src="../Pager.ascx" TagName="Pager" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
<script src="../../Js/SpiderManagement/IPList.js" type="text/javascript"></script>
<script type="text/javascript">
	var ipList = null;
	$(document).ready(function () {
	    ipList = new VP.IPList();
	    $(".ipGroupRow .Click_btn", this).click(function () {
	        VP.IPList.LoadIpList($(this).find('input')[0].value, $(this).find('input')[1].value);
	        $(this).parent().next().toggleClass("expanded");
	        $(this).toggleClass("collaps_icon");
	    });
	});
</script>		
	<div class="AdminPanel spider">
		<div class="AdminPanelHeader">
			<h3>IP Group/Address List</h3>
		</div>
		<div class="AdminPanelContent">
		<div class="add-button-container">
            <asp:HyperLink ID="lnkAddNewIP" runat="server" CssClass="aDialog btn">Add New IP</asp:HyperLink>
		    <asp:HyperLink ID="lnkAddIpGroup" runat="server" CssClass="aDialog btn">Add IP Group</asp:HyperLink>
		</div>
			<asp:UpdateProgress ID="UpdateProgress1" runat="server">
				<ProgressTemplate>
					<asp:Image ID="imgProgress" runat="server" ImageUrl="~/Images/Progress.gif" />
				</ProgressTemplate>
			</asp:UpdateProgress>
			
			<table class="common_data_grid table table-bordered" cellpadding="0" cellspacing="0" style="width:auto">
					<asp:Repeater ID="rptIpGroupList" runat="server" OnItemCommand="rptIpGroupListItemCommand"
						OnItemDataBound="rptIpGroupListItemDataBound">
						<HeaderTemplate>
							<asp:TableHeaderRow runat="server" ID="tableCampaignTypeHeaderRow">
								<asp:TableHeaderCell Width="30">
									&nbsp;
								</asp:TableHeaderCell>
								<asp:TableHeaderCell width="25">
										Id
								</asp:TableHeaderCell>
								<asp:TableHeaderCell width="100">
									<asp:LinkButton ID="lbtnGroup" runat="server">
										IP Group
									</asp:LinkButton>
								</asp:TableHeaderCell>
								<asp:TableHeaderCell Width="60">
									<asp:LinkButton ID="lbtnCount" runat="server">
										IP Count
									</asp:LinkButton>
								</asp:TableHeaderCell>
								<asp:TableHeaderCell Width="300">
										Description
								</asp:TableHeaderCell>
								<asp:TableHeaderCell Width="60">
									&nbsp;
								</asp:TableHeaderCell>
							</asp:TableHeaderRow>
						</HeaderTemplate>
						<ItemTemplate>
							<asp:TableRow CssClass="ipGroupRow" runat="server" ID="tableCampaignTypeRow">
								<asp:TableCell CssClass="Click_btn" VerticalAlign="top">
									<div>&nbsp;</div>
									<asp:HiddenField ID="hdnIpGroup" runat="server" />
									<asp:HiddenField ID="hdnIpCount" runat="server" />
								</asp:TableCell>
								<asp:TableCell VerticalAlign="top">
									<asp:Label ID="ipGroupId" runat="server"></asp:Label>
									&nbsp;
								</asp:TableCell>
								<asp:TableCell VerticalAlign="top">
									<asp:Label ID="lblIpGroup" runat="server"></asp:Label>
									&nbsp;
								</asp:TableCell>
								<asp:TableCell VerticalAlign="top">
									<asp:Label ID="lblIpCount" runat="server"></asp:Label>
									&nbsp;
								</asp:TableCell>
								<asp:TableCell VerticalAlign="top">
									<asp:Label ID="lblDescription" runat="server"></asp:Label>
									&nbsp;
								</asp:TableCell>
								<asp:TableCell VerticalAlign="top">
									<asp:HyperLink ID="lnkEdit" runat="server" CssClass="aDialog grid_icon_link edit"
										ToolTip="Edit" Text="" Visible="false"></asp:HyperLink>
									<asp:LinkButton ID="lbtnDelete" runat="server"
										CommandName="DeleteGroup" Text="" CssClass="grid_icon_link delete" 
										ToolTip="Delete" Visible="false"></asp:LinkButton>
								</asp:TableCell>
							</asp:TableRow>
							<tr class="campaignRowContent ipGroupRowContent">
								<td colspan="20">
									<div class="content_div clearfix ip-content-inner">
										<div id="ipAddress_<%# DataBinder.Eval(Container.DataItem, "GroupId") %>" class="inner clearfix">
											
										</div>
									</div>
								</td>
							</tr>
						</ItemTemplate>
					</asp:Repeater>
				</table>
			<asp:HiddenField ID="hdnHoneypotIP" Value="false" runat="server" />
			<uc1:Pager ID="pagerIpGroup" runat="server"  OnPageIndexClickEvent="PageIndexClick"
				RecordsPerPage="10" />
		</div>
	</div>
	
	
</asp:Content>
