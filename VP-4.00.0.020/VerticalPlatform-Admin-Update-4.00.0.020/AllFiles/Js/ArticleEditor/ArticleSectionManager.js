RegisterNamespace("VP.ArticleEditor.ArticleSectionManager");

VP.ArticleEditor.ArticleSectionManager = function (mediaUrl, siteId) {

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
	this.Metadata = 11;
	this.ExhibitionVendorSpecial = 12;
	this.Advertisement = 13;
	this.ArticleList = 14;
	this.HorizontalMatrix = 15;
	this.RelatedVendor = 16;
	this.MultimediaGallery = 17;
	this.Rating = 18;

	this.ServiceUrl = "../../Services/ArticleEditorService.asmx/";

	this.PageIcon = "../../App_Themes/Default/Images/ArticleEditor/page.gif";
	this.SectionIcon = "../../App_Themes/Default/Images/ArticleEditor/section.jpg";

	this.FlashIcon = "../../App_Themes/Default/Images/ArticleEditor/flash.gif";
	this.ImageIcon = "../../App_Themes/Default/Images/ArticleEditor/image.gif";
	this.LinkIcon = "../../App_Themes/Default/Images/ArticleEditor/link.gif";
	this.VideoIcon = "../../App_Themes/Default/Images/ArticleEditor/Video.gif";
	this.ProductIcon = "../../App_Themes/Default/Images/ArticleEditor/product.jpg";
	this.CategoryIcon = "../../App_Themes/Default/Images/ArticleEditor/category.jpg";
	this.EmbaddedIcon = "../../App_Themes/Default/Images/ArticleEditor/embad.jpg";
	this.ArticleToolsIcon = "../../App_Themes/Default/Images/ArticleEditor/tools.jpg";
	this.LeadFormIcon = "../../App_Themes/Default/Images/ArticleEditor/lead.jpg";
	this.TextIcon = "../../App_Themes/Default/Images/ArticleEditor/text.jpg";
	this.MetadataIcon = "../../App_Themes/Default/Images/ArticleEditor/meta.jpg";
	this.ExhibitionVendorSpecialIcon = "../../App_Themes/Default/Images/ArticleEditor/specials.jpg";
	this.AdvertisementIcon = "../../App_Themes/Default/Images/ArticleEditor/ad.png";
	this.ArticleListIcon = "../../App_Themes/Default/Images/ArticleEditor/articleList.png";
	this.HorizontalMatrixIcon = "../../App_Themes/Default/Images/ArticleEditor/matrix.jpg";
	this.RelatedVendorIcon = "../../App_Themes/Default/Images/ArticleEditor/vendor.png";
	this.MultimediaGalleryIcon = "../../App_Themes/Default/Images/ArticleEditor/multimedia.png";
	this.RatingIcon = "../../App_Themes/Default/Images/ArticleEditor/rating.png";

	this._siteId = siteId;
	this._mediaUrl = mediaUrl;
	this._serviceUrl = this.ServiceUrl;
	this._article = null;
	this._element = $("#ArticleEditor");
	this._editor = null;
	this._nextNewSectionId = -100;
	this._nextNewResourceId = -100;
	this._pageNumber = 1;
	this._pageArray = [];
	this._wymEditors = new Object();
	var that = this;

	that = this;
	$("#articleTree").tree({
		callback: {
			onselect: function () {
				that.NodeSelected();
			},
			onmove: function (node, refNode, type, treeObj, rb) {
				that.NodeMoved(node, refNode, type, rb);
			},
			beforechange: function () {
				if (that._editor !== null) {
					if (that.ConfirmSaveChanges()) {
						if (!that.SaveCurrentEditor()) {
							return false;
						} else {
							that.RefreshScreen();
						}
					}
				}
			}
		},
		rules: {
			valid_children: ["page"]
		},
		types: {
			"default": {
				deletable: true,
				renameable: false

			},
			"page": {
				draggable: false,
				valid_children: ["section"],
				icon: {
					image: that.PageIcon
				}
			},
			"section": {
				valid_children: ["resource"],
				renameable: true,
				icon: {
					image: that.SectionIcon
				}
			},
			"resource": {
				valid_children: "none",
				max_children: 0,
				max_depth: 0
			}
		}
	});

	$("#PageButton").click(function (event) {
		that._pageNumber = that._pageNumber + 1;
		that.AddPage(that._pageNumber, false);
	});

	$("#ContainerButton").click(function (event) {
		that.AddSection();
	});

	$("#btnSaveSections").click(function (event) {
		that.SaveSections();
	});

	$("#btnCancel").click(function (event) {
		that.CancelButtonClicked();
	});

	$("#btnPreview").click(function (event) {
		that.ArticlePreview();
	});

	this.InitializeResourceToolButtons(that);
};

VP.ArticleEditor.ArticleSectionManager.prototype.InitializeResourceToolButtons = function(that) {
	$("#ArticleToolButton").click(function(event) {
		that.AddResource(that.ArticleTools);
	});

	$("#EmbeddedCodeButton").click(function(event) {
		that.AddResource(that.EmbeddedCode);
	});

	$("#FlashButton").click(function(event) {
		that.AddResource(that.FlashFile);
	});

	$("#ImageButton").click(function(event) {
		that.AddResource(that.Image);
	});

	$("#LeadFormButton").click(function(event) {
		that.AddResource(that.LeadForm);
	});

	$("#LinkButton").click(function(event) {
		that.AddResource(that.Link);
	});

	$("#MetaDataButton").click(function(event) {
		that.AddResource(that.Metadata);
	});

	$("#RelatedProductButton").click(function(event) {
		that.AddResource(that.RelatedProduct);
	});

	$("#RelatedCategoryButton").click(function(event) {
		that.AddResource(that.RelatedCategory);
	});

	$("#TextButton").click(function(event) {
		that.AddResource(that.Text);
	});

	$("#VideoButton").click(function(event) {
		that.AddResource(that.Video);
	});

	$("#ExhibitionVendorSpecial").click(function(event) {
		that.AddResource(that.ExhibitionVendorSpecial);
	});

	$("#Advertisement").click(function(event) {
		that.AddResource(that.Advertisement);
	});

	$("#ArticleList").click(function(event) {
		that.AddResource(that.ArticleList);
	});
	
	$("#HorizontalMatrix").click(function(event) {
		that.AddResource(that.HorizontalMatrix);
	});

	$("#RelatedVendor").click(function (event) {
		that.AddResource(that.RelatedVendor);
	});

	$("#MultimediaGallery").click(function (event) {
		that.AddResource(that.MultimediaGallery);
	});

	$("#Rating").click(function (event) {
		that.AddResource(that.Rating);
	});
};

VP.ArticleEditor.ArticleSectionManager.prototype.NodeMoved = function(node, refNode, position, rb) {
	var nodeType = $.data(node, "nodeType");
	var refNodeType = $.data(refNode, "nodeType");
	var sectionId;
	var section;

	switch (nodeType) {
		case "resource":
			var resourceId = $.data(node, "resourceId");
			sectionId = $.data(node, "sectionId");
			var newSectionId = $.data(refNode, "sectionId");
			var refResId = $.data(refNode, "resourceId");
			var resource = this.GetSecectedResource(sectionId, resourceId);
			section = this.GetSecectedSection(sectionId);
			var newSection;

			if (resource.TemplateResourceId === null || (section.EnableResourceReordering && sectionId === newSectionId)) {
				if (sectionId != newSectionId) {
					if (this.IsValidResource(newSectionId, resource.ResourceType, false)) {
						newSection = this.GetSecectedSection(newSectionId);
						this.RemoveResource(sectionId, resource);
						this.ReorderSectionResources(newSection, refResId, position, resource);
						$.data(node, "sectionId", newSectionId);
						this.NodeSelected();
					}
					else {
						this.DrawSectionTree();
					}
				}
				else {
					this.RemoveResource(sectionId, resource);
					newSection = this.GetSecectedSection(sectionId);
					this.ReorderSectionResources(newSection, refResId, position, resource);
					newSection[newSection.length] = resource;
				}
			}
			else {
				$.notify({ message: "Template content cannot be moved" });
				this.DrawSectionTree();
			}

			break;

		case "section":
			var newPageId = $.data(refNode, "pageId");
			var refSectionId = $.data(refNode, "sectionId");
			sectionId = $.data(node, "sectionId");
			section = this.GetSecectedSection(sectionId);

			if (!this._article.IsTemplate && this._article.LockSections && !this._article.EnableSectionReordering) {
				$.notify({ message: "Template container cannot be moved" });
				this.DrawSectionTree();
			}
			else {
				section.Page = newPageId;
				this.RemoveMovedSection(section);
				this.ReorderSections(refSectionId, position, section);
				$.data(node, "pageId", newPageId);
			}
			break;
	}
};

VP.ArticleEditor.ArticleSectionManager.prototype.ReorderSections = function(refSectionId, position, section) {
	var newNodeIndex = 0;
	for (newNodeIndex = 0; newNodeIndex < this._article.Sections.length; newNodeIndex++) {
		if (this._article.Sections[newNodeIndex].Id == refSectionId) {
			break;
		}
	}

	if (position == "after" && (newNodeIndex != this._article.Sections.length)) {
		newNodeIndex++;
	}

	var oldSections = [];
	for (var index = 0; index < this._article.Sections.length; index++) {
		oldSections[index] = this._article.Sections[index];
	}

	var oldNodeIndex = 0;
	this._article.Sections = [];
	for (var nodeIndex = 0; nodeIndex <= oldSections.length; nodeIndex++) {
		if (nodeIndex != newNodeIndex) {
			this._article.Sections[nodeIndex] = oldSections[oldNodeIndex];
			oldNodeIndex++;
		}
		else {
			this._article.Sections[nodeIndex] = section;
		}
	}
};

VP.ArticleEditor.ArticleSectionManager.prototype.ReorderSectionResources = function(section, refResId, position, resource) {
	if (section.Resources.length == 0) {
		section.Resources[section.Resources.length] = resource;
	}
	else {
		var newNodeIndex = 0;
		for (newNodeIndex = 0; newNodeIndex < section.Resources.length; newNodeIndex++) {
			if (section.Resources[newNodeIndex].Id == refResId) {
				break;
			}
		}

		if (position == "after" && (newNodeIndex != section.Resources.length)) {
			newNodeIndex++;
		}

		var oldSectionResources = [];
		for (var index = 0; index < section.Resources.length; index++) {
			oldSectionResources[index] = section.Resources[index];
		}

		var oldNodeIndex = 0;
		for (var nodeIndex = 0; nodeIndex <= oldSectionResources.length; nodeIndex++) {
			if (nodeIndex != newNodeIndex) {
				section.Resources[nodeIndex] = oldSectionResources[oldNodeIndex];
				oldNodeIndex++;
			}
			else {
				section.Resources[nodeIndex] = resource;
			}
		}
	}
};

VP.ArticleEditor.ArticleSectionManager.prototype.AddPage = function(pageNumber, isCreate) {
	if (this._article.IsTemplate || !this._article.LockSections || isCreate) {
		var pageName = "Page" + pageNumber;
		var pageNode = $.tree.focused().create({ data: { title: pageName, attributes: { "class": "rootElement"} },
			attributes: { "id": pageName, "rel": "page"}
		}, -1);
		$.data(pageNode[0], "pageId", pageNumber);
		$.data(pageNode[0], "nodeType", "page");
	}
	else {
		$.notify({ message: "New pages are not allowed in this article" });
	}
};

VP.ArticleEditor.ArticleSectionManager.prototype.AddSection = function () {
	if (this._article.IsTemplate || !this._article.LockSections) {
		if (typeof ($.tree.focused().selected) != "undefined") {
			var selectedNodeType = this.GetSelectedNodeData($.tree.focused(), "nodeType");
			if (selectedNodeType == "page") {
				//Add the section id as a data :
				var newSection = new VerticalPlatform.Core.Web.Dto.Articles.Section();
				newSection.Id = this._nextNewSectionId;
				newSection.Title = "";
				newSection.Page = this.GetSelectedNodeData($.tree.focused(), "pageId");
				newSection.SortOrder = this._article.Sections.length;
				newSection.Resources = [];
				newSection.PreviewImageTitle = "";
				newSection.PreviewImageCode = "";
				newSection.IsPopup = false;
				newSection.CssClass = "";
				newSection.IsTemplateSection = this._article.IsTemplate;
				newSection.LockSections = true;
				newSection.EnableResourceReordering = true;
				newSection.EnableChangeCSSClass = true;
				newSection.DisabledResourceTypes = [];
				newSection.IsTitleOptional = true;
				newSection.SectionName = "";
				newSection.HideWhenEmpty = false;

				this._article.Sections[this._article.Sections.length] = newSection;
				var sectionName = "Section" + newSection.Id;

				var newSectonNode = $.tree.focused().create({ data: { title: "Section", attributes: { "class": "folderElement"} },
					attributes: { "id": sectionName, "rel": "section" }
				}, 0);
				$.tree.focused().select_branch(newSectonNode);

				$.data(newSectonNode[0], "sectionId", this._nextNewSectionId);
				$.data(newSectonNode[0], "nodeType", "section");
				$.data(newSectonNode[0], "pageId", newSection.Page);
				this._nextNewSectionId = this._nextNewSectionId - 1;

				this.LoadSectionEditor(newSection, true);
			}
		}
	}
	else {
		$.notify({ message: "New sections are not allowed in this article" });
	}
};

VP.ArticleEditor.ArticleSectionManager.prototype.CreateSection = function(refNode, section, position) {
	var sectionName = "Section" + section.Id;
	var newSectonNode = $.tree.focused().create({ data: { title: "Section", attributes: { "class": "folderElement"} },
		attributes: { "id": sectionName, "rel": "section"}
	}, "#Page" + section.Page, position);
	$.data(newSectonNode[0], "sectionId", section.Id);
	$.data(newSectonNode[0], "nodeType", "section");
	$.data(newSectonNode[0], "pageId", section.Page);
};

VP.ArticleEditor.ArticleSectionManager.prototype.GetSecectedSection = function(sectionId) {
	for (var i = 0; i < this._article.Sections.length; i++) {
		if (this._article.Sections[i].Id == sectionId) {
			return this._article.Sections[i];
		}
	}
};

VP.ArticleEditor.ArticleSectionManager.prototype.GetSecectedResource = function(sectionId, resourceId) {
	var section = this.GetSecectedSection(sectionId);
	if (typeof (section) != "undifined") {
		for (var i = 0; i < section.Resources.length; i++) {
			if (section.Resources[i].Id == resourceId) {
				return section.Resources[i];
			}
		}
	}
};

VP.ArticleEditor.ArticleSectionManager.prototype.CreateResource = function(sectionId, resource, position) {
	var sectionName = "Section" + sectionId;
	var typeName = this.GetResourcePropertirs("name", resource.ResourceType);
	var iconName = this.GetResourcePropertirs("icon", resource.ResourceType);

	var newResourceNode = $.tree.focused().create({
		data: { title: typeName, icon: iconName, attributes: { "class": "fileElement"} },
		attributes: { "rel": "resource"}
	}, "#" + sectionName, position);

	$.data(newResourceNode[0], "resourceId", resource.Id);
	$.data(newResourceNode[0], "sectionId", sectionId);
	$.data(newResourceNode[0], "nodeType", "resource");
};

VP.ArticleEditor.ArticleSectionManager.prototype.GetResourcePropertirs = function(property, type) {
	var returnValue = "";

	switch (type) {
		case this.Link:
			typeName = "Link";
			iconName = this.LinkIcon;
			break;

		case this.Image:
			typeName = "Image";
			iconName = this.ImageIcon;
			break;

		case this.Video:
			typeName = "Video";
			iconName = this.VideoIcon;
			break;

		case this.FlashFile:
			typeName = "Flash";
			iconName = this.FlashIcon;
			break;

		case this.EmbeddedCode:
			typeName = "Embedded Code";
			iconName = this.EmbaddedIcon;
			break;

		case this.LeadForm:
			typeName = "Lead Form";
			iconName = this.LeadFormIcon;
			break;

		case this.RelatedProduct:
			typeName = "Related Products";
			iconName = this.ProductIcon;
			break;

		case this.RelatedCategory:
			typeName = "Related Categories";
			iconName = this.CategoryIcon;
			break;

		case this.Text:
			typeName = "Text";
			iconName = this.TextIcon;
			break;

		case this.ArticleTools:
			typeName = "Article Tools";
			iconName = this.ArticleToolsIcon;
			break;

		case this.Metadata:
			typeName = "Meta";
			iconName = this.MetadataIcon;
			break;

		case this.ExhibitionVendorSpecial:
			typeName = "Exhibition Vendor Special";
			iconName = this.ExhibitionVendorSpecialIcon;
			break;

		case this.Advertisement:
			typeName = "Advertisement";
			iconName = this.AdvertisementIcon;
			break;
		case this.ArticleList:
			typeName = "ArticleList";
			iconName = this.ArticleListIcon;
			break;
		case this.HorizontalMatrix:
			typeName = "Horizontal Matrix";
			iconName = this.HorizontalMatrixIcon;
			break;
		case this.RelatedVendor:
			typeName = "Related Vendor";
			iconName = this.RelatedVendorIcon;
			break;

		case this.MultimediaGallery:
			typeName = "Multimedia Gallery";
			iconName = this.MultimediaGalleryIcon;
			break;

		case this.Rating:
			typeName = "Rating";
			iconName = this.RatingIcon;
			break;
	}

	if (property == "name") {
		returnValue = typeName;
	} else {
		returnValue = iconName;
	}

	return returnValue;
};

VP.ArticleEditor.ArticleSectionManager.prototype.LeadFromAvailable = function(section) {
	var leadFormAvailable = false;
	for (var resourceIndex = 0; resourceIndex < section.Resources.length; resourceIndex++) {
		if (section.Resources[resourceIndex].ResourceType == this.LeadForm) {
			$.notify({ message: "Please note that only one lead form is allowed in an article." });
			leadFormAvailable = true;
			break;
		}
	}

	return leadFormAvailable;
};

VP.ArticleEditor.ArticleSectionManager.prototype.ExhibitionVendorSpecialAvailable = function(section) {
	var isExhibitionVendorSpecialAvailable = false;
	for (var resourceIndex = 0; resourceIndex < section.Resources.length; resourceIndex++) {
		if (section.Resources[resourceIndex].ResourceType == this.ExhibitionVendorSpecial) {
			$.notify({ message: "Please note that only one exhibition vendor special is allowed in an article." });
			isExhibitionVendorSpecialAvailable = true;
			break;
		}
	}

	return isExhibitionVendorSpecialAvailable;
};

VP.ArticleEditor.ArticleSectionManager.prototype.IsValidResource = function(sectionId, intType, isNewResource) {
	var section = this.GetSecectedSection(sectionId);
	var valid = true;
	if (intType == this.LeadForm) {
		if (isNewResource) {
			for (var sectionIndex = 0; sectionIndex < this._article.Sections.length; sectionIndex++) {
				if (this.LeadFromAvailable(this._article.Sections[sectionIndex])) {
					valid = false;
				}
			}
		}
	}

	if (intType == this.ExhibitionVendorSpecial) {
		if (isNewResource) {
			for (var index = 0; index < this._article.Sections.length; index++) {
				if (this.ExhibitionVendorSpecialAvailable(this._article.Sections[index])) {
					valid = false;
				}
			}
		}
	}

	if (valid) {
		if (intType == this.LeadForm || intType == this.ArticleTools) {
			if (section.IsPopup) {
				$.notify({ message: "Please note that popup sections cannot hold a Lead Form or Article Tools" });
				valid = false;
			}
		}
	}

	if (valid) {
		if (!this._article.IsTemplate) {
			if (section.Locked) {
				$.notify({ message: "Selected section is locked" });
				valid = false;
			}
			else if (section.DisabledResourceTypes.length > 0) {
				for (var i = 0; i < section.DisabledResourceTypes.length; i++) {
					if (section.DisabledResourceTypes[i] == intType) {
						$.notify({ message: "Selected resource not allowed in this section" });
						valid = false;
					}
				}
			}
		}
	}

	return valid;
};

VP.ArticleEditor.ArticleSectionManager.prototype.GetSelectedNodeData = function(node, dataName) {
	return $.data(node.selected[0], dataName);
};

VP.ArticleEditor.ArticleSectionManager.prototype.AddResource = function(typeInt) {

	if (this._editor != null && this.ConfirmSaveChanges() && this.SaveCurrentEditor()) {
		var selectedSectionNode = $.tree.focused();
		if (typeof (selectedSectionNode.selected) != "undefined") {
			var selectedNodeType = this.GetSelectedNodeData(selectedSectionNode, "nodeType");

			if (typeof (selectedSectionNode.selected) != "undefined" && selectedNodeType == "section") {
				var selectedSectionId = this.GetSelectedNodeData(selectedSectionNode, "sectionId");
				var selectedSection = this.GetSecectedSection(selectedSectionId);

				if (this.IsValidResource(selectedSectionId, typeInt, true)) {
					var typeName = this.GetResourcePropertirs("name", typeInt);
					var iconName = this.GetResourcePropertirs("icon", typeInt);

					var newResource = null;
					switch (typeInt) {
						case this.Link:
							newResource = new VerticalPlatform.Core.Web.Dto.Articles.LinkResource();
							newResource.ResourceType = this.Link;
							break;

						case this.Image:
						    newResource = new VerticalPlatform.Core.Web.Dto.Articles.ImageResource();
							newResource.ResourceType = this.Image;
							break;

						case this.Video:
						    newResource = new VerticalPlatform.Core.Web.Dto.Articles.VideoResource();
							newResource.ResourceType = this.Video;
							break;

						case this.FlashFile:
						    newResource = new VerticalPlatform.Core.Web.Dto.Articles.FlashResource();
							newResource.ResourceType = this.FlashFile;
							break;

						case this.EmbeddedCode:
						    newResource = new VerticalPlatform.Core.Web.Dto.Articles.EmbeddedCodeResource();
							newResource.ResourceType = this.EmbeddedCode;
							break;

						case this.LeadForm:
						    newResource = new VerticalPlatform.Core.Web.Dto.Articles.LeadFormResource();
							newResource.ResourceType = this.LeadForm;
							break;

						case this.RelatedProduct:
						    newResource = new VerticalPlatform.Core.Web.Dto.Articles.RelatedProductsResource();
							newResource.ResourceType = this.RelatedProduct;
							break;

						case this.RelatedCategory:
						    newResource = new VerticalPlatform.Core.Web.Dto.Articles.RelatedCategoryResource();
							newResource.ResourceType = this.RelatedCategory;
							break;

						case this.Text:
						    newResource = new VerticalPlatform.Core.Web.Dto.Articles.TextResource();
							newResource.ResourceType = this.Text;
							if (this._article.IsTemplate) {
								newResource.DisabledResourceTypes = [];
							}
							break;

						case this.ArticleTools:
						    newResource = new VerticalPlatform.Core.Web.Dto.Articles.ArticleToolsResource();
							newResource.ResourceType = this.ArticleTools;
							break;

						case this.Metadata:
						    newResource = new VerticalPlatform.Core.Web.Dto.Articles.MetadataResource();
							newResource.ResourceType = this.Metadata;
							break;

						case this.ExhibitionVendorSpecial:
						    newResource = new VerticalPlatform.Core.Web.Dto.Articles.ExhibitionVendorSpecialResource();
							newResource.ResourceType = this.ExhibitionVendorSpecial;
							break;

						case this.Advertisement:
						    newResource = new VerticalPlatform.Core.Web.Dto.Articles.AdvertisementResource();
							newResource.ResourceType = this.Advertisement;
							break;
							
						case this.ArticleList:
							newResource = new VerticalPlatform.Core.Web.Dto.Articles.ArticleListResource();
							newResource.ResourceType = this.ArticleList;
							break;
							
						case this.HorizontalMatrix:
						    newResource = new VerticalPlatform.Core.Web.Dto.Articles.HorizontalMatrixResource();
							newResource.ResourceType = this.HorizontalMatrix;
							break;

						case this.RelatedVendor:
							newResource = new VerticalPlatform.Core.Web.Dto.Articles.RelatedVendorResource();
							newResource.ResourceType = this.RelatedVendor;
							break;

						case this.MultimediaGallery:
							newResource = new VerticalPlatform.Core.Web.Dto.Articles.MultimediaGalleryResource();
							newResource.ResourceType = this.MultimediaGallery;
							break;

						case this.Rating:
							newResource = new VerticalPlatform.Core.Web.Dto.Articles.RatingResource();
							newResource.ResourceType = this.Rating;
							break;
					}

					if (newResource != null) {
					
						newResource.Id = this._nextNewResourceId;
						selectedSection.Resources[selectedSection.Resources.length] = newResource;
						this.RefreshScreen();

						var newResourceNode = $.tree.focused().create({
							data: { title: typeName, icon: iconName, attributes: { "class": "fileElement"} },
							attributes: { "rel": "resource"}
						}, 0);

						$.tree.focused().select_branch(newResourceNode);
						$.data(newResourceNode[0], "resourceId", this._nextNewResourceId);
						$.data(newResourceNode[0], "sectionId", selectedSectionId);
						$.data(newResourceNode[0], "nodeType", "resource");

						this._nextNewResourceId = this._nextNewResourceId - 1;
						this.LoadResourceEditor(selectedSectionId, newResource, true);
					}
				}
			}
		}
	}
};

VP.ArticleEditor.ArticleSectionManager.prototype.LoadResourceEditor = function (sectionId, resource, isFirstLoad) {
	var container = $(".ArticleContentEdit", this._element).empty()[0];	
		var editor = this.CreateResourceEditor(resource);		
		if (typeof (editor) != 'undefined') {
			editor.LoadEditor(container, this._element.id);
			this._editor = editor;
			this.InitializeResourceButtonPanel(sectionId, resource, container, isFirstLoad, editor._showApplyButton);
		}	
};

VP.ArticleEditor.ArticleSectionManager.prototype.LoadArticle = function(articleId) {
	var that = this;
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: that._serviceUrl + "GetArticle",
		data: "{'articleId' : " + articleId + "}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function(msg) {
			that._article = msg.d;
		},
		error: function(xmlHttpRequest, textStatus, errorThrown) {
			document.location("../../Error.aspx");
		}
	});

	$("input[id$='hdnIsTemplate']").val(that._article.IsTemplate);

	if (that._article.IsTemplate) {
		$("#btnPreview").hide();
	}

	this.DrawSectionTree();
};

VP.ArticleEditor.ArticleSectionManager.prototype.DrawSectionTree = function() {
	var html = "";
	var pageNode;
	$("#articleTree").empty();
	$("#articleTree")[0].innerHTML = "<ul></ul>";
	var isRestricted = this._article.IsRestricted;
	var enableReorder = this._article.EnableReorder;
	var isTemplate = this._article.IsTemplate;

	this._pageNumber = 1;
	this.AddPage(this._pageNumber, true);

	var sectionPosition = 0;
	var resourcePosition = 0;
	for (var i = 0; i < this._article.Sections.length; i++) {
		var section = this._article.Sections[i];
		sectionPosition++;

		if (section.Page == this._pageNumber) {
			pageNode = "Page" + this._pageNumber;
			this.CreateSection(pageNode, section, sectionPosition);

			for (var inx = 0; inx < section.Resources.length; inx++) {
				resourcePosition++;
				this.CreateResource(section.Id, section.Resources[inx], resourcePosition);
			}
		}
		else {
			this._pageNumber = section.Page;
			this.AddPage(this._pageNumber, true);

			pageNode = "Page" + this._pageNumber;
			this.CreateSection(pageNode, section, sectionPosition);

			for (var idx = 0; idx < section.Resources.length; idx++) {
				resourcePosition++;
				this.CreateResource(section.Id, section.Resources[idx], resourcePosition);
			}
		}
	}
};

VP.ArticleEditor.ArticleSectionManager.prototype.NodeSelected = function() {
	var selectedNode = $.tree.focused();

	if (typeof (selectedNode.selected) != "undefined") {
		var selectedNodeType = this.GetSelectedNodeData(selectedNode, "nodeType");

		switch (selectedNodeType) {
			case "page":
				this.RefreshScreen();
				break;

			case "section":
				this.SelectSection();
				break;

			case "resource":
				this.SelectResource();
				break;
		}
	}
};

VP.ArticleEditor.ArticleSectionManager.prototype.SelectResource = function () {
	var selectedResourceNode = $.tree.focused();
	var selectedResourceId = this.GetSelectedNodeData(selectedResourceNode, "resourceId");
	var selectedSectionId = this.GetSelectedNodeData(selectedResourceNode, "sectionId");

	// Section editor open as a patch for ie8 bug - 
	// Could not type in text resource after selecting, if there were more than one textarea in an article.
	//-------------------------------------------------------------
	var selectedSection = this.GetSecectedSection(selectedSectionId);
	this.LoadSectionEditor(selectedSection, false);
	//-------------------------------------------------------------

	var resource = this.GetSecectedResource(selectedSectionId, selectedResourceId);

	this.LoadResourceEditor(selectedSectionId, resource, false);
};

VP.ArticleEditor.ArticleSectionManager.prototype.SelectSection = function() {

	var selectedSectionNode = $.tree.focused();
	var selectedSectionId = this.GetSelectedNodeData(selectedSectionNode, "sectionId");
	var selectedSection = this.GetSecectedSection(selectedSectionId);
	this.LoadSectionEditor(selectedSection, false);
};

VP.ArticleEditor.ArticleSectionManager.prototype.LoadSectionEditor = function(section, isFirstLoad) {
	var container = $(".ArticleContentEdit", this._element).empty()[0];
	var html = $("#SectionPropertyEntry").clone();
	$(container).append(html);

	var editor = new VP.ArticleEditor.SectionEditor();
	this._editor = editor;
	editor.InitEditor(section);
	editor.LoadEditor(container, this._element.id, this._article.IsTemplate);
	this._editor = editor;
	this.InitializeSectionButtonPanel(section, container, isFirstLoad);
};

VP.ArticleEditor.ArticleSectionManager.prototype.CreateResourceEditor = function(resource) {
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

		case this.Metadata:
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

VP.ArticleEditor.ArticleSectionManager.prototype.InitializeResourceButtonPanel = function(sectionId, resource,
		 container, isFirstLoad, showApplyButton) {
	var resourceButtonPanelHtml = $("#ContentButtonPanel").clone();
	$(container).append(resourceButtonPanelHtml);
	var that = this;
	$("#btnRemove").click(function(event) {
		if (resource.TemplateResourceId == null) {
			if (confirm('Are you sure you want to remove this content?')) {
				if (that.RemoveResource(sectionId, resource)) {
					that.RefreshScreen();
					$.tree.focused().remove();
				}
			}
		}
		else {
			for (var i = 0; i < that._article.Sections.length; i++) {
				if (that._article.Sections[i].Id == sectionId) {
					if (that._article.Sections[i].Locked == false) {
						if (confirm('Are you sure you want to remove this content from a template?')) {
							if (that.RemoveResource(sectionId, resource)) {
								that.RefreshScreen();
								$.tree.focused().remove();
							}
						}
					}
					else {
						$.notify({ message: "Template resources are locked and cannot be removed" });
					}
				}
			}
		}
	});

	if (!isFirstLoad || !showApplyButton) {
		$("#btnCancel").click(function(event) {
			that.RefreshScreen();
			$.tree.focused().deselect_branch($.tree.focused().selected);
		});
	} else {
		$("#btnCancel").hide();
	}

	$("#btnApply").click(function(event) {
		if (that.SaveCurrentEditor()) {
			that.RefreshScreen();
			$.tree.focused().deselect_branch($.tree.focused().selected);
		}
	});

	if (!showApplyButton) {
		$("#btnApply").hide();
	}

	if (that._article.IsTemplate && resource.ResourceType == this.Text) {
		$("#btnSettings").click(function(event) {
			if (that.SaveCurrentEditor()) {
				that.LoadTextResourceSetting(resource);
			}
		});
	}
	else {
		$("#btnSettings").hide();
	}
};

VP.ArticleEditor.ArticleSectionManager.prototype.InitializeSectionButtonPanel = function(section, container, isFirstLoad) {
	var sectionButtonPanelHtml = $("#ContentButtonPanel").clone();
	$(container).append(sectionButtonPanelHtml);
	var that = this;
	$("#btnRemove").click(function(event) {
		that.RemoveSection(section);
	});

	if (!isFirstLoad) {
		$("#btnCancel").click(function(event) {
			that.RefreshScreen();
			$.tree.focused().deselect_branch($.tree.focused().selected);
		});
	}
	else {
		$("#btnCancel").hide();
	}

	$("#btnApply").click(function(event) {
		if (that.SaveCurrentEditor()) {
			that.RefreshScreen();
			$.tree.focused().deselect_branch($.tree.focused().selected);
		}
	});

	if (that._article.IsTemplate) {
		$("#btnSettings").click(function(event) {
			if (that.SaveCurrentEditor()) {
				that.LoadSectionSetting(section);
			}
		});
	}
	else {
		$("#btnSettings").hide();
	}
};

VP.ArticleEditor.ArticleSectionManager.prototype.RemoveResource = function(sectionId, resource) {
	var ret = false;
	for (var i = 0; i < this._article.Sections.length; i++) {
		if (this._article.Sections[i].Id == sectionId) {
			this._article.Sections[i].Resources = jQuery.grep(this._article.Sections[i].Resources, function(value) {
				return value != resource;
			});

			ret = true;
		}
	}

	return ret;
};

VP.ArticleEditor.ArticleSectionManager.prototype.RemoveMovedSection = function(section) {
	this._article.Sections = jQuery.grep(this._article.Sections, function(value) {
		return value != section;
	});
};

VP.ArticleEditor.ArticleSectionManager.prototype.RemoveSection = function(section) {

	if (section.TemplateSectionId == null) {
		if (confirm('Are you sure you want to remove this container?')) {
			this._article.Sections = jQuery.grep(this._article.Sections, function(value) {
				return value != section;
			});

			this.RefreshScreen();
			$.tree.focused().remove();
		}
	}
	else {
		$.notify({ message: "Template sections cannot be removed" });
	}
};

VP.ArticleEditor.ArticleSectionManager.prototype.RefreshScreen = function() {
	this.ClearEditorPane();
	$(".EditorErrors", this._element).empty();
	this._editor = null;
};

VP.ArticleEditor.ArticleSectionManager.prototype.ClearEditorPane = function() {
	$(".ArticleContentEdit", this._element).empty().append("<p class=\"ContentMessage\">Please select a content to edit..</p>");
};

VP.ArticleEditor.ArticleSectionManager.prototype.SaveCurrentEditor = function() {
	var ret = false;
	$(".EditorErrors", this._element).empty();
	if (this._editor != null) {
		this._editor._errors = [];
		if (this._editor.Validate(this._article.IsTemplate)) {
			this._editor.Save();
			ret = true;
		}
		else {
			var errorMessages = "";
			for (i = 0; i < this._editor._errors.length; i = i + 1) {
				errorMessages = errorMessages + this._editor._errors[i];

				if (i != (this._editor._errors.length - 1)) {
					errorMessages = errorMessages + ", ";
				}
				else {
					errorMessages = errorMessages + ".";
				}
			}

			$.notify({ message: errorMessages });
		}
	}
	else {
		this.RefreshScreen();
		return true;
	}

	return ret;
};

VP.ArticleEditor.ArticleSectionManager.prototype.ConfirmSaveChanges = function() {
	return true;
};

VP.ArticleEditor.ArticleSectionManager.prototype.SaveSections = function() {
	this._pageArray = [];
	if (this._editor == null || (this.ConfirmSaveChanges() && this.SaveCurrentEditor())) {

		var validator = new VP.ArticleEditor.ArticleSectionValidator();
		if (!validator.ValidateArticleSections(this._article)) {
			if (validator.ErrorObjectType == "resource") {
				this.LoadResourceEditor(validator.SectionId, validator.ErroredObject, false);
			}
			else if (validator.ErrorObjectType == "section") {
				this.LoadSectionEditor(validator.ErroredObject, false);
			}

			$.notify({ message: validator.ErrorMessage });
			return;
		}

		for (i = 0; i < this._article.Sections.length; i++) {

			if (this._article.Sections[i].Id < 0) {
				this._article.Sections[i].Id = 0;
			}

			this.AddToPageArray(this._article.Sections[i].Page);

			for (j = 0; j < this._article.Sections[i].Resources.length; j++) {
				if (this._article.Sections[i].Resources[j].Id < 0) {
					this._article.Sections[i].Resources[j].Id = 0;
				}
			}
		}

		if (!this.ValidatePageArray()) {
			$.notify({ message: "System doesn't allow empty pages!" });
			return;
		}

		var articleData = $.toJSON(this._article);
		var that = this;
		$.ajax({
			type: "POST",
			async: false,
			cache: false,
			timeout: 10000,
			url: that._serviceUrl + "SaveArticle",
			data: "{'article' : " + articleData + "}",
			contentType: "application/json; charset=utf-8",
			dataType: "json",
			success: function(msg) {
				var url;
				if (that._article.IsTemplate) {
					url = "AddArticle.aspx?aid=" + that._article.Id + "&iat=true";
				}
				else {
					url = "AddArticle.aspx?aid=" + that._article.Id;
				}
				location.href = url;
			},
			error: function(xmlHttpRequest, textStatus, errorThrown) {
				document.location("../../Error.aspx");
			}
		});
	}
};

VP.ArticleEditor.ArticleSectionManager.prototype.ArticlePreview = function() {
	if (this._editor == null || (this.ConfirmSaveChanges() && this.SaveCurrentEditor())) {
		this.RefreshScreen();
		var articleData = $.toJSON(this._article);
		var that = this;
		$.ajax({
			type: "POST",
			async: false,
			cache: false,
			url: that._serviceUrl + "GetArticlePreview",
			data: "{'article' : " + articleData + ", 'siteId' : '" + that._siteId + "'}",
			contentType: "application/json; charset=utf-8",
			dataType: "json",
			success: function(msg) {
				that.ShowPopupPreview(msg.d);
			},
			error: function(xmlHttpRequest, textStatus, errorThrown) {
				$.notify({ message: "Can not preview. Article has errors. Check for incorrect HTML in article text sections." });
			}
		});
	}
};

VP.ArticleEditor.ArticleSectionManager.prototype.ShowPopupPreview = function(content) {
	var previewWindow = window.open('ArticlePreview.html', 'ArticlePreview',
				'location=0,status=1,scrollbars=1,width=700,height=600,toolbar=0,menubar=0,resizable=1');
	var htmlSource;

	previewWindow.document.write(content);
	previewWindow.document.close();
	previewWindow.focus();
	return false;
};

VP.ArticleEditor.ArticleSectionManager.prototype.CancelButtonClicked = function() {
	var url;
	if (this._article.IsTemplate) {
		url = "AddArticle.aspx?aid=" + this._article.Id + "&iat=true";
	}
	else {
		url = "AddArticle.aspx?aid=" + this._article.Id;
	}
	location.href = url;
};

VP.ArticleEditor.ArticleSectionManager.prototype.LoadSectionSetting = function(section) {
	var container = $(".ArticleContentEdit", this._element).empty()[0];
	var html = $("#SectionSettings").clone();
	$(container).append(html);

	var editor = new VP.ArticleEditor.SectionSettingEditor();
	this._editor = editor;
	editor.InitEditor(section);
	editor.LoadEditor(container, this._element.id);
	this._editor = editor;

	this.InitializeSectionSettingButtonPanel(section, container);
};

VP.ArticleEditor.ArticleSectionManager.prototype.LoadTextResourceSetting = function(textResource) {
	var container = $(".ArticleContentEdit", this._element).empty()[0];
	var html = $("#TextResourceSettings").clone();
	$(container).append(html);

	var editor = new VP.ArticleEditor.TextResourceSettingEditor();
	this._editor = editor;
	editor.InitEditor(textResource);
	editor.LoadEditor(container, this._element.id);
	this._editor = editor;

	this.InitializeTextResourceSettingButtonPanel(textResource, container);
};

VP.ArticleEditor.ArticleSectionManager.prototype.InitializeSectionSettingButtonPanel = function(section, container) {
	var html = $("#TemplateSettingsButtonPanel").clone();
	$(container).append(html);
	var that = this;
	$("#btnBack").click(function(event) {
		that.SelectSection();
	});

	$("#btnApplySettings").click(function(event) {
		if (that.SaveCurrentEditor()) {
			that.SelectSection();
		}
	});
};

VP.ArticleEditor.ArticleSectionManager.prototype.InitializeTextResourceSettingButtonPanel = function(textResource, container) {
	var html = $("#TemplateSettingsButtonPanel").clone();
	$(container).append(html);
	var that = this;
	$("#btnBack").click(function(event) {
		that.SelectResource();
	});

	$("#btnApplySettings").click(function(event) {
		if (that.SaveCurrentEditor()) {
			that.SelectResource();
		}
	});
};

VP.ArticleEditor.ArticleSectionManager.prototype.AddToPageArray = function(pageId) {
	var pageAdded = false;
	for (var i = 0; i < this._pageArray.length; i++) {
		if (this._pageArray[i] == pageId) {
			pageAdded = true;
			break;
		}
	}

	if (!pageAdded) {
		this._pageArray[this._pageArray.length] = pageId;
	}
};

VP.ArticleEditor.ArticleSectionManager.prototype.ValidatePageArray = function() {
	this._pageArray.sort();

	var validate = true;

	if (this._pageArray.length > 0) {
		for (var i = 0; i < this._pageArray.length; i++) {
			if (this._pageArray[i] != (i + 1)) {
				validate = false;
				break;
			}
		}
	}

	return validate;
};