RegisterNamespace("VP.Citations");

$(document).ready(function () {
	setTimeout(function () {
		VP.Citations.TransferToCitationsTab();
	}, 1);
});

VP.Citations.GetQueryStringParameter = function (paremeterKey) {
	paremeterKey = paremeterKey.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
	var regex = new RegExp("[\\?&]" + paremeterKey + "=([^&#]*)");
	var results = regex.exec(location.search);
	return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
};

VP.Citations.GetCitationsTabIndex = function () {
	var tabIndex;
	var headerUl = $(".productDetailTabContainer .tab").find('ul');
	if (headerUl != undefined) {
		headerUl.find('li').each(function () {
			if ($(this).text().toLowerCase().match("citations")) {
				tabIndex = headerUl.find('li').index($(this));
			}
		});
	}

	if (tabIndex == undefined || tabIndex < 0) {
		tabIndex = 0;
	}

	return tabIndex;
};

VP.Citations.TransferToCitationsTab = function () {
	var transferTab = VP.Citations.GetQueryStringParameter('transferto');
	if (transferTab != "" && transferTab == "citations") {
		var tabId = $("#hiddenCitationsTabId").val();
		var tabIndex = VP.Citations.GetCitationsTabIndex();
        //trying tab container
		if(window["tab" + tabId]) {
            var tabInstance = eval("tab" + tabId);
            tabInstance.SelectTab($(".productDetailTabContainer .tab"), tabIndex);
		}
		else {
            var citationContainer = $(".citations").closest(".container").attr("id");
            //try anchorlink container
            if (VP.AnchorLinkContainer) {
                var anchorLinkContainer = "#"+$(".citations").closest(".anchor-link-section").attr("id");
                VP.AnchorLinkContainer.prototype.Navigate(anchorLinkContainer);
            } else {
                var tp = $("#" + citationContainer).offset().top;
                $('html, body').animate({
                    scrollTop: tp
                }, 1000);
            }
        }
	}
};