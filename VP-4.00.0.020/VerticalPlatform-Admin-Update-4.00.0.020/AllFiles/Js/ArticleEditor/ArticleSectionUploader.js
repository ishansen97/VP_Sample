RegisterNamespace("VP.ArticleEditor.ArticleSectionUploader");

VP.ArticleEditor.ArticleSectionUploader = function(siteId) {

	this.HandlerUrl = "../../Handlers/AjaxUploadHandler.ashx";
	this._siteId = siteId;
	
	var uploader = new qq.FileUploader({
		element: document.getElementById('ImageUploader'),
		action: this.HandlerUrl,
		sizeLimit: 4194304,
		allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'tif', 'bmp']
	});

	uploader.setParams({
		sid: this._siteId
	});
};

qq.FileUploader.prototype._formatFileName = function(name) {
	if (name.length > 33) {
		name = 'o/' + name.slice(0, 19) + '...' + name.slice(-13);
	}
	return 'o/' + name;
};