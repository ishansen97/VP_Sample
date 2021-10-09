<%@ Page Language="C#" MasterPageFile="~/MasterPage.Master" AutoEventWireup="true"
	CodeBehind="ProductTemplateUpload.aspx.cs" Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Product.UploadProductTemplate"
	Title="Untitled Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphContent" runat="server">
    <script src="../Js/file_uploader.js" type="text/javascript"></script>
	<div class="tablediv">
		<div class="AdminPanelHeader">
			<h3>
			Product Template Upload</h3></div>
		<div id="divDownloadFile" runat="server">
		
			<asp:LinkButton ID="lbtnDownloadExcel" runat="server" Visible="false" OnClick="lbtnDownloadExcel_Click"
				CausesValidation="false"></asp:LinkButton>
		</div>
		
		<div class="rowdiv">
			<div class="celldiv">
				<span class="displayMsg">
					Select the finalized Excel File.</span><br />
						<span class="displayMsg">
					Add a column Named "Product Type" and set the value as "Service" for services and "Product" for products and "Model" for models.</span><br />
				<span class="displayMsg">
					Excel 97-2003(xls) or Excel 2007(xlsx) files only</span><br /><br />
			</div>
			<div class="celldiv">
				<asp:FileUpload ID="fuLoadPreExcel" runat="server" CssClass="buttonFace" />
				<asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="fuLoadPreExcel"
					ErrorMessage="Please select file." CssClass="displayMsg" ValidationGroup="Upload">*</asp:RequiredFieldValidator>
				<br />
			</div>
		</div>
		<br />
		<div class="rowdiv">
			<div class="celldiv">
				<asp:Button ID="btnUploadFile" runat="server" OnClick="btnUploadFile_Click" Text="Upload Template"
					CssClass="btn" ValidationGroup="Upload" />
			</div>
			<div class="celldiv">
				<asp:DropDownList ID="ddlManuSeller" runat="server" Visible="False">
					<asp:ListItem>Manufacturer</asp:ListItem>
					<asp:ListItem>Seller</asp:ListItem>
				</asp:DropDownList>
			</div>
		</div>
		<br />
		<div class="rowdiv">
			<div class="celldiv">
			</div>
		</div>
		<div>
		</div>
	</div>
</asp:Content>
