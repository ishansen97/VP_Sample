RegisterNamespace("VP.TabContainer");

var tabContainers = [];

VP.TabContainer = function(moduleInstanceId, tabElementId, persistState) {
	this._moduleInstanceId = moduleInstanceId;
	this._tabElementId = tabElementId;
	this._element = null;
	this._persistState = persistState;
};

VP.TabContainer.prototype.Initialize = function() {
	var that = this;
	var firstLoad = true;
	$(document).ready(function() {
		that._element = $("#" + that._tabElementId);
		var selectedIndex = 0;

		var isContainHashTabName = true;
		if (this.location.hash == '') {
			isContainHashTabName = false;
		}

		var initialTab = VP.TabContainer.GetQueryStringParameters();
		var focusToTab = initialTab.includes("srptab");
		if (focusToTab) {
			isContainHashTabName = true;
			var contentTypeName = initialTab["srptab"].toLowerCase().split("#");
			var contentTypeToTab = {
				"product": "products",
				"category": "categories",
				"article": "articles"
			};
			this.location.hash = contentTypeToTab[contentTypeName[0]];
		}

		if (!isContainHashTabName)
		{
			var cookieName = "tab" + that._moduleInstanceId;
			var cookieValue = $.Cookie(cookieName);
			if (cookieValue) {
				selectedIndex = parseInt(cookieValue, 10);
			}
			if (!that._persistState) {
				$.Cookie(cookieName, null);
			}
		}
		else {
			var contentTypeToTab = this.location.hash.substring(1).replace(/\s/g, '');

			$('.tab > ul > li').each(function (index, value) {
				var text = value.textContent;
				text = text.split('(')[0].replace(/\s/g, '').toLowerCase();
				if (contentTypeToTab == text) {
					selectedIndex = index;

					if (that._persistState) {
						cookieName = "tab" + that._moduleInstanceId;
						$.Cookie(cookieName, selectedIndex);
					}

					return false;
				}
			});
		}

		that._element.tabs({
            active: selectedIndex,
            activate: function (event, ui) {
				var tabName = ui.newTab.text();
				tabName = tabName.split('(')[0].replace(/\s/g, '').toLowerCase();

				if (!firstLoad) {
					window.location.hash = tabName;
				}

				if (that._persistState) {
					$.Cookie(cookieName, $(this).tabs("option", "active"));
				}
			}
		});

		if (that._persistState) {
			tabContainers.push(cookieName);
		} else {
			$(".pages.module li").bind("click", function () {
				$.Cookie(cookieName, $(".content.tab").tabs("option", "active"));
			});
		}
		
		firstLoad = false;
	});
};

VP.TabContainer.prototype.SelectTab = function(element, selectedIndex) {
	element.tabs({
		active: selectedIndex
	});
};

$(document).ready(function() {
	setTimeout(function () { VP.TabContainer.CleanCookies(); }, 2000);
});

VP.TabContainer.CleanCookies = function() {
	if (tabContainers) {
		var cookies = $.Cookie.Match("tab");
		if (cookies) {
			var name;
			for (name in cookies) {
				if ($.inArray(name, tabContainers) < 0) {
					$.Cookie(name, null);
				}
			}
		}
	}
};

VP.TabContainer.GetQueryStringParameters = function () {
	var vars = [], hash;
	var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
	for (var i = 0; i < hashes.length; i++) {
		hash = hashes[i].split('=');
		vars.push(hash[0]);
		vars[hash[0]] = hash[1];
	}
	return vars;
};
