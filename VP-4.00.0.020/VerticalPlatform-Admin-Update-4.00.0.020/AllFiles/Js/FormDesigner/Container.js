// ---------- ContainerDesignTimeElement ----------------- //

VP.Forms.Designer.ContainerDesignTimeElement = function() {
	VP.Forms.Designer.DesignTimeElement.apply(this);
	this._controlCount = 0;
	this._idCount = 0;
	this._containerElement = null;
	this._droppable = true;
}

VP.Forms.Designer.ContainerDesignTimeElement.prototype = Object.create(VP.Forms.Designer.DesignTimeElement.prototype);

VP.Forms.Designer.ContainerDesignTimeElement.prototype.Create = function (parent, element, controlId) {
	VP.Forms.Designer.DesignTimeElement.prototype.Create.apply(this, arguments);
	this._containerElement = $(this._element).find(".controlContainer");
	var that = this;
	if (this._droppable) {
		$(this._element).find(".controlContainer").droppable({
			activeClass: 'droppable-active',
			hoverClass: 'droppable-hover',
			greedy: true,
			drop: function (ev, ui) {
				var item = $(ui.draggable).text().trim();
				var designer = null;

				//Some times when draggable is dropped, it does not drop to hovering droppable. But drops to some other container.
				//This should be a bug in jquery droppable plugin. Fixing this issue from our javascript.
				//If a proper drop happened droppable-hover class should not be in any element
				//Check for any droppables with the class droppable-hover inside the canvas and drop the draggable
				//forcefuly
				var container = $(VP.Forms.Designer.CanvasInstance._formDesigner_element).find(".droppable-hover");
				//Some times two containers can be highlited with the hovering style.
				//At this stage should exit removing the droppable-hover class without dropping.
				if (container.length > 1) {
					$(container).removeClass("droppable-hover");
					return;
				}

				var realContainer = $(this);
				var actualParent = that;

				if (container.length > 0) {
					var tempParentContainer = $(container).parents("div.controlDesigner:eq(0)");
					var tempParentContainerId = $(tempParentContainer).attr('id').replace(/_designer/, '');
					var tempParent = VP.Forms.Designer.CanvasInstance._formDesigner.FindControl(tempParentContainerId);
					if (tempParent != null) {
						actualParent = tempParent;
						realContainer = container;
					}
				}
				var ctlId = actualParent._controlId + "_ctl" + actualParent._idCount;
				switch (item) {
					case "DropDownList":
						designer = new VP.Forms.Designer.DropDownListDesignTimeElement();
						designer.Create(actualParent, $(realContainer), ctlId);
						designer.ShowPropertyDialog();
						break;
					case "Panel":
						designer = new VP.Forms.Designer.PanelDesignTimeElement();
						designer.Create(actualParent, $(realContainer), ctlId);
						break;
					case "TextBox":
						designer = new VP.Forms.Designer.TextBoxDesignTimeElement();
						designer.Create(actualParent, $(realContainer), ctlId);
						designer.ShowPropertyDialog();
						break;
					case "CheckBoxList":
						designer = new VP.Forms.Designer.CheckBoxListDesignTimeElement();
						designer.Create(actualParent, $(realContainer), ctlId);
						designer.ShowPropertyDialog();
						break;
					case "Html":
						designer = new VP.Forms.Designer.HtmlDesignTimeElement();
						designer.Create(actualParent, $(realContainer), ctlId);
						designer.ShowPropertyDialog();
						break;
					case "TextArea":
						designer = new VP.Forms.Designer.TextAreaDesignTimeElement();
						designer.Create(actualParent, $(realContainer), ctlId);
						designer.ShowPropertyDialog();
						break;
					case "RadioButtonList":
						designer = new VP.Forms.Designer.RadioButtonListDesignTimeElement();
						designer.Create(actualParent, $(realContainer), ctlId);
						designer.ShowPropertyDialog();
						break;
					case "Label":
						designer = new VP.Forms.Designer.LabelDesignTimeElement();
						designer.Create(actualParent, $(realContainer), ctlId);
						designer.ShowPropertyDialog();
						break;
					case "Button":
						designer = new VP.Forms.Designer.ButtonDesignTimeElement();
						designer.Create(actualParent, $(realContainer), ctlId);
						designer.ShowPropertyDialog();
						break;
					case "Description":
						designer = new VP.Forms.Designer.DescriptionDesignTimeElement();
						designer.Create(actualParent, $(realContainer), ctlId);
						designer.ShowPropertyDialog();
						break;
					case "Break":
						designer = new VP.Forms.Designer.BreakDesignTimeElement();
						designer.Create(actualParent, $(realContainer), ctlId);
						designer.ShowPropertyDialog();
						break;
					case "DatePicker":
						designer = new VP.Forms.Designer.DatePickerDesignTimeElement();
						designer.Create(actualParent, $(realContainer), ctlId);
						designer.ShowPropertyDialog();
						break;
					case "PlaceHolder":
						designer = new VP.Forms.Designer.PlaceHolderDesignTimeElement();
						designer.Create(actualParent, $(realContainer), ctlId);
						designer.ShowPropertyDialog();
						break;
					case "CheckBox":
						designer = new VP.Forms.Designer.CheckBoxDesignTimeElement();
						designer.Create(actualParent, $(realContainer), ctlId);
						designer.ShowPropertyDialog();
						break;
					case "FileUpload":
						designer = new VP.Forms.Designer.FileUploadDesignTimeElement();
						designer.Create(actualParent, $(realContainer), ctlId);
						designer.ShowPropertyDialog();
						break;
					case "Rating":
						designer = new VP.Forms.Designer.RatingDesignTimeElement();
						designer.Create(actualParent, $(realContainer), ctlId);
						designer.ShowPropertyDialog();
						break;
					case "ContentPicker":
						designer = new VP.Forms.Designer.ContentPickerDesignTimeElement();
						designer.Create(actualParent, $(realContainer), ctlId);
						designer.ShowPropertyDialog();
						break;
				}

				if (container.length > 0) {
					$(realContainer).removeClass("droppable-hover");
				}

				actualParent._children[designer.GetControlId()] = designer;
				actualParent._controlCount++;
				actualParent._idCount++;
				actualParent.ControlAdded(designer);
			}
		});
	}
}

VP.Forms.Designer.ContainerDesignTimeElement.prototype.GetControl = function(controlId) {
	for (var i in this._children) {
		if (this._children[i]._controlId == controlId) {
			return this._children[i];
		}
	}

	for (var i in this._children) {
		if (this._children[i]._controlCount > 0) {
			return this._children[i].GetControl(controlId);
		}
	}
}

VP.Forms.Designer.ContainerDesignTimeElement.prototype.DeleteChild = function(controlId) {
	for (var i in this._children) {
		if (this._children[i]._controlId == controlId) {
			var control = this._children[i];
			control.Destroy();
			this.DeleteFields(control);
			delete this._children[i];
			this._controlCount--;
			this.ControlDeleted();
			break;
		}
	}
}

VP.Forms.Designer.ContainerDesignTimeElement.prototype.DeleteFields = function(control) {
	if (control._controlCount == null) {
		var addedFields = VP.Forms.Designer.CanvasInstance._fields[control.FieldType];
		if (addedFields != null) {
			var newArray = null;
			if (addedFields != control.FieldId) {
				if (typeof (addedFields) != "number") {
					var addedFieldsArray = addedFields.split(',');
					for (var i = 0; i < addedFieldsArray.length; i++) {
						if (control.FieldId != addedFieldsArray[i]) {
							if (newArray != null) {
								newArray += "," + addedFieldsArray[i];
							}
							else {
								newArray = addedFieldsArray[i];
							}
						}
					}
				}
			}
			VP.Forms.Designer.CanvasInstance._fields[control.FieldType] = newArray;
		}
	}
	else {
		this.DeleteChildFields(control._children);
	}
}

VP.Forms.Designer.ContainerDesignTimeElement.prototype.DeleteChildFields = function(children) {
	if (children != null) {
		for (var index in children) {
			var addedFields = VP.Forms.Designer.CanvasInstance._fields[children[index].FieldType];
			if (addedFields != null) {
				var newArray = null;
				if (typeof (addedFields) != "number") {
					var addedFieldsArray = addedFields.split(',');
					for (var i = 0; i < addedFieldsArray.length; i++) {
						if (children[index].FieldId != addedFieldsArray[i]) {
							if (newArray != null) {
								newArray += "," + addedFieldsArray[i];
							}
							else {
								newArray = addedFieldsArray[i];
							}
						}
					}
				}
				VP.Forms.Designer.CanvasInstance._fields[children[index].FieldType] = newArray;
			}

			if (children[index]._children != null) {
				this.DeleteChildFields(children[index]._children);
			}
		}
	}
}

VP.Forms.Designer.ContainerDesignTimeElement.prototype.MoveUp = function(controlId) {
	var prev = null;
	var prevId = "";
	for (var i in this._children) {
		if (this._children[i].FieldType != null) {
			if (this._children[i]._controlId == controlId) {
				if (prev != null) {
					$("#" + this._children[i]._controlId + "_designer").after
							($("#" + this._children[prevId]._controlId + "_designer"));

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
	}
}

VP.Forms.Designer.ContainerDesignTimeElement.prototype.MoveDown = function(controlId) {
	var prev = null;
	var prevId = "";
	var isPrevFound = false;
	for (var i in this._children) {
		if (this._children[i].FieldType != null) {
			if (this._children[i]._controlId == controlId) {
				prev = this._children[i];
				prevId = i;
				isPrevFound = true;
			}
			else {
				if (isPrevFound) {
					if (prev != null) {
						$("#" + this._children[i]._controlId + "_designer").after
								($("#" + this._children[prevId]._controlId + "_designer"));

						this._children[prevId] = this._children[i];
						this._children[i] = prev;
					}
					break;
				}
			}
		}
	}
}

VP.Forms.Designer.ContainerDesignTimeElement.prototype.ControlAdded = function(designer) {
}

VP.Forms.Designer.ContainerDesignTimeElement.prototype.ControlDeleted = function() {
}



			

