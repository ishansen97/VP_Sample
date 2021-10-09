RegisterNamespace("VP.SliderContainer");

VP.SliderContainer = function(moduleInstanceId, tabElementId) {
	this._moduleInstanceId = moduleInstanceId;
	this._tabElementId = tabElementId;
	this._element = null;
};

VP.SliderContainer.prototype.Initialize = function() {
	var that = this;
	$(document).ready(function() {
		that._element = $("#" + that._tabElementId);
		that._element.slides({
			generateNextPrev: true,
			generatePagination: true,
			play: 5000
		});
	});
};