RegisterNamespace("VP.VendorSearchNotifier");

$(document).ready(function () {
	$('.vendor_link').click(function (e) {
		e.preventDefault();
		var id = $(this).attr('id').split('_')[1];
		var redirectUrl = VP.VendorSearchNotifier.UpdateQueryStringParameter(location.href, "vendor", id);
		location.href = redirectUrl;
	});

	$('.single_vendor .no').click(function (e) {
		e.preventDefault();
		$(this).parent().parent().parent().hide();
	});
});

VP.VendorSearchNotifier.UpdateQueryStringParameter = function (uri, key, value) {
	var re = new RegExp("([?|&])" + key + "=.*?(&|#|$)", "i");
	if (uri.match(re)) {
		return uri.replace(re, '$1' + key + "=" + value + '$2');
	} else {
		var separator = uri.indexOf('?') !== -1 ? "&" : "?";
		if (uri.indexOf('#') !== -1) {
			uri = uri.replace(/#.*/, '');
		}
		return uri + separator + key + "=" + value;
	}
};