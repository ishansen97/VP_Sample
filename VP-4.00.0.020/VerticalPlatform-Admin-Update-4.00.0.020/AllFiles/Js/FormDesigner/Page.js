
VP.Forms.Designer.PageDesignTimeElement = function() {
	VP.Forms.Designer.ContainerDesignTimeElement.apply(this);
	this.FieldType = 13;
	this.Title = "Page";
	this.PageTitle = "";
	this.ErrorMessage = "";
}

VP.Forms.Designer.PageDesignTimeElement.prototype = Object.create(VP.Forms.Designer.ContainerDesignTimeElement.prototype);

VP.Forms.Designer.PageDesignTimeElement.prototype.CreateUI = function() {
	return "<div class=\"controlContainer\"></div>";
}

VP.Forms.Designer.PageDesignTimeElement.prototype.CreateEditMenu = function() {
	var deleteId = this._controlId + "_delete";
	var editId = this._controlId + "_edit";
	var nextId = this._controlId + "_next";
	var prevId = this._controlId + "_prev";
	var leftId = this._controlId + "_left";
	var rightId = this._controlId + "_right";
	var pageNumber = this._controlId + "_pageNumber";
	var html = "<a class=\"deleteIcon\" id=\"" + deleteId + "\" title=\"delete page\" />" +
			"<a class=\"editIcon\" id=\"" + editId + "\" title=\"Edit\"/>" +
			"<a class=\"prevIcon\" id=\"" + prevId + "\" title=\"previous page\" />" +
			"<a class=\"nextIcon\" id=\"" + nextId + "\" title=\"next page\" />" +
			"<a class=\"leftIcon\" id=\"" + leftId + "\" title=\"move page to left\" />" +
			"<a class=\"rightIcon\" id=\"" + rightId + "\" title=\"move page to right\" />" +
			"<span id=\"" + pageNumber + "\"></span>";

	return html;
}

VP.Forms.Designer.PageDesignTimeElement.prototype.Create = function(parent, element, controlId) {
	VP.Forms.Designer.ContainerDesignTimeElement.prototype.Create.apply(this, arguments);

	var that = this;
	$("#" + this._controlId + "_delete").unbind();
	$("#" + this._controlId + "_delete").click(function() {
		that.DeletePage();
	});
	$("#" + this._controlId + "_next").click(function() {
		that.ShowNextPage();
	});
	$("#" + this._controlId + "_prev").click(function() {
		that.ShowPreviousPage();
	});
	$("#" + this._controlId + "_left").click(function() {
		that.MoveLeft();
	});
	$("#" + this._controlId + "_right").click(function() {
		that.MoveRight();
	});
}

VP.Forms.Designer.PageDesignTimeElement.prototype.PreparePropertyDialog = function() {
	VP.Forms.Designer.DesignTimeElement.prototype.PreparePropertyDialog.apply(this);
	$("#custom").empty();
	$("#custom").append("<div class='dialog_header clearfix'><h2>" + this.Title + "</h2></div>" +
	"<div class='content_div'><div class='popupRow'>" +
		"<span class='popupCol1'>Title</span>" +
		"<span class='popupCol2'><input type='text' class='title' /></span>" +
		"</div>" +
		"<div class='popupRow'>" +
		"<span class='popupCol1'>CssClass</span>" +
		"<span class='popupCol2'><input type='text' class='cssClass' /></span>" +
		"</div>" +
		"<div class='popupRow'>" +
		"<span class='popupCol1'>Error Message</span>" +
		"<span class='popupCol2'><textarea></textarea></span>" +
		"</div>" +
		"<div id='errorMsg' style='color:Red'></div></div>");

	$("#custom .title").val(this.PageTitle);
	$("#custom .cssClass").val(this._cssClass);
	$("#custom textarea").val(this.ErrorMessage);
}

VP.Forms.Designer.PageDesignTimeElement.prototype.UpdateProperties = function() {
	this.PageTitle = $("#custom .title").val();
	this._cssClass = $("#custom .cssClass").val();
	this.ErrorMessage = $("#custom textarea").val();

	VP.Forms.Designer.DesignTimeElement.prototype.UpdateProperties.apply(this);
}

VP.Forms.Designer.PageDesignTimeElement.prototype.DeletePage = function() {
	if (this._parent._controlCount > 1) {
		if (confirm("Are you sure you want to delete this page?")) {
			this._parent.DeleteChild(this._controlId);
			this._parent.ShowPage("");
		}
	}
	else {
		alert('Form should have at least one page');
	}
}

VP.Forms.Designer.PageDesignTimeElement.prototype.ShowPreviousPage = function() {
	var prevPage;
	var index = 0;
	var controlId = this._controlId;
	var isShowPage = true;
	for (var i in this._parent._children) {
		if (this._parent._children[i]._controlId == this._controlId) {
			if (index == 0) {
				isShowPage = false;
				break;
			}
			if (prevPage != null) {
				controlId = prevPage._controlId;
				break;
			}
		}
		else {
			prevPage = this._parent._children[i];
		}

		index++;
	}

	if (isShowPage) {
		this._parent.ShowPage(controlId);
	}
}

VP.Forms.Designer.PageDesignTimeElement.prototype.ShowNextPage = function() {
	var isNextPage = false;
	var controlId = this._controlId;
	var isShowPage = false;
	for (var i in this._parent._children) {
		if (this._parent._children[i]._controlId == this._controlId) {
			isNextPage = true;
		}
		else {
			if (isNextPage) {
				controlId = this._parent._children[i]._controlId;
				isShowPage = true;
				break;
			}
		}
	}
	if (isShowPage) {
		this._parent.ShowPage(controlId);
	}
}

VP.Forms.Designer.PageDesignTimeElement.prototype.MoveLeft = function() {
	var prev = null;
	var prevId = "";
	var isShowPage = false;
	for (var i in this._parent._children) {
		if (this._parent._children[i]._controlId == this._controlId) {
			if (prev != null) {
				$("#" + this._parent._children[i]._controlId + "_designer").after($("#"
						+ this._parent._children[prevId]._controlId + "_designer"));
				this._parent._children[prevId] = this._parent._children[i];
				this._parent._children[i] = prev;
				isShowPage = true;
			}
			break;
		}
		else {
			prev = this._parent._children[i];
			prevId = i;
		}
	}

	if (isShowPage) {
		this._parent.ShowPage(this._controlId);
	}
}

VP.Forms.Designer.PageDesignTimeElement.prototype.MoveRight = function() {
	var prev = null;
	var prevId = "";
	var isPrevFound = false;
	var isShowPage = false;
	for (var i in this._parent._children) {
		if (this._parent._children[i]._controlId == this._controlId) {
			prev = this._parent._children[i];
			prevId = i;
			isPrevFound = true;
		}
		else {
			if (isPrevFound) {
				if (prev != null) {
					$("#" + this._parent._children[i]._controlId + "_designer").after($("#"
							+ this._parent._children[prevId]._controlId + "_designer"));
					this._parent._children[prevId] = this._parent._children[i];
					this._parent._children[i] = prev;
					isShowPage = true;
				}
				break;
			}
		}
	}

	if (isShowPage) {
		this._parent.ShowPage(this._controlId);
	}
}

VP.Forms.Designer.PageDesignTimeElement.prototype.GetData = function() {
	var page = new VerticalPlatform.UI.Forms.Core.Page();
	page.FieldType = this.FieldType;
	page.Title = this.PageTitle;
	page.CssClass = this._cssClass;
	page.ErrorMessage = this.ErrorMessage;
	page.Children = new Array();
	var index = 0;
	for (var i in this._children) {
		page.Children[index] = this._children[i].GetData();
		index++;
	}

	return page;
}

VP.Forms.Designer.PageDesignTimeElement.prototype.Load = function(data, parent, element) {
	this.LoadProperties(data);
	this.Create(parent, element, this._controlId);
}

VP.Forms.Designer.PageDesignTimeElement.prototype.LoadProperties = function(data) {
	if (data != null) {
		if (data.CssClass != null) {
			this._cssClass = data.CssClass;
		}
		if (data.Title != null) {
			this.PageTitle = data.Title;
		}
		if (data.ErrorMessage != null) {
			this.ErrorMessage = data.ErrorMessage;
		}
	}
}