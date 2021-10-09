RegisterNamespace("VP.ArticleEditor");

VP.ArticleEditor.ArticleSectionValidator = function () {
	this.Link = 1;
	this.Image = 2;
	this.Video = 3;
	this.FlashFile = 4;
	this.EmbeddedCode = 5;
	this.LeadForm = 6;
	this.RelatedProduct = 7;
	this.RelatedCategory = 8;
	this.Text = 9;
	this.ArticleTools = 10;
	this.MetaData = 11;
	this.ExhibitionVendorSpecial = 12;
	this.Advertisement = 13;
	this.ArticleList = 14;
	this.HorizontalMatrix = 15;
	this.RelatedVendor = 16;
	this.MultimediaGallery = 17;
	this.Rating = 18;

	this.SectionId = -1;
	this.ErrorObjectType = "";
	this.ErroredObject = null;
	this.ErrorMessage = "";
}

VP.ArticleEditor.ArticleSectionValidator.prototype.ValidateArticleSections = function(article)
{
	for (i = 0; i < article.Sections.length; i = i + 1) {
		if (!article.IsTemplate) {
			var editor = new VP.ArticleEditor.SectionEditor();
			editor.InitEditor(article.Sections[i]);
			if (!editor.ValidateSectionObject(article.IsTemplate)) {
				this.ErrorMessage = "Section validation error";
				this.ErrorObjectType = "section";
				this.ErroredObject = article.Sections[i];
				return false;
			}
		}
		for (j = 0; j < article.Sections[i].Resources.length; j++) {
			if (!article.IsTemplate) {
				editor = this.CreateResourceEditor(article.Sections[i].Resources[j]);
				if (!editor.ValidateResourceObject(article.IsTemplate)) {
					this.SectionId = article.Sections[i].Id;
					this.ErrorMessage = "Resource validation error";
					this.ErrorObjectType = "resource";
					this.ErroredObject = article.Sections[i].Resources[j];
					return false;
				}
				if (article.Sections[i].Resources[j].ResourceType == this.Text) {
					for (k = 0; k < article.Sections[i].Resources[j].Resources.length; k++) {
						editor = this.CreateResourceEditor(article.Sections[i].Resources[j].Resources[k]);
						if (!editor.ValidateResourceObject(article.IsTemplate)) {
							this.SectionId = article.Sections[i].Id;
							this.ErrorMessage = "Text resource plugin validation error";
							this.ErrorObjectType = "resource";
							this.ErroredObject = article.Sections[i].Resources[j];
							return false;
						}
					}
				}
			}
		}
	}
	
	return true;
}

VP.ArticleEditor.ArticleSectionValidator.prototype.CreateResourceEditor = function(resource) {
	var editor;

	switch (resource.ResourceType) {
		case this.Link:
			editor = new VP.ArticleEditor.LinkResourceEditor();
			break;

		case this.Image:
			editor = new VP.ArticleEditor.ImageResourceEditor();
			break;

		case this.Video:
			editor = new VP.ArticleEditor.VideoResourceEditor();
			break;

		case this.FlashFile:
			editor = new VP.ArticleEditor.FlashResourceEditor();
			break;

		case this.EmbeddedCode:
			editor = new VP.ArticleEditor.EmbeddedCodeResourceEditor();
			break;

		case this.LeadForm:
			editor = new VP.ArticleEditor.LeadFormResourceEditor();
			break;

		case this.RelatedProduct:
			editor = new VP.ArticleEditor.RelatedProductsResourceEditor();
			break;

		case this.RelatedCategory:
			editor = new VP.ArticleEditor.RelatedCategoryResourceEditor();
			break;

		case this.Text:
			editor = new VP.ArticleEditor.TextResourceEditor();
			break;

		case this.ArticleTools:
			editor = new VP.ArticleEditor.ArticleToolsResourceEditor();
			break;

		case this.MetaData:
			editor = new VP.ArticleEditor.MetadataResourceEditor();
			break;

		case this.ExhibitionVendorSpecial:
			editor = new VP.ArticleEditor.ExhibitionVendorSpecialResourceEditor();
			break;
			
		case this.Advertisement:
			editor = new VP.ArticleEditor.AdvertisementResourceEditor();
			break;
			
		case this.ArticleList:
			editor = new VP.ArticleEditor.ArticleListResourceEditor();
			break;
		case this.HorizontalMatrix:
			editor = new VP.ArticleEditor.HorizontalMatrixResourceEditor();
			break;
		case this.RelatedVendor:
			editor = new VP.ArticleEditor.RelatedVendorResourceEditor();
			break;
		case this.MultimediaGallery:
			editor = new VP.ArticleEditor.MultimediaGalleryResourceEditor();
			break;
		case this.Rating:
			editor = new VP.ArticleEditor.RatingResourceEditor();
			break;
	}

	editor.InitEditor(resource);
	return editor;
};