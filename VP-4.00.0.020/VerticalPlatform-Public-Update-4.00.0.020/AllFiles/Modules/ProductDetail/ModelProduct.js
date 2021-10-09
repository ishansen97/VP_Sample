$(document).ready(function() {
	$('.modelProductModule, .linkedProducts').each(function(){
		var thisWidth = $(this).width();
		var tableWidth = $('.productDetailTable', this).width();
		if(tableWidth > thisWidth){
			$(this).css({'overflow-x':'scroll'});
		}
	});
});