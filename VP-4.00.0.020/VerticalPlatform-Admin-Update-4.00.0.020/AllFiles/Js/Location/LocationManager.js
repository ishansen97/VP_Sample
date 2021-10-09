RegisterNamespace("VP.Location.LocationManager");

VP.Location.LocationManager = function(contentTypeId, contentId) {
	this._contentTypeId = contentTypeId;
	this._contentId = contentId;
	this._locations = [];
	this._element = $("#locations");
	this._regionType = 1;
	this._countryType = 2;
	this._idCount = 0;
};

VP.Location.LocationManager.prototype.GetLocations = function() {
$.ajax({
	type: "POST",
	async: false,
	cache: false,
	url: webserviceUrl,
	data: "{'siteId':" + VP.SiteId + ",'pageId':" + VP.Pages.Designer.PageId + "}",
	contentType: "application/json; charset=utf-8",
	dataType: "json",
	success: function(msg) {
		modules = msg.d;
	},
	error: function(XMLHttpRequest, textStatus, errorThrown) {
	}
});};

VP.Location.LocationManager.prototype.Load = function() {
	var locations = this.GetLocations();
	for (var i = 0; i < locations.length; i++) {
	}
};

VP.Location.LocationManager.prototype.Save = function() {
};

VP.Location.LocationManager.prototype.Add = function() {
	if ($("input[id$='rdbCountry']").attr("checked")) {
		if ($("select[id$='ddlCountry']").val() == "") {
			$.notify({ message: "Please select a country", type: "error" });
		}
		else {
			var location = new VP.Location.BaseLocation();
			var option = $("select[id$='ddlCountry'] option:selected")
			var locationId = "l" + (this._idCount + 1);
			location.Create(locationId,
				VP.Location.BaseLocation.LocationEntity.GetLocationInstance(this._countryType, option.val(), 
				option.text(), $("input[id$='chkExcludeCountry']").attr("checked")), this._element);
			this._locations[locationId] = location;
			this._idCount++;
		}
	}
	else if ($("input[id$='rdbRegion']").attr("checked")) {
		if ($("select[id$='ddlRegion']").val() == "") {
			$.notify({ message: "Please select a region", type: "error" });
		}
		else {
		}
	}
};

VP.Location.LocationManager.prototype.Remove = function(id) {
};

$(document).ready(function() {
	VP.Location.LocationManagerInstance = new VP.Location.LocationManager();

	$("#btnAddLocation").click(function() {
		VP.Location.LocationManagerInstance.Add();
	});
});