VP.Forms.Designer.Canvas = function() {
	this._formDesigner = null;
	this._fields = new Array();
};

VP.Forms.Designer.Canvas.prototype.Initialize = function() {
	$(".controlDesigner").live("mouseover", function() {
		$(".editMenu", this).addClass("editMenuHover");
		$(".controlContainer", this).addClass("controlContainerHover");
		$(this).addClass("controlDesignerHover");
	});
	$(".controlDesigner").live("mouseout", function() {
		$(".editMenu", this).removeClass("editMenuHover");
		$(".controlContainer", this).removeClass("controlContainerHover");
		$(this).removeClass("controlDesignerHover");
	});
};

VP.Forms.Designer.Canvas.prototype.LoadDefaultForm = function() {
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

VP.Forms.Designer.Canvas.prototype.LoadDefaultLeadForm = function() {
	this.LoadDefaultForm();
}

VP.Forms.Designer.Canvas.prototype.LoadDefaultRegistrationForm = function() {
	this.LoadDefaultForm();
};

VP.Forms.Designer.Canvas.prototype.LoadForm = function(formId) {
	var form;
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: webServiceUrl + "/GetForm",
		data: "{'formId' : '" + formId + "'}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function(msg) {
			form = msg.d;
		},
		error: function(xmlHttpRequest, textStatus, errorThrown) {
		}
	});

	this.Load(form);
};

VP.Forms.Designer.Canvas.prototype.Load = function(form) {
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

VP.Forms.Designer.Canvas.prototype.LoadApplicationLeadForm = function() {
	var form;
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: webServiceUrl + "/GetApplicationLeadForm",
		data: "{'isForLoggedInUser':'" + isForLoggedInUser + "'}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function(msg) {
			form = msg.d;
		},
		error: function(xmlHttpRequest, textStatus, errorThrown) {
		}
	});

	$("#canvas").empty();
	if (form != null) {
		this.Load(form);
	}
	else {
		this.LoadDefaultForm();
	}
}

VP.Forms.Designer.Canvas.prototype.LoadRegistrationForm = function(siteId) {
	var form;
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: webServiceUrl + "/GetRegistrationForm",
		data: "{'siteId' : '" + siteId + "'}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function(msg) {
			form = msg.d;
		},
		error: function(xmlHttpRequest, textStatus, errorThrown) {
		}
	});

	$("#canvas").empty();
	if (form != null) {
		this.Load(form);
	}
	else {
		this.LoadDefaultRegistrationForm();
	}
};

VP.Forms.Designer.Canvas.prototype.GetControl = function(control) {
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
			}
	}
};

VP.Forms.Designer.Canvas.prototype.LoadChildren = function(children, parent) {
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

VP.Forms.Designer.Canvas.prototype.DeleteForm = function() {
	if (formId > 0) {
		$.ajax({
			type: "POST",
			async: false,
			cache: false,
			url: webServiceUrl + "/DeleteForm",
			data: "{'formId' : '" + formId + "'}",
			contentType: "application/json; charset=utf-8",
			dataType: "json",
			success: function(msg) {
				window.location = redirectUrl;
			},
			error: function(xmlHttpRequest, textStatus, errorThrown) {
				var err = "";
			}
		});
	}
	else {
		window.location = redirectUrl;
	}
};

VP.Forms.Designer.Canvas.prototype.SaveForm = function() {
	if (this._formDesigner != null) {
		if (this.ValidateForm(1)) {
			var form = this._formDesigner.GetData();
			var jsonForm = $.toJSON(form);
			var thanksMsg = $(".txtThanksMsg").val();
			var emailSubject = $(".txtSubject").val();
			var emailBody = $(".txtBody").val();
			var enable = $(".chkEnable").find("input[type='checkbox']").attr('checked');
			var title = $(".txtTitle").val();
			$.ajax({
				type: "POST",
				async: false,
				cache: false,
				url: webServiceUrl + "/SaveForm",
				data: "{'siteId' : '" + siteId + "','contentTypeId' : '" + contentTypeId + "','contentId' : '"
			        + contentId + "','leadTypeId' : '" + leadTypeId + "','formId' : '" + formId + "','form' : "
			        + jsonForm + ",'thankMsg' : '" + thanksMsg + "','emailBody' : '"
			        + emailBody + "','emailSubject' : '" + emailSubject + "','enable' : '" + enable
			        + "','isForLoggedInUser':'" + isForLoggedInUser + "','title':'" + title + "'}",
				contentType: "application/json; charset=utf-8",
				dataType: "json",
				success: function(msg) {
					html = msg.d;
				},
				error: function(xmlHttpRequest, textStatus, errorThrown) {
					var err = "";
				}

			});

			window.location = redirectUrl;
		}
	}
};

VP.Forms.Designer.Canvas.prototype.SaveRegistrationForm = function() {
	if (this._formDesigner != null) {
		if (this.ValidateForm(2)) {
			var form = this._formDesigner.GetData();
			var jsonForm = $.toJSON(form);

			$.ajax({
				type: "POST",
				async: false,
				cache: false,
				url: webServiceUrl + "/SaveRegistrationForm",
				data: "{'siteId' : '" + siteId + "','form' : " + jsonForm + "}",
				contentType: "application/json; charset=utf-8",
				dataType: "json",
				success: function(msg) {
					html = msg.d;
				},
				error: function(xmlHttpRequest, textStatus, errorThrown) {
					var err = "";
				}

			});

			window.location = redirectUrl;
		}
	}
};


VP.Forms.Designer.Canvas.prototype.SaveApplicationLeadForm = function() {
	if (this._formDesigner != null) {
		if (this.ValidateForm(1)) {
			var form = this._formDesigner.GetData();
			var jsonForm = $.toJSON(form);
			var thanksMsg = $(".txtThanksMsg").val();
			var emailSubject = $(".txtSubject").val();
			var emailBody = $(".txtBody").val();

			$.ajax({
				type: "POST",
				async: false,
				cache: false,
				url: webServiceUrl + "/SaveApplicationLeadForm",
				data: "{'form' : " + jsonForm + ",'isForLoggedInUser':'" + isForLoggedInUser + "','thankyouMessage':'"
				+ thanksMsg + "','emailSubject':'" + emailSubject + "','emailBody':'"
				+ emailBody + "'}",
				contentType: "application/json; charset=utf-8",
				dataType: "json",
				success: function(msg) {
					html = msg.d;
				},
				error: function(xmlHttpRequest, textStatus, errorThrown) {
					var err = "";
				}
			});

			window.location = redirectUrl;
		}
	}
};

VP.Forms.Designer.Canvas.prototype.LoadApplicationRegistrationForm = function() {
	var form;
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: webServiceUrl + "/GetApplicationRegistrationForm",
		data: "{}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function(msg) {
			form = msg.d;
		},
		error: function(xmlHttpRequest, textStatus, errorThrown) {
		}
	});

	$("#canvas").empty();
	if (form != null) {
		this.Load(form);
	}
	else {
		this.LoadDefaultRegistrationForm();
	}
};

VP.Forms.Designer.Canvas.prototype.SaveApplicationRegistrationForm = function() {
	if (this._formDesigner != null) {
		if (this.ValidateForm(2)) {
			var form = this._formDesigner.GetData();
			var jsonForm = $.toJSON(form);

			$.ajax({
				type: "POST",
				async: false,
				cache: false,
				url: webServiceUrl + "/SaveApplicationRegistrationForm",
				data: "{'form' : " + jsonForm + "}",
				contentType: "application/json; charset=utf-8",
				dataType: "json",
				success: function(msg) {
					html = msg.d;
				},
				error: function(xmlHttpRequest, textStatus, errorThrown) {
					var err = "";
				}

			});

			window.location = redirectUrl;
		}
	}
};

VP.Forms.Designer.Canvas.prototype.ValidateForm = function(formType) {
	var addedFields = new Array();
	var index = 0;
	for (var i in this._fields) {
		if (isNaN(this._fields[i])) {
			var fieldIds = this._fields[i].split(",");
			for (var j = 0; j < fieldIds.length; j++) {
				if (fieldIds[j] != null) {
					addedFields[index] = fieldIds[j];
					index++;
				}
			}
		}
		else {
			if (this._fields[i]) {
				addedFields[index] = this._fields[i];
				index++;
			}
		}
	}

	var loggedInUser = false;
	if (isForLoggedInUser != null) {
		loggedInUser = isForLoggedInUser;
	}

	var jsonFields = $.toJSON(addedFields);
	var isValid = false;
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: webServiceUrl + "/IsValidForm",
		data: "{'fieldIds' : " + jsonFields + ",'formType' : " + formType + ",'isForLoggedInUser' : '" + loggedInUser + "'}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function(msg) {
			if (msg.d == "") {
				isValid = true;
			}
			else {
				$.notify({ message: "Please add these field(s): " + msg.d });
			}
		},
		error: function(xmlHttpRequest, textStatus, errorThrown) {
			var err = "";
		}
	});

	return isValid;
};