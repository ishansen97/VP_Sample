(function($) {
	$.otherRequestedProducts = function() {
		var container = $(".product_div");
		$(".request_button", container).click(function() {
			var products = $(".requested_product input[type=checkbox]", container);
			var index = 0;
			var productsSelected = false;
			for (; index < products.length; index++) {
				if ($(products[index]).prop("checked")) {
					productsSelected = true;
					break;
				}
			}

			if (!productsSelected) {
				alert("Please select one or more products to request information.");
				return false;
			}
		});
	};
})(jQuery);

$(document).ready(function() {
	$.otherRequestedProducts();
});