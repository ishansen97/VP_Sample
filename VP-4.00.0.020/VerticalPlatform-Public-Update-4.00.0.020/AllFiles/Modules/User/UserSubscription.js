RegisterNamespace("VP.UserSubscription");

VP.UserSubscription.Init = function() {
	$(document).ready(function() {
		var container = $(".userSubscriptionModule");
		$(".selectAll", container).click(function() {
			$("input[type=checkbox]", container).prop("checked", true);
		});

		$(".selectNone", container).click(function() {
			$("input[type=checkbox]", container).prop("checked", false);
		});
	});
};

VP.UserSubscription.Init();