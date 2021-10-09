<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="HorizontalMatrix.ascx.cs"
	Inherits="VerticalPlatformWeb.Modules.Matrix.HorizontalMatrix" %>

<div class="matrixModule">
	<div class="horizontalMatrixModule module">
		<div>
			<asp:HyperLink ID="lnkAllAction" runat="server" Text="Request Info" CssClass="button requestInfoAllButton primary"></asp:HyperLink>
		</div>
		<asp:PlaceHolder ID="phProducts" runat="server"></asp:PlaceHolder>
	</div>
	<asp:PlaceHolder ID="phRelatedArticles" runat="server"></asp:PlaceHolder>
</div>
