RegisterNamespace("VP.CampaignArchiveList");

VP.CampaignArchiveList = function(moduleId, element, datePickerFormat) {
	this._moduleId = moduleId;
	this._element = $("#" + element);
	this._dateFormat = datePickerFormat;
	this._error = '';
	var that = this;
	
	$(".btnCampaignArchiveListFilter", this._element).click(function() {
		that.ApplyFilter();
	});

	$(".btnCampaignArchiveListReset", this._element).click(function() {
		that.ResetFilter();
	});
};

VP.CampaignArchiveList.prototype.ApplyFilter = function() {
	if (this.Validate()) {
		var campaignType = $("select.campaignType ", this._element).val();

		var selectedMonth = $("select.dropdownMonth ", this._element).val();
		var selectedYear = $("select.dropdownYear ", this._element).val();
		var campaignName = $("input.campaignName ", this._element).val();

		document.location =
				this.GetFilterUrl(document.location, campaignType, false, selectedMonth, selectedYear, campaignName);
	}
	else {
		$('#campaignArchiveListError', this._element).empty().append(this._error);
	}
};

VP.CampaignArchiveList.prototype.ResetFilter = function() {
	document.location =
				this.GetFilterUrl(document.location, "", true, "", "", "");
};

VP.CampaignArchiveList.prototype.Validate = function() {
	var isValidated = false;
	var campaignType = $("select.campaignType ", this._element).val();


	var selectedMonth = $("select.dropdownMonth ", this._element).val();
	var selectedYear = $("select.dropdownYear ", this._element).val();

	try {
		if (selectedMonth != '' || campaignType != '') {
			
			isValidated = true;
		}
	}
	catch (e) {
		isValidated = false;
		this._error = "Invalid date format.";
	}

	return isValidated;
};

VP.CampaignArchiveList.prototype.GetFilterUrl = function(url, campaignType, isReset, selectedMonth, selectedYear, campaignName) {
	var moduleFilterParameter = 'calf_' + this._moduleId;
	var urlWithoutScrolling = url.href.split('#');
	var actualUrl = urlWithoutScrolling[0].split(moduleFilterParameter + '=');
	var filterString = this.GetFilterString(campaignType, selectedMonth, selectedYear, campaignName);
	var urlBackPart;
	var currentUrlBack = '';
	if (actualUrl.length > 1) {
		urlBackPart = actualUrl[1].split('&');
		if (urlBackPart.length > 1) {
			var index = 0;
			for (index in urlBackPart) {
				if (index > 0) {
					currentUrlBack += '&' + urlBackPart[index];
				}
			}
		}
	}

	if (!isReset) {
		var temp = actualUrl[0].split('?');
		if (temp.length == 1) {
			actualUrl[0] = actualUrl[0] + '?';
		}
		else {
			if (temp[1].substr(-1) != "&") {
				actualUrl[0] = actualUrl[0] + '&';
			}
		}
	}

	var currentUrl;
	if (isReset) {
		currentUrl = actualUrl[0] + currentUrlBack + "#cal_" + this._moduleId;
	}
	else {
		currentUrl = actualUrl[0] + moduleFilterParameter + '=' + filterString +
				currentUrlBack + "#cal_" + this._moduleId;
	}

	return currentUrl;
};

VP.CampaignArchiveList.prototype.GetFilterString = function(campaignType, selectedMonth, selectedYear, campaignName) {
	return campaignType + '|' + selectedMonth + '|' + selectedYear + '|' + campaignName;
};