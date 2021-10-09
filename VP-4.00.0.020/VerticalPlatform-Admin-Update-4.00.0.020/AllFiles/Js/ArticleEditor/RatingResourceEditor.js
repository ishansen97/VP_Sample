
VP.ArticleEditor.RatingResourceEditor = function () {
	VP.ArticleEditor.ResourceEditor.apply(this);
};

VP.ArticleEditor.RatingResourceEditor.prototype = Object.create(VP.ArticleEditor.ResourceEditor.prototype);

VP.ArticleEditor.RatingResourceEditor.prototype.LoadEditor = function (element, parentId) {
	this._element = element;
	VP.ArticleEditor.ResourceEditor.prototype.LoadEditor.apply(this, arguments);
	this.DisplayResourceTypeName("Rating Resource");
	var html = $("#RatingResourceEditorTemplate").clone();
	$(this._element).append(html);

	if (this._resource !== null) {
		if (typeof (this._resource.RatingCustomPropertyName) != 'undefined' && this._resource.RatingCustomPropertyName !== null) {
			var selectedRatingList = this._resource.RatingCustomPropertyName.split(',');
			$("#RatingResourceEditorTemplate").find(':checkbox').each(function () {
				if ($.inArray($(this).next('label').text(), selectedRatingList) != -1) {
					$(this).attr('checked', 'true');
				}
			});
		}
	}
};

VP.ArticleEditor.RatingResourceEditor.prototype.Save = function () {
	var selection = [];
	$("#RatingResourceEditorTemplate").find(':checkbox').each(function () {
		if ($(this).is(':checked')) {
			selection.push($(this).next('label').text());
		}
	});

	VP.ArticleEditor.ResourceEditor.prototype.Save.apply(this);
	this._resource.RatingCustomPropertyName = selection.toString();
};

VP.ArticleEditor.RatingResourceEditor.prototype.Validate = function (isTemplate) {
	var ret = VP.ArticleEditor.ResourceEditor.prototype.Validate.apply(this);
	return ret;
};

VP.ArticleEditor.RatingResourceEditor.prototype.ValidateResourceObject = function () {
	var ret = VP.ArticleEditor.ResourceEditor.prototype.ValidateResourceObject.apply(this);
	return ret;
};
