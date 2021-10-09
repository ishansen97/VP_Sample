<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ProductDetail.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Product.ProductDetail" %>
<script type="text/javascript">
    $(document).ready(function() {
        var fileInput = document.getElementById("<%=fuImage.ClientID%>");
        var allowedExtension = ".jpg";
        console.log(fileInput);
        fileInput.addEventListener("change", function () {
            // Check that the file extension is supported.
            // If not, clear the input.
            var hasInvalidFiles = false;
            for (var i = 0; i < this.files.length; i++) {
                var file = this.files[i];

                if (!file.name.toLowerCase().endsWith(allowedExtension)) {
                    hasInvalidFiles = true;
                }
            }

            if (hasInvalidFiles) {
                fileInput.value = "";
                alert("Unsupported file selected.");
            }
        });
    });
</script>
<div class="form-horizontal">
	<div class="control-group">
		<label class="control-label">
			<asp:Literal ID="ltlProductIdText" runat="server" Text="Product&nbsp;Id"></asp:Literal></label>
		<div class="controls">
			<asp:Literal ID="ltlProductId" runat="server"></asp:Literal>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">
			<asp:Literal ID="Literal1" runat="server" Text="Product&nbsp;Type"></asp:Literal></label>
		<div class="controls">
			<asp:DropDownList ID="ddlProductType" runat="server" Width="310px" />
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">
			<asp:Literal ID="Literal2" runat="server" Text="Product&nbsp;Status"></asp:Literal></label>
		<div class="controls">
			<asp:DropDownList ID="ddlStatus" runat="server" Width="310px">
			</asp:DropDownList>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">
			<asp:Literal ID="ltlProductName" runat="server" Text="Product&nbsp;Name"></asp:Literal></label>
		<div class="controls">
			<asp:TextBox ID="txtProductName" runat="server" Width="300px" MaxLength="255" ValidationGroup="saveGroup"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvProductName" runat="server" ControlToValidate="txtProductName"
				ErrorMessage="Please enter product name." Font-Bold="True" ValidationGroup="saveGroup">*</asp:RequiredFieldValidator>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">
			<asp:Literal ID="ltlCatalogNumber" runat="server" Text="Catalog&nbsp;Number"></asp:Literal></label>
		<div class="controls">
			<asp:TextBox ID="txtCatalogNumber" runat="server" MaxLength="255" Width="300px"></asp:TextBox>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">
			<asp:Literal ID="ltlRank" runat="server" Text="Product Rank"></asp:Literal></label>
		<div class="controls">
			<asp:DropDownList ID="ddlProductRank" runat="server" Width="310px">
			</asp:DropDownList>
			<asp:HiddenField ID="hdnGeneric" runat="server" />
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">
			<asp:Literal ID="ltlDefaultRank" runat="server" Text="Default Product Rank"></asp:Literal></label>
		<div class="controls">
			<asp:DropDownList ID="ddlDefaultProductRank" runat="server" Width="310px">
			</asp:DropDownList>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">
			<asp:Literal ID="ltlSearchRank" runat="server" Text="Search Rank"></asp:Literal></label>
		<div class="controls">
			<asp:TextBox ID="txtSearchRank" runat="server" MaxLength="255" Width="300px" ValidationGroup="saveGroup"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvSearchRank" runat="server" ControlToValidate="txtSearchRank"
				ErrorMessage="Please enter search rank." Font-Bold="True">*</asp:RequiredFieldValidator>
			<asp:RangeValidator ID="rnvSearchRank" ControlToValidate="txtSearchRank" 
				Type="Double" MinimumValue="0" MaximumValue="500" runat="server"
				ErrorMessage="Search Rank should be between 0 and 500.">*</asp:RangeValidator>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">
			<asp:Literal ID="ltlDefaultSearchRank" runat="server" Text="Default Search Rank"></asp:Literal></label>
		<div class="controls">
			<asp:TextBox ID="txtDefaultSearchRank" runat="server" MaxLength="255" Width="300px"
				ValidationGroup="saveGroup"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvDefaultSearchRank" runat="server" ControlToValidate="txtDefaultSearchRank"
				ErrorMessage="Please enter default search rank." Font-Bold="True">*</asp:RequiredFieldValidator>
			<asp:RangeValidator ID="rnvDefaultSearchRank" ControlToValidate="txtDefaultSearchRank"
				Type="Double" MinimumValue="0" MaximumValue="500" runat="server" 
				ErrorMessage="Default Search Rank should be between 0 and 500." >*</asp:RangeValidator>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">
			<asp:Literal ID="ltlBusinessValue" runat="server" Text="Business Value"></asp:Literal></label>
		<div class="controls">
			<asp:TextBox ID="txtBusinessValue" runat="server" MaxLength="255" Width="300px" ValidationGroup="saveGroup"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvBusinessValue" runat="server" ControlToValidate="txtBusinessValue"
				ErrorMessage="Please enter business value." Font-Bold="True">*</asp:RequiredFieldValidator>
			<asp:RangeValidator ID="rnvBusinessValue" ControlToValidate="txtBusinessValue" 
				Type="Integer" MinimumValue="-100" MaximumValue="100" runat="server" 
				ErrorMessage="Business value should be between -100 and 100.">*</asp:RangeValidator>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">
			<asp:Literal ID="ltlEnable" runat="server" Text="Product&nbsp;Enabled"></asp:Literal></label>
		<div class="controls">
			<asp:CheckBox ID="chkProductEnable" runat="server" Text=" " Checked="True" />
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">
			Hidden</label>
		<div class="controls">
			<asp:CheckBox ID="chkHidden" runat="server" />
		</div>
	</div>
	<div class="control-group" id="fixedUrlRow" runat="server">
		<label class="control-label">
			Fixed URL</label>
		<div class="controls">
			<asp:TextBox ID="txtFixedUrl" runat="server" Width="300px" MaxLength="255"></asp:TextBox>
			<asp:RequiredFieldValidator ID="rfvFixedUrl" runat="server" ErrorMessage="Please enter fixed url."
				ControlToValidate="txtFixedUrl" Display="Dynamic">*</asp:RequiredFieldValidator>
			<asp:RegularExpressionValidator ID="revFixedUrl" runat="server" ErrorMessage="Url should start with '/', end with '/' and should only contain alpha numeric characters ,'-'. example '/id-category-name/id-product-name/'."
				ControlToValidate="txtFixedUrl" ValidationExpression="^((?:\/[a-zA-Z0-9]+(?:_[a-zA-Z0-9]+)*(?:\-[a-zA-Z0-9]+)*)+)/$"
				Display="Static">*</asp:RegularExpressionValidator>
		</div>
	</div>
	<div class="control-group" id="includeInSitemapRow" runat="server">
		<label class="control-label">
			Include in Sitemap</label>
		<div class="controls">
			<asp:CheckBox ID="includeInSitemap" runat="server" Width="300px"></asp:CheckBox>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">
			<asp:Literal ID="ltlImage" runat="server" Text="Image"></asp:Literal></label>
		<div class="controls">
			<asp:FileUpload ID="fuImage" runat="server" accept=".jpg"/>
			<asp:HiddenField ID="hdnHasImage" runat="server" />
			<asp:HiddenField ID="hdnHasTemporaryImage" runat="server" />
			<asp:HiddenField ID="hdnTemporaryFileName" runat="server" />
			<label class="checkbox inline">
				<asp:CheckBox ID="chkResizeImage" runat="server" />
				Create Standard Image Sizes
			</label>
		</div>
	</div>
	<div class="control-group">
		<div class="controls">
			<asp:Image ID="imgProduct" runat="server" Height="70px" Width="70px" />
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">
			Has Image</label>
		<div class="controls">
			<asp:CheckBox ID="chkHasImage" runat="server" />
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">
			Show in Matrix</label>
		<div class="controls">
			<asp:CheckBox ID="chkShowInMatrix" runat="server" Checked="true" />
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">
			Show Detail Page</label>
		<div class="controls">
			<asp:CheckBox ID="chkShowDetailPage" runat="server" Checked="true" />
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">
			Ignore in Rapid</label>
		<div class="controls">
			<asp:CheckBox ID="chkIgnoreInRapid" runat="server" />
		</div>
	</div>
	<div class="control-group">
		<asp:Panel ID="pnlProductArticles" runat="server" CssClass="product_article">
		</asp:Panel>
	</div>
</div>
