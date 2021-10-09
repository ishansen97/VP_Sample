// --------- FormDesignTimeElement ---------------------//

VP.Forms.Designer.FormDesignTimeElement = function() {
	VP.Forms.Designer.ContainerDesignTimeElement.apply(this);
	this.Id = 0;
}

VP.Forms.Designer.FormDesignTimeElement.prototype = Object.create(VP.Forms.Designer.ContainerDesignTimeElement.prototype);

VP.Forms.Designer.FormDesignTimeElement.prototype.CreateUI = function() {
	var html = "<div class=\"controlContainer\"></div>";
	return html;
}

VP.Forms.Designer.FormDesignTimeElement.prototype.CreateEditMenu = function() {
	var newPageId = this._controlId + "_new";
	var html = "<a class=\"newPageIcon\" id=\"" + newPageId + "\" title=\"Add new page\">&nbsp;</a>"
	return html;
}

VP.Forms.Designer.FormDesignTimeElement.prototype.Create = function(parent, element, controlId) {
	this._droppable = false;
	VP.Forms.Designer.ContainerDesignTimeElement.prototype.Create.apply(this, arguments);

	var that = this;
	$("#" + this._controlId + "_new").click(function() {
		that.AddNewPage();
	});
}

VP.Forms.Designer.FormDesignTimeElement.prototype.AddNewPage = function() {
	var page = new VP.Forms.Designer.PageDesignTimeElement();
	page._controlId = "p_" + this._idCount;
	page.Load(null, this, this._containerElement);

	this._children[page.GetControlId()] = page;
	this._controlCount++;
	this._idCount++;

	this.ShowPage(page._controlId);
}

VP.Forms.Designer.FormDesignTimeElement.prototype.FindControl = function(controlId) {
	var control = this.FindControlRecursively(controlId, this);
	return control;
}

VP.Forms.Designer.FormDesignTimeElement.prototype.FindControlRecursively = function(controlId, control) {
	var ctrl = null;
	for (var i in control._children) {
		if (control._children[i]._controlId == controlId) {
			return control._children[i];
		}
		else {
			if (control._children != null) {
				if (control._children[i]._controlCount > 0) {
					ctrl = this.FindControlRecursively(controlId, control._children[i]);
					if (ctrl != null) {
						return ctrl;
					}
				}
			}
		}
	}
	return null;
}

VP.Forms.Designer.FormDesignTimeElement.prototype.ShowPage = function(pageId) {
	var index = 1;
	var currentPageNumber = index;
	var controlId = "";
	for (var i in this._children) {
		if (index == 1) {
			if (pageId == null) {
				pageId = this._children[i]._controlId;
			}
			else if (pageId == "") {
				pageId = this._children[i]._controlId;
			}
		}

		if (this._children[i]._controlId != pageId) {
			$(this._children[i]._element).hide();
		}
		else {
			$(this._children[i]._element).show();
			currentPageNumber = index;
			controlId = this._children[i]._controlId;
		}

		index++;
	}

	index = index - 1;
	$("#" + controlId + "_pageNumber").text("Page " + currentPageNumber + " of " + index);

	$(window).scrollTop(0);
}

VP.Forms.Designer.FormDesignTimeElement.prototype.GetData = function() {
	var form = new VerticalPlatform.UI.Forms.Core.Form();
	form.Children = new Array();
	var index = 0;
	for (var i in this._children) {
		form.Children[index] = this._children[i].GetData();
		index++;
	}

	return form;
}

VP.Forms.Designer.FormDesignTimeElement.prototype.Load = function(data, parent, element) {
	this.LoadProperties(data);
	this.Create(null, element, "form");
}


VP.Forms.Designer.FormDesignTimeElement.prototype.LoadProperties = function(data) {
	this.Id = data.Id;
}