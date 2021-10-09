<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="FixedUrlSettingControl.ascx.cs"
	Inherits="VerticalPlatformAdminWeb.ModuleAdmin.FixedUrls.FixedUrlSettingControl" %>
	<script src="../../Js/UrlHelper.js" type="text/javascript"></script>
<script type="text/javascript">

	
	$(document).ready(function () {
		var typeElementId = "txtCategoryId";
		var optionProduct = { siteId: VP.SiteId, type: "Product", currentPage: "1", pageSize: "10", categoryTypeElementId: typeElementId };
		$("input[type=text][id*=txtProductId]").contentPicker(optionProduct);
		var optionCategory = { siteId: VP.SiteId, type: "Category", currentPage: "1", pageSize: "10", categoryType: "Leaf" };
		$("input[type=text][id*=txtCategoryId]").contentPicker(optionCategory);

		$("input[type=text][id*=txtCategoryId]").change(function () {
			$("input[type=text][id*=txtProductId]").val("");
		});

		if (!$("input[type=checkbox][id*=chkBehindLead]").attr("checked")) {
			$("#PopupControl_dvRegistrationNotRequired").hide();
		}

		$("input[type=checkbox][id*=chkBehindLead]").change(function () {
			if ($("input[type=checkbox][id*=chkBehindLead]").attr("checked")) {
				$("#PopupControl_dvRegistrationNotRequired").show();
			}
			else {
				$("#PopupControl_dvRegistrationNotRequired").hide();
				$("input[type=checkbox][id*=chkRegistrationNotRequired]").removeAttr('checked');
			}
		});

		if (!$("input[type=checkbox][id*=chkBehindLogin]").attr("checked")) {
			$(".loginPopupLoadTimeoutDiv").hide();
		}
		
		$("input[type=checkbox][id*=chkBehindLogin]").change(function () {
			if ($("input[type=checkbox][id*=chkBehindLogin]").attr("checked")) {
				$(".loginPopupLoadTimeoutDiv").show();
			}
			else {
				$(".loginPopupLoadTimeoutDiv").hide();
				$("input[type=checkbox][id*=chkBehindLogin]").removeAttr('checked');
			}
		});
	});

	function ValidateRedirectUrl(src, args) {
		if ($("input[type=checkbox][id*=enableUrlRedirect]").attr('checked')) {
			var redirectUrl = $("input[type=text][id*=redirectUrl]").val().trim();
			var urlValidator = new VP.UrlHelper.UrlValidator(redirectUrl);
			args.IsValid = urlValidator.ValidateAbsoluteOrRelativeUrl();
		} else {
			args.IsValid = true;
		}
	};

	function ValidateCategory(src, args) {
		if ($("input[type=checkbox][id*=chkBehindLead]").attr("checked") &&
			$("input[type=text][id*=txtCategoryId]").val() == "") {
			args.IsValid = false;
		}
		else {
			args.IsValid = true;
		}
	}

	function ValidateProduct(src, args) {
		if ($("input[type=checkbox][id*=chkBehindLead]").attr("checked") &&
			$("input[type=text][id*=txtProductId]").val() == "") {
			args.IsValid = false;
		}
		else {
			args.IsValid = true;

		}
	}

	function ValidateLeadType(src, args) {
		if ($("input[type=checkbox][id*=chkBehindLead]").attr("checked") &&
			$("select[id*=ddlLeadType]").val() == "") {
			args.IsValid = false;
		}
		else {
			args.IsValid = true;

		}
	}

	function ValidatePassword(src, args) {
		if ($("input[type=text][id*=txtPassword]").val() !== "") {
			if ($("input[type=text][id*=txtPassword]").val().trim().length < 6 || 
				$("input[type=text][id*=txtPassword]").val().trim().length > 25) {
				args.IsValid = false;
			}
			else {
				args.IsValid = true;
			}
		}
		else {
			args.IsValid = true;

		}
	}
</script>
<style type="text/css">
.form-horizontal .control-group{margin-bottom:0px;}
.form-horizontal .control-group input[type=checkbox]{margin-top:10px;}
</style>
<div>
    <div class="form-horizontal">
        <div class="control-group">
            <label class="control-label">Behind Lead</label>
            <div class="controls">
                <asp:HiddenField ID="hdnBehindLead" runat="server" />
				<asp:CheckBox ID="chkBehindLead" runat="server" />
            </div>
        </div>
        <div class="control-group"  id="dvRegistrationNotRequired" runat="server">
            <label class="control-label">No Registration Required</label>
            <div class="controls">
                <asp:HiddenField ID="hdnRegistrationNotRequired" runat="server" />
				<asp:CheckBox ID="chkRegistrationNotRequired" runat="server" />
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">Category ID</label>
            <div class="controls">
                <asp:TextBox ID="txtCategoryId" runat="server"></asp:TextBox>
				<asp:CustomValidator ID="cvCategoryId" runat="server" ErrorMessage="Please enter category id."
					ClientValidationFunction="ValidateCategory">*</asp:CustomValidator>
				<asp:HiddenField ID="hdnCategoryId" runat="server" />
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">Product ID</label>
            <div class="controls">
                <asp:TextBox ID="txtProductId" runat="server"></asp:TextBox>
				<asp:CustomValidator ID="cvProductId" runat="server" ErrorMessage="Please enter product id."
					ClientValidationFunction="ValidateProduct">*</asp:CustomValidator>
				<asp:HiddenField ID="hdnProductId" runat="server" />
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">Lead Type</label>
            <div class="controls">
                <asp:DropDownList ID="ddlLeadType" runat="server" AppendDataBoundItems="true">
					<asp:ListItem Text="Select" Value=""></asp:ListItem>
				</asp:DropDownList>
				<asp:CustomValidator ID="cvLeadType" runat="server" ErrorMessage="Please select lead type."
					ClientValidationFunction="ValidateLeadType">*</asp:CustomValidator>
				<asp:HiddenField ID="hdnLeadType" runat="server" />
            </div>
        </div>
        <hr />
        <div class="control-group">
            <label class="control-label">Behind Login</label>
            <div class="controls">
                <asp:CheckBox ID="chkBehindLogin" runat="server" />
				<asp:HiddenField ID="hdnBehindLogin" runat="server" />
            </div>
        </div>
        <div class="control-group loginPopupLoadTimeoutDiv">
            <label class="control-label">Login Popup Load Timeout</label>
            <div class="controls">
				<asp:TextBox runat="server" ID="loginPopupLoadTimeout"></asp:TextBox> seconds
				<asp:HiddenField ID="loginPopupLoadTimeoutHidden" runat="server" />
            </div>
        </div>
		<div class="control-group">
			<label class="control-label">
				Password</label>
			<div class="controls">
				<asp:TextBox ID="txtPassword" runat="server"></asp:TextBox>
				<asp:HiddenField ID="hdnPassword" runat="server" />
				<asp:CustomValidator ID="cvPassword" runat="server" ErrorMessage="The 'Password' length should be between 6 to 25 characters."
					ClientValidationFunction="ValidatePassword">*</asp:CustomValidator>
			</div>
		</div>
	<div>
		<label class="control-label">
			Enable Url Redirect</label>
		<div class="controls">
			<asp:HiddenField ID="enableUrlRedirectHidden" runat="server" />
		<div class="input-prepend">
				<span class="add-on"><asp:CheckBox ID="enableUrlRedirect" runat="server" CssClass="checkbox-1" /></span>
				<asp:TextBox ID="redirectUrl" runat="server" style="width:180px"></asp:TextBox>
			</div>
		<div>
				<asp:CustomValidator ID="redirectUrlCustomValidator" runat="server" ClientValidationFunction="ValidateRedirectUrl"
				 ErrorMessage="Please enter a valid url for redirect url eg. http://www.example.com/ or a relative url eg. /example/page"
				>*</asp:CustomValidator>
			</div>
			<asp:HiddenField ID="redirectUrlHidden" runat="server" />
		</div>
	</div>
	</div>
</div>
