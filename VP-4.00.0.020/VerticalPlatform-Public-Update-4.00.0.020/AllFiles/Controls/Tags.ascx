<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Tags.ascx.cs" Inherits="VerticalPlatformWeb.Controls.Tags" %>
<div class="tagControl module">
	<p class="title">
		Tags:</p>
	<asp:Panel ID="pnlTagAdd" runat="server">
		<div id="tagAdd" class="input">
			<input id="txtTagName" type="text" class="textbox" /><span id="rfvTagName" class="errorMessage"
				style="display: none;">*</span>
			<input id="btnAddTag" type="button" value="Add" class="button tagButton" />
			<div id="tagError" class="tagError">
			</div>
		</div>
	</asp:Panel>
	<asp:Panel ID="pnlMessage" runat="server" CssClass="tagMessage">
	</asp:Panel>
	<asp:Panel ID="pnlTagNames" CssClass="tagDisplay" runat="server">
	</asp:Panel>
</div>
