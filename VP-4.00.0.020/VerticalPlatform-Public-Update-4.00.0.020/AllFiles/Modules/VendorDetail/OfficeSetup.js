RegisterNamespace("VP.OfficeSetup");

VP.OfficeSetup = function(moduleUniqueClass, vpLeadFormUrl,vpContentIdParameter, vpContentTypeIdParameter, vpContentTypeId) {
	this.officeSetupModuleUniqueClass = moduleUniqueClass;
	this.leadFormUrl = vpLeadFormUrl;
	this.contentTypeId = vpContentTypeId;
	this.contentTypeIdParameter = vpContentTypeIdParameter;
	this.contentIdParameter = vpContentIdParameter;
	this.officeSetupContent = "";
};

VP.OfficeSetup.prototype.Init = function() {
	this.officeSetupContent = $("." + this.officeSetupModuleUniqueClass)[0];
	var that = this;

	$(".selectAll", this.officeSetupContent).click(function() {
		$("input[type=checkbox]", that.officeSetupContent).prop("checked", true);
	});

	$(".selectNone", this.officeSetupContent).click(function() {
		$("input[type=checkbox]", that.officeSetupContent).prop("checked", false);
	});

	$(".officeSetupLeadAction", this.officeSetupContent).click(function(event) {
		var vendors = $(".osVendor", that.officeSetupContent);
		var selectedVendors = "";
		for (var index = 0; index < vendors.length; index++) {
			if ($(vendors[index]).prop("checked")) {
				var vendorId = vendors[index].value;
				if (selectedVendors != "") {
					selectedVendors = selectedVendors + "," + vendorId;
				}
				else {
					selectedVendors = vendorId;
				}
			}
		}

		if (selectedVendors != "") {
			var leadFormUrl = that.leadFormUrl + "&" + that.contentIdParameter + "="
					+ selectedVendors + "&" + that.contentTypeIdParameter + "=" + that.contentTypeId;
			$(this).attr("href", leadFormUrl);
		}
		else {
			alert("Please select one or more vendors.");
			event.preventDefault();
		}
	});
};
