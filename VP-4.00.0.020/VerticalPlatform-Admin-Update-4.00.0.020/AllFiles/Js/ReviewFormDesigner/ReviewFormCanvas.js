VP.Forms.Designer.Canvas = function () {
	this._formDesigner = null;
	this._fields = new Array();
	this._formDto = null;
};

VP.Forms.Designer.Canvas.prototype.Initialize = function () {
	$(".controlDesigner").live("mouseover", function () {
		$(".editMenu", this).addClass("editMenuHover");
		$(".controlContainer", this).addClass("controlContainerHover");
		$(this).addClass("controlDesignerHover");
	});
	$(".controlDesigner").live("mouseout", function () {
		$(".editMenu", this).removeClass("editMenuHover");
		$(".controlContainer", this).removeClass("controlContainerHover");
		$(this).removeClass("controlDesignerHover");
	});
};

VP.Forms.Designer.Canvas.prototype.LoadDefaultForm = function () {
	var designer = new VP.Forms.Designer.FormDesignTimeElement();
	designer.Create(null, $("#canvas"), "form");
	this._formDesigner = designer;

	var page = new VP.Forms.Designer.PageDesignTimeElement();
	page._controlId = "p_" + designer._idCount;
	page.Load(null, designer, designer._containerElement);

	designer._children[page.GetControlId()] = page;
	designer._idCount++;
	designer._controlCount++;

	designer.ShowPage(page._controlId);
}

VP.Forms.Designer.Canvas.prototype.LoadForm = function (formId) {
	var that = this;
	var form;
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: "/Services/FormService.asmx/RetrieveFormData",
		data: "{'formId' : '" + formId + "'}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function (msg) {
			that._formDto = msg.d;
			form = that._formDto.UIForm;
		},
		error: function (xmlHttpRequest, textStatus, errorThrown) {
		}
	});

	this.Load(form);
};

VP.Forms.Designer.Canvas.prototype.Load = function (form) {
	$("#canvas").empty();
	if (form != null) {
		var designer = new VP.Forms.Designer.FormDesignTimeElement();
		designer.Load(form, null, $("#canvas")[0]);
		this._formDesigner = designer;
		var parent = designer;
		this.LoadChildren(form.Children, parent);

		designer.ShowPage("");
	}
}

VP.Forms.Designer.Canvas.prototype.GetControl = function (control) {
	switch (control.__type) {
		case "VerticalPlatform.UI.Forms.Core.Page":
			return new VP.Forms.Designer.PageDesignTimeElement();
		case "VerticalPlatform.UI.Forms.Core.Panel":
			return new VP.Forms.Designer.PanelDesignTimeElement();
		case "VerticalPlatform.UI.Forms.Core.Field":
			switch (control.FieldType) {
				case 1:
					return new VP.Forms.Designer.DropDownListDesignTimeElement();
				case 2:
					return new VP.Forms.Designer.TextBoxDesignTimeElement();
				case 3:
					return new VP.Forms.Designer.CheckBoxListDesignTimeElement();
				case 4:
					return new VP.Forms.Designer.HtmlDesignTimeElement();
				case 5:
					return new VP.Forms.Designer.TextAreaDesignTimeElement();
				case 6:
					return new VP.Forms.Designer.RadioButtonListDesignTimeElement();
				case 7:
					return new VP.Forms.Designer.LabelDesignTimeElement();
				case 8:
					return new VP.Forms.Designer.ButtonDesignTimeElement();
				case 9:
					return new VP.Forms.Designer.DescriptionDesignTimeElement();
				case 10:
					return new VP.Forms.Designer.PanelDesignTimeElement();
				case 11:
					return new VP.Forms.Designer.BreakDesignTimeElement();
				case 12:
					return new VP.Forms.Designer.DatePickerDesignTimeElement();
				case 14:
					return new VP.Forms.Designer.PlaceHolderDesignTimeElement();
				case 15:
					return new VP.Forms.Designer.CheckBoxDesignTimeElement();
				case 16:
					return new VP.Forms.Designer.FileUploadDesignTimeElement();
				case 17:
					return new VP.Forms.Designer.RatingDesignTimeElement();
				case 18:
					return new VP.Forms.Designer.ContentPickerDesignTimeElement();
			}
	}
};

VP.Forms.Designer.Canvas.prototype.LoadChildren = function (children, parent) {
	if (children != null) {
		for (var index = 0; index < children.length; index++) {
			var control = this.GetControl(children[index]);
			control._edit = true;
			control._controlId = parent.GetControlId() + "_" + parent._idCount;
			control.Load(children[index], parent, parent._containerElement);

			parent._children[control.GetControlId()] = control;
			parent._controlCount++;
			parent._idCount++;

			if (children[index].__type == "VerticalPlatform.UI.Forms.Core.Field") {
				if (children[index].Id != 0) {
					var fieldIds = this._fields[children[index].FieldType];
					if (fieldIds != null) {
						fieldIds += "," + children[index].Id;
					}
					else {
						fieldIds = children[index].Id;
					}

					this._fields[children[index].FieldType] = fieldIds;
				}
			}

			if (children[index].Children != null) {
				this.LoadChildren(children[index].Children, control);
			}
		}
	}
}

VP.Forms.Designer.Canvas.prototype.SaveForm = function () {
	if (this._formDesigner != null) {
		var form = this._formDesigner.GetData();
		if (this.ValidateForm(form)) {
			var that = this;
			that._formDto.UIForm = form;
			var formData = $.toJSON(that._formDto);

			$.ajax({
				type: "POST",
				async: false,
				cache: false,
				url: "/Services/FormService.asmx/SaveFormData",
				data: "{'formData' : " + formData + "}",
				contentType: "application/json; charset=utf-8",
				dataType: "json",
				success: function (msg) {
					html = msg.d;
					$.notify({ message: "Review form saved successfully.", type: 'ok' });
					window.location = redirectUrl;
				},
				error: function (xmlHttpRequest, textStatus, errorThrown) {
					var err = "";
				}
			});
		}
	}
};

VP.Forms.Designer.Canvas.prototype.ValidateForm = function (data) {
	var textBoxFieldType = 2;
	var addedTextBoxFieldIdArray = [];
	var addedTextBoxFieldIds = this._fields[textBoxFieldType];

	if (addedTextBoxFieldIds != null) {
		if (isNaN(addedTextBoxFieldIds)) {
			var fieldIds = addedTextBoxFieldIds.split(",");
			for (var i = 0; i < fieldIds.length; i++) {
				if (fieldIds[i] != null) {
					addedTextBoxFieldIdArray.push(fieldIds[i]);
				}
			}
		}
		else {
			addedTextBoxFieldIdArray.push(addedTextBoxFieldIds);
		}
	}

	var jsonFields = $.toJSON(addedTextBoxFieldIdArray);
	var jsonForm = $.toJSON(data);
	var isValid = false;
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: "/Services/FormService.asmx/ValidateReviewFormData",
		data: "{'fieldIds' : " + jsonFields + ", 'reviewForm' : " + jsonForm + "}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function (msg) {
			if (msg.d == "") {
				isValid = true;
			}
			else {
				$.notify({ message: "Please add these field(s): " + msg.d, type: "error" });
			}
		},
		error: function (xmlHttpRequest, textStatus, errorThrown) {
			var err = "";
		}
	});

	return isValid;
};

VP.Forms.Designer.Canvas.prototype.DeleteForm = function () {
	if (formId > 0) {
		$.ajax({
			type: "POST",
			async: false,
			cache: false,
			url: "/Services/FormService.asmx/DeleteFormData",
			data: "{'formId' : '" + formId + "'}",
			contentType: "application/json; charset=utf-8",
			dataType: "json",
			success: function (msg) {
				window.location = redirectUrl;
			},
			error: function (xmlHttpRequest, textStatus, errorThrown) {
				var err = "";
			}
		});
	}
};