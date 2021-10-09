(function ($) {
	$(document).ready(function () {
		if (typeof (ValidationSummaryOnSubmit) == "function") {
			ValidationSummaryOnSubmit = $.validationSummaryOnSubmit;
		}
	});

	$.validationSummaryOnSubmit = function (validationGroup) {
		var messages = [];

		if (!Page_IsValid) {
			var i;
			for (i = 0; i < Page_Validators.length; i++) {
				if (!Page_Validators[i].isvalid && typeof (Page_Validators[i].errormessage) == "string") {
					messages.push(Page_Validators[i].errormessage);
				}
			}
			var s = messages.join(" ");
			if ($.trim(s) == "") {
				s = "There were problems with some of the fields.";
			}
			$.notify({ message: s });
		}
	};
})(jQuery);