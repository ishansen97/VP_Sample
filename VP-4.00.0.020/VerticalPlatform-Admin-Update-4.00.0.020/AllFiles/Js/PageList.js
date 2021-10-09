(function ($) {

	$.fn.displayPageList = function (options) {
		return this.each(function () {
			$.pageList.initPageList(this);
			$.pageList.bindPages();
		});
	};

	$.pageList = {
		initPageList: function (pageListDiv) {
			_controlDiv = $("#" + pageListDiv.id);
			_pageTree = $(".PageTree", _controlDiv);
			_messageLable = $(".lblSuccessMessage", _controlDiv);

			_pageTree.tree({
				callback: {
					onselect: function () {
						$.notify({ message: "Press 'ALT' key to scroll the page.", type: "info" });
						setCloneButtonPageId();
						enablePageModifications();
					},
					onmove: function (node, refNode, type, treeObj, rb) {
						if (!confirm("Are you sure you want to move this page?")) {
							createStructuredPageTreeview();
						}
						else {
							pageMoved(node, refNode, type);
							savePageList();
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
						draggable: true,
						valid_children: ["page"],
						icon: {
							image: _pageIcon
						}
					}
				}
			});
		},
		bindPages: function () {
			getPageList();
			createStructuredPageTreeview();

			$(".btnMoveUp", _controlDiv).click(function () {
				moveUp();
			});

			$(".btnMoveDown", _controlDiv).click(function () {
				moveDown();
			});

			$(".btnMoveRight", _controlDiv).click(function () {
				moveRight();
			});

			$(".btnMoveLeft", _controlDiv).click(function () {
				moveLeft();
			});

			$(".btnDelete", _controlDiv).click(function () {
				return confirm("Are you sure you want to delele this page?");
			});

		}
	};

	function getPageList() {
		$.ajax({
			type: "POST",
			async: false,
			cache: false,
			url: VP.AjaxWebServiceUrl + "/GetSitePages",
			data: "{'siteId' : " + VP.SiteId + "}",
			contentType: "application/json; charset=utf-8",
			dataType: "json",
			success: function (msg) {
				_sitePages = msg.d;
			},
			error: function (xmlHttpRequest, textStatus, errorThrown) {
				document.location("../Error.aspx");
			}
		});
	}

	function createStructuredPageTreeview() {
		$.ajax({
			type: "POST",
			async: false,
			cache: false,
			url: VP.AjaxWebServiceUrl + "/GetOrganizedSitePages",
			data: "{'siteId' : " + VP.SiteId + "}",
			contentType: "application/json; charset=utf-8",
			dataType: "json",
			success: function (msg) {
				_structuredPages = msg.d;
				createPageTree();
			},
			error: function (xmlHttpRequest, textStatus, errorThrown) {
				document.location("../Error.aspx");
			}
		});
	}

	function createPageTree() {
		if (_structuredPages !== null && _structuredPages.UIPageList.length > 0) {

			_pageTree.empty();
			_pageTree[0].innerHTML = "<ul class=\"pageTree\"></ul>";

			for (var index = 0; index < _structuredPages.UIPageList.length; index++) {

				var UIPage = _structuredPages.UIPageList[index];
				var pageNode = $.tree.focused().create({ data: { title: getPageTitle(UIPage.PageName, UIPage.PageId), attributes: { "class": "pageNode"} },
					attributes: { "id": "page_" + UIPage.PageId, "rel": "page" }
				}, -1);
				$.data(pageNode[0], "pageId", UIPage.PageId);
				$.data(pageNode[0], "parentPageId", null);

				if (UIPage.ChildPages !== null || UIPage.ChildPages.length !== 0) {
					addChildPages(UIPage, UIPage.ChildPages);
				}
			}
		}
	}

	function getPageTitle(pageName, pageId){
		return pageName + "( Id: " + pageId + ")";
	}

	function addChildPages(parentPage, childPageList) {
		for (var index = 0; index < childPageList.length; index++) {
			var UIPage = childPageList[index];
			if (parentPage !== null || parentPage !== 'undefined') {
				var pageNode = $.tree.focused().create({ data: { title: getPageTitle(UIPage.PageName, UIPage.PageId), attributes: { "class": "pageNode"} },
					attributes: { "id": "page_" + UIPage.PageId, "rel": "page" }
				}, "#page_" + parentPage.PageId);

				$.data(pageNode[0], "pageId", UIPage.PageId);
				$.data(pageNode[0], "parentPageId", UIPage.ParentPageId);

				if (UIPage.ChildPages !== null || UIPage.ChildPages.length !== 0) {
					addChildPages(UIPage, UIPage.ChildPages);
				}
			}
		}
	}

	function enablePageModifications() {
		var selectedNode = $.tree.focused();
		var selectedPageId = $.data(selectedNode.selected[0], "pageId");
		$("input[id$='hdnPageId']").val(selectedPageId);
		$(".btnEdit").removeAttr("disabled");
		$(".btnDelete").removeAttr("disabled");
		$(".btnMoveUp").removeAttr("disabled");
		$(".btnMoveDown").removeAttr("disabled");
		$(".btnMoveLeft").removeAttr("disabled");
		$(".btnMoveRight").removeAttr("disabled");
		$(".btnClone").removeAttr("disabled");
		$(".btnClone").addClass("aDialog");
		$("#popupDialog").jqmAddTrigger('.aDialog');
	}

	function savePageList() {
		_messageLable.text("Saving...");
		_messageLable.show();

		var pageData = $.toJSON(_sitePages);
		$.ajax({
			type: "POST",
			async: false,
			cache: false,
			url: VP.AjaxWebServiceUrl + "/SavePageList",
			data: "{'pages' : " + pageData + "}",
			contentType: "application/json; charset=utf-8",
			dataType: "json",
			success: function (msg) {
				_messageLable.text("Saved.");
				_messageLable.fadeOut(2500);
			},
			error: function (xmlHttpRequest, textStatus, errorThrown) {
				document.location("../Error.aspx");
			}
		});
	}

	function getSelectedNodeData(node, data) {
		return $.data(node.selected[0], data);
	}

	function pageMoved(page, refPage, position) {
		var refPageId = $.data(refPage, "pageId");
		var movedPageId = $.data(page, "pageId");

		var reorderedPageList = $.grep(_sitePages.UIPageList, function (page) {
			return page.PageId !== movedPageId;
		});

		var newPageIndex = getPageIndex(reorderedPageList, refPageId);
		var movedPageIndex = getPageIndex(_sitePages.UIPageList, movedPageId);
		var movedPage = _sitePages.UIPageList[movedPageIndex];

		if (position == "inside") {
			movedPage.ParentPageId = refPageId;
		}
		else {
			movedPage.ParentPageId = $.data(refPage, "parentPageId");
		}

		$.data(page, "parentPageId", movedPage.ParentPageId);

		if (position == "after" || position == "inside") {
			newPageIndex = newPageIndex + 1;
		}

		reorderedPageList.splice(newPageIndex, 0, movedPage);

		_sitePages.UIPageList = reorderedPageList;
	}

	function getPageIndex(pageList, pageId) {
		for (var index = 0; index < pageList.length; index++) {
			var verticlePage = pageList[index];
			if (verticlePage.PageId == pageId) {
				return index;
			}
		}
	}

	function moveUp() {
		var pageId = getSelectedNodeData($.tree.focused(), "pageId");
		var pageIndex = getPageIndex(_sitePages.UIPageList, pageId);

		var movedPage = _sitePages.UIPageList[pageIndex];
		var parentPageId = movedPage.ParentPageId;
		var insertIndex = -1;

		for (index = (pageIndex - 1); index > 0; index--) {
			if (_sitePages.UIPageList[index].ParentPageId == parentPageId) {
				insertIndex = index;
				break;
			}
		}

		insertPage(insertIndex, movedPage);
	}

	function moveDown() {
		var pageId = getSelectedNodeData($.tree.focused(), "pageId");
		var pageIndex = getPageIndex(_sitePages.UIPageList, pageId);

		var movedPage = _sitePages.UIPageList[pageIndex];
		var parentPageId = movedPage.ParentPageId;
		var insertIndex = -1;

		for (index = (pageIndex + 1); index < _sitePages.UIPageList.length; index++) {
			if (_sitePages.UIPageList[index].ParentPageId == parentPageId) {
				insertIndex = index;
				break;
			}
		}

		insertPage(insertIndex, movedPage);
	}

	function moveRight() {
		var pageId = getSelectedNodeData($.tree.focused(), "pageId");
		var pageIndex = getPageIndex(_sitePages.UIPageList, pageId);

		var movedPage = _sitePages.UIPageList[pageIndex];
		var insertIndex = -1;

		for (index = (pageIndex - 1); index > 0; index--) {
			if (_sitePages.UIPageList[index].ParentPageId == movedPage.ParentPageId) {
				movedPage.ParentPageId = _sitePages.UIPageList[index].PageId;
				insertIndex = index + 1;
				break;
			}
		}

		insertPage(insertIndex, movedPage);
	}

	function moveLeft() {
		var pageId = getSelectedNodeData($.tree.focused(), "pageId");
		var pageIndex = getPageIndex(_sitePages.UIPageList, pageId);

		var movedPage = _sitePages.UIPageList[pageIndex];
		var startIndex = -1;
		var insertIndex = -1;

		for (index = (pageIndex - 1); index > 0; index--) {
			if (_sitePages.UIPageList[index].PageId == movedPage.ParentPageId) {
				movedPage.ParentPageId = _sitePages.UIPageList[index].ParentPageId;
				startIndex = index + 1;
				break;
			}
		}

		if (startIndex !== -1) {
			for (index = startIndex; index < _sitePages.UIPageList.length; index++) {
				if (_sitePages.UIPageList[index].ParentPageId == movedPage.ParentPageId) {
					insertIndex = index;
					break;
				}
			}
		}

		insertPage(insertIndex, movedPage);
	}

	function insertPage(insertIndex, movedPage) {
		if (insertIndex !== -1) {
			var reorderedPages = $.grep(_sitePages.UIPageList, function (page) {
				return page.PageId !== movedPage.PageId;
			});

			reorderedPages.splice(insertIndex, 0, movedPage);

			_sitePages.UIPageList = reorderedPages;
			savePageList();
			createStructuredPageTreeview();

			$.tree.focused().select_branch("#page_" + movedPage.PageId);
		}
	}

	function setCloneButtonPageId() {
		var selectedNode = $.tree.focused();
		var selectedPageId = $.data(selectedNode.selected[0], "pageId");
		var cloneButton = $(".btnClone");
		cloneButton.attr("href", getUpdatedQueryStringParameter(cloneButton.attr("href"), "pid", selectedPageId));
	}

	function getUpdatedQueryStringParameter(uri, key, value) {
		var re = new RegExp("([?|&])" + key + "=.*?(&|$)", "i");
		var separator = uri.indexOf('?') !== -1 ? "&" : "?";
		if (uri.match(re)) {
			return uri.replace(re, '$1' + key + "=" + value + '$2');
		}
		else {
			return uri + separator + key + "=" + value;
		}
	}

	//Globals
	var _pageIcon = "../App_Themes/Default/Images/page_white.png";
	var _structuredPages = [], _sitePages = [];
	var _controlDiv = null;

})(jQuery);