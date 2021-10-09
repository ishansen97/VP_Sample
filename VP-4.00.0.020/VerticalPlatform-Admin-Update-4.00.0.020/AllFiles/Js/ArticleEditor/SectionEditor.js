
VP.ArticleEditor.SectionEditor = function() {
	this._errors = [];
	this._sections = [];
};

VP.ArticleEditor.SectionEditor.prototype.InitEditor = function(section) {
	this._section = section;
};

VP.ArticleEditor.SectionEditor.prototype.LoadEditor = function (element, parentId, isTemplate) {
	this.DisplaySectionTypeName();
	this._element = element;
	var that = this;

	if (typeof (this._section.SectionName) != 'undefined') {
		$(".txtSectionName", this._element).val(this._section.SectionName);
	}
	if (typeof (this._section.Title) != 'undefined') {
		$(".txtSectionTitle", this._element).val(this._section.Title);
	}
	if (typeof (this._section.PreviewImageCode) != 'undefined') {
		$(".txtPreviewImageCode", this._element).val(this._section.PreviewImageCode);
	}
	if (typeof (this._section.PreviewImageTitle) != 'undefined') {
		$(".txtPreviewImageTitle", this._element).val(this._section.PreviewImageTitle);
	}
	if (typeof (this._section.CssClass) != 'undefined') {
		$(".txtCssClass", this._element).val(this._section.CssClass);
	}
	if (typeof (this._section.EnableChangeCssClass) != 'undefined' && this._section.EnableChangeCssClass != true
			&& this._section.TemplateSectionId != null) {
		$(".txtCssClass", this._element).attr('disabled', 'disabled');
		$(".ddlCssClass", this._element).attr('disabled', 'disabled');
	}

	if (typeof (this._section.IsPopup) != 'undefined') {
		if (this._section.IsPopup) {
			$(".chkIsPopup", this._element).attr('checked', 'checked');
		}
	}

	if (typeof (this._section.ToggleSection) != 'undefined') {
		if (this._section.ToggleSection) {
			$(".chkToggleSection", this._element).attr('checked', 'checked');
		}
	}

	if (typeof (this._section.ToggleText) != 'undefined') {
		$(".txtToggleText", this._element).val(this._section.ToggleText);
	}

	if (typeof (this._section.HideWhenEmpty) != 'undefined') {
		if (this._section.HideWhenEmpty) {
			$(".hideWhenEmptyToggle", this._element).attr('checked', 'checked');
		}
	}

	$("#lblIsPopup", this._element).show("slow");
	$("#lblPreviewImageCode", this._element).show("slow");
	$("#lblPreviewImageTitle", this._element).show("slow");

	$(".chkIsPopup", this._element).click(function () {
		VP.ArticleEditor.SectionEditor.EnablePreviewImage();
	});

	$(".chkToggleSection", this._element).click(function () {
		VP.ArticleEditor.SectionEditor.EnableToggleSection();
	});

	$(".ddlCssClass", this._element).change(function () {
		if ($(".ddlCssClass", that._element).val() > 0) {
			$(".txtCssClass", that._element).val($('option:selected', $(".ddlCssClass", that._element)).text());
		}
	});

	VP.ArticleEditor.SectionEditor.EnablePreviewImage($(".chkIsPopup", this._element).attr('checked'));
	$(".txtSectionTitle", this._element).focus();

	if (!isTemplate) {
		$("#sectionName", this._element).hide();
	}
};

VP.ArticleEditor.SectionEditor.prototype.Save = function() {
	this._section.Title = $(".txtSectionTitle", this._element).val();
	this._section.PreviewImageCode = $(".txtPreviewImageCode", this._element).val();
	this._section.PreviewImageTitle = $(".txtPreviewImageTitle", this._element).val();
	this._section.CssClass = $(".txtCssClass", this._element).val();
	this._section.IsPopup = $(".chkIsPopup", this._element).attr('checked');
	this._section.ToggleSection = $(".chkToggleSection", this._element).attr('checked');
	this._section.ToggleText = $(".txtToggleText", this._element).val();
	this._section.SectionName = $(".txtSectionName", this._element).val();
	this._section.HideWhenEmpty = $(".hideWhenEmptyToggle", this._element).attr('checked');
};

VP.ArticleEditor.SectionEditor.prototype.Validate = function(isTemplate) {
	var ret = true;
	this._errors = [];

	if ($(".txtSectionName", this._element).val() == '' && isTemplate) {
		this._errors[this._errors.length] = "Please enter the template 'Section Name'";
		ret = false;
	}
	if ($(".txtSectionTitle", this._element).val() == '' && isTemplate) {
		this._errors[this._errors.length] = "Please enter the template 'Section Title'";
		ret = false;
	}
	if ($(".chkIsPopup", this._element).attr('checked') && $(".txtPreviewImageCode", this._element).val() == '' && !isTemplate) {
		this._errors[this._errors.length] = "Please enter the 'Preview Image'";
		ret = false;
	}
	if ($(".chkIsPopup", this._element).attr('checked') && $(".txtPreviewImageTitle").val() == '' && !isTemplate) {
		this._errors[this._errors.length] = "Please enter the 'Preview Image Title'";
		ret = false;
	}

	if ($(".chkToggleSection", this._element).attr('checked') && $(".txtToggleText").val() == '' && !isTemplate) {
		this._errors[this._errors.length] = "Please enter the 'Toggle Text'";
		ret = false;
	}
	
	if($(".chkIsPopup", this._element).attr('checked'))
	{
		for(var r = 0; r < this._section.Resources.length; r++)
		{
			if(this._section.Resources[r].ResourceType == 6 || this._section.Resources[r].ResourceType == 10)
			{
				this._errors[this._errors.length] = "Popup section cannot contain a Lead From or Article Tools";
				ret = false;
			}
		}
	}
	
	return ret;
};

VP.ArticleEditor.SectionEditor.EnablePreviewImage = function () {
	var enabled = $(".chkIsPopup", this._element).attr('checked');
	if (enabled) {
		$(".txtPreviewImageCode", this._element).removeAttr('disabled');
		$(".txtPreviewImageTitle", this._element).removeAttr('disabled');

		$(".chkToggleSection", this._element).attr('disabled', 'disabled');
		$(".chkToggleSection", this._element).removeAttr('checked');
		$(".txtToggleText", this._element).attr('disabled', 'disabled');
		$(".txtToggleText", this._element).val('');
	}
	else {
		$(".txtPreviewImageCode", this._element).attr('disabled', 'disabled');
		$(".txtPreviewImageTitle", this._element).attr('disabled', 'disabled');
		$(".txtPreviewImageCode", this._element).val('');
		$(".txtPreviewImageTitle", this._element).val('');

		$(".chkToggleSection", this._element).removeAttr('disabled');
	}
};

VP.ArticleEditor.SectionEditor.EnableToggleSection = function () {
	var enabled = $(".chkToggleSection", this._element).attr('checked');
	if (!enabled) {
		$(".chkIsPopup", this._element).removeAttr('disabled');
		$(".txtToggleText", this._element).attr('disabled', 'disabled');
		$(".txtToggleText", this._element).val('');
	}
	else {
		$(".chkIsPopup", this._element).attr('disabled', 'disabled');
		$(".txtPreviewImageCode", this._element).attr('disabled', 'disabled');
		$(".txtPreviewImageTitle", this._element).attr('disabled', 'disabled');
		$(".txtPreviewImageCode", this._element).val('');
		$(".txtPreviewImageTitle", this._element).val('');

		$(".chkToggleSection", this._element).removeAttr('disabled');
		$(".txtToggleText", this._element).removeAttr('disabled');
	}
};

VP.ArticleEditor.SectionEditor.prototype.DisplaySectionTypeName = function(sectionTypeName) {
	var container = $(".ArticleContentEdit", this._element);
	$(container).prepend("<h4>Section Properties</h4>");
};

VP.ArticleEditor.SectionEditor.prototype.ValidateSectionObject = function(isTemplate) {
	var ret = true;

	if (this._section.Title == '' && isTemplate) {
		ret =  false;
	}
	if (this._section.IsPopup && this._section.PreviewImageCode == '' && !isTemplate) {
		ret =  false;
	}
	if (this._section.IsPopup && this._section.PreviewImageTitle == '' && !isTemplate) {
		ret =  false;
	}
	if (this._section.ToggleSection && this._section.ToggleText == '' && !isTemplate) {
		ret = false;
	}

	return ret;
};
