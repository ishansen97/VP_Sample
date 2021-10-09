RegisterNamespace("VP.Location.BaseLocation.LocationEntity");

VP.Location.BaseLocation.LocationEntity.GetLocationInstance = function(locationType, locationId,
	locationName, excluded) {
	var location = new VerticalPlatform.Admin.Web.UI.Location.LocationInformation();
	location.LocationTypeId = locationType;
	location.LocationId = locationId;
	location.LocationName = locationName;
	location.Excluded = excluded;

	return location;
};