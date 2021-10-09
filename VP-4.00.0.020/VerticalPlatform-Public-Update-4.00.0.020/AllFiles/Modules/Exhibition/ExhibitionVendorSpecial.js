RegisterNamespace("VP.ExhibitionVendorSpecial");
VP.ExhibitionVendorSpecial.CookieName = "mySpecials";

VP.ExhibitionVendorSpecial.AddToMyShowSpecials = function(exhibitionVendorSpecialId, element) {
	var specialsIds = VP.ExhibitionVendorSpecial.GetCookie(VP.ExhibitionVendorSpecial.CookieName);
	if (specialsIds != "") {
		if (!VP.ExhibitionVendorSpecial.IsAlreadyAdded(specialsIds, exhibitionVendorSpecialId)) {
			VP.ExhibitionVendorSpecial.SetCookie(VP.ExhibitionVendorSpecial.CookieName,
					specialsIds + '|' + exhibitionVendorSpecialId);
		}
	}
	else {
		VP.ExhibitionVendorSpecial.SetCookie(VP.ExhibitionVendorSpecial.CookieName,
				exhibitionVendorSpecialId);
	}
	
	if (!$(element).attr("disabled")) {
		VP.ExhibitionVendorSpecial.ShowSpecialClick(exhibitionVendorSpecialId);
	}

	$(element).attr("disabled", "disabled");
	if (typeof (VP.ExhibitionShowSpecials) != 'undefined') {
		VP.ExhibitionShowSpecials.UpdateSpecialCountLabel();
	}
	return false;
};

VP.ExhibitionVendorSpecial.GetCookie = function(cookieName) {
	if (document.cookie.length > 0) {
		var cookieStart = document.cookie.indexOf(cookieName + "=");
		if (cookieStart != -1) {
			cookieStart = cookieStart + cookieName.length + 1;
			var cookieEnd = document.cookie.indexOf(";", cookieStart);
			if (cookieEnd == -1) {
				cookieEnd = document.cookie.length;
			}
			return unescape(document.cookie.substring(cookieStart, cookieEnd));
		}
	}
	
	return "";
};

VP.ExhibitionVendorSpecial.SetCookie = function(cookieName, value) {
	document.cookie = cookieName + '=' + value + '; path=/';
};

VP.ExhibitionVendorSpecial.IsAlreadyAdded = function(specialsIds, exhibitionVendorSpecialId) {
	var specialIdList = specialsIds.split('|');
	for (var i = 0; i < specialIdList.length; i++) {
		if (specialIdList[i] == exhibitionVendorSpecialId) {
			return true;
		}
	}

	return false;
};

VP.ExhibitionVendorSpecial.ShowSpecialClick = function(specialId) {
	if (VP.ExhibitionHeader != null) {
		if (VP.ExhibitionHeader.WebAnalyticsSupportOn) {
			var script = VP.ExhibitionVendorSpecial.ShowSpecialClickScript();
			script = script.replace(/<BoothId>/gi, VP.ExhibitionHeader.BoothId);
			script = script.replace(/<ExhibitionId>/gi, VP.ExhibitionHeader.ExhibitionId);
			script = script.replace(/<Vendor>/gi, VP.ExhibitionHeader.VendorName);
			script = script.replace(/<VendorSpecialId>/gi, specialId);
			//eval('alert(\'' + script + '\')');
			eval(script);
		}
	}
};

VP.ExhibitionVendorSpecial.ShowSpecialClickScript = function() {
	var script = 's.eVar17="<BoothId>";' +
		's.linkTrackVars="eVar16,eVar6,eVar19,eVar17,events";' +
		's.linkTrackEvents="event31";' +
		's.events="event31";' +
		's.tl(true, "o", "' + s.pageName + ':exhibitHallAddToCart");';
		
	return script;
};
