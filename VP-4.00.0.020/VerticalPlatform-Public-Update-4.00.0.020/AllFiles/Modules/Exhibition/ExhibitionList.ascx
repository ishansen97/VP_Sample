<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ExhibitionList.ascx.cs" Inherits="VerticalPlatformWeb.Modules.Exhibition.ExhibitionList" %>
<%@ Register Src="../../Controls/Pager.ascx" TagName="Pager" TagPrefix="uc1" %>
<div class="exhibitionList" id="exhibitionListDiv" runat="server"></div>
<div><uc1:Pager ID="PagerExhibitionList" runat="server" /></div>