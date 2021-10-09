(function () {
	RegisterNamespace("VP.UrlHelper");

	VP.UrlHelper.UrlValidator = function(url) {
		this.Url = url;
		this.ValidationRegex = {
			Relative: null,
			Absolute: null
		};
	};

	VP.UrlHelper.UrlValidator.prototype.ValidateAbsoluteOrRelativeUrl = function () {
		var validationRegex = this.CreateValidationRegex();
		return this.Url.length > 0 && validationRegex.test(this.Url);
	};

	VP.UrlHelper.UrlValidator.prototype.CreateValidationRegex = function () {
		var regex;
		if (this.Url.charAt(0) === '/') {
			if (this.ValidationRegex.Relative == null) {
				this.ValidationRegex.Relative = new RegExp("^((?:\/[a-zA-Z0-9]+(?:_[a-zA-Z0-9]+)*(?:\-[a-zA-Z0-9]+)*)+)\/$");
			}

			regex = this.ValidationRegex.Relative;
		} else {
			if (this.ValidationRegex.Absolute == null) {
				this.ValidationRegex.Absolute = new RegExp("(https?|ftp|file)://[-A-Za-z0-9+&@#%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]");
			}

			regex = this.ValidationRegex.Absolute;
		}
		return regex;
	};
})();