RegisterNamespace("VP.Location.BaseLocation");

VP.Location.BaseLocation = function() {
	this._locationTypeId;
	this._locationId;
	this._locationName;
	this._excluded;
	this._element;
	this._container;
	this._id;
};

VP.Location.BaseLocation.prototype.Create = function(id, data, container) {
	this._id = id;
	this._container = container;
	this.Load(data);
	var ui = "<div id='l_" + id + "'>" + this._locationName + "<a id='c_" + id + "'>c</a></div>";
	container.append(ui);
	$("#c_" + id).click(function() {
		alert($(this).attr("id"));
	});
};

VP.Location.BaseLocation.prototype.Load = function(data) {
	this._locationTypeId = data.LocationTypeId;
	this._locationId = data.LocationId;
	this._locationName = data.LocationName;
	this._excluded = data.Excluded;
};