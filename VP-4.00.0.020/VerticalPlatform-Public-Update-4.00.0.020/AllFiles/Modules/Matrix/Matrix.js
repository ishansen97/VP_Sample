
RegisterNamespace("VP.VerticalMatrix");

var MatrixList = [];
var ColumnBasedVerticalMatrix = 2;
VP.VerticalMatrix.compareMatrixPageUrl = "";
VP.VerticalMatrix.SelectAllText = "";
VP.VerticalMatrix.SelectNoneText = "";
VP.VerticalMatrix.LeadFormUrlForAll = "";
VP.VerticalMatrix.LeadFormUrlForSelected = "";
VP.VerticalMatrix.ContentIdParameter = "";
VP.VerticalMatrix.VerticalMatrixPageUrl = "";
VP.VerticalMatrix.ItemNameSortDisplayName = "";
VP.VerticalMatrix.ItemNameSortText = "";
VP.VerticalMatrix.CompanyNameSortDisplayName = "";
VP.VerticalMatrix.CompanyNameSortText = "";
VP.VerticalMatrix.PriceSortDisplayName = "";
VP.VerticalMatrix.PriceSortText = "";
VP.VerticalMatrix.RelevancySortDisplayName = "";
VP.VerticalMatrix.RelevancySortText = "";
VP.VerticalMatrix.CategoryId = "";
VP.VerticalMatrix.MatrixImageToSupplierPage = "";


VP.VerticalMatrix = function (matrixContentId) {
  this.matrixContentId = matrixContentId;
  this.matrixContent = "";
  this.checkboxList = "";
  this.leadEnableCheckboxList = "";
  this.requestInfoButtons = "";
  this.selectAllButtons = "";
  this.dropDownSelectedValue = "";
  this.requestInfoLinks = "";
  this.pageIndexParameter = "";
  this.selectedProducts = [];
  this.selectedProductPositions = [];
  this.directClickThrough = false;
  this.primaryLeadFormButtonText = "";
  this.primaryLeadFormButtonText = "";
  this.directClickThroughButtonText = "";
  this.requestSelectedInfoButtonText = "";
  this.selectedLeadEnabledProducts = [];
  this.selectedFeaturedProducts = [];
  this.selectedLeadEnableParameter = "";
  this.selectedProductsParameter = "";
  this.selectedProductPositionParameter = "";
  this.selectedFeaturedProductsParameter = "";
  this.sortByKey = "";
};

VP.VerticalMatrix.prototype.Expand = function (row) {
  var that = this;
  if (!$(row).hasClass("expanded")) {
    $(row).addClass("expanded");
    var url = $(row).attr('href');
    var id = $(row).attr('id');
    var args = id.split('_');
    var childProductIds = "";
    if (args.length > 5) {
      childProductIds = args[5];
    }

    $.ajax({
      type: "POST",
      async: false,
      cache: false,
      url: url,
      data: "{'categoryId' : " + args[0] +
				", 'productId' : " + args[1] +
				", 'groupId' : " + args[2] +
				", 'moduleInstanceId' : " + args[3] +
				", 'matrixType' : " + args[4] +
				", 'childProductIds' : '" + childProductIds + "'" +
				"}",
      contentType: "application/json; charset=utf-8",
      dataType: "json",
      success: function (msg) {
        var html = msg.d;
        $(row).parent().append(html);

        that.checkboxList = $("input:checkbox.action", that.matrixContent);
        $(that.checkboxList).unbind('click').bind('click', function (event) {
          that.AddRemoveProduct($(this));
        });

        var ratingControls = $('.ratingControl', that.matrixContent);
        VP.VerticalMatrix.RenderRatingControl(ratingControls);
      },
      error: function (xmlHttpRequest, textStatus, errorThrown) {
        var message = "";
      }
    });
  } else {
    $(row).siblings().slideToggle("slow");
  }
};

VP.VerticalMatrix.prototype.ExpandMoreVersions = function (row) {
  var that = this;
  var expandContainer = $(row).parent().parent();
  var url = $(row).attr('href');
  var id = $(row).attr('id');
  var args = id.split('_');
  var isInColumnBasedVerticalMatrix = (args[4] == ColumnBasedVerticalMatrix);

  if ((!expandContainer.next().hasClass("compressionRow") && isInColumnBasedVerticalMatrix)
				|| (!expandContainer.next().hasClass("compGroups") && !isInColumnBasedVerticalMatrix)) {
    $(row).addClass("expanded");
    $(row).parent().parent().addClass("expanded");
    $.ajax({
      type: "POST",
      async: false,
      cache: false,
      url: url,
      data: "{'categoryId' : " + args[0] +
				", 'parentProductId' : " + args[1] +
				", 'rowIndex' : " + args[2] +
				", 'moduleInstanceId' : " + args[3] +
				", 'matrixType' : " + args[4] +
				", 'searchOptionIds' : '" + args[5] + "'" +
				", 'searchText' : '" + args[6] + "'}",
      contentType: "application/json; charset=utf-8",
      dataType: "json",
      success: function (msg) {
        var html = msg.d;

        expandContainer.after(html);

        that.checkboxList = $("input:checkbox.action", that.matrixContent);

        $(".expandGroup", that.matrixContent).unbind('click').bind('click', function (event) {
          event.preventDefault();
          that.Expand(this);
          return false;
        });

        var ratingControls = $('.ratingControl', that.matrixContent);
        VP.VerticalMatrix.RenderRatingControl(ratingControls);

        $(that.checkboxList).unbind('click').bind('click', function (event) {
          that.AddRemoveProduct($(this));
        });

        VP.VerticalMatrix.prototype.SetShowMoreVersionsText(row);

        if (isInColumnBasedVerticalMatrix) {
          $(".compressedProductRow > td.title", that.matrixContent).unbind('click').bind('click', function (event) {
            event.preventDefault();
            $(this).parent().nextUntil("tr.compressedProductRow:has(>td.title)").slideToggle("slow");
            return false;
          });
        }
      },
      error: function (XMLHttpRequest, textStatus, errorThrown) {
        var message = "";
      }
    });
  } else {
    expandContainer.next().slideToggle("slow");

    VP.VerticalMatrix.prototype.SetShowMoreVersionsText(row);

    $(row).toggleClass("expanded");
    $(row).parent().parent().toggleClass("expanded");
  }
};

VP.VerticalMatrix.prototype.ExpandVendorCompressed = function (row) {
  var that = this;
  var expandContainer = $(row).parent().parent().parent();
  var url = $(row).attr('href');
  var id = $(row).attr('id');
  var args = id.split('_');
  var searchInfo = $("#hdnSearchInfo", this.matrixContent).val();
  var dataString = "{'productId' : " + args[1] +
				", 'vendorId' : " + args[2] +
				", 'rowIndex' : " + args[3] +
				", 'moduleInstanceId' : " + args[4] +
				", 'matrixType' : " + args[5] +
				", 'info' : " + JSON.stringify(searchInfo) +
				", 'rendered' : '" + args[6] + "'" +
				", 'matrixVendorPosition' : '" + args[8] + "'" +
				"}";

  if (!$(row).hasClass("expanded")) {
    $(row).addClass("expanded");
    $(row).parent().parent().addClass("expanded");
    $.ajax({
      type: "POST",
      async: false,
      cache: false,
      url: url,
      data: dataString,
      contentType: "application/json; charset=utf-8",
      dataType: "json",
      success: function (msg) {
        var html = msg.d;
        expandContainer.before(html);

        that.checkboxList = $("input:checkbox.action", that.matrixContent);
        $(that.checkboxList).unbind('click').bind('click', function (event) {
          that.AddRemoveProduct($(this));
        });

        $(row).text('- See Fewer');

        var ratingControls = $('.ratingControl', that.matrixContent);
        VP.VerticalMatrix.RenderRatingControl(ratingControls);
      },
      error: function (XMLHttpRequest, textStatus, errorThrown) {
        var message = "";
      }
    });
  } else {
    var expandedClass = "vendorExpanded" + args[2];
    $("." + expandedClass, this.matrixContent).slideToggle("slow");
    $("." + expandedClass, this.matrixContent).remove();
    $(row).toggleClass("expanded");
    $(row).parent().parent().toggleClass("expanded");
    $(row).text('+ See More (' + args[7] + ')');
  }
};

VP.VerticalMatrix.prototype.Init = function () {
  this.matrixContent = $("#" + this.matrixContentId);
  this.checkboxList = $("input:checkbox.action", this.matrixContent);
  this.requestInfoButtons = $(".btnRequestQuote", this.matrixContent);
  this.selectAllButtons = $(".selectAll", this.matrixContent);
  this.requestInfoLinks = $(".requestSelected");
  var that = this;

  $(this.checkboxList).click(function (event) {
    that.AddRemoveProduct($(this));
  });

  $(this.selectAllButtons).click(function (event) {
    that.SelectAll($(this).text());
    return false;
  });

  $(".btnRequestQuote").on('click', function (event) {
    that.RequestInfomationForMultipeProduct();
  });

  $(".requestSelected").on('click', function (event) {
    that.RequestInfomationForMultipeProduct();
  });

  $(".btnCompare", this.matrixContent).on('click', function (event) {
    that.Compare();
    return false;
  });

  $(".compare", this.matrixContent).on('click', function (event) {
    that.Compare();
    return false;
  });

  $("select.selectTop", this.matrixContent).change(function (event) {
    that.Sort($(".selectTop", that.matrixContent).val());
  });

  $("#lnkService", this.matrixContent).click(function (event) {
    that.Sort(VP.VerticalMatrix.CompanyNameSortDisplayName);
  });

  $("#lnkProduct", this.matrixContent).click(function (event) {
    that.Sort(VP.VerticalMatrix.ItemNameSortDisplayName);
  });

  $("#lnkVendor", this.matrixContent).click(function (event) {
    that.Sort(VP.VerticalMatrix.CompanyNameSortDisplayName);
  });

  $("#lnkPrice", this.matrixContent).click(function (event) {
    that.Sort(VP.VerticalMatrix.PriceSortDisplayName);
  });

  $(".pager a", this.matrixContent).click(function (event) {
    that.AddSelectedProductsToLink($(this));
  });

  $("ul.selected li", this.matrixContent).on('click', function (event) {
    var productId = $(event.currentTarget).attr('rel');
    if (productId != undefined) {
      that.checkboxList.each(function (i, domElement) {
        if ($(domElement).val() == productId) {
          $(domElement).removeAttr("checked");
        }
      });

      that.RemoveFromSelectedProducts(productId);
      that.RemoveFromSelectedProductPositions(productId);
      that.SetRequestInformationButtonData();
      that.ChangeSelectButtonText();
    }
    return false;
  });

  $("body").bind('productRemoved', function (event, parameters) {
    that.RemoveProduct(parameters);
  });

  $("body").bind('allProductsRemoved', function (event) {
    that.RemoveAllProducts();
  });

  $('.expandMore', this.matrixContent).click(function (event) {
    event.preventDefault();
    that.ExpandMoreVersions(this);
    return false;
  });

  $(".expandGroup", this.matrixContent).click(function (event) {
    event.preventDefault();
    that.Expand(this);
    return false;
  });

  $('.expandVendorCompressed', this.matrixContent).click(function (event) {
    event.preventDefault();
    that.ExpandVendorCompressed(this);
    return false;
  });

  this.LoadProductList();
  this.SetSelectedSortValue();
  this.SetCheckBoxValues();
  this.SetRequestInformationButtonData();
  this.ChangeSelectButtonText();
};

VP.VerticalMatrix.prototype.Sort = function (text) {
  var sortText;
  if (text == VP.VerticalMatrix.CompanyNameSortDisplayName) {
    sortText = VP.VerticalMatrix.CompanyNameSortText;
  }
  else if (text == VP.VerticalMatrix.PriceSortDisplayName) {
    sortText = VP.VerticalMatrix.PriceSortText;
  }
  else if (text == VP.VerticalMatrix.ItemNameSortDisplayName) {
    sortText = VP.VerticalMatrix.ItemNameSortText;
  }
  else if (text == VP.VerticalMatrix.RelevancySortDisplayName) {
    sortText = VP.VerticalMatrix.RelevancySortText;
  }
  else {
    sortText = "";
  }

  var url, urlComponents, foundPositions, foundSortBy, foundSelect, foundLeadEnable, productList, leadEnabledProductList, i,
	queryComponents;
  url = window.location.href;

  urlComponents = url.split("?");
  if (urlComponents.length > 1) {
    queryComponents = urlComponents[1].split("&");
  } else {
    queryComponents = new Array();
  }

  foundSortBy = false;
  foundSelect = false;
  foundLeadEnable = false;
  foundFeatured = false;
  productList = this.GetCommaSeperatedProductIdList(false);
  productPositionList = this.GetCommaSeperatedProductPositionList();
  leadEnabledProductList = this.GetCommaSeperatedProductIdList(true);
  featuredProductList = this.GetCommaSeperatedFeaturedProductIdList();

  for (i = 0; i < queryComponents.length; i++) {
    if (queryComponents[i].indexOf(this.sortByKey) >= 0) {
      queryComponents[i] = this.sortByKey + "=" + sortText;
      foundSortBy = true;
    }
    if (queryComponents[i].indexOf(this.selectedProductsParameter) >= 0) {
      queryComponents[i] = this.selectedProductsParameter + "=" + productList;
      foundSelect = true;
    }
    if (queryComponents[i].indexOf(this.selectedLeadEnableParameter) >= 0) {
      queryComponents[i] = this.selectedLeadEnableParameter + "=" + leadEnabledProductList;
      foundLeadEnable = true;
    }
    if (queryComponents[i].indexOf(this.selectedProductPositionParameter) >= 0) {
      queryComponents[i] = this.selectedProductPositionParameter + "=" + productPositionList;
      foundPositions = true;
    }
    if (queryComponents[i].indexOf(this.selectedFeaturedProductsParameter) >= 0) {
      queryComponents[i] = this.selectedFeaturedProductsParameter + "=" + featuredProductList;
      foundFeatured = true;
    }
  }

  if (!foundSortBy) {
    queryComponents.push(this.sortByKey + "=" + sortText);
  }
  if (!foundSelect && productList != "") {
    queryComponents.push(this.selectedProductsParameter + "=" + productList);
  }
  if (!foundLeadEnable && leadEnabledProductList != "") {
    queryComponents.push(this.selectedLeadEnableParameter + "=" + leadEnabledProductList);
  }
  if (!foundPositions && productPositionList != "") {
    queryComponents.push(this.selectedProductPositionParameter + "=" + productPositionList);
  }
  if (!foundFeatured && featuredProductList != "") {
    queryComponents.push(this.selectedFeaturedProductsParameter + "=" + featuredProductList);
  }

  location.href = urlComponents[0] + "?" + queryComponents.join("&");
};

VP.VerticalMatrix.prototype.GetPageIndex = function () {
  var pageIndex = 1;
  var query = location.search.substring(1);
  if (query != "") {
    var queryParameters = query.split('&');
    for (var i = 0; i < queryParameters.length; i++) {
      var keyValue = queryParameters[i].split('=');
      var nameValue = keyValue[0].split('_');
      if (nameValue[0] == "vmpi") {
        pageIndex = keyValue[1];
        break;
      }
    }
  }

  return pageIndex;
};

VP.VerticalMatrix.prototype.SetShowMoreVersionsText = function (showMoreLink) {

  var regexIsLowerCase = new RegExp('^(?=.*[a-z])');
  var linktext = $(showMoreLink).text();
  var isExpanded = (linktext.search(/more/i) == -1);
  var moreReplaceText = "More";
  var lessReplaceText = "Fewer";

  if (!linktext.match(regexIsLowerCase)) {
    moreReplaceText = moreReplaceText.toUpperCase();
    lessReplaceText = lessReplaceText.toUpperCase();
  }

  if (!isExpanded) {
    linktext = linktext.replace(moreReplaceText, lessReplaceText);
  } else {
    linktext = linktext.replace(lessReplaceText, moreReplaceText);
  }
  $(showMoreLink).text(linktext);
};

VP.VerticalMatrix.prototype.SetSelectedSortValue = function () {
    if ($("select.selectTop option[value='" + this.dropDownSelectedValue + "']").length === 1) {
        $("select.selectTop", this.matrixContent).val(this.dropDownSelectedValue);
    } else {
        $("select.selectTop", this.matrixContent).val("");
    }
};

VP.VerticalMatrix.prototype.SetCheckBoxValues = function () {
  if (this.selectedProducts.length == 0) {
    return;
  }
  var productId;

  for (var i = 0; i < this.selectedProducts.length; i++) {
    productId = this.selectedProducts[i];
    for (var j = 0; j < this.checkboxList.length; j++) {
      if ($(this.checkboxList[j]).val() == productId) {
        $(this.checkboxList[j]).attr('checked', 'checked');
      }
    }
  }
};

//Add or remove product id to list when check box is checked and unchecked.
VP.VerticalMatrix.prototype.AddRemoveProduct = function (checkBox) {
  var status = $(checkBox).prop('checked');
  var productId = $(checkBox).val();
  var featured = $(checkBox).attr("featuredProduct");
  var position = 0;

  this.checkboxList.each(function (i, domElement) {
    if ($(domElement).val() == productId) {
      position = i;
    }
  });

  if (status) {
    this.AddToSelectedProducts(productId, !$(checkBox).is('.leadDisable'));
    this.AddToSelectedProductPositions(productId, position);
    $("body").trigger("productSelected", { id: productId, actionDisabled: $(checkBox).is('.actionDisabled') });

    if (featured == "True") {
      this.AddToSelectedFeaturedProducts(productId);
    }
  }
  else {
    this.RemoveFromSelectedProducts(productId);
    this.RemoveFromSelectedProductPositions(productId);
    $("body").trigger("productDeselected", { id: productId });
    this.RemoveFromSelectedFeaturedProducts(productId);
  }
  this.SetRequestInformationButtonData();
  this.ChangeSelectButtonText();
  return true;
};

VP.VerticalMatrix.prototype.RemoveProduct = function (parameters) {
  var checkbox = $("input[value='" + parameters.id + "']", this.matrixContent);
  checkbox.prop("checked", false);
  checkbox.siblings('div').hide();
  this.RemoveFromSelectedProducts(parameters.id);
  this.RemoveFromSelectedProductPositions(parameters.id);
  this.SetRequestInformationButtonData();
  this.ChangeSelectButtonText();
};

VP.VerticalMatrix.prototype.RemoveAllProducts = function () {
  $('input:checked', this.matrixContent).each(function () {
    $(this).prop("checked", false);
    $(this).siblings('div').hide();
  });

  this.selectedProducts = [];
  this.selectedLeadEnabledProducts = [];
  this.selectedProductPositions = [];
  this.SetRequestInformationButtonData();
  this.ChangeSelectButtonText();
};

//Calls the horizontal matrix page for product comparison.
VP.VerticalMatrix.prototype.Compare = function () {
  if (this.selectedProducts.length < 2) {
    alert("Please select at least two products");
  }
  else if (this.selectedProducts.length > 5) {
    alert("No more than five items can be selected. This could happen if there are multiple item " +
			"pages and you have selected items on other pages");
  }
  else {
    var url = VP.VerticalMatrix.compareMatrixPageUrl + "&compare=" +
			VP.VerticalMatrix.GetAllSelectedProducts() + "&ppim=" +
			VP.VerticalMatrix.GetAllSelectedProductPositions(this.selectedProducts) + "&fpids=" +
			VP.VerticalMatrix.GetAllSelectedFeaturedProducts();

    location.href = url;
  }
};

//Adds the list of selected product ids to the given hyperlink object.
VP.VerticalMatrix.prototype.AddSelectedProductsToLink = function (PagerLink) {
  var url = this.AddSelectedProductsToUrl(PagerLink.attr('href'));
  PagerLink.attr('href', url);
  return true;
};

//Adds the list of selected product ids to the given url.
VP.VerticalMatrix.prototype.AddSelectedProductsToUrl = function (url) {
  var urlComponents, foundSelect, foundPositions, foundLeadEnable,
		productList, leadEnabledProductList, i, queryComponents, productPositionList;

  urlComponents = url.split("?");
  if (urlComponents.length > 1) {
    queryComponents = urlComponents[1].split("&");
  } else {
    queryComponents = new Array();
  }

  foundSelect = false;
  foundPositions = false;
  foundLeadEnable = false;
  foundFeatured = false;
  productList = this.GetCommaSeperatedProductIdList(false);
  productPositionList = this.GetCommaSeperatedProductPositionList();
  leadEnabledProductList = this.GetCommaSeperatedProductIdList(true);
  featuredProductList = this.GetCommaSeperatedFeaturedProductIdList();

  for (i = 0; i < queryComponents.length; i++) {
    if (queryComponents[i].indexOf(this.selectedProductsParameter) >= 0) {
      queryComponents[i] = this.selectedProductsParameter + "=" + productList;
      foundSelect = true;
    }
    if (queryComponents[i].indexOf(this.selectedLeadEnableParameter) >= 0) {
      queryComponents[i] = this.selectedLeadEnableParameter + "=" + leadEnabledProductList;
      foundLeadEnable = true;
    }
    if (queryComponents[i].indexOf(this.selectedProductPositionParameter) >= 0) {
      queryComponents[i] = this.selectedProductPositionParameter + "=" + productPositionList;
      foundPositions = true;
    }
    if (queryComponents[i].indexOf(this.selectedFeaturedProductsParameter) >= 0) {
      queryComponents[i] = this.selectedFeaturedProductsParameter + "=" + featuredProductList;
      foundFeatured = true;
    }
  }

  if (!foundSelect && productList != "") {
    queryComponents.push(this.selectedProductsParameter + "=" + productList);
  }
  if (!foundLeadEnable && leadEnabledProductList != "") {
    queryComponents.push(this.selectedLeadEnableParameter + "=" + leadEnabledProductList);
  }
  if (!foundPositions && productPositionList != "") {
    queryComponents.push(this.selectedProductPositionParameter + "=" + productPositionList);
  }
  if (!foundFeatured && featuredProductList != "") {
    queryComponents.push(this.selectedFeaturedProductsParameter + "=" + featuredProductList);
  }

  url = urlComponents[0] + "?" + queryComponents.join("&");
  return url;
};

//Adds to the list of selected products.
VP.VerticalMatrix.prototype.AddToSelectedProducts = function (productId, leadEnable) {
  if (!this.FoundElementInArray(this.selectedProducts, productId)) {
    this.selectedProducts.push(productId);
  }
  if (leadEnable && !this.FoundElementInArray(this.selectedLeadEnabledProducts, productId)) {
    this.selectedLeadEnabledProducts.push(productId);
  }
};

//Adds to the list of selected featured products.
VP.VerticalMatrix.prototype.AddToSelectedFeaturedProducts = function (productId) {
  if (!this.FoundElementInArray(this.selectedFeaturedProducts, productId)) {
    this.selectedFeaturedProducts.push(productId);
  }
};

VP.VerticalMatrix.prototype.AddToSelectedProductPositions = function (productId, relativePosition) {
  var pageIndex = VP.VerticalMatrix.prototype.GetPageIndex();
  var pageSize = this.checkboxList.length;
  var position = ((pageIndex * 1 - 1) * pageSize + relativePosition + 1);
  var productPosition = productId + '_' + position;
  if (!this.FoundElementInArray(this.selectedProductPositions, productPosition)) {
    this.selectedProductPositions.push(productPosition);
  }
};

//Removes the given product id from the list of selected product ids.
VP.VerticalMatrix.prototype.RemoveFromSelectedProducts = function (productId) {
  for (var i = 0; i < this.selectedProducts.length; i++) {
    if (this.selectedProducts[i] == productId) {
      this.selectedProducts.splice(i, 1);
    }
  }

  for (var i = 0; i < this.selectedLeadEnabledProducts.length; i++) {
    if (this.selectedLeadEnabledProducts[i] == productId) {
      this.selectedLeadEnabledProducts.splice(i, 1);
    }
  }
};

//Removes the given product id from the list of selected product ids.
VP.VerticalMatrix.prototype.RemoveFromSelectedFeaturedProducts = function (productId) {
  for (var i = 0; i < this.selectedFeaturedProducts.length; i++) {
    if (this.selectedFeaturedProducts[i] == productId) {
      this.selectedFeaturedProducts.splice(i, 1);
    }
  }
};

VP.VerticalMatrix.prototype.RemoveFromSelectedProductPositions = function (productId) {
  for (var i = 0; i < this.selectedProductPositions.length; i++) {
    var productIdInArray = this.selectedProductPositions[i].split('_')[0];
    if (productIdInArray == productId) {
      this.selectedProductPositions.splice(i, 1);
      break;
    }
  }
};

//Returns true if the given element value is found within the given array.
VP.VerticalMatrix.prototype.FoundElementInArray = function (array, elementValue) {
  for (var i = 0; i < array.length; i++) {
    if (array[i] == elementValue) {
      return true;
    }
  }
  return false;
};

VP.VerticalMatrix.prototype.RequestInfomationForMultipeProduct = function () {
  if (this.selectedProducts.length == 0) {
    alert("Please select at least one product");
    return false;
  }
  else if (this.selectedLeadEnabledProducts == 0) {
    alert("No valid product selected to request information.");
    return false;
  }
};

VP.VerticalMatrix.prototype.SetRequestInformationButtonData = function () {
  this.requestInfoButtons = $(".btnRequestQuote", this.matrixContent);
  this.requestInfoLinks = $(".requestSelected");

  var productSiteUrl = "";
  if (this.selectedLeadEnabledProducts.length == 0) {
    $(this.requestInfoButtons).attr('href', "#");
    $(this.requestInfoLinks).attr('href', "#");
  }
  else if (this.selectedLeadEnabledProducts.length == 1 && this.directClickThrough) {
    var vendorId = $("#" + this.selectedLeadEnabledProducts[0] + "Manufacturer").attr('rel');
    productSiteUrl = VP.VerticalMatrix.GetProductWebSiteUrl(this.selectedLeadEnabledProducts[0], vendorId);

    if (productSiteUrl != "") {
      $(this.requestInfoButtons).attr('href', productSiteUrl);
      $(this.requestInfoLinks).attr('href', productSiteUrl);
    }
  }

  if (this.selectedLeadEnabledProducts.length > 0 && productSiteUrl == "") {
    var leadFormUrl = VP.VerticalMatrix.LeadFormUrlForSelected;
    var parameter = VP.VerticalMatrix.ContentIdParameter + "=";
    var parameterWithValues = parameter + VP.VerticalMatrix.GetAllSelectedProducts();
    parameterWithValues = parameterWithValues + "&ppim=" +
			VP.VerticalMatrix.GetAllSelectedProductPositions(this.selectedLeadEnabledProducts);
    parameterWithValues = parameterWithValues + "&fpids=" +
			VP.VerticalMatrix.GetAllSelectedFeaturedProducts();

    var navigateUrl = '';
    if (leadFormUrl.indexOf(parameter) == -1) {
      navigateUrl = leadFormUrl + '&' + parameterWithValues;
    }
    else {
      navigateUrl = leadFormUrl.replace(parameter, parameterWithValues);
    }

    for (var i = 0; i < this.requestInfoButtons.length; i++) {
      $(this.requestInfoButtons[i]).attr('href', navigateUrl);
    }

    for (var j = 0; j < this.requestInfoLinks.length; j++) {
      $(this.requestInfoLinks[j]).attr('href', navigateUrl);
    }
  }

  this.SetRequestInfoButtonDisplayData(productSiteUrl);
};

//select all or none check boxes
VP.VerticalMatrix.prototype.SelectAll = function (buttonText) {
  var nextTextForButton = "";

  for (var i = 0; i < this.checkboxList.length; i++) {
    if (buttonText == VP.VerticalMatrix.SelectAllText) {
      this.checkboxList[i].checked = true;
      this.AddToSelectedProducts(this.checkboxList[i].value, !$(this.checkboxList[i]).is('.leadDisable'));
      this.AddToSelectedProductPositions(this.checkboxList[i].value, i);

      if (this.checkboxList[i].attr("featuredProduct") == "True") {
        this.AddToSelectedFeaturedProducts(this.checkboxList[i].value);
      }
    }
    else {
      this.checkboxList[i].checked = false;
      this.RemoveFromSelectedProducts(this.checkboxList[i].value);
      this.RemoveFromSelectedProductPositions(this.checkboxList[i].value);
      this.RemoveFromSelectedFeaturedProducts(this.checkboxList[i].value);
    }
  }
  this.SetRequestInformationButtonData();
  this.ChangeSelectButtonText();
};

//Change select button text according to check box selection.
VP.VerticalMatrix.prototype.ChangeSelectButtonText = function () {
  var noOfCheckedOnPage = 0;
  for (var i = 0; i < this.checkboxList.length; i++) {
    if (this.checkboxList[i].checked == true) {
      noOfCheckedOnPage = noOfCheckedOnPage + 1;
    }
  }

  if (noOfCheckedOnPage < this.checkboxList.length) {
    $(this.selectAllButtons).text(VP.VerticalMatrix.SelectAllText);
  }
  else {
    $(this.selectAllButtons).text(VP.VerticalMatrix.SelectNoneText);
  }
};

VP.VerticalMatrix.prototype.GetCommaSeperatedProductIdList = function (leadEnabledId) {
  var commaSeperatedProductIdList = "";
  var selectedProducts = [];
  if (leadEnabledId) {
    selectedProducts = this.selectedLeadEnabledProducts;
  }
  else {
    selectedProducts = this.selectedProducts;
  }

  if (selectedProducts.length > 0) {
    if (commaSeperatedProductIdList == "") {
      commaSeperatedProductIdList = selectedProducts[0];
    }
    for (var i = 1; i < selectedProducts.length; i++) {
      commaSeperatedProductIdList = commaSeperatedProductIdList + "," + selectedProducts[i];
    }
  }

  return commaSeperatedProductIdList;
};

VP.VerticalMatrix.prototype.GetCommaSeperatedFeaturedProductIdList = function () {
  var commaSeperatedProductIdList = this.selectedFeaturedProducts.join(",");
  return commaSeperatedProductIdList;
};

VP.VerticalMatrix.prototype.GetCommaSeperatedLeadEnabledProductIdList = function () {
  var commaSeperatedProductIdList = "";

  if (this.selectedProducts.length > 0) {
    if (commaSeperatedProductIdList == "") {
      commaSeperatedProductIdList = this.selectedProducts[0];
    }
    for (var i = 1; i < this.selectedProducts.length; i++) {
      commaSeperatedProductIdList = commaSeperatedProductIdList + "," + this.selectedProducts[i];
    }
  }

  return commaSeperatedProductIdList;
};

VP.VerticalMatrix.prototype.GetCommaSeperatedProductPositionList = function () {
  var commaSeperatedProductPositionList = "";
  var selectedProducts = [];
  selectedProductPositions = this.selectedProductPositions;

  if (selectedProductPositions.length > 0) {
    if (commaSeperatedProductPositionList == "") {
      commaSeperatedProductPositionList = selectedProductPositions[0];
    }
    for (var i = 1; i < selectedProductPositions.length; i++) {
      commaSeperatedProductPositionList = commaSeperatedProductPositionList + "," +
				selectedProductPositions[i];
    }
  }

  return commaSeperatedProductPositionList;
};

VP.VerticalMatrix.prototype.LoadProductList = function () {
  this.selectedProducts = VP.VerticalMatrix.GetProductListFromQueryString(this.selectedProductsParameter);
  this.selectedLeadEnabledProducts = VP.VerticalMatrix.GetLeadEnabledProductListFromQueryString(
			this.selectedLeadEnableParameter);
  this.selectedProductPositions = VP.VerticalMatrix.GetProductPositionListFromQueryString(
			this.selectedProductPositionParameter);
  this.selectedFeaturedProducts = VP.VerticalMatrix.GetFeaturedProductListFromQueryString(this.selectedFeaturedProductsParameter);

  for (var i = 0; i < this.checkboxList.length; i++) {
    var productCheckBox = $(this.checkboxList[i]);
    if (this.checkboxList[i].checked == true && $.inArray(productCheckBox.val(), this.selectedProducts) == -1) {
      this.selectedProducts.push(productCheckBox.val());
      var position = productCheckBox.val() + '_' + i;
      this.selectedProductPositions.push(position);

      if (productCheckBox.attr("featuredProduct") == "True") {
        this.selectedFeaturedProducts.push(productCheckBox.val());
      }
    }

    if (this.checkboxList[i].checked == true && !($(this.checkboxList[i]).is('.leadDisable'))
				&& $.inArray($(this.checkboxList[i]).val(), this.selectedLeadEnabledProducts) == -1) {
      this.selectedLeadEnabledProducts.push($(this.checkboxList[i]).val());
    }
  }
};

VP.VerticalMatrix.prototype.SetRequestInfoButtonDisplayData = function (productSiteUrl) {
  this.requestInfoButtons = $(".btnRequestQuote", this.matrixContent);
  this.requestInfoLinks = $(".requestSelected");

  if (this.directClickThrough && this.selectedProducts.length == 1 && productSiteUrl != "") {
    $(this.requestInfoLinks).text(this.directClickThroughButtonText);
    $(this.requestInfoLinks).attr('title', this.directClickThroughButtonText + ' for Selected Products');
    $(this.requestInfoButtons).text(this.directClickThroughButtonText);
    $(this.requestInfoButtons).attr('class', 'button first leadClickThrough');
    $(this.requestInfoButtons).attr('title', this.directClickThroughButtonText + ' for Selected Products');
  }
  else {
    $(this.requestInfoLinks).text(this.primaryLeadFormButtonText);
    $(this.requestInfoLinks).attr('title', this.primaryLeadFormButtonText + ' for Selected Products');
    $(this.requestInfoButtons).text(this.requestSelectedInfoButtonText);
    $(this.requestInfoButtons).attr('class', 'button first btnRequestQuote');
    $(this.requestInfoButtons).attr('title', this.requestSelectedInfoButtonText + ' for Selected Products');
  }
};

//-------------------------------------------------


/**
* @author Jason Roy
*/
(function ($) {
  $(document).ready(function () {
    $('.functionPanel').vpMatrixImages(
		{
		  context: $.vp.domFragments.contentPane
		});
    buildToolTip();
  });

  function buildToolTip(domElement) {
    $('.matrixModule .productRow').each(function (i, domElement) {
      if ($(domElement).find('.imageHolder').length > 0) {
        var productId = $(domElement).find('.productActions .action').attr('value');
        var titleHTML = $(domElement).find('.title h3').html();
        var productHref = $(titleHTML).attr('href');
        var titleText = $(domElement).find('.title h3').text();
        var vendor = $(domElement).find('.title h4').text();
        var related = $(domElement).find('.related').html();
        var action = $(domElement).find('.leadActions').html();
        var newImageTitle = $(domElement).find('.imageHolder a img').attr('title');
        var newImagePath = getImagePath($(domElement).find('.imageHolder a img').attr('src'));
        var newImage = '<A title="Product Name" href="#"><IMG title="' + newImageTitle + '" alt="' +
						newImageTitle + '" src="' + newImagePath + '" width=400 height=300></A>';
        var tipContent = '<div id="zoom_' + productId + '" class="zoomedContent"><div class="image">' +
						newImage +
						'</div><div class="actions module"><a class="productLink" href="' +
						productHref + '">View Details Page</a>' + action + '</div></div>';
        var textTop = "";
        if (vendor != "") {
          textTop = titleHTML + ' from ' + vendor;
        }

        if (VP.VerticalMatrix.MatrixImageToSupplierPage == "False")
        {
            $(domElement).find('.imageHolder').append('<span class="icon zoom compact">Zoom In</span>');
        }

        $(domElement).find('.imageHolder').hover(function (event) {
          $(event.currentTarget).find('.zoom').fadeIn(200);
        }, function (event) {
          $(event.currentTarget).find('.zoom').fadeOut(200);
        });
        $(domElement).find("img").qtip(
					{
					  content: {
					    title: {
					      text: textTop,
					      button: "Close"
					    },
					    text: tipContent
					  },
					  position: {
					    my: "left center",
					    at: "right center"
					  },
					  show: {
					    delay: 0,
					    solo: true,
					    event: false
					  },
					  hide: {
					    event: "unfocus"
					  },
					  style: {
					    tip: true,
                          classes: "qtip-light qtip-titlebar ui-tooltip-rounded matrix-zoom"
					  },
					  prerender: false
					});

        $(domElement).find('.zoom').click(function (event) {
          if ($("#zoom_" + productId).length == 0) {
            var newImageTitle = $(domElement).find('.imageHolder a img').attr('title');
            var newImagePath = getImagePath($(domElement).find('.imageHolder a img').attr('src'));
            var newImage = '<A title="Product Name" href="#"><IMG title="' + newImageTitle + '" alt="' +
								newImageTitle + '" src="' + newImagePath + '" width=400 height=300></A>';
            $("#zoom_" + productId).find(".image").append(newImage);
          }
          $(event.currentTarget).parents(".imageHolder").find('img').qtip("show");
        });
      }
    });
  }

  function getImagePath(rowImagePath) {
    var imageSize = "-400x300";
    var paths = rowImagePath.split('/');
    var imageNameParts = paths[paths.length - 1].split('.');
    var previousImageName = imageNameParts[0];
    var imageExtension = imageNameParts[1];
    var itemName = (previousImageName.split('-'))[0];
    var zoomImagePath = "";
    for (var i = 0; i < paths.length - 1; i++) {
      zoomImagePath = zoomImagePath + paths[i] + "/";
    }
    zoomImagePath = zoomImagePath + itemName + imageSize + "." + imageExtension;
    return zoomImagePath;
  }
})(jQuery);
//Plugin for Top and Bottom Image Lists

(function ($) {
  //Private Variables
  _options = {};
  _isFirstTime = true;
  _checkBoxes = {};
  _productList = {};
  _imageLists = {};
  _containers = {};
  _hasMessageShown = false;
  _imageCartItems = [];

  //Public functions

  vpMatrixImages = jQuery.fn.vpMatrixImages = function (options) {
    _options = $.extend({}, $.fn.vpMatrixImages.defaults, options);
    $(_options.context).find('div.productList').find(':checkbox').on('click', itemChecked);
    _productList = $(_options.context).find('div.productRow');
    $(_options.context).find('.selectAll').click(selectAllClick);
    _containers = $(this);
    setCheckBoxesForSelectedItems();
    this.each(function () {
      setupImageLists(this);
    });
    setupCheckBoxes();
    setupHintHover();
    _isFirstTime = false;
    return this;
  };

  function setupActionCheckBoxes() {
    _checkBoxes = $(_options.context).find('div.productList').find(':checkbox');
  }

  /**
	* Product List General Functions
	*/
  function setupHintHover() {
    $(_options.context).find(_options.hintSelector).css(
		{
		  'opacity': '1'
		});
  }

  //function to call when select all button is clicked
  function selectAllClick(event) {
    if ($(event.currentTarget).text() == 'Select All') {
      setupActionCheckBoxes();
      _checkBoxes.each(function (i, domElement) {
        if (_imageCartItems.length < _options.compareItemTotal && $.inArray($(domElement).val(),
						_imageCartItems) == -1) {
          addItem($(domElement).val());
        }
        else {
          if ($.vp.customMatrixAnimation) {
            $(domElement).siblings('div').animate($.vp.customMatrixAnimation.fadeIn, _options.fadeTime);
          }
          else {
            $(domElement).siblings('div').fadeIn(_options.fadeTime);
          }
        }
        if ($.inArray($(domElement).val(), _options.selectedItems) == -1) {
          _options.selectedItems.push($(domElement).val());
        }
      });
    }
    else {
      setupActionCheckBoxes();
      _checkBoxes.each(function (i, domElement) {
        removeItemFromArray($(domElement).val());
        if ($.inArray($(domElement).val(), _imageCartItems) != -1) {
          removeItem($(domElement).val());
        }
      });
    }
  }

  //Remove item from the array which store product id used in image cart
  function removeAddedImageItemFromArray(arrayElement) {
    for (var i = 0; i < _imageCartItems.length; i++) {
      if (_imageCartItems[i] == arrayElement) {
        _imageCartItems.splice(i, 1);
        return true;
      }
    }

    return false;
  }

  function setupCheckBoxes() {
    if (_options.selectedItems[0] == "") {
      return;
    }

    //initialize images
    for (var i = 0; i < _options.selectedItems.length; i++) {
      addItem(_options.selectedItems[i]);
    }
  }

  // Item Checked From Checbox
  function itemChecked(event) {
    if ($(event.currentTarget).is(':checked')) {
      addItem($(event.currentTarget).val());
      _options.selectedItems.push($(event.currentTarget).val());
    }
    else {
      removeItemFromArray($(event.currentTarget).val());
      removeItem($(event.currentTarget).val());
    }
  }

  // Add Item From Checkbox
  function addItem(productId) {
    var index;
    setupActionCheckBoxes();
    _checkBoxes.each(function (i, domElement) {
      if ($(domElement).val() === productId) {
        if ($.vp.customMatrixAnimation) {
          $(domElement).siblings('div').animate($.vp.customMatrixAnimation.fadeIn, _options.fadeTime);
        }
        else {
          $(domElement).siblings('div').fadeIn(_options.fadeTime);
        }
        index = i;
      }
    });

    if (_imageCartItems.length < _options.compareItemTotal) {
      var productName = getProductName(index, productId);
      addImage(productId, productName);
    }
    else
      if (!_isFirstTime && !_hasMessageShown) {
        showCompareMaxMessage();
      }
  }

  // Remove Item, either from the image cart or checkbox
  function removeItem(productId) {
    setupActionCheckBoxes();
    _checkBoxes.each(function (i, domElement) {
      if (Number($(domElement).val()) == productId) {
        if ($(domElement).is(':checked')) {
          $(domElement).removeAttr('checked');
        }

        if ($(".product-container").length == 0) //If not a vendor compressed row based matrix
        {
            if ($.vp.customMatrixAnimation) {
                $(domElement).siblings('div').animate($.vp.customMatrixAnimation.fadeOut, _options.fadeTime);
            }
            else {
                $(domElement).siblings('div').fadeOut(_options.fadeTime);
            }
        }     
      }
    });

    removeImage(productId);
    if (_imageCartItems.length < _options.compareItemTotal && _options.selectedItems.length >=
				_options.compareItemTotal) {
      addItem(_options.selectedItems[_options.compareItemTotal - 1]);
    }
  }

  function removeItemFromArray(arrayElement) {
    for (var i = 0; i < _options.selectedItems.length; i++) {
      if (_options.selectedItems[i] == arrayElement) {
        _options.selectedItems.splice(i, 1);
        return true;
      }
    }

    return false;
  }

  function showCompareMaxMessage() {
    alert(_options.message);
    _hasMessageShown = true;
  }

  /**
	* Availabale to each image card
	*/
  function setupImageLists(element) {
    domElement = $(element);
    domElement.data('imageList', domElement.find('ul.selected'));
    domElement.data('imageList').find('li');
    prepareRemoveButtons(domElement);
  }

  // Setup for removing item from image cart
  function prepareRemoveButtons(domElement) {
    domElement.data('imageList').find('li').on('click mouseenter mouseleave', function (event) {
      if ($(event.currentTarget).hasClass('active') > -1) {
        switch (event.type) {
          case 'click':
            removeItemFromArray($(event.currentTarget).attr('rel'));
            removeItem(Number($(event.currentTarget).attr('rel')));
            break;
          case 'mouseover':
            $(event.currentTarget).find('a.close').fadeTo(_options.fadeTime, 1);
            break;
          case 'mouseout':
            $(event.currentTarget).find('a.close').fadeTo(_options.fadeTime, 0.5);
            break;
        }
      }
    });
  }

  // Add Image from Checkboxes
  function addImage(productId, productName) {
    var imagePath = VP.VerticalMatrix.GetImagePath(productId, _options.imageExtension);
    var title = "Click to Remove " + productName;
    _containers.each(function (i, domElement) {
      $($(domElement).data('imageList').find('li:not(:has(img))')[0])
					.attr('class', 'active')
					.attr('rel', String(productId))
					.find('span')
					.append('<a href="#" class="icon compact close">Remove Item</a>')
					.append('<image src="' + imagePath + '" width="' + _options.listItemWidth + '" height="' +
					Math.round(_options.listItemWidth * 0.75) + '" style="border:none" title="' + title + '" />')
					.fadeIn(_options.fadeTime);
      if (i == 1) {
        _imageCartItems.push(productId);
      }
    });
  }

  // Remove image from checkboxes or image cart
  function removeImage(productId) {
    if (isNaN(productId)) {
      return;
    }

    _containers.each(function (i, domElement) {
      var imageElement = $(domElement).data('imageList').find('li[rel="' + productId + '"]');
      if (imageElement.length == 0) {
        return;
      }
      imageElement.animate(
			{
			  width: 0,
			  opacity: 0
			}, _options.fadeTime, function () {
			  $(this).remove();
			});
      $('<li><span></span></li>').css(
			{
			  width: 0,
			  opacity: 0
			}).appendTo($(domElement).data('imageList')).animate(
			{
			  opacity: 1,
			  width: _options.listItemWidth
			}, _options.fadeTime);

      if (i == 1) {
        removeAddedImageItemFromArray(productId);
      }
    });
  }

  function setCheckBoxesForSelectedItems() {
    var url, urlComponents, selectedProductString, selectedProducts, i;

    url = window.location;
    urlComponents = url.href.split("&");
    selectedProductString = "";
    selectedProducts = [];
    for (i = 0; i < urlComponents.length; i++) {
      if (urlComponents[i].indexOf("sel_") >= 0) {
        var items = urlComponents[i].split("=");
        selectedProductString += items[1] + ",";
      }
    }
    if (selectedProductString != "") {
      selectedProductString = selectedProductString.substring(0, selectedProductString.length - 1);
      selectedProducts = selectedProductString.split(',');
    }

    _options.selectedItems = selectedProducts;
    setupActionCheckBoxes();
    _checkBoxes.each(function (i, domElement) {
      if ($(domElement).is(':checked') && $.inArray($(domElement).val(), _options.selectedItems) == -1) {
        _options.selectedItems.push($(domElement).val());
      }

      if ($.inArray($(domElement).val(), selectedProducts) > -1) {
        $(domElement).attr('checked', 'true');
      }
    });
  }

  //Get the product name
  function getProductName(index, productId) {
    var productName;
    if (index != undefined && $((_options.context).find('.imageHolder a img')[index]).length != 0) {
      productName = $((_options.context).find('.imageHolder a img')[index]).attr('title');
    }
    else {
      $.ajax({
        type: "POST",
        async: false,
        cache: false,
        url: VP.AjaxWebServiceUrl + "/GetProductName",
        data: "{'productId' : '" + productId + "'}",
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (msg) {
          productName = msg.d;
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
          var error = XMLHttpRequest;
        }
      });
    }

    return productName;
  }

  $.fn.vpMatrixImages.defaults =
	{
	  fadeTime: 400,
	  selectedItems: [],
	  listItemWidth: 36,
	  message: "You can only select 5 items to compare, although you may request information for more than 5.  Any additional items will not be added to your compare cart.",
	  context: 'body',
	  hintSelector: '.hint',
	  productListRowSelector: 'div.productRow',
	  productActionsSelector: '.productActions div',
	  imageExtension: "-52x39.jpg",
	  compareItemTotal: 5
	};

})(jQuery);

//Get image path for given product id and image extension
VP.VerticalMatrix.GetImagePath = function (productId, imageExtension) {
  var imagePath;
  $.ajax({
    type: "POST",
    async: false,
    cache: false,
    url: VP.AjaxWebServiceUrl + "/GetMatrixRowImagePath",
    data: "{'productId' : '" + productId + "', 'imageExtension' : '" + imageExtension + "', 'categoryId' : '" + VP.VerticalMatrix.CategoryId + "'}",
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    success: function (msg) {
      imagePath = msg.d;
    },
    error: function (XMLHttpRequest, textStatus, errorThrown) {
      var error = XMLHttpRequest;
    }
  });

  return imagePath;
};

VP.VerticalMatrix.GetProductListFromQueryString = function (selectedProductsParameter) {
  var url = window.location;
  var urlComponents = url.href.split("&");
  var selectedProductString = "";
  var selectedProducts = [];
  for (var i = 0; i < urlComponents.length; i++) {
    if (urlComponents[i].indexOf(selectedProductsParameter + "=") >= 0) {
      selectedProductString = urlComponents[i].replace(selectedProductsParameter + "=", "");
    }
  }
  if (selectedProductString != "") {
    selectedProducts = selectedProductString.split(',');
  }
  return selectedProducts;
};

VP.VerticalMatrix.GetFeaturedProductListFromQueryString = function (selectedFeaturedProductsParameter) {
  var url = window.location;
  var urlComponents = url.href.split("&");
  var selectedProductString = "";
  var selectedProducts = [];
  for (var i = 0; i < urlComponents.length; i++) {
    if (urlComponents[i].indexOf(selectedFeaturedProductsParameter + "=") >= 0) {
      selectedProductString = urlComponents[i].replace(selectedFeaturedProductsParameter + "=", "");
    }
  }
  if (selectedProductString != "") {
    selectedProducts = selectedProductString.split(',');
  }
  return selectedProducts;
};

VP.VerticalMatrix.GetLeadEnabledProductListFromQueryString = function (queryStringParameter) {
  var url = window.location;
  var urlComponents = url.href.split("&");
  var selectedProductString = "";
  var selectedProducts = [];
  var parameter = queryStringParameter + "=";
  for (var i = 0; i < urlComponents.length; i++) {
    if (urlComponents[i].indexOf(parameter) >= 0) {
      selectedProductString = urlComponents[i].replace(parameter, "");
    }
  }
  if (selectedProductString != "") {
    selectedProducts = selectedProductString.split(',');
  }
  return selectedProducts;
};

VP.VerticalMatrix.GetProductPositionListFromQueryString = function (selectedProductPositionParameter) {
  var url = window.location;
  var urlComponents = url.href.split("&");
  var selectedProductPositionString = "";
  var selectedProductPostions = [];
  for (var i = 0; i < urlComponents.length; i++) {
    if (urlComponents[i].indexOf(selectedProductPositionParameter + "=") >= 0) {
      selectedProductPositionString = urlComponents[i].replace(selectedProductPositionParameter + "=", "");
    }
  }
  if (selectedProductPositionString != "") {
    selectedProductPostions = selectedProductPositionString.split(',');
  }
  return selectedProductPostions;
};

VP.VerticalMatrix.GetProductWebSiteUrl = function (productId, vendorId) {
  var navigateUrl;
  $.ajax({
    type: "POST",
    async: false,
    cache: false,
    url: VP.AjaxWebServiceUrl + "/GetProductWebSiteUrl",
    data: "{'productId' : '" + productId + "', 'vendorId' : '" + vendorId + "'}",
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    success: function (msg) {
      navigateUrl = msg.d;
    },
    error: function (XMLHttpRequest, textStatus, errorThrown) {
      var error = XMLHttpRequest;
    }
  });

  return navigateUrl;
};

VP.VerticalMatrix.GetAllSelectedProducts = function () {
  var i, products;
  products = [];
  for (i = 0; i < MatrixList.length; i++) {
    products = products.concat(MatrixList[i].selectedProducts);
  }

  return products.join(",");
};

VP.VerticalMatrix.GetAllSelectedFeaturedProducts = function () {
  var i, products;
  products = [];
  for (i = 0; i < MatrixList.length; i++) {
    products = products.concat(MatrixList[i].selectedFeaturedProducts);
  }

  return products.join(",");
};

VP.VerticalMatrix.GetAllSelectedProductPositions = function (products) {
  var i, j, productPositions, selectedProductPositions;
  productPositions = [];
  selectedProductPositions = [];
  selectedProductPositions = selectedProductPositions.concat(MatrixList[0].selectedProductPositions);
  for (j = 0; j < selectedProductPositions.length; j++) {
    if (selectedProductPositions[j] != undefined) {
      var product = selectedProductPositions[j].split('_')[0];
      if ($.inArray(product, products) > -1) {
        var position = selectedProductPositions[j].split('_')[1];
        var value = products[j] + '_' + (position * 1);
        productPositions.push(value);
      }
    }
  }

  return productPositions.join(",");
};

VP.VerticalMatrix.RenderRatingControl = function (ratingControl) {
  ratingControl.raty({
    readOnly: true,
    starOff: '/Images/star-off.png',
    starOn: '/Images/star-on.png',
    starHalf: '/Images/star-half.png',
    halfShow: true,
    hints: ['Ratings', 'Ratings', 'Ratings', 'Ratings', 'Ratings'],
    //width: 150,
    noRatedMsg: 'Ratings',
    score: function () {
      return $(this).attr('ratingScore');
    }
  });
};

VP.VerticalMatrix.ShowTooltips = function () {
  $('.specification_help_header').each(function () {
    var elementId = $(this).attr('id');
    var id = elementId.replace('spec_type_help_', '');
    var tooltip_id = "spec_type_help_tooltip_".concat(id);
    var tooltip_html = $("#".concat(tooltip_id)).attr('value');
    $(this).qtip({
      content: tooltip_html,
      show: 'mouseover',
      hide: 'mouseout',
      style: {
        name: 'light'
      },
      position: {
        corner: {

          tooltip: 'topRight'
        }
      }
    });
  });
};

$(document).ready(function () {

  if (typeof VP.ratyInitialized === 'undefined' || !VP.ratyInitialized) {
     VP.ratyInitialized = true;
     VP.VerticalMatrix.RenderRatingControl($('.ratingControl'));
 }
  
  VP.VerticalMatrix.ShowTooltips();

  $('.product-review-container .specification.col-1.truncate li:nth-child(odd)').addClass('alternate');
});
