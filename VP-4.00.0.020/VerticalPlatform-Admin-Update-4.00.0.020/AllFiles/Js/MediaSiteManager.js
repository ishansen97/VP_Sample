(function($) {
	$(document).ready(function() {
		
		buildToolTip();
	});

	function buildToolTip() {
		$('.ProductListRow').each(function(i, domElement) {
			if ($(domElement).find('.LnkFileName').length > 0) {
				var labelText = $(domElement).find('.LnkFileName').text();
				var path = $(domElement).find('.hdnPathSpan').attr('title');
				if(path != "")
				{
				
				
					var contentText = '<div> <img height="100" width="150" src="'+ path +'"></div>';
					
					$(domElement).find('.LnkFileName').append('<img class="icon zoom compact" src="/Images/zoom.png"/>');
					$(domElement).find('.LnkFileName').parents(".ProductListRow").hover(function(event) {
						$(event.currentTarget).find('.zoom').fadeIn(200);
					}, function(event) {
						$(event.currentTarget).find('.zoom').fadeOut(200);
					});
					$(domElement).find('.LnkFileName').qtip({
						content: {
								title: {
									text: labelText,
									button: "Close"
								},
								text: contentText
							},
							position: {
								my: "left center",
								at: "right center"
							},
							show: {
								event: false, 
								solo: true
							},
							hide: {
								event: "unfocus"
							},
							style: {
								tip: true,
								width : 160,
								height : 110,
								classes: "ui-tooltip-light ui-tooltip-rounded"
							},
							prerender: false
					});

					$(domElement).find('.LnkFileName').find('.zoom').click(function(event) {
						$(event.currentTarget).parents(".LnkFileName").qtip("show");

					});
				}
			}
		});
	}
})(jQuery);