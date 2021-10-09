<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="FixedUrlControl.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.Category.FixedUrlControl" %>
	<script src="../../Js/UrlHelper.js" type="text/javascript"></script>
	<script type="text/javascript">
		(function () {
			RegisterNamespace("VP.Category.FixedUrlControl");

			VP.Category.FixedUrlControl.ValidateRedirectUrl = function (src, args) {
				var redirectUrl = $("input[type=text][id*=redirectUrl]").val().trim();
				var redirectEnabled = $("input[type=checkbox][id*=enableUrlRedirect]").attr('checked');
				if (redirectEnabled || redirectUrl.length > 0) {
					var urlValidator = new VP.UrlHelper.UrlValidator(redirectUrl);
					args.IsValid = urlValidator.ValidateAbsoluteOrRelativeUrl();
				} else {
					args.IsValid = true;
				}
			};
		})();

	</script>
    <style type="text/css">
        .main-container .main-content .page-content-area .tabs-container .menuHorizontal ul.menu > li.urlParent a#ctl00_cphContent_lbtnFixedUrl {
            background: #ffffff;
            font-weight: bold;
        }
    </style>
<div class="form-horizontal">
	<table>
		<tr id="trFixedUrl" runat="server">
			<td>
				<div class="control-group">
					<label class="control-label">
						Fixed URL</label>
					<div class="controls">
						<asp:TextBox ID="txtFixedUrl" runat="server" Width="250px"></asp:TextBox>
					</div>
				</div>
			</td>
		</tr>
	</table>
	<div class="control-group">
		<label class="control-label">
			Page</label>
		<div class="controls">
			<asp:Label ID="lblSelectedPage" runat="server" Text="" Style="display: inline-block;
				padding-top: 5px;"></asp:Label>
			<asp:HiddenField ID="hdnSelectedPage" runat="server" />
		</div>
	</div>
	<div class="control-group">
		<div class="controls">
			<div class="inline-form-container">
				<asp:DropDownList ID="ddlPage" runat="server" Width="265px">
				</asp:DropDownList>
				<asp:Button ID="btnSetPage" runat="server" Text="Change" OnClick="btnSetPage_Click"
					CssClass="btn" CausesValidation="False" />
			</div>
		</div>
	</div>
	<div class="control-group">
		<label class="control-label">
			Include in Sitemap</label>
		<div class="controls">
			<asp:CheckBox ID="includeInSitemap" runat="server" />
		</div>
	</div>
	
	<div class="control-group">
		<label class="control-label">
			Enable Url Redirect</label>
		<div class="controls">
			<asp:HiddenField ID="enableUrlRedirectHidden" runat="server" />
			<div class="input-prepend">
				<span class="add-on"><asp:CheckBox ID="enableUrlRedirect" runat="server" CssClass="checkbox-1 in-prepend" /></span>
				<asp:TextBox ID="redirectUrl" runat="server" Width="223"></asp:TextBox>
			</div>
			<asp:CustomValidator ID="redirectUrlCustomValidator" runat="server" ClientValidationFunction="VP.Category.FixedUrlControl.ValidateRedirectUrl"
				 ErrorMessage="Please enter a valid url for redirect url eg. http://www.example.com/ or a relative url eg. /example/page/">*</asp:CustomValidator>
			<asp:HiddenField ID="redirectUrlHidden" runat="server" />
		</div>
	</div>
</div>
