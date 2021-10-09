VP.Pages.Designer.PaneDesignTimeElement = function() {
	VP.Pages.Designer.ContainerDesignTimeElement.apply(this);
	this._type = 'Pane';
	this._subType = '';
};

VP.Pages.Designer.PaneDesignTimeElement.prototype = Object.create(VP.Pages.Designer.ContainerDesignTimeElement.prototype);

VP.Pages.Designer.PaneDesignTimeElement.prototype.CreateUI = function() {
	var paneHtml = "<div class=\"controlContainer\"></div>";
	return paneHtml;
};

VP.Pages.Designer.PaneDesignTimeElement.prototype.CreateEditMenu = function() {
	return "";
};

VP.Pages.Designer.PaneDesignTimeElement.prototype.Create = function(parent, element, controlId) {
	VP.Pages.Designer.ContainerDesignTimeElement.prototype.Create.apply(this, arguments);

	$(this._element).addClass(this._subType);
	$(this._element).prepend("<h3>" + this._subType + "</h3>");
};

VP.Pages.Designer.PaneDesignTimeElement.prototype.Load = function(data, parent, element) {
	this._subType = data;
	this.Create(parent, element, this._controlId);
};

VP.Pages.Designer.PaneDesignTimeElement.prototype.GetData = function() {
	var index = 0;
	var modules = [];
	for (var i in this._children) {
		if (this._children[i]) {
			modules[index] = this._children[i].GetData();
			index++;
		}
	}

	return modules;
};