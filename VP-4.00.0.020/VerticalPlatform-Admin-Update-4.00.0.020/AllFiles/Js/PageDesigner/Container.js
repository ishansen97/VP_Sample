VP.Pages.Designer.ContainerDesignTimeElement = function() {
	VP.Pages.Designer.DesignTimeElement.apply(this);
	this._controlCount = 0;
	this._idCount = 0;
	this._containerElement = null;
	this._droppable = true;
	this._tempDeletedModules = [];
};

VP.Pages.Designer.ContainerDesignTimeElement.prototype = Object.create(VP.Pages.Designer.DesignTimeElement.prototype);

VP.Pages.Designer.ContainerDesignTimeElement.prototype.Create = function(parent, element, controlId) {
	VP.Forms.Designer.DesignTimeElement.prototype.Create.apply(this, arguments);
	this._containerElement = $(this._element).find(".controlContainer");
	var that = this;
	if (this._droppable) {
		$(this._element).find(".controlContainer").droppable({
			activeClass: 'droppable-active',
			hoverClass: 'droppable-hover',
			greedy: true,
			drop: function(ev, ui) {
				var itemName = $(ui.draggable).attr('id').trim();
				var itemText = $(ui.draggable).text().trim();
				var designer = null;
				var canvas = VP.Pages.Designer.CanvasInstance;
				var moduleIdNamePair = jQuery.grep(canvas._moduleList, function(IdNamePair) { return IdNamePair.Name == itemName; });
				if (moduleIdNamePair) {
					var elementId = that._controlId + "_ctl" + that._idCount;

					if ($(ui.draggable).parent().hasClass('container')) {
						designer = new VP.Pages.Designer.ContainerModuleDesignTimeElement(moduleIdNamePair[0].Id, itemText + ' Container', itemName);
						designer.Create(that, $(this), elementId);
						designer.ShowPropertyDialog();
					}
					else if ($(ui.draggable).parent().hasClass('module')) {
						designer = new VP.Pages.Designer.ModuleDesignTimeElement(moduleIdNamePair[0].Id, itemText, itemName);
						designer.Create(that, $(this), elementId);
						designer.ShowPropertyDialog();
					}

					that._children[designer.GetControlId()] = designer;
					that._controlCount++;
					that._idCount++;
					that.ControlAdded(designer);
				}
			}
		});
	}
};

VP.Pages.Designer.ContainerDesignTimeElement.prototype.GetControl = function(controlId) {
	for (var i in this._children) {
		if (this._children[i]._controlId === controlId) {
			return this._children[i];
		}
	}

	for (var j in this._children) {
		if (this._children[j]._controlCount > 0) {
			return this._children[j].GetControl(controlId);
		}
	}
};

VP.Pages.Designer.ContainerDesignTimeElement.prototype.DeleteChild = function(controlId) {
	for (var i in this._children) {
		if (this._children[i]._controlId === controlId) {
			var control = this._children[i];
			control.Destroy();
			this.SetDeletedModuleInstances(control);
			delete this._children[i];
			this._controlCount--;
			this.ControlDeleted();
			break;
		}
	}

	for (var index = this._tempDeletedModules.length; index > 0; index--) {
		VP.Pages.Designer.CanvasInstance._deletedModuleInstances.push(this._tempDeletedModules[index - 1]);
	}

	this._tempDeletedModules = [];
};

VP.Pages.Designer.ContainerDesignTimeElement.prototype.SetDeletedModuleInstances = function(control) {
	if (control._moduleInstanceId > 0) {
		this._tempDeletedModules.push(control._moduleInstanceId);
	}

	for (var i in control._children) {
		if (control._children[i]._moduleInstanceId !== null) {
			this.SetDeletedModuleInstances(control._children[i]);
		}
	}
};

VP.Pages.Designer.ContainerDesignTimeElement.prototype.ControlAdded = function(designer) {
};

VP.Pages.Designer.ContainerDesignTimeElement.prototype.ControlDeleted = function() {
};

VP.Pages.Designer.ContainerDesignTimeElement.prototype.MoveUp = function(controlId) {
	var prev = null;
	var prevId = "";
	for (var i in this._children) {
		if (this._children[i]._controlId === controlId) {
			if (prev !== null) {
				$("#" + this._children[i]._controlId + "_designer").after(
						$("#" + this._children[prevId]._controlId + "_designer"));

				this._children[prevId] = this._children[i];
				this._children[i] = prev;
			}
			break;
		}
		else {
			prev = this._children[i];
			prevId = i;
		}
	}
};

VP.Pages.Designer.ContainerDesignTimeElement.prototype.MoveDown = function(controlId) {
	var prev = null;
	var prevId = "";
	var isPrevFound = false;
	for (var i in this._children) {
		if (this._children[i]._controlId === controlId) {
			prev = this._children[i];
			prevId = i;
			isPrevFound = true;
		}
		else {
			if (isPrevFound) {
				if (prev !== null) {
					$("#" + this._children[i]._controlId + "_designer").after(
							$("#" + this._children[prevId]._controlId + "_designer"));

					this._children[prevId] = this._children[i];
					this._children[i] = prev;
				}
				break;
			}
		}
	}
};

