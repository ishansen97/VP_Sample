VP.Pages.Designer.TemplateDesignTimeElement = function() {
    VP.Pages.Designer.ContainerDesignTimeElement.apply(this);
    this._templateType = 2;
    this._type = 'Template';
    this._panes = {};
    this._templates = { 1: { 'name': 'singleColumnLayout', 'panes': ['pageHeader', 'contentPane', 'footer'] },
        2: { 'name': 'twoColumnLayout', 'panes': ['pageHeader', 'contentPane', 'leftSidebar', 'footer'] },
        3: { 'name': 'twoColumnFiveRowLayout', 'panes': ['pageHeader', 'contentPaneHeader', 'contentPane', 'leftSidebar', 'contentPaneFooter', 'footer'] },
        4: { 'name': 'singleColumnFiveRowLayout', 'panes': ['pageHeader', 'contentPaneHeader', 'contentPane', 'contentPaneFooter', 'footer'] }
    };
};

VP.Pages.Designer.TemplateDesignTimeElement.prototype = Object.create(VP.Pages.Designer.ContainerDesignTimeElement.prototype);

VP.Pages.Designer.TemplateDesignTimeElement.prototype.Create = function(parent, element, controlId) {
	this._droppable = false;
	VP.Pages.Designer.ContainerDesignTimeElement.prototype.Create.apply(this, arguments);
};

VP.Pages.Designer.TemplateDesignTimeElement.prototype.CreateUI = function() {
	var templateHtml = "<div class=\"controlContainer " + this._templates[this._templateType].name + "\"></div>";
	return templateHtml;
};

VP.Pages.Designer.TemplateDesignTimeElement.prototype.CreateEditMenu = function() {
	return "";
};

VP.Pages.Designer.TemplateDesignTimeElement.prototype.Load = function(data, parent, element) {
    this.Create(parent, element, "t");
    var template = this._templates[this._templateType];
    for (var i = 0; i < template.panes.length; i++) {
        var designElement = new VP.Pages.Designer.PaneDesignTimeElement();
        designElement._edit = true;
        designElement._controlId = this.GetControlId() + "_" + this._idCount;
        designElement.Load(template.panes[i], this, this._containerElement);

        this._children[designElement.GetControlId()] = designElement;
        this._controlCount++;
        this._idCount++;

        this._panes[template.panes[i]] = designElement;
    }

    if (data) {
        this.LoadChildren(data, null, 1);
    }
};

VP.Pages.Designer.TemplateDesignTimeElement.prototype.LoadChildren = function(modules, parent, level) {
	for (var index = 0; index < modules.length; index++) {

		if (level === 1) {
			parent = this._panes[modules[index].Pane];
		}

		if (parent != null) {

			var designElement = this.GetDesignTimeElement(modules[index]);
			designElement._edit = true;
			designElement._controlId = parent.GetControlId() + "_" + parent._idCount;
			designElement.Load(modules[index], parent, parent._containerElement);

			parent._children[designElement.GetControlId()] = designElement;
			parent._controlCount++;
			parent._idCount++;

			if (modules[index].Children.length > 0) {
				this.LoadChildren(modules[index].Children, designElement, level + 1);
			}
		}
	}
};

VP.Pages.Designer.TemplateDesignTimeElement.prototype.GetDesignTimeElement = function(module) {
	if (module.IsContainer) {
		return new VP.Pages.Designer.ContainerModuleDesignTimeElement();
	}
	else {
		return new VP.Pages.Designer.ModuleDesignTimeElement();
	}
};

VP.Pages.Designer.TemplateDesignTimeElement.prototype.SetTemplateType = function(type) {
	this._templateType = type;
};

VP.Pages.Designer.TemplateDesignTimeElement.prototype.GetData = function() {
	var index = 0;
	var modules = [];
	for (var i in this._children) {
		if (this._children[i]) {
			var children = this._children[i].GetData();
			for (var j = 0; j < children.length; j++) {
				modules[index] = children[j];
				index++;
			}
		}
	}

	return modules;
};