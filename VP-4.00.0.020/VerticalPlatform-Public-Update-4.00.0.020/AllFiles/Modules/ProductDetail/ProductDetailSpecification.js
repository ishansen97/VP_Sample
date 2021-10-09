RegisterNamespace("VP.ProductDetailSpecification");
(function ($) {
	$(document).ready(function () {
		var $compareButton = $("#productDetailCompareButton");
		var productId = $compareButton.data("productid");
		var productPosition = $compareButton.data("matrixposition");

		if ($compareButton.length > 0) {

			var updateProductSelectionStatus = function () {
			var isProductSelected = false;
			if (VP.SelectedProducts && VP.SelectedProducts.Products) {
				$(VP.SelectedProducts.Products).each(
					function (index, data) {
						if (data.split("_")[0] == productId) {
							isProductSelected = true;
							return false;
						}
					});
			}

				if (!isProductSelected) {
					$compareButton.removeClass("disabled");
				}
				else {
					$compareButton.addClass("disabled");
				}
			};

			$("body").on("productRemoved", function (event, productData) {
				if (productData.id === productId) {
					$compareButton.removeClass("disabled");
				}
			});

			$compareButton.on("click", function (e) {
				if (!$(this).hasClass("disabled")) {
					VP.SelectedProducts.ProductPositions.push(productId + "_" + productPosition);
					$("body").trigger("productSelected", {
						id: productId
					});

					$compareButton.addClass("disabled");
				}
			});

			$("body").on("selectedProductsLoaded", function () {
				updateProductSelectionStatus();
			});
		}

	});

})(jQuery);

