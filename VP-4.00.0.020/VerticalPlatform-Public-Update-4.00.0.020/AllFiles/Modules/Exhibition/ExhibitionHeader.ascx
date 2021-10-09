<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ExhibitionHeader.ascx.cs"
    Inherits="VerticalPlatformWeb.Modules.Exhibition.ExhibitionHeader" %>
<div class="exibitionHeaderModule">
        <div class="vendorLogo">
            <asp:HyperLink ID="lnkHeaderLink" runat="server">
                <asp:Image ID="imgHeaderLogo" runat="server"></asp:Image>
            </asp:HyperLink>
        </div>
        <div class="headerInfo">
            <ul>
                <li class="ehp">Exhibit hall preview</li>
                <li>
                    <h1 class="vendorName">
                        <asp:Literal ID="ltlHeaderTitle" runat="server"></asp:Literal></h1>
                </li>
                <li class="date">
                    <asp:Literal ID="ltlHeaderInfo" runat="server"></asp:Literal>
                </li>
            </ul>
        </div> 
</div>
