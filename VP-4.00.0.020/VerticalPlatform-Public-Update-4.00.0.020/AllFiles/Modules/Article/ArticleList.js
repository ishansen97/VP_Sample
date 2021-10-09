RegisterNamespace("VP.ArticleList");

VP.ArticleList = function (moduleId, element, category, vendor, custom) {
	this._moduleId = moduleId;
	this._element = "#" + element;
	var that = this;

	$("#btnFilter", this._element).click(function () {
		document.location =
				that.GetFilterUrl(document.location, $(".vendors select", that._element).val(),
				 $(".categories select", that._element).val(), false);
	});
	$("#btnReset", this._element).click(function () {
		document.location = that.GetFilterUrl(document.location, "-1", "-1", true);
	});
	$("#filterHeader", this._element).click(function () {
		if ($("#filterHeader.hidden", that._element).length > 0) {
			$("#filterHeader", that._element).removeClass("hidden");
			$("#filterBody", that._element).show("slow");
			$("#filterHeader", that._element).text("Hide Filter");
		}
		else {
			$("#filterHeader", that._element).addClass("hidden");
			$("#filterBody", that._element).hide("slow");
			$("#filterHeader", that._element).text("Show Filter");
		}
	});

	var filterBody = $("#filterBody", this._element);
	var categoryFilter = $(".categories", filterBody);
	var vendorFilter = $(".vendors", filterBody);
	var customFilter = $(".custom", filterBody);

	if (!category && !vendor && !custom) {
		$(".filter", this._element).hide();
	}
};

VP.ArticleList.prototype.GetFilterUrl = function (Url, vendorId, categoryId, reset) {
	var urlParts = Url.href.split("?");
	var urlWithoutQueryStrings = urlParts[0] + "?";
	var hasFilter = false;
	var index = 0;
	var pagerParameterIndex = -1;

	var queryStringArray = [];
	if (urlParts.length == 2) {
		var urlQueryStrings = urlParts[1].split("#")[0];
		queryStringArray = urlQueryStrings.split("&");
		for (index = 0; index < queryStringArray.length; index++) {
			if (queryStringArray[index].indexOf("afcid_" + this._moduleId) >= 0) {
				if (reset) {
					queryStringArray.splice(index, 1);
					index--;
					pagerParameterIndex--;
				}
				else {
					queryStringArray[index] = "afcid_" + this._moduleId + "=" + categoryId;
				}

				hasFilter = true;
			}
			else if (queryStringArray[index].indexOf("afvid_" + this._moduleId) >= 0) {
				if (reset) {
					queryStringArray.splice(index, 1);
					index--;
					pagerParameterIndex--;
				}
				else {
					queryStringArray[index] = "afvid_" + this._moduleId + "=" + vendorId;
				}

				hasFilter = true;
			}
			else if (queryStringArray[index].indexOf("alpi_" + this._moduleId) >= 0) {
				if (reset) {
					pagerParameterIndex = index;
				}
				else {
					queryStringArray[index] = "alpi_" + this._moduleId + "=" + 1;
				}
			}
		}
	}

	if (!hasFilter && !reset) {
		if (vendorId != undefined) {
			queryStringArray.push("afvid_" + this._moduleId + "=" + vendorId);
		}

		if (categoryId != undefined) {
			queryStringArray.push("afcid_" + this._moduleId + "=" + categoryId);
		}
	}

	pagerParameterIndex = this.SetCustomPropertyFilter(reset, queryStringArray, pagerParameterIndex);

	if (reset && pagerParameterIndex >= 0) {
		queryStringArray.splice(pagerParameterIndex, 1);
	}

	var queryString = "";
	index = 0;
	for (index in queryStringArray) {
		if (!queryString) {
			queryString = queryStringArray[index];
		}
		else {
			queryString += "&" + queryStringArray[index];
		}
	}

	var currentUrl = urlWithoutQueryStrings + queryString;
	currentUrl = currentUrl + "#al" + this._moduleId;
	return currentUrl;
};

VP.ArticleList.prototype.SetCustomPropertyFilter = function(reset, queryStringArray, pagerParameterIndex) {
	var customProperties = [];
	var customPropertyDropdownClass = ".ddlCustomProperty_" + this._moduleId;
	var customPropertyDropdown = $(customPropertyDropdownClass, this._element);
	var index = 0;
	for (index = 0; index < customPropertyDropdown.length; index++) {
		var dropdownId = customPropertyDropdown[index].id;
		var selectedVal;

		if (reset === false) {
			selectedVal = $("#" + dropdownId, this._element).val();
		}
		else {
			selectedVal = "-1";
		}

		var queryStringParam = dropdownId.split("CustomProperty");
		customProperties["cpf" + queryStringParam[1]] = encodeURIComponent(selectedVal);
	}

	var cpIndex = 0;
	for (cpIndex in customProperties) {
		var hasFilter = false;
		for (index = 0; index < queryStringArray.length; index++) {
			if (queryStringArray[index].indexOf(cpIndex) >= 0) {
				if (reset) {
					queryStringArray.splice(index, 1);
					index--;
					pagerParameterIndex--;
				}
				else {
					queryStringArray[index] = cpIndex + "=" + customProperties[cpIndex];
				}

				hasFilter = true;
			}
		}

		if (!hasFilter && !reset) {
			queryStringArray.push(cpIndex + "=" + customProperties[cpIndex]);
		}
	}

	return pagerParameterIndex;
};

VP.ArticleList.RenderRatingControl = function(ratingControl){
	ratingControl.raty({
		readOnly: true,
		starOff: '/Images/star-off.png',
		starOn: '/Images/star-on.png',
		starHalf: '/Images/star-half.png',
		halfShow: true,
		hints: ['Ratings', 'Ratings', 'Ratings', 'Ratings', 'Ratings'],
		//width: 150,
		noRatedMsg: 'Ratings',
		score: function () {
			return $(this).attr('ratingScore');
		}
	});
};

$(document).ready(function () {
	
	if (typeof VP.ratyInitialized === 'undefined' || !VP.ratyInitialized) {		
		VP.ratyInitialized = true;
		VP.ArticleList.RenderRatingControl($('.ratingControl'));
	}
	
});
