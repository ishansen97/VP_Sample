RegisterNamespace("VP.VendorFilteringList");

VP.VendorFilteringList.Init = function() {
	$(document).ready(function() {
		$("#btnFilterVendors").click(function() {

			var urlComponents, newUrlComponents, foundVendorKey;

			urlComponents = location.href.replace(location.hash, "").split("?");
			if (urlComponents.length > 1) {
				queryComponents = urlComponents[1].split("&");
			} else {
				queryComponents = new Array();
			}

			newUrlComponents = new Array();

			for (i = 0; i < queryComponents.length; i++) {
				if (queryComponents[i].indexOf("vids") >= 0) {
					queryComponents[i] = "vids" + "=" + VP.VendorFilteringList.GetAllSelectedVendors();
					foundVendorKey = true;
				}

				if (queryComponents[i].indexOf("vmpi") == -1) {
					newUrlComponents.push(queryComponents[i]);
				}
			}

			if (!foundVendorKey) {
				newUrlComponents.push("vids" + "=" + VP.VendorFilteringList.GetAllSelectedVendors());
			}

			location.href = urlComponents[0] + "?" + newUrlComponents.join("&") + location.hash;
			return false;
		});
	});
};

VP.VendorFilteringList.GetAllSelectedVendors = function() {
	var vendors = [];
	var selectedVendors = $(".parentVendorFiltering input:checked");
	$(selectedVendors).each(function(index) {
		vendors.push($(this).val());
	});
	
	return vendors.join(",");
};

VP.VendorFilteringList.Init();