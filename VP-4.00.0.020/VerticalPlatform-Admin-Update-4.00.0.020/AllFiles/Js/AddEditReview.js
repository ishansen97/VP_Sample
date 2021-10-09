(function ($) {
  $.fn.vprating = function (options) {
    var defaults = { ratingValueHolder: '' };
    var settings = $.extend({}, defaults, options);
    return this.each(function () {
      var $this = $(this);
      var rating = $("#" + settings.ratingValueHolder).val();
      if (rating == "") {
        rating = 0;
      }

      $this.raty({
        starOff: '/Images/star-off.png',
        starOn: '/Images/star-on.png',
        score: rating,
        halfShow: true,
        hints: ['Ratings', 'Ratings', 'Ratings', 'Ratings', 'Ratings'],
        width: 150,
        noRatedMsg: '',
        click: function (score, evt) {
          $("#" + settings.ratingValueHolder).val(score);
        }
      });
    });
  };
})(jQuery);

$(document).ready(function () {
  var productIdElement = { contentId: "productHidden" };
  var productNameOptions = { siteId: VP.SiteId, type: "Product", currentPage: "1", pageSize: "15", showName: "true", bindings: productIdElement };
  $("input[type=text][id*=productTextBox]").contentPicker(productNameOptions);

  var vendorIdElement = { contentId: "companyHidden" };
  var vendorNameOptions = { siteId: VP.SiteId, type: "Vendor", currentPage: "1", pageSize: "15", showName: "true", bindings: vendorIdElement };

  $("input[type=text][id*=companyTextBox]").contentPicker(vendorNameOptions);

  if ($("a[id$='sendPaymentButton']").attr("disabled") === "disabled") {
    $("a[id$='sendPaymentButton']").click(function (e) {
			e.preventDefault();
		});
	} else {
	  $("a[id$='sendPaymentButton']").addClass("aDialog");
	  $("#popupDialog").jqmAddTrigger('.aDialog');
	}
});

function OverrideVerification() {
	if (confirm('Do you want to publish this review based on previous verified reviews?') === true) {
		return true;
	}
	else {
		$.notify({ message: 'Review has not been published.', type: 'warning' });
		return false;
	}
};