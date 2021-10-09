RegisterNamespace("VP.ProductContactInformation");
VP.ProductContactInformation.clickThroughId = "";

VP.ProductContactInformation = function(){
};

VP.ProductContactInformation.ContactInfoClickThroughTracking = function(id, enableClickThrough, clickThroughTrackingId) {
	if (enableClickThrough) {
		clickThroughId = clickThroughTrackingId;
		$('.vendorProfileLink').click(this.TriggerClickThrough);
		$('#' + id).click(this.TriggerClickThrough);
	}
};

VP.ProductContactInformation.TriggerClickThrough = function() {
	$(this).clickThroughTrigger(clickThroughId);
};