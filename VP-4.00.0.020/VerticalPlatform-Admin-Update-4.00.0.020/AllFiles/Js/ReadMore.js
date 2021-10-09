$(document).ready(function () {
	$('#messageCount').click(function () {
		$('#toggleDisplayMessages').show();
		$('#toggleHideMessages').show();
		$('#messageCount').hide();
	});

	$('.readless').click(function () {
		var count = $(".moreMessages:visible").length;
		if (count > 0) {
			if (count == 1) {
				$('#messageCount').show();
				$('#messageCount').html("You have " + count + " more message.");
				$('#toggleHideMessages').hide();
				$('#toggleDisplayMessages').hide();
			}
			else {
				$('#messageCount').show();
				$('#messageCount').html("You have " + count + " more messages.");
				$('#toggleHideMessages').hide();
				$('#toggleDisplayMessages').hide();
			}
		}
		else {
			$('#messageCount').hide();
			$('#toggleHideMessages').hide();
			$('#extraMessages').hide();
		}
	});
});