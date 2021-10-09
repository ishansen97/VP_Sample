<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ServiceDetail.ascx.cs"
	Inherits="VerticalPlatformWeb.Modules.ProductDetail.ServiceDetail" %>
<asp:Literal ID="ltlVendorImage" runat="server"></asp:Literal>
<div class="serviceListingModule">
	<div id="servicesContentTabs" class="ui-tabs">
		<ul class="ui-tabs ui-tabs-nav module">
			<li><a href="#services">Services</a> </li>
			<li><a href="#companyInfo">Contact Information</a> </li>
			<li><a href="#relatedProducts">Related Products</a> </li>
		</ul>
		<div class="sectionsHolder">
			<div id="services" class="ui-tabs-panel">
				<div id="relatedContent" class="relatedContent" runat="server">
					<asp:Literal ID="ltlRelatedContent" runat="server"></asp:Literal>
				</div>
				<div class="description module">
					<div class="galleryAndCompanyInfo">
						<asp:Literal ID="ltlGallery" runat="server"></asp:Literal>
						<asp:Literal ID="ltlVendorSpecification" runat="server"></asp:Literal>
					</div>
					<h2>
						Description<asp:HyperLink ID="lnkContactPartnerTop" CssClass="pillButton lead primary"
							runat="server">Contact Partner</asp:HyperLink></h2>
					<div class="overview">
						<asp:Literal ID="ltlDescription" runat="server"></asp:Literal>
					</div>
					<div class="contact">
						<asp:HyperLink ID="lnkContactPartnerBottom" CssClass="pillButton medium lead primary" runat="server">Contact Partner</asp:HyperLink>
						<asp:HyperLink ID="lnkContactVendor" CssClass="contactLink primary" runat="server"></asp:HyperLink>
					</div>
				</div>
				<div class="serviceCategories module">
					<h2>
						Services</h2>
					<div id="servicesAccordion">
						<asp:Literal ID="ltlCategorySpecification" runat="server"></asp:Literal>
					</div>
				</div>
			</div>
			<div id="companyInfo" class="ui-tabs-panel">
				<asp:Literal ID="ltlVendorAddress" runat="server"></asp:Literal>
			</div>
			<div id="relatedProducts" class="ui-tabs-panel">
				<asp:Literal ID="ltlRelatedProducts" runat="server"></asp:Literal>
			</div>
		</div>
	</div>
</div>
