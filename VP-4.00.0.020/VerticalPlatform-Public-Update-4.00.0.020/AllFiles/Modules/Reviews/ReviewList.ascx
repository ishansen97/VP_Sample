<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ReviewList.ascx.cs" 
	Inherits="VerticalPlatformWeb.Modules.Reviews.ReviewList" %>
<%@ Register Src="../../Controls/Pager.ascx" TagName="Pager" TagPrefix="uc1" %>

<div class="reviewList module">
	<a name="reviewListModule"></a>
	<div class="reviewList module">
		<asp:PlaceHolder ID="phReviewList" runat="server"></asp:PlaceHolder>
	</div>
	<uc1:Pager ID="pgReviewList" runat="server" />
</div>
