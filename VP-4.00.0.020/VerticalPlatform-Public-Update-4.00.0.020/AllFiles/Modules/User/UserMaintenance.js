RegisterNamespace("VP.UserMaintenance");

VP.UserMaintenance = function(moduleId, element, tabContainerInstanceId) {
	this._tabContainerInstanceId = tabContainerInstanceId;
	this._element = $("#" + element);
	this._tabContainerCssClass = "userMaintenanceTabContainer";
	this._moduleId = moduleId;
	this._deleteSubscriptionModule = "deleteSubscriptionModule";
	this._userProfileModule = "userProfile";
	this._userSubscriptionModule = "userSubscriptionModule";
	var that = this;

	this.HideUnavailableNavigationLinks();

	$("a[id$='lnkDeleteSubscriptions']", this._element).click(function() {
		that.SelectTab(that._deleteSubscriptionModule);
	});

	$("a[id$='lnkEditSubscriptions']", this._element).click(function() {
		that.SelectTab(that._userSubscriptionModule);
	});

	$("a[id$='lnkEditUserInformation']", this._element).click(function() {
		that.SelectTab(that._userProfileModule);
	});
};

VP.UserMaintenance.prototype.HideUnavailableNavigationLink = function(divModuleClass, link) {
	var tabInstance = eval("tab" + this._tabContainerInstanceId);
	if ($('div.' + divModuleClass, '#' + tabInstance._tabElementId).length == 0) {
		link.parent('li').remove();
	}
};

VP.UserMaintenance.prototype.HideUnavailableNavigationLinks = function() {
	this.HideUnavailableNavigationLink(this._deleteSubscriptionModule, $("a[id$='lnkDeleteSubscriptions']", this._element));
	this.HideUnavailableNavigationLink(this._userProfileModule, $("a[id$='lnkEditUserInformation']", this._element));
	this.HideUnavailableNavigationLink(this._userSubscriptionModule, $("a[id$='lnkEditSubscriptions']", this._element));
};

VP.UserMaintenance.prototype.SelectTab = function(divClass) {
	var tabInstance = eval("tab" + this._tabContainerInstanceId);
	var tabHref;
	if($('div.ui-tabs-panel div.' + divClass,tabInstance._element).parent('div.ui-tabs-panel').length > 0) {
		tabHref = "#" + $('div.ui-tabs-panel div.' + divClass,
				tabInstance._element).parent('div.ui-tabs-panel').attr('id');
		var tabIndex = this.GetTabIndex(tabHref);
		if (tabIndex > 0) {
			tabInstance.SelectTab($("." + this._tabContainerCssClass + " .tab"), tabIndex);
		}
	}
};

VP.UserMaintenance.prototype.GetTabIndex = function(tabHref) {
	var tabIndex = 0;

	var selectedIndex = $('.' + this._tabContainerCssClass + ' .tab ul:first').find('li a[href="' + tabHref +
			'"]').parent('li').index();
	if (selectedIndex > -1) {
		tabIndex = selectedIndex;
	}
	return tabIndex;
};