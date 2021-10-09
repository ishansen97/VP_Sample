(function ($) {
	$.fn.contentPicker = function (options) {
		var initialOptions = $.extend({}, $.fn.contentPicker.defaults, options);
		$(document).mousedown(checkExternalClick);
		return this.each(function () {
			var elm = $(this);
			if (this._cpid) {
				return true;
			}
			_count++;
			this._cpid = _count;
			_hash[_count] = {
				e: elm,
				o: initialOptions
			};

			$.contentPicker.bindElement(_count);
		});
	};

	$.fn.contentPicker.defaults = { siteId: VP.SiteId, type: "Category", currentPage: "1", pageSize: "15",
		categoryType: null, categoryTypes: null, productType: null, categoryTypeElementId: null,
		displayContentTypes: false, displaySites: false, siteElementId: null, isArticleTemplate: false,
		contentTypeDropDownId: null, displayArticleTypes: false, articleTypeId: 0, enabled: null,
		displayProductStatus: false, status: null, publishedOnly: false, parentVendorOnly: null,
		crossPostedArticles: false, displaySearchGroups: true, searchGroupId: 0, campaignTypeElementId: null, excludeParent: null,
		excludeParentChild: null, vendorId: null
	};

	$.contentPicker = {
		hash: {},
		bindElement: function (elementId) {
			w = _hash[elementId];
			var element = w.e;
			var options = w.o;
			element.data("eId", elementId);

			element.focus(function () {
				createContentPickerPopUp(element, options);
			});

			$("." + element.data("eId") + "_contentTableRow").live('click', function () {
				var contentId = $(".cpp_idTableColumn", this).text();
				var contentName = $(".cpp_nameTableColumn", this).text();

				if (contentName.indexOf("((") > 0) {
					contentName = contentName.substr(0, contentName.indexOf("(("));
				}

				if (_hash[_activeElement.data("eId")].o.showName == "true") {
					_hash[_activeElement.data("eId")].e.val(contentName).change();
				}
				else {
					_hash[_activeElement.data("eId")].e.val(contentId).change();
				}

				if (_hash[_activeElement.data("eId")].o.getFixUrl == "true") {
					var fixedUrl = getFixUrl(_hash[_activeElement.data("eId")].o.type, contentId);

					var fixUrlDetail = { url: fixedUrl.Url, id: fixedUrl.Id };
					manupilateBindings(element, fixUrlDetail);
				}
				else {
					var contentDetail = { id: contentId, name: contentName };
					manupilateBindings(element, contentDetail);
				}

				if (_hash[_activeElement.data("eId")].o.displayContentTypes == true) {
					$("[id*=" + _hash[_activeElement.data("eId")].o.contentTypeDropDownId + "]").find("option[text='" + options.type + "']").attr("selected", "selected");
				}

				if (_hash[_activeElement.data("eId")].o.displaySites == true) {
					$("[id*=" + _hash[_activeElement.data("eId")].o.siteElementId + "]").val(options.siteId);
				}

				removeContentPickerPopUp();
			});

			$("." + element.data("eId") + "_contentTableRow").live('mouseover', function () {
				$(this).addClass("contentTableRaw-select");
			});

			$("." + element.data("eId") + "_contentTableRow").live('mouseout', function () {
				$(this).removeClass("contentTableRaw-select");
			});
		}
	};

	function getContentAutoComplete(elementId, request) {
		var categories = null;
		var options = _hash[elementId].o;
		var ajaxRequestStrings = getAutoCompleteAjaxRequestStrings(options, request);
		var urlString = ajaxRequestStrings.url;
		var dataString = ajaxRequestStrings.data;

		$.ajax({
			type: "POST",
			async: false,
			cache: false,
			timeout: 3000,
			url: urlString,
			data: dataString,
			contentType: "application/json; charset=utf-8",
			dataType: "json",
			success: function (data) {
				categories = data;
			},
			error: function (XMLHttpRequest, textStatus, errorThrown) {
				var error = XMLHttpRequest;
			}
		});

		return categories;
	}

	function createContentPickerPopUp(elm, options) {
		if (_contentPickerDisplay !== true) {
			var position = elm.position();

			var left = position.left;
			var top = position.top + 25;
			var html = "<div class='contentPickerPopUp' id='cpp_divContentPickerPopUp' style='position:absolute;top:" +
				top + "px;left:" + left + "px;" + "'>";
			var conTypeName = $('option:selected', options.typeElement).text();

			if (options.displayContentTypes) {
				html += "<div class='contentPickerContentType clearfix'><h3>Content Type</h3><div id='cpp_tabContentType'></div></div>";
			}
			if (options.displaySites && conTypeName.toLowerCase() != "site") {
				html += "<div class='contentPickerSite clearfix'><h3>Site</h3><div id='cpp_tabSite'></div></div>";
			}

			if (options.displayProductStatus) {
				html += "<div class='contentPickerProductStatus clearfix'><h3>Status</h3><div id='cpp_tabProductStatus'></div></div>";
			}

			if (options.externalType === "true") {

				if (typeof options.typeElement === "undefined") {
					options.type = options.contentType;
				}
				else {
					options.type = $('option:selected', options.typeElement).text();
				}
			}

			if (options.displayArticleTypes) {
				if (options.type.toLowerCase() === "article") {
					html += "<div class='contentPickerArticleType clearfix'><h3>Article Type</h3><div id='cpp_tabArticleType'></div></div>";
				}
			}

			if (options.displaySearchGroups) {
				if (options.type.toLowerCase() === "search option") {
					html += "<div class='contentPickerSearchGroup clearfix'><h3>Search Group</h3><div id='cpp_tabSearchOption'></div></div>";
				}
			}

			html += "<div id='cpp_tabs'>" +
				"<ul>" +
				"<li><a href='#cpp_tabAutoComplete'>Search</a></li>" +
				"<li><a href='#cpp_tabContentGrid'>Browse</a></li>" +
				"</ul>" +
				"<div id='cpp_tabAutoComplete'> </div>" +
				"<div id='cpp_tabContentGrid'> </div>" +
				"</div>" +
				"</div>";

			elm.after(html);

			if (options.displayContentTypes) {
				createContentTypeTab(_hash[elm.data("eId")].e, options);
			}
			if (options.displaySites) {
				createSiteTab(_hash[elm.data("eId")].e, options);
			}
			if (options.displayArticleTypes) {
				if (options.type.toLowerCase() === "article") {
					createArticleTypeTab(_hash[elm.data("eId")].e, options);
				}
			}
			if (options.displaySearchGroups) {
				if (options.type.toLowerCase() === "search option") {
					createSearchGroupTab(_hash[elm.data("eId")].e, options);
				}
			}
			if (options.displayProductStatus) {
				createProductStatusTab(_hash[elm.data("eId")].e, options);
			}

			_contentPickerDisplay = true;
			$("#cpp_tabs").tabs({
				show: function (event, ui) {
					switch (ui.tab.hash) {
						case "#cpp_tabAutoComplete":
							if ($('#cpp_txtAutoComplete').length === 0) {
								createAutoCompleteTab(_hash[elm.data("eId")].e);
							}
							positionContentPicker(_activeElement);
							break;
						case "#cpp_tabContentGrid":
							if ($('#contentdialog').length === 0) {
								createContentGridTab(_hash[elm.data("eId")].e, 1);
							}
							positionContentPicker(_activeElement);
							break;
					}
				}
			});
		}
	}	

	function createAutoCompleteTab(element) {
		_activeElement = element;	

		var popUpBox = element.next(".contentPickerPopUp");
		var htmlAutoComplete = "";	
		var _opt = _hash[element.data("eId")].o;		

		var showCategoryFilters = _opt.type.toLowerCase() === "category" && _opt.showFilters;		
		if (showCategoryFilters) {
			// category

			htmlAutoComplete = `<div class='filter-top-margin'><input type='checkbox' id='ckhEnabled' class='filter-checkbox' checked><label for='ckhEnabled'>Enabled</label></div>
			<div><input type='checkbox' id='ckhCatTypeTrunk' class='filter-checkbox' checked data-catTypeId='1'><label class='fixed-width' for='ckhCatTypeTrunk'>Trunk</label>
			<input type='checkbox' id='ckhCatTypeBranch' class='filter-checkbox' checked data-catTypeId='2'><label class='fixed-width' for='ckhCatTypeBranch'>Branch</label>
			<input type='checkbox' id='ckhCatTypeLeaf' class='filter-checkbox' checked data-catTypeId='4'><label for='ckhCatTypeLeaf'>Leaf</label></div>
			<div><input type='checkbox' id='ckhLeafTypeFlat' class='filter-checkbox' checked><label class='fixed-width' for='ckhLeafTypeFlat'>Flat</label>
			<input type='checkbox' id='ckhLeafTypeSearch' class='filter-checkbox' checked><label for='ckhLeafTypeSearch'>Search</label></div>
			<div><input type='checkbox' id='ckhLeafTypeAutoGenerated' class='filter-checkbox'><label for='ckhLeafTypeAutoGenerated'>Autogenerated</label></div>
			<div><input id='cpp_txtAutoComplete' class='non_cpp_autoCompleteTextBox' type='text' style='margin-left:5px;' autocomplete='off' /></div>
			<div><input id='cpp_btnAutoComplete' type='button' class='cpp_autoCompleteTextBox' style='margin-left:5px;' value='Search' ></div>
			<div class='cpp_autoCompleteResults'></div>`;
		}
		else {
			// non category
			htmlAutoComplete = `<div><input id='cpp_txtAutoComplete' class='cpp_autoCompleteTextBox' type='text' style='margin-left:5px;'/>
				</div><div class='cpp_autoCompleteResults'></div>`;
		}

		var cpp_tabAutoComplete = $("#cpp_tabAutoComplete", popUpBox);
		cpp_tabAutoComplete.contents().remove();
		cpp_tabAutoComplete.append(htmlAutoComplete);	
		
		cpp_tabAutoComplete.keypress(function (event) {
			var keycode = (event.keyCode ? event.keyCode : event.which);
			if (keycode == '13') {
				event.preventDefault();
				if (showCategoryFilters)
					$("#cpp_btnAutoComplete").click();
			}
		});		


		$('.cpp_autoCompleteTextBox').autocomplete({
			source: function (request, response) {
				var categories = null;

				var opt = _hash[element.data("eId")].o;
				var filtersApplied = opt.type.toLowerCase() === "category" && opt.showFilters;
				if (filtersApplied) {
					// category and filters should be shown			
					opt.isEnabledSelected = $('#ckhEnabled').is(':checked');

					opt.catTypes = [];
					$("input:checkbox[data-catTypeId]").each(function (index, elem) {
						if ($(elem).is(':checked')) {

							var att = $(elem).attr("data-catTypeId");							
							opt.catTypes.push(att);
						}
							
					})				

					opt.isLeafTypeFlatSelected = $('#ckhLeafTypeFlat').is(':checked');
					opt.isLeafTypeSearchSelected = $('#ckhLeafTypeSearch').is(':checked');
					opt.isLeafTypeAutoGeneratedSelected = $('#ckhLeafTypeAutoGenerated').is(':checked');
				}				
				 
				categories = getContentAutoComplete(element.data("eId"), request.term);
				if (categories !== null) {
					$(".cpp_autoCompleteResults").empty();
					var htmlTable = createContentTableHtml(element, categories.d);
					$(".cpp_autoCompleteResults").append(htmlTable);
					if (filtersApplied)
						$(".cpp_autoCompleteTextBox").removeClass("ui-autocomplete-loading");						
					else
						$(".cpp_autoCompleteTextBox").css("background-image", "none");
					positionContentPicker(_activeElement);
				}
			},

			minLength: 1
		});

		$('#cpp_btnAutoComplete').click(function () {
			$(".cpp_autoCompleteTextBox").autocomplete("search", $('.non_cpp_autoCompleteTextBox').val());			
		})

		positionContentPicker(_activeElement);
		$('.cpp_autoCompleteTextBox').focus();
	}

	

	function createContentGridTab(element, currentPage) {
		_activeElement = element;
		if ($("#contentdialog").length === 0) {
			var html = "<div id='contentdialog'" +
					"' class='contentSearch_window'><div id='contentsearch'>" +
					"</div><div id='pager' class='clearfix'></div>";
			var popUpBox = _activeElement.next(".contentPickerPopUp");
			$("#cpp_tabContentGrid", popUpBox).append(html);
		}

		var contentTable = createContentTable(_activeElement, currentPage);
		$('#contentsearch').html(contentTable);

		positionContentPicker(_activeElement);
	}

	function positionContentPicker(activeElement) {
		var activeElementPosition = activeElement.position();
		var browserHeight = document.body.offsetHeight;
		var browserMiddle = browserHeight / 2;

		if (browserMiddle < (activeElementPosition.top + 20)) {
			var contentPickerHeight = $(".contentPickerPopUp").height();
			var contentPickerTop = activeElementPosition.top - (contentPickerHeight);
			var contentPickerLeft = activeElementPosition.left;
			if (contentPickerTop < 0) {
				contentPickerTop = 0;
				contentPickerLeft = contentPickerLeft + 30;
			}

			$(".contentPickerPopUp").css({ 'top': contentPickerTop + 'px', 'left': contentPickerLeft + "px" });
		}
		else {
			var contentPickerHeight = $(".contentPickerPopUp").height();
			var contentPickerBottem = activeElementPosition.top + 20 + contentPickerHeight;
			if (contentPickerBottem > browserHeight) {
				var contentPickerTop = activeElementPosition.top - (contentPickerBottem - browserHeight);
                contentPickerTop = contentPickerTop > 10 ? contentPickerTop : 50;
				var contentPickerLeft = activeElementPosition.left;
				contentPickerLeft = contentPickerLeft + 30;
				$(".contentPickerPopUp").css({ 'top': contentPickerTop + 'px', 'left': contentPickerLeft + "px" });
			}
		}
	}

	function createContentTypeTab(element, options) {
		_activeElement = element;
		var container = $("#cpp_tabContentType");
		if (container.contents().length == 0) {
			var html = "<div id='cppContentTypeWindow'>" +
				"<select id='cppContentTypeSelect'>" +
				"<option value='1'>Category</option>" +
				"<option value='2'>Product</option>" +
				"<option value='4'>Article</option>" +
				"</select>" +
				"</div>";

			container.append(html);

			$("#cppContentTypeSelect").find("option[text='" + options.type + "']").attr("selected", "selected");

			$("#cppContentTypeSelect").change(function () {
				options.type = $("option:selected", $(this)).text();
				$("#cpp_tabAutoComplete").empty();
				$("#cpp_tabContentGrid").empty();
				refreshSelectedTab(element);
			});
		}
	}

	function createProductStatusTab(element, options) {
		var container = $("#cpp_tabProductStatus");
		if (container.contents().length == 0) {
			var html = "<div id='cppProductStatusWindow'>" +
				"<select id='cppProductStatusSelect'>" +
				"<option value='0'>None</option>" +
				"<option value='1'>New</option>" +
				"<option value='2'>Featured</option>" +
				"</select>" +
				"</div>";

			container.append(html);

			if (options.status == null) {
				options.status = 0;
			}

			$("#cppProductStatusSelect").find("option[value='" + options.status + "']").attr("selected", "selected");

			$("#cppProductStatusSelect").change(function () {
				options.status = $("option:selected", $(this)).val();
				$("#cpp_tabAutoComplete").empty();
				$("#cpp_tabContentGrid").empty();
				refreshSelectedTab(element);
			});
		}
	}

	function createSiteTab(element, options) {
		_activeElement = element;
		var container = $("#cpp_tabSite");
		if (container.contents().length == 0) {
			var sites = null;
			$.ajax({
				type: "POST",
				async: false,
				cache: false,
				url: VP.AjaxWebServiceUrl + "/GetSiteList",
				data: "{}",
				contentType: "application/json; charset=utf-8",
				dataType: "json",
				success: function (data) {
					sites = data.d;
				},
				error: function (XMLHttpRequest, textStatus, errorThrown) {
					var error = XMLHttpRequest;
				}
			});

			if (sites) {
				var html = "<div id='cppSiteWindow'><select id='cppSiteSelect'>";
				for (var index = 0; index < sites.length; index++) {
					html += "<option value='" + sites[index].Id + "'>" + sites[index].Name + "</option>"
				}

				html += "</select></div>";

				container.append(html);

				$("#cppSiteSelect").val(options.siteId.toString());

				$("#cppSiteSelect").change(function () {
					options.siteId = parseInt($(this).val(), 10);
					$("#cpp_tabAutoComplete").empty();
					$("#cpp_tabContentGrid").empty();

					if (options.crossPostedArticles && VP.SiteId != options.siteId) {
						$("#cpp_tabArticleType").attr("disabled", true);
					}
					else {
						$("#cpp_tabArticleType").attr("disabled", false);
					}

					createArticleTypeTab(element, options);
					refreshSelectedTab(element);
				});
			}
		}
	}

	function refreshSelectedTab(element) {
		var selected = $("#cpp_tabs").tabs().tabs('option', 'selected');
		if (selected == 0) {
			createAutoCompleteTab(element);
		}
		else if (selected == 1) {
			createContentGridTab(element, 1);
		}
	}

	function removeContentPickerPopUp() {
		$('.contentPickerPopUp').remove();
		_activeElement = null;
		_contentPickerDisplay = false;
	}

	function checkExternalClick(event) {
		var target = $(event.target);

		if (_activeElement !== null) {
			if (target.attr('id') !== _activeElement.attr('id') &&
					(target.attr('id') !== 'cpp_divContentPickerPopUp') &&
					(target.parents('#cpp_divContentPickerPopUp').length === 0) &&
					(target.attr('class').indexOf("ui-corner-all") === -1)) {

				removeContentPickerPopUp();
			}
		}
	}

	function createContentTable(element, currentPage) {
		var options = _hash[element.data("eId")].o;
		var requestStrings = getAjaxRequestStrings(options, currentPage);
		var contentTable;
		$.ajax({
			type: "POST",
			async: false,
			timeout: 3000,
			cache: false,
			url: requestStrings.url,
			data: requestStrings.data,
			contentType: "application/json; charset=utf-8",
			dataType: "json",
			success: function (data) {
				if (data !== null) {
					contentTable = createContentTableHtml(element, data.d.IdNamePairList);
					var currentPageCount = Math.ceil(data.d.TotalCount / options.pageSize);
					$("#pager").pager({ pagenumber: currentPage, pagecount: currentPageCount, buttonClickCallback: PageClick });
				}
			},
			error: function (XMLHttpRequest, textStatus, errorThrown) {
				var error = XMLHttpRequest;
			}
		});

		return contentTable;
	}

	PageClick = function (pageclickednumber) {
		createContentGridTab(_activeElement, pageclickednumber);
	};

	function createContentTableHtml(element, content) {
		var contentType;
		if (_hash[element.data("eId")].o.externalType === "true") {

			if (typeof _hash[element.data("eId")].o.typeElement === "undefined") {
				contentType = _hash[element.data("eId")].o.contentType;
			}
			else {
				contentType = $('option:selected', _hash[element.data("eId")].o.typeElement).text();
			}
		}
		else {
			contentType = _hash[element.data("eId")].o.type;
		}

		var html = "<table class='categoryTable common_data_grid' cellpadding='0' cellspacing='0' width='100%'><tr class='categoryHeaderRow'>" +
				"<th width='80px'>" + contentType + " Id</th>" +
				"<th>" + contentType + " Name</th>" +
				"</tr>";
		for (var index in content) {
			if (content[index]) {
				html += "<tr class='" + element.data("eId") + "_contentTableRow'><td class='cpp_idTableColumn'>" + content[index].Id + "</td>" +
						"<td class='cpp_nameTableColumn'>" + content[index].Name + "</td></tr>";
			}
		}

		html += "</table>";
		return html;
	}

	function getAjaxRequestStrings(options, currentPage) {
		var urlString;
		var dataString;
		var conType;

		if (options.externalType == "true") {

			if (typeof options.typeElement === "undefined") {
				conType = options.contentType;
			}
			else {
				conType = $('option:selected', options.typeElement).text();
			}
		}
		else {
			conType = options.type;
		}

		switch (conType.toLowerCase()) {
			case "category":
				var categoryType = "";
				var productType = "";
				var categoryTypes = "";

				if (options.categoryType !== null) {
					categoryType = options.categoryType;
				}

				if (options.productType !== null) {
					productType = options.productType;
				}

				if (options.categoryTypes !== null) {
					categoryTypes = options.categoryTypes;
					urlString = VP.AjaxWebServiceUrl + "/GetCategoriesByCategoryTypes";
					dataString = "{'siteId' :" + options.siteId + ", 'categoryTypes' : '" + categoryTypes +
						"' , 'pageIndex' : " + currentPage + ", 'pageSize' :" + options.pageSize + ",'productType' :'" +
						productType + "', 'enabled' :" + options.enabled + ", 'vendorId' :" + options.vendorId + "}";
				}
				else {
					urlString = VP.AjaxWebServiceUrl + "/GetCategories";
					dataString = "{'siteId' :" + options.siteId + ", 'categoryType' : '" + categoryType +
						"' , 'pageIndex' : " + currentPage + ", 'pageSize' :" + options.pageSize + ",'productType' :'" +
						productType + "', 'enabled' :" + options.enabled + ", 'vendorId' :" + options.vendorId + "}";
				}
				break;

			case "product":
				var categoryId = null;
				if (options.categoryTypeElementId !== null) {
					if ($("input[type=text][id*=" + options.categoryTypeElementId + "]").val() > 0) {
						categoryId = $("input[type=text][id*=" + options.categoryTypeElementId + "]").val();
						if (isNaN(categoryId)) {
							categoryId = null;
						}
					}
				}

				urlString = VP.AjaxWebServiceUrl + "/GetProductsBySiteIdPageIndexPageSize";
				dataString = "{'siteId' :" + options.siteId + ", 'pageIndex' : " + currentPage +
						", 'pageSize' :" + options.pageSize + ",'categoryId' :" + categoryId +
						", 'enabled' :" + options.enabled + ", 'status' :" + options.status +
						", 'excludeParent' :" + options.excludeParent + ", 'excludeParentChild' :" + options.excludeParentChild + ", 'vendorId' :" + options.vendorId + "}";
				break;

			case "vendor":
				urlString = VP.AjaxWebServiceUrl + "/GetVendorsBySiteIdPageIndexPageSize";
				dataString = "{'siteId' :" + options.siteId + ", 'pageIndex' : " + currentPage +
						", 'pageSize' :" + options.pageSize + ", 'enabled' :" + options.enabled +
						", 'parentVendorOnly' :" + options.parentVendorOnly + "}";
				break;

			case "article":
				if (options.crossPostedArticles && VP.SiteId != options.siteId) {
					urlString = VP.AjaxWebServiceUrl + "/GetPagedCrossPostedArticles";
					dataString = "{'siteId' : " + VP.SiteId + ", 'targetSiteId' : " + options.siteId + ", 'pageIndex' : " + currentPage +
						", 'pageSize' :" + options.pageSize + "}";
				}
				else if (options.vendorId != null) {
					urlString = VP.AjaxWebServiceUrl + "/GetVendorAssociatedArticles";
					dataString = "{'siteId' : " + VP.SiteId + ", 'pageIndex' : " + currentPage + ", 'pageSize' :" + options.pageSize + ", 'vendorId' :" + options.vendorId + "}";
				}
				else {
					urlString = VP.ArticleEditorWebServiceUrl + "/GetArticlesBySiteIdPageSizePageIndex";
					dataString = "{'siteId' :" + options.siteId + ", 'pageIndex' : " + currentPage + ", 'pageSize' :" + options.pageSize +
						",'isArticleTemplate' :" + options.isArticleTemplate + ",'articleTypeId' : " +
						options.articleTypeId + ", 'publishedOnly' :" + options.publishedOnly + "}";
				}
				break;

			case "page":
				urlString = VP.AjaxWebServiceUrl + "/GetPagesBySiteIdPageIndexPageSize";
				dataString = "{'siteId' :" + options.siteId + ", 'pageIndex' : " + currentPage + ", 'pageSize' :" + options.pageSize + "}";
				break;

			case "campaign":
				var campaignTypeId = null;
				if (options.campaignTypeElementId !== null) {
					if ($("#" + options.campaignTypeElementId + " option:selected").val() != -1) {
						campaignTypeId = $("#" + options.campaignTypeElementId + " option:selected").val()
					}
				}

				urlString = VP.AjaxWebServiceUrl + "/GetCampaignsBySiteIdPageIndexPageSize";
				dataString = "{'siteId' :" + options.siteId + ", 'campaignTypeId' : " + campaignTypeId +
					 ", 'pageIndex' : " + currentPage + ", 'pageSize' :" + options.pageSize + "}";
				break;

			case "file":
				urlString = VP.AjaxWebServiceUrl + "/GetFilesWithPaging";
				dataString = "{'siteId' :" + options.siteId + ", 'pageIndex' : " + currentPage + ", 'pageSize' :" + options.pageSize + "}";
				break;

			case "article type":
			case "specificationtype":
			case "tag":
				urlString = VP.AjaxWebServiceUrl + "/GetContentPageList";
				dataString = "{'siteId' :" + options.siteId + ",'contentType' : '" + conType + "', 'pageIndex' : " + currentPage + ", 'pageSize' :" + options.pageSize + "}";
				break;

			case "search option":
				urlString = VP.AjaxWebServiceUrl + "/GetSearchOptionsBySiteIdGroupIdPageSizePageIndex";
				dataString = "{'siteId' :" + options.siteId + ", 'pageIndex' : " + currentPage + ", 'pageSize' :" + options.pageSize +
					",'searchGroupId' : " + options.searchGroupId + "}";
				break;

			case "productcompressiongroup":
				urlString = VP.AjaxWebServiceUrl + "/GetProductCompressionGroupSiteIdPageSizePageIndex";
				dataString = "{'siteId' :" + options.siteId + ", 'pageIndex' : " + currentPage + ", 'pageSize' :" + options.pageSize + "}";
				break;

			case "site":
				urlString = VP.AjaxWebServiceUrl + "/GetSiteListBySiteIdPageSizePageIndex";
				dataString = "{'siteId' :" + options.siteId + ", 'pageIndex' : " + currentPage + ", 'pageSize' :" + options.pageSize + "}";
				break;

			case "forumtopic":
				urlString = VP.AjaxWebServiceUrl + "/GetForumTopicsBySiteIdPageIndexPageSize";
				dataString = "{'siteId' :" + options.siteId + ", 'pageIndex' : " + currentPage + ", 'pageSize' :" + options.pageSize + "}";
				break;

			case "forumthread":
				urlString = VP.AjaxWebServiceUrl + "/GetForumThreadsBySiteIdPageIndexPageSize";
				dataString = "{'siteId' :" + options.siteId + ", 'pageIndex' : " + currentPage + ", 'pageSize' :" + options.pageSize + "}";
				break;

		}

		var ajaxRequestString = { url: urlString, data: dataString };
		return ajaxRequestString;
	}

	function getAutoCompleteAjaxRequestStrings(options, requestString) {
		var urlString;
		var dataString;
		var conType;
		var categoryId = null;

		var request = encodeURIComponent(requestString).replace("'", "%27");
		request = request.replace("'-", "%27-");
		request = request.replace(")'", "%29%27");
		request = request.replace("')", "%27%29");
		request = request.replace("('", "%28%27");

		if (options.externalType === "true") {
			if (typeof options.typeElement === "undefined") {
				conType = options.contentType;
			}
			else {
				conType = $('option:selected', options.typeElement).text();
			}
		}
		else {
			conType = options.type;
		}

		switch (conType.toLowerCase()) {
			case "category":				
				
				var categoryType = "";
				var categoryTypes = "";
				var productType = "";
				if (options.categoryType !== null && options.productType === null) {
					categoryType = options.categoryType;
					dataString = "{'siteId' :" + options.siteId + ",'contentType' : '" + conType + "', 'searchText' : '" + request + "','categoryType' : '" + categoryType + "', 'enabled' :" + options.enabled + ", 'vendorId' :" + options.vendorId + "}";
					urlString = VP.AjaxWebServiceUrl + "/GetCategoryAutoCompleteResults";
				}
				else if (options.categoryTypes !== null) {
					categoryTypes = options.categoryTypes;
					dataString = "{'siteId' :" + options.siteId + ",'contentType' : '" + conType + "', 'searchText' : '" + request + "','categoryTypes' : '" + categoryTypes + "','productType' : '" + productType + "', 'enabled' :" + options.enabled + ", 'vendorId' :" + options.vendorId + "}";
					urlString = VP.AjaxWebServiceUrl + "/GetCategoryAutoCompleteResultsByCategoryTypes";
				}
				else if (options.categoryType !== null && options.productType !== null) {
					productType = options.productType;
					categoryType = options.categoryType;
					dataString = "{'siteId' :" + options.siteId + ",'contentType' : '" + conType + "', 'searchText' : '" + request + "','categoryType' : '" + categoryType + "','productType' : '" + productType + "', 'enabled' :" + options.enabled + ", 'vendorId' :" + options.vendorId + "}";
					urlString = VP.AjaxWebServiceUrl + "/GetCategoryAutoCompleteResultsWithProductType";
				} else if (options.showFilters) {
					dataString = "{'siteId' :" + options.siteId + ",'contentType' : '" + conType + "', 'searchText' : '" + request + "', 'enabled' :" + options.isEnabledSelected + ", 'vendorId' :" + options.vendorId + ", 'categoryTypeIds':" + JSON.stringify(options.catTypes) + ", 'isFlat' : " + options.isLeafTypeFlatSelected + ", 'isSearch':" + options.isLeafTypeSearchSelected + ", 'isAutoGenerated': " + options.isLeafTypeAutoGeneratedSelected + "}";
					urlString = VP.AjaxWebServiceUrl + "/GetContentAutoCompleteResultsForCategories";
				}
				else {				
					dataString = "{'siteId' :" + options.siteId + ",'contentType' : '" + conType + "', 'searchText' : '" + request + "', 'enabled' :" + options.enabled + ", 'vendorId' :" + options.vendorId + "}";
					urlString = VP.AjaxWebServiceUrl + "/GetContentAutoCompleteResults";					
				}

				break;

			case "product":
				if (options.categoryTypeElementId !== null) {
					if ($("input[type=text][id*=" + options.categoryTypeElementId + "]").val() > 0) {
						categoryId = $("input[type=text][id*=" + options.categoryTypeElementId + "]").val();
						if (isNaN(categoryId)) {
							categoryId = null;
						}
					}
				}

				if (categoryId != null) {
					if (options.displayProductStatus == true) {
						urlString = VP.AjaxWebServiceUrl + "/GetCategoryProductAutoCompleteResultsByStatus";
						dataString = "{'siteId' :" + options.siteId + ",'contentType' : '" + conType + "', 'searchText' : '" + request + "','categoryId' : " + categoryId + ", 'enabled' :" + options.enabled + ", 'status' :'" + options.status + "'}";
					}
					else {
						urlString = VP.AjaxWebServiceUrl + "/GetProductAutoCompleteResults";
						dataString = "{'siteId' :" + options.siteId + ",'contentType' : '" + conType + "', 'searchText' : '" + request + "','categoryId' : " + categoryId + ", 'enabled' :" + options.enabled + ", 'excludeParent' :" + options.excludeParent + ", 'excludeParentChild' :" + options.excludeParentChild + ", 'vendorId' :" + options.vendorId + "}";
					}
				}
				else {
					if (options.displayProductStatus == true) {
						urlString = VP.AjaxWebServiceUrl + "/GetProductAutoCompleteResultsByStatus";
						dataString = "{'siteId' :" + options.siteId + ",'contentType' : '" + conType + "', 'searchText' : '" + request + "', 'enabled' :" + options.enabled + ", 'status' :'" + options.status + "}";
					}
					else {
						urlString = VP.AjaxWebServiceUrl + "/GetProductAutoCompleteResults";
						dataString = "{'siteId' :" + options.siteId + ",'contentType' : '" + conType + "', 'searchText' : '" + request + "','categoryId' : " + categoryId + ", 'enabled' :" + options.enabled + ", 'excludeParent' :" + options.excludeParent + ", 'excludeParentChild' :" + options.excludeParentChild + ", 'vendorId' :" + options.vendorId + "}";
					}
				}
				break;

			case "vendor":
				urlString = VP.AjaxWebServiceUrl + "/GetVendorContentAutoCompleteResults";
				dataString = "{'siteId' :" + options.siteId + ",'contentType' : '" + conType + "', 'searchText' : '" + request + "', 'enabled' :" + options.enabled + ", 'parentVendorOnly' :" + options.parentVendorOnly + "}";
				break;

			case "article":
				if (options.crossPostedArticles && VP.SiteId != options.siteId) {
					urlString = VP.AjaxWebServiceUrl + "/GetSearchedCrossPostedArticles";
					dataString = "{'siteId' : " + VP.SiteId + ", 'targetSiteId' : " + options.siteId + ", 'searchText' : '" + request +
						"'}";
				}
				else {
					urlString = VP.AjaxWebServiceUrl + "/GetArticleAutoCompleteResults";
					dataString = "{'siteId' :" + options.siteId + ",'contentType' : '" + conType + "', 'searchText' : '" + request +
						 "','isArticleTemplate' : '" + options.isArticleTemplate + "','articleTypeId' : '" + options.articleTypeId + "','publishedOnly' : '" + options.publishedOnly + "', 'vendorId' : " + options.vendorId + "}";
				}
				break;

			case "page":
				urlString = VP.AjaxWebServiceUrl + "/GetContentAutoCompleteResults";
				dataString = "{'siteId' :" + options.siteId + ",'contentType' : '" + conType + "', 'searchText' : '" + request + "', 'enabled' :" + null + ", 'vendorId' :" + options.vendorId + "}";
				break;

			case "campaign":
				var campaignTypeId = null;
				if (options.campaignTypeElementId !== null) {
					if ($("#" + options.campaignTypeElementId + " option:selected").val() != -1) {
						campaignTypeId = $("#" + options.campaignTypeElementId + " option:selected").val()
					}
				}

				if (campaignTypeId != null) {
					urlString = VP.AjaxWebServiceUrl + "/GetCampaignAutoCompleteResults";
					dataString = "{'siteId' :" + options.siteId + ",'contentType' : '" + conType +
							"', 'searchText' : '" + request + "', 'campaignTypeId' : " + campaignTypeId + ", 'enabled' :" + options.enabled + "}";
				}
				else {
					urlString = VP.AjaxWebServiceUrl + "/GetContentAutoCompleteResults";
					dataString = "{'siteId' :" + options.siteId + ",'contentType' : '" + conType + "', 'searchText' : '" + request + "', 'enabled' :" + options.enabled + ", 'vendorId' :" + options.vendorId + "}";
				}
				break;

			case "file":
				urlString = VP.AjaxWebServiceUrl + "/GetContentAutoCompleteResults";
				dataString = "{'siteId' :" + options.siteId + ",'contentType' : '" + conType + "', 'searchText' : '" + request + "', 'enabled' :" + null + ", 'vendorId' :" + options.vendorId + "}";
				break;

			case "article type":
			case "specificationtype":
			case "tag":
			case "productcompressiongroup":
			case "site":
			case "forumtopic":
			case "forumthread":
				urlString = VP.AjaxWebServiceUrl + "/GetContentAutoCompleteResults";
				dataString = "{'siteId' :" + options.siteId + ",'contentType' : '" + conType + "', 'searchText' : '" + request + "', 'enabled' :" + null + ", 'vendorId' :" + options.vendorId + "}";
				break;

			case "search option":
				urlString = VP.AjaxWebServiceUrl + "/GetSearchOptionsAutoCompleteResults";
				dataString = "{'siteId' :" + options.siteId + ",'contentType' : '" + conType + "', 'searchText' : '" + request + "', 'searchGroupId' :" + options.searchGroupId + "}";
				break;
		}

		var ajaxRequestString = { url: urlString, data: dataString };
		return ajaxRequestString;
	}

	function getFixUrl(contentType, contentId) {
		var fixUrl = null;
		$.ajax({
			type: "POST",
			async: false,
			cache: false,
			url: VP.AjaxWebServiceUrl + "/GetFixUrlByContentTypeContentId",
			data: "{'contentType' :'" + contentType + "', 'contentId' : '" + contentId + "'}",
			contentType: "application/json; charset=utf-8",
			dataType: "json",
			success: function (data) {
				fixUrl = data.d;
			},
			error: function (XMLHttpRequest, textStatus, errorThrown) {
				var error = XMLHttpRequest;
			}
		});

		return fixUrl;
	}

	function manupilateBindings(element, bindingDetail) {
		var bindingList = _hash[element.data("eId")].o.bindings;

		for (var binding in bindingList) {
			if (bindingList[binding]) {
				switch (binding.toLowerCase()) {
					case "fixurl":
						$("[id*=" + bindingList[binding] + "]").val(bindingDetail.url);
						break;

					case "fixurlid":
						$("[id*=" + bindingList[binding] + "]").val(bindingDetail.id);
						break;

					case "contentname":
						$("[id*=" + bindingList[binding] + "]").val(bindingDetail.name);
						break;

					case "contentid":
						$("[id*=" + bindingList[binding] + "]").val(bindingDetail.id);
						break;

					case "contenttype":
						$("[id*=" + bindingList[binding] + "]").val(bindingDetail.id);
						break;
				}
			}
		}
	}

	function createArticleTypeTab(element, options) {
		var articleTypeList;
		_activeElement = element;
		var container = $("#cpp_tabArticleType");
		container.contents().remove();
		if (container.contents().length == 0) {
			$.ajax({
				type: "POST",
				async: false,
				cache: false,
				url: VP.AjaxWebServiceUrl + "/GetArticleTypes",
				data: "{'siteId' :'" + options.siteId + "'}",
				contentType: "application/json; charset=utf-8",
				dataType: "json",
				success: function (data) {
					articleTypeList = data.d;
				},
				error: function (XMLHttpRequest, textStatus, errorThrown) {
					var error = XMLHttpRequest;
				}
			});
		}


		if (articleTypeList) {
			var html = "<div id='cppArticleTypeWindow'><select id='cppArticleTypeSelect'>";
			html += "<option value='" + 0 + "'>" + "All" + "</option>"
			for (var index = 0; index < articleTypeList.length; index++) {
				html += "<option value='" + articleTypeList[index].Id + "'>" + articleTypeList[index].Name + "</option>"
			}
			html += "</select></div>";

			container.append(html);
			options.articleTypeId = 0;
		}

		$("#cppArticleTypeSelect").change(function () {
			options.articleTypeId = parseInt($(this).val(), 10);
			$("#cpp_tabAutoComplete").empty();
			$("#cpp_tabContentGrid").empty();
			refreshSelectedTab(element);
		});
	}

	function createSearchGroupTab(element, options) {
		var searchGroupList;
		_activeElement = element;
		var container = $("#cpp_tabSearchOption");
		if (container.contents().length == 0) {
			$.ajax({
				type: "POST",
				async: false,
				cache: false,
				url: VP.AjaxWebServiceUrl + "/GetSearchGroups",
				data: "{'siteId' :'" + options.siteId + "'}",
				contentType: "application/json; charset=utf-8",
				dataType: "json",
				success: function (data) {
					searchGroupList = data.d;
				},
				error: function (XMLHttpRequest, textStatus, errorThrown) {
					var error = XMLHttpRequest;
				}
			});
		}

		if (searchGroupList) {
			var html = "<div id='cppSearchGroupWindow'><select id='cppSearchGroupSelect'>";
			html += "<option value='" + 0 + "'>" + "All" + "</option>"
			for (var index = 0; index < searchGroupList.length; index++) {
				html += "<option value='" + searchGroupList[index].Id + "'>" + searchGroupList[index].Name + "</option>"
			}
			html += "</select></div>";

			container.append(html);
		}

		$("#cppSearchGroupSelect").find("option[value='" + options.searchGroupId + "']").attr("selected", "selected");

		$("#cppSearchGroupSelect").change(function () {
			options.searchGroupId = parseInt($(this).val(), 10);
			$("#cpp_tabAutoComplete").empty();
			$("#cpp_tabContentGrid").empty();
			refreshSelectedTab(element);
		});
	}

	var _count = 0, _hash = $.contentPicker.hash, _activeElement = null, _contentPickerDisplay = false;

})(jQuery);