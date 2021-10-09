RegisterNamespace("VP.AccordionContainer");

var accordions = [];

VP.AccordionContainer = function(moduleInstanceId, accordionElementId, persistState) {
	this._moduleInstanceId = moduleInstanceId;
	this._accordionElementId = accordionElementId;
	this._element = null;
	this._persistState = persistState;
};

VP.AccordionContainer.prototype.Initialize = function() {
	var that = this;
	$(document).ready(function() {

		that._element = $("#" + that._accordionElementId);
		var activeIndex = 0;
		if (that._persistState) {
			var cookieValue = $.Cookie("acc" + that._moduleInstanceId);
			if (cookieValue) {
				activeIndex = parseInt(cookieValue, 10);
			}
		}

		that._element.accordion({
			active: activeIndex,
			autoHeight: false,
			collapsible: true,
			change: function(event, ui) {
				if (that._persistState) {
					$.Cookie("acc" + that._moduleInstanceId, $(this).accordion("option", "active"));
				}
			}
		});

		if (that._persistState) {
			accordions.push("acc" + that._moduleInstanceId);
		}
	});
};

$(document).ready(function() {
	setTimeout(function() { VP.AccordionContainer.CleanCookies(); }, 2000);
});

VP.AccordionContainer.CleanCookies = function() {
	if (accordions) {
		var cookies = $.Cookie.Match("acc");
		if (cookies) {
			var name;
			for (name in cookies) {
				if ($.inArray(name, accordions) < 0) {
					$.Cookie(name, null);
				}
			}
		}
	}
};