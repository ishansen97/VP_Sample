<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DeletedCampaignList.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.BulkEmail.DeletedCampaignList"
  MasterPageFile="~/MasterPage.Master" %>

<%@ Register Src="../Pager.ascx" TagName="Pager" TagPrefix="uc1" %>
<%@ Register TagPrefix="ajaxToolkit" Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" %>
<asp:Content ID="contents" ContentPlaceHolderID="cphContent" runat="server">
  <div class="AdminPanelHeader">
    <h3>Deleted Campaign List</h3>
  </div>

  <div class="AdminPanelContent">
    <table ID="deletedCampaignTable" width="100%" cellpadding="0" cellspacing="0" class="common_data_grid table table-bordered">
      <asp:Repeater ID="deletedCampaignList" runat="server" OnItemDataBound="deletedCampaignList_ItemDataBound" OnItemCommand="deletedCampaignList_ItemCommand">
        <HeaderTemplate>
          <asp:TableHeaderRow runat="server" ID="tableCampaignHeaderRow">
            <asp:TableHeaderCell>
                  <b>Id</b>
            </asp:TableHeaderCell>
            <asp:TableHeaderCell>
                  <b>Name</b>
            </asp:TableHeaderCell>
            <asp:TableHeaderCell>
                  <b>Campaign Type</b>
            </asp:TableHeaderCell>
            <asp:TableHeaderCell>
                  <b>Scheduled Date</b>
            </asp:TableHeaderCell>
            <asp:TableHeaderCell>
                  <b>Status</b>
            </asp:TableHeaderCell>
            <asp:TableHeaderCell>
                  <b>Logs</b>
            </asp:TableHeaderCell>
            <asp:TableHeaderCell>
                  <b>Created</b>
            </asp:TableHeaderCell>
            <asp:TableHeaderCell>
                  <b>Last Modified</b>
            </asp:TableHeaderCell>
            <asp:TableHeaderCell>
                  &nbsp;
            </asp:TableHeaderCell>
            <asp:TableHeaderCell>
                  &nbsp;
            </asp:TableHeaderCell>
          </asp:TableHeaderRow>
        </HeaderTemplate>
        <ItemTemplate>
          <asp:TableRow CssClass="campaignRow" runat="server" ID="tableCampaignTypeRow">
            <asp:TableCell VerticalAlign="top">
              <asp:Label runat="server" ID="lblId"></asp:Label>
              &nbsp;
            </asp:TableCell>
            <asp:TableCell VerticalAlign="top">
              <asp:Label runat="server" ID="lblName"></asp:Label>
              &nbsp;
            </asp:TableCell>
            <asp:TableCell VerticalAlign="top">
              <asp:Label runat="server" ID="lblType"></asp:Label>
              &nbsp;
            </asp:TableCell>
            <asp:TableCell VerticalAlign="top">
              <asp:Label runat="server" ID="lblScheduledDate"></asp:Label>
              &nbsp;
            </asp:TableCell>
            <asp:TableCell VerticalAlign="top">
              <asp:Label ID="lblStatus" runat="server"></asp:Label>
              &nbsp;
            </asp:TableCell>
            <asp:TableCell VerticalAlign="top">
              <asp:HyperLink ID="lnkLogs" runat="server" Text="Logs" CssClass="aDialog"></asp:HyperLink>
              &nbsp;
            </asp:TableCell>
            <asp:TableCell VerticalAlign="top">
              <asp:Label ID="lblCreated" runat="server"></asp:Label>
              &nbsp;
            </asp:TableCell>
            <asp:TableCell VerticalAlign="top">
              <asp:Label ID="lblModified" runat="server"></asp:Label>
              &nbsp;
            </asp:TableCell>
            <asp:TableCell>
              <asp:LinkButton ID="lbtnRestore" runat="server" CommandName="RestoreCampaign" CssClass="btn" ToolTip="Restore">Restore</asp:LinkButton>
              <ajaxtoolkit:confirmbuttonextender id="cbeRestore" runat="server" targetcontrolid="lbtnRestore"
                confirmtext="Are you sure you want to restore the campaign?">
              </ajaxtoolkit:confirmbuttonextender>
            </asp:TableCell>
            <asp:TableCell VerticalAlign="top">
              <asp:LinkButton ID="lbtnDelete" runat="server" CommandName="DeleteCampaign" Text="" CssClass="grid_icon_link delete" ToolTip="Delete"></asp:LinkButton>
              &nbsp;
            </asp:TableCell>
          </asp:TableRow>
        </ItemTemplate>
        <FooterTemplate>
          <ul> 
            <li runat="server" Visible='<%# DataBinder.Eval(Container.Parent, "Items.Count").ToString() == "0" %>'>
              No deleted campaigns found.
            </li>
          </ul>
        </table>
    </FooterTemplate>
      </asp:Repeater>
    </table>
    <br />
    <uc1:Pager ID="pagerCampaign" runat="server" OnPageIndexClickEvent="pagerCampaign_PageIndexClick" RecordsPerPage="10" PostBackPager="false" />
    <asp:Literal ID="ltlNoCampaigns" runat="server" Text="No Deleted Campaigns found." Visible="false"></asp:Literal>
  </div>
</asp:Content>
