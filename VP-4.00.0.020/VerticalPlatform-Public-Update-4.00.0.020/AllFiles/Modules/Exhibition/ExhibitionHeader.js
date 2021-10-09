RegisterNamespace("VP.ExhibitionHeader");
VP.ExhibitionHeader.VendorPage = false;
VP.ExhibitionHeader.VendorName = '';
VP.ExhibitionHeader.ExhibitionId = 0;
VP.ExhibitionHeader.BoothId = '';
VP.ExhibitionHeader.WebAnalyticsSupportOn = false;

VP.ExhibitionHeader.Initialize = function() {
	$(document).ready(function () {
		if (VP.ExhibitionHeader.VendorPage) {
			var contentPane = $(".contentPane");
			$("a", contentPane).click(function () {
				if ($(this).parents(".companySpecial").length == 0) {
					VP.ExhibitionHeader.VendorPageClick($(this));
				}
			});
		}
	});
};

VP.ExhibitionHeader.VendorPageClick = function($a) {
	if (VP.ExhibitionHeader.WebAnalyticsSupportOn) {
		var script = VP.ExhibitionHeader.VendorPageClickScript();
		script = script.replace(/<url>/gi, $a.attr('href'));
		script = script.replace(/<ExhibitionId>/gi, VP.ExhibitionHeader.ExhibitionId);
		script = script.replace(/<Vendor>/gi, VP.ExhibitionHeader.VendorName);
		//eval('alert(\'' + script + '\')');
		eval(script);
	}
};

VP.ExhibitionHeader.VendorPageClickScript = function() {
	var script = 's.eVar18="<Url>";' +
		's.linkTrackVars="eVar16,eVar6,eVar19,eVar18,events";' +
		's.linkTrackEvents="event34";' +
		's.events="event34";' +
		's.tl(true, "o", "' + s.pageName +  ':exhibitHallLinkClick");';
		
	return script;
};

VP.ExhibitionHeader.Initialize();