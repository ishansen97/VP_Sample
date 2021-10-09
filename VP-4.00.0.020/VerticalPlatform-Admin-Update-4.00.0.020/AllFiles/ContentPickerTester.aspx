<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
CodeBehind="ContentPickerTester.aspx.cs" Inherits="VerticalPlatformAdminWeb.ContentPickerTester" %>

<asp:Content ID="content" ContentPlaceHolderID="cphContent" runat="server">
	
	<script src="../../Js/JQuery/jquery-ui-1.8.13.custom.min.js" type="text/javascript"></script>
	<script src="../../Js/JQuery/jquery.pager.js" type="text/javascript"></script>
	<script src="Js/Knockout/knockout-2.2.0.js" type="text/javascript"></script>
	<script src="Js/MultiColumnContentPicker.js" type="text/javascript"></script>

	<div class="AdminPanelHeader">
		<h3>Content Picker Tester</h3>
	</div>
	<div class="AdminPanelContent">
		<table>
			<tr>
				<td style="width:250px">Content Picker</td>
				<td><asp:TextBox ID="txtContentPicker" runat="server"></asp:TextBox></td>
			</tr>
		</table>
		<hr />
		<table>
			<tr>
				<td style="width:250px">Content Type</td>
				<td><asp:DropDownList ID="ddlContentType" runat="server"></asp:DropDownList></td>
			</tr>
			<tr>
				<td>Selection Type</td>
				<td><asp:DropDownList ID="ddlSelectionType" runat="server"></asp:DropDownList></td>
			</tr>
			<tr>
				<td>Page Size</td>
				<td><asp:TextBox ID="txtPageSize" runat="server" Text="10"></asp:TextBox></td>
			</tr>
			<tr>
				<td>Display Sites</td>
				<td>
					<asp:RadioButtonList ID="rblDisplaySites" runat="server" RepeatDirection="Horizontal"
						CellPadding="0" CellSpacing="0" CssClass="radio_table"></asp:RadioButtonList>
				</td>
			</tr>
			<tr>
				<td>Display Article Types</td>
				<td>
					<asp:RadioButtonList ID="rblDisplayArticleTypes" runat="server" RepeatDirection="Horizontal"
						CellPadding="0" CellSpacing="0" CssClass="radio_table"></asp:RadioButtonList>
				</td>
			</tr>
			<tr>
				<td>Show Article Type Column</td>
				<td>
					<asp:RadioButtonList ID="rblShowArticleTypeColumn" runat="server" RepeatDirection="Horizontal"
						CellPadding="0" CellSpacing="0" CssClass="radio_table"></asp:RadioButtonList>
				</td>
			</tr>
			<tr>
				<td>Show Article Published Date Column</td>
				<td>
					<asp:RadioButtonList ID="rblShowArticlePublishedDateColumn" runat="server" RepeatDirection="Horizontal"
						CellPadding="0" CellSpacing="0" CssClass="radio_table"></asp:RadioButtonList>
				</td>
			</tr>
			<tr>
				<td>Enabled</td>
				<td>
					<asp:RadioButtonList ID="rblEnabled" runat="server" RepeatDirection="Horizontal"
						CellPadding="0" CellSpacing="0" CssClass="radio_table"></asp:RadioButtonList>
				</td>
			</tr>
			<tr>
				<td>Is Article Published</td>
				<td>
					<asp:RadioButtonList ID="rblIsArticlePublished" runat="server" RepeatDirection="Horizontal"
						CellPadding="0" CellSpacing="0" CssClass="radio_table"></asp:RadioButtonList>
				</td>
			</tr>
			<tr>
				<td>Is Article Template</td>
				<td>
					<asp:RadioButtonList ID="rblIsArticleTemplate" runat="server" RepeatDirection="Horizontal"
						CellPadding="0" CellSpacing="0" CssClass="radio_table"></asp:RadioButtonList>
				</td>
			</tr>
			<tr>
				<td>Is Article Cross Posted</td>
				<td>
					<asp:RadioButtonList ID="rblIsArticleCrossPosted" runat="server" RepeatDirection="Horizontal"
						CellPadding="0" CellSpacing="0" CssClass="radio_table"></asp:RadioButtonList>
				</td>
			</tr>
		</table>
		<hr />
		<asp:Button ID="btnChangeSettings" runat="server" CssClass="btn" Text="Change Settings" OnClick="btnChangeSettings_Click"/>
	</div>
</asp:Content>