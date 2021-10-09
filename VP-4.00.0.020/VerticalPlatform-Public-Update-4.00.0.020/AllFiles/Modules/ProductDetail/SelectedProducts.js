RegisterNamespace("VP.SelectedProducts");

VP.SelectedProducts.Products = [];
VP.SelectedProducts.LeadDisabledProducts = [];
VP.SelectedProducts.FeaturedProducts = [];
VP.SelectedProducts.ProductPositions = [];
VP.SelectedProducts.Container = null;
VP.SelectedProducts.Form = null;
VP.SelectedProducts.ContainerHidden = true;
VP.SelectedProducts.MaxProducts = 5;
VP.SelectedProducts.ProductUrl = null;
VP.SelectedProducts.AnimationTime = 0;
VP.SelectedProducts.HasProducts = false;
VP.SelectedProducts.CurrentTip = {};
VP.SelectedProducts.CountDown = null;
VP.SelectedProducts.LeadTypes = [];
VP.SelectedProducts.CategoryId = 0;

VP.SelectedProducts.Init = function () {
  $(document).ready(function () {
    VP.SelectedProducts.Container = $("#selectedProducts");
    VP.SelectedProducts.ProductUrl = $.vp.globals.productDirectoryLocation || '/';
    VP.SelectedProducts.CategoryId = $("input[id$='hdnCategoryId']", VP.SelectedProducts.Container).val();
      VP.SelectedProducts.Form = $("#frmMain");      
      if (typeof VP.ratyInitialized === 'undefined' || !VP.ratyInitialized) {
          VP.ratyInitialized = true;
          VP.SelectedProducts.RenderRatingControl();
      }      
    
    $("body").bind('productSelected', function (event, parameters) {
      VP.SelectedProducts.Add(parameters);
    });
    $("body").bind('productDeselected', function (event, parameters) {
      VP.SelectedProducts.Remove(parameters);
    });
    $("a[id$='lnkSelProAction']", VP.SelectedProducts.Container).click(function (event) {
      VP.SelectedProducts.Action($(this).attr("href"));
      event.preventDefault();
    });
    $("a[id$='lnkSelProCompare']", VP.SelectedProducts.Container).click(function (event) {
      if (VP.SelectedProducts.Products.length < 2) {
        alert("Please select at least two products");
      }
      else {
        VP.SelectedProducts.Compare($(this).attr("href"));
      }
      $("a[id$='clearSelectedProds']", VP.SelectedProducts.Container).click(function (event) {
        VP.SelectedProducts.Action($(this).attr("href"));
        event.preventDefault();
      });

      event.preventDefault();
    });
    $('h5', VP.SelectedProducts.Container).click(function (event) {
      VP.SelectedProducts.ToggleView(event, true);
    });
    $('a.find', VP.SelectedProducts.Container).attr('href', VP.SelectedProducts.ProductUrl);
    VP.SelectedProducts.Load();
      $(VP.SelectedProducts.Container).on('mouseover', "ul li.active",  function (event) {
      VP.SelectedProducts.StopCountDown(event);
      VP.SelectedProducts.ShowProductInfo(event);
      event.preventDefault();
    });
      $(VP.SelectedProducts.Container).on('mouseout', "ul li.active",  function (event) {
      VP.SelectedProducts.StartCountDown(event);
      event.preventDefault();
    });
      $(VP.SelectedProducts.Container).on('mouseover', ".qtip", function (event) {
      VP.SelectedProducts.StopCountDown(event);
      event.preventDefault();
    });
      $(VP.SelectedProducts.Container).on('mouseout', ".qtip", function (event) {
      VP.SelectedProducts.StartCountDown(event);
      event.preventDefault();
    });

    VP.SelectedProducts.ToggleGetQuoteButton();
  });
};

VP.SelectedProducts.RenderRatingControl = function () {
    $('.ratingControl').raty({
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

VP.SelectedProducts.Action = function (link) {
  if (VP.SelectedProducts.Products.length > 0 && !$("a[id$='lnkSelProAction']").is('.disabled')) {
    var leadType = VP.SelectedProducts.GetCommonLeadType();
    if (leadType > 0) {
      link = VP.SelectedProducts.UpdateLeadType(link, leadType);
    }

    window.location = link + "&ilt=true&cids=" + VP.SelectedProducts.GetSelectedProductIds() + "&ppim=" +
			VP.SelectedProducts.ProductPositions.join();
  }
};
VP.SelectedProducts.DetermineInitialState = function () {
  if ($.Cookie("selectedProductsToggle") != null && $.Cookie("selectedProductsToggle") != '') {
    if ($.Cookie("selectedProductsToggle") == 'open') {
      VP.SelectedProducts.ShowContainer(null);
    } else if ($.Cookie("selectedProductsToggle") == 'closed') {
      VP.SelectedProducts.HideContainer(null);
    }

  } else if (VP.SelectedProducts.HasProducts) {
    VP.SelectedProducts.ShowContainer(null);
  } else if (VP.SelectedProducts.Form.hasClass('VerticalMatrix')) {
    VP.SelectedProducts.ShowContainer(null);
  } else {
    VP.SelectedProducts.HideContainer(null);

  }
};
VP.SelectedProducts.StartCountDown = function (event) {
  clearTimeout(VP.SelectedProducts.CountDown);
  VP.SelectedProducts.CountDown = setTimeout('VP.SelectedProducts.HideProductInfo()', 400);
};
VP.SelectedProducts.StopCountDown = function (event) {
  clearTimeout(VP.SelectedProducts.CountDown);
};
VP.SelectedProducts.HideProductInfo = function (event) {
  if (VP.SelectedProducts.CurrentTip) {
    VP.SelectedProducts.CurrentTip.qtip('toggle', false);
  }
  clearTimeout(VP.SelectedProducts.CountDown);

};
VP.SelectedProducts.ShowProductInfo = function (event) {
  var element = $(event.currentTarget);
  if (!element.data('hasTip')) {
    $(element).qtip(
			{
			  overwrite: false,
			  content: {
			    text: unescape($(element).attr('data-content')),
			    title: {
			      text: unescape($(element).attr('data-title')),
			      button: "Close"
			    }
			  },
			  show: {
			    event: event.type,
			    ready: true,
			    solo: true
			  },
			  hide: {
			    event: "unfocus"
			  },
			  position: {
			    my: "bottom left",
			    at: "top center",
			    container: VP.SelectedProducts.Container,
			    viewport: false
			  },
			  style: {
			    tip: true,
                  classes: "qtip-light qtip-titlebar ui-tooltip-rounded matrix-zoom"
			  },
			  prerender: false
			},

		event);
  }
  element.data('hasTip', true);
  VP.SelectedProducts.CurrentTip = element;
};

VP.SelectedProducts.Compare = function (link) {
  if (VP.SelectedProducts.Products.length > 0) {
    window.location = link + "?compare=" + VP.SelectedProducts.GetSelectedProductIds() + "&ppim=" +
			VP.SelectedProducts.ProductPositions.join() + VP.SelectedProducts.GetCategoryQueryString() +
			"&fpids=" + VP.SelectedProducts.FeaturedProducts.join();
  }
};

VP.SelectedProducts.GetPageIndex = function () {
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

VP.SelectedProducts.Add = function (parameters) {
  var productId = parameters.id + "_" + VP.SelectedProducts.CategoryId;
  if ($.inArray(productId, VP.SelectedProducts.Products) == -1) {
    VP.SelectedProducts.Products.push(productId);
    var productCheckboxList = $("input:checkbox.action");

    if (parameters.position) {
      VP.SelectedProducts.ProductPositions.push(parameters.id + '_' + parameters.position);
    } else {
      for (var i = 0; i < productCheckboxList.length; i++) {
        if (parameters.id == productCheckboxList[i].value) {
          var pageIndex = VP.SelectedProducts.GetPageIndex();
          var pageSize = productCheckboxList.length;
          var position = ((pageIndex * 1 - 1) * pageSize + i + 1);
          var productPosition = parameters.id + '_' + position;
          VP.SelectedProducts.ProductPositions.push(productPosition);

          if (productCheckboxList[i].attributes["featuredProduct"].value == "True") {
            VP.SelectedProducts.FeaturedProducts.push(parameters.id);
          }
        }
      }

      if (VP.SelectedProducts.Products.length > VP.SelectedProducts.MaxProducts) {
        VP.SelectedProducts.Delete(VP.SelectedProducts.Products[0].split("_")[0]);
      }
      var data = VP.SelectedProducts.GetProducts(parameters.id.toString());
      VP.SelectedProducts.Render(data);
      $.Cookie("selectedProducts", VP.SelectedProducts.Products.join());
      $.Cookie("selectedProductPositions", VP.SelectedProducts.ProductPositions.join());
      $.Cookie("selectedFeaturedProducts", VP.SelectedProducts.FeaturedProducts.join());
    }

    if (parameters.actionDisabled) {
      VP.SelectedProducts.LeadDisabledProducts.push(productId);
      $.Cookie("leadDisabledProducts", VP.SelectedProducts.LeadDisabledProducts.join());
    }

    VP.SelectedProducts.ToggleGetQuoteButton();
  }
};

VP.SelectedProducts.Render = function (data) {
  if (data != null) {
    VP.SelectedProducts.Append(data);
  }

  VP.SelectedProducts.RenderEmptyItems();
  VP.SelectedProducts.RenderCount();
};

VP.SelectedProducts.RenderEmptyItems = function () {
  $("li[rel='-1']", VP.SelectedProducts.Container).remove();
  if (VP.SelectedProducts.Products.length < VP.SelectedProducts.MaxProducts) {
    var index = VP.SelectedProducts.Products.length;
    for (index; index < VP.SelectedProducts.MaxProducts; index++) {
      $("ul", VP.SelectedProducts.Container).append("<li rel='-1'></li>");
    }
  }
};

VP.SelectedProducts.RenderCount = function () {
  $("#productCount", VP.SelectedProducts.Container).text(VP.SelectedProducts.Products.length);
  if (VP.SelectedProducts.Products.length > 0) {
    VP.SelectedProducts.Container.addClass("hasSelected");
    $("ul", VP.SelectedProducts.Container).addClass("selected");
  } else {
    VP.SelectedProducts.Container.removeClass("hasSelected");
    $("ul", VP.SelectedProducts.Container).removeClass("selected");
  }
};

VP.SelectedProducts.Append = function (data) {
  var html = "";
  var i;
  for (i = 0; i < data.length; i++) {
    var largeImage = null;
    var action = '';
    var titleContent = '';
    var tipContent = '';

    if (parseInt(data[i].DefaultActionId) > 0) {
      VP.SelectedProducts.LeadTypes.push(parseInt(data[i].DefaultActionId));
    }

    if (data[i].ImageUrl) {
      largeImage = "<a title='" + data[i].ProductName + "' href='" + data[i].ProductUrl + "'><img src='" + data[i].ImageUrl.replace('52x39', '400x300') + "' alt='" + data[i].ProductName + "' title='" + data[i].ProductName + "' /></a>";
    }

    if (data[i].GetQuoteUrl == null && data[i].ClickThroughUrl == null) {
      action = "<span>" + data[i].LeadTurnOffText + "</span>";
    } else if (data[i].GetQuoteUrl != null) {
      action = "<a title='Get Quote for " + data[i].ProductName + "' href='" + data[i].GetQuoteUrl + "' class='button action-1 btnRequestQuote'>" + data[i].GetQuoteButtonText + "</a>";
    } else if (data[i].ClickThroughUrl != null) {
      action = "<a title='" + data[i].ProductName + "'";
      if (data[i].NewWindow != null) {
        action += "target='_blank'";
      }
      action += "href='" + data[i].ClickThroughUrl + "' class='button action-1 clickThrough'>" + data[i].ClickThroughType + "</a>";
    }

    titleContent = "<a title='" + data[i].ProductName + "' href='" + data[i].ProductUrl + "'>" + data[i].ProductName + "</a> from " +
			"<span class='company'>" + data[i].ManufacturerName + "</span>";

    tipContent = "<div id='zoom_" + data[i].ProductId + "' class='zoomedContent'>";
    if (largeImage) {
      tipContent += "<div class='image'>" + largeImage + "</div>";
    }
    tipContent += "<div class='actions module'><a class='icon externalLink productLink' href='" +
			data[i].ProductUrl + "'>View Details</a><a class='icon close' onclick='VP.SelectedProducts.Delete(" + data[i].ProductId + ");'>Remove Item</a>" + action + "</div></div>";
    html += "<li class=\"active\" rel=\"" + data[i].ProductId + "\" data-content=\"" + escape(tipContent) + "\"" +
			"data-title=\"" + escape(titleContent) + "\"><div class=\"itemHolder\">";

    if (data[i].ImageUrl != null) {
      html += "<img src=\"" + data[i].ImageUrl + "\" alt=\"" + data[i].ProductName + "\" title=\"" + data[i].ProductName + "\">";
    }
    html += "<a class=\"icon compact close\" onclick=\"VP.SelectedProducts.Delete(" + data[i].ProductId + ");\">Remove Item</a></div></li>";
  }
  $("ul", VP.SelectedProducts.Container).append(html);
  VP.SelectedProducts.ShowContainer();
};

VP.SelectedProducts.Delete = function (productId, index) {
  VP.SelectedProducts.Remove({ id: productId });
  $("body").trigger("productRemoved", { id: productId });
};

VP.SelectedProducts.Remove = function (parameters) {
  var i, j, productId, k, l;
  $("li[rel='" + parameters.id + "']", VP.SelectedProducts.Container).remove();
  i = 0;
  j = 0;
  k = 0;
  l = 0;
  for (i; i < VP.SelectedProducts.Products.length; i++) {
    productId = VP.SelectedProducts.Products[i].split("_")[0];
    if (productId == parameters.id) {
      VP.SelectedProducts.RemoveLeadType(parameters.id);
      VP.SelectedProducts.Products.splice(i, 1);
      break;
    }
  }

  for (j; j < VP.SelectedProducts.ProductPositions.length; j++) {
    var productIdArray = VP.SelectedProducts.ProductPositions[j];
    if (productIdArray != undefined) {
      var productId = productIdArray.split('_');
      if (productId[0] == parameters.id) {
        VP.SelectedProducts.ProductPositions.splice(j, 1);
        break;
      }
    }
  }

  for (k; k < VP.SelectedProducts.FeaturedProducts.length; k++) {
    var featuredProductId = VP.SelectedProducts.FeaturedProducts[k];
    if (featuredProductId != undefined) {
      if (featuredProductId == parameters.id) {
        VP.SelectedProducts.FeaturedProducts.splice(k, 1);
        break;
      }
    }
  }

  for (l; l < VP.SelectedProducts.LeadDisabledProducts.length; l++) {
    var leadDisabledProductId = VP.SelectedProducts.LeadDisabledProducts[l].split("_")[0];
    if (leadDisabledProductId != undefined) {
      if (leadDisabledProductId == parameters.id) {
        VP.SelectedProducts.LeadDisabledProducts.splice(l, 1);
        break;
      }
    }
  }

  $.Cookie("selectedProducts", VP.SelectedProducts.Products.join());
  $.Cookie("selectedProductPositions", VP.SelectedProducts.ProductPositions.join());
  $.Cookie("selectedFeaturedProducts", VP.SelectedProducts.FeaturedProducts.join());
  $.Cookie("leadDisabledProducts", VP.SelectedProducts.LeadDisabledProducts.join());

  if (VP.SelectedProducts.Products.length == 0) {
    VP.SelectedProducts.ContainerHidden = true;
  }

  VP.SelectedProducts.RenderEmptyItems();
  VP.SelectedProducts.RenderCount();
  VP.SelectedProducts.ToggleGetQuoteButton();
};

VP.SelectedProducts.ToggleView = function (event, userInteraction) {
  if (VP.SelectedProducts.ContainerHidden) {
    VP.SelectedProducts.ShowContainer(userInteraction);
  } else {
    VP.SelectedProducts.HideContainer(userInteraction);
  }
};
VP.SelectedProducts.ShowContainer = function (userInteraction) {
  VP.SelectedProducts.Container.animate({ bottom: '8px' }, VP.SelectedProducts.AnimationTime);
  VP.SelectedProducts.ContainerHidden = false;
  VP.SelectedProducts.Container.removeClass('closed');
  VP.SelectedProducts.AnimationTime = 200;
  if (userInteraction) {
    $.Cookie("selectedProductsToggle", 'open');
  }
};

VP.SelectedProducts.HideContainer = function (userInteraction) {
  VP.SelectedProducts.Container.animate({ bottom: '-42px' }, VP.SelectedProducts.AnimationTime);
  VP.SelectedProducts.Container.addClass('closed');
  VP.SelectedProducts.ContainerHidden = true;
  VP.SelectedProducts.AnimationTime = 200;
  if (userInteraction) {
    $.Cookie("selectedProductsToggle", 'closed');
  }
};

VP.SelectedProducts.Load = function () {
  var cookieValue = $.Cookie("selectedProducts");
  var cookiePositionValues = $.Cookie("selectedProductPositions");
  var cookieFeaturedValue = $.Cookie("selectedFeaturedProducts");

  if (cookieValue != null && cookieValue != "" && cookiePositionValues != null && cookiePositionValues != "") {
    VP.SelectedProducts.HasProducts = true;
    var items = cookieValue.split(",");
    VP.SelectedProducts.Products = cookieValue.split(",");
    var positionItems = cookiePositionValues.split(",");
    var data = VP.SelectedProducts.GetProducts(VP.SelectedProducts.GetSelectedProductIds());
    if (cookieFeaturedValue != null && cookieFeaturedValue != "") {
      VP.SelectedProducts.FeaturedProducts = cookieFeaturedValue.split(",");
    }

    if (data.length > 0) {
      var newCookieValue = "";
      var newPositionCookieValue = "";
      var newLeadDisabledProducts = "";
      if (data.length < items.length) {
        var index = 0;
        for (index; index < data.length; index++) {
          newCookieValue += VP.SelectedProducts.GetProductCategory(data[index].ProductId) + ',';

          for (var j = 0; j < positionItems.length; j++) {
            var productId = positionItems[j].split('_');
            if (productId[0] == data[index].ProductId) {
              newPositionCookieValue += positionItems[j] + ',';
              VP.SelectedProducts.ProductPositions.push(positionItems[j]);
            }
          }
        }

        newCookieValue = newCookieValue.substr(0, newCookieValue.length - 1);
        newPositionCookieValue = newPositionCookieValue.substr(0, newPositionCookieValue.length - 1);
        VP.SelectedProducts.Products = newCookieValue.split(",");

        $.Cookie("selectedProducts", null);
        $.Cookie("selectedProducts", newCookieValue);

        $.Cookie("selectedProductPositions", null);
        $.Cookie("selectedProductPositions", newPositionCookieValue);
      }
      else {
        var index = 0;
        for (index; index < data.length; index++) {
          for (var k = 0; k < positionItems.length; k++) {
            var productId = positionItems[k].split('_');
            if (productId[0] == data[index].ProductId) {
              VP.SelectedProducts.ProductPositions.push(positionItems[k]);
              break;
            }
          }
        }
      }

      VP.SelectedProducts.Render(data);
    }
    else {
      VP.SelectedProducts.Render(null);
      VP.SelectedProducts.HasProducts = false;


      $.Cookie("selectedProducts", null);
      VP.SelectedProducts.Products.splice(0, VP.SelectedProducts.Products.length);

      $.Cookie("selectedProductPositions", null);
      VP.SelectedProducts.ProductPositions.splice(0, VP.SelectedProducts.ProductPositions.length);

      $.Cookie("selectedFeaturedProducts", null);
      VP.SelectedProducts.FeaturedProducts.splice(0, VP.SelectedProducts.FeaturedProducts.length);
    }

    var leadDisabledProducts = VP.SelectedProducts.GetLeadDisabledSelectedProducts();
    $.Cookie("leadDisabledProducts", null);
    VP.SelectedProducts.LeadDisabledProducts.splice(0, VP.SelectedProducts.LeadDisabledProducts.length);
    $.Cookie("leadDisabledProducts", leadDisabledProducts);
    VP.SelectedProducts.LeadDisabledProducts = leadDisabledProducts.split(",");
  }
  else {
    VP.SelectedProducts.Render(null);
  }



  VP.SelectedProducts.DetermineInitialState();
  $("body").trigger("selectedProductsLoaded");
};

VP.SelectedProducts.GetCommonLeadType = function () {
  var leadType, leadTypeCounts, maxCount, lead;
  leadType = 0;
  if (VP.SelectedProducts.LeadTypes.length > 0) {
    leadTypeCounts = [];
    maxCount = 0;
    for (lead in VP.SelectedProducts.LeadTypes) {
      leadTypeCounts[VP.SelectedProducts.LeadTypes[lead]] = (leadTypeCounts[VP.SelectedProducts.LeadTypes[lead]] || 0) + 1;
      if (leadTypeCounts[VP.SelectedProducts.LeadTypes[lead]] > maxCount) {
        maxCount = leadTypeCounts[VP.SelectedProducts.LeadTypes[lead]];
        leadType = VP.SelectedProducts.LeadTypes[lead];
      }
    }
  }

  return leadType;
};

VP.SelectedProducts.UpdateLeadType = function (link, leadType) {
  var urlComponents, queryComponents, i;
  urlComponents = link.split("?");

  if (urlComponents.length > 1) {
    queryComponents = urlComponents[1].split("&");
    for (i = 0; i < queryComponents.length; i++) {
      if (queryComponents[i].indexOf("ltid") >= 0) {
        link = link.replace(queryComponents[i], "ltid=" + leadType);
        break;
      }
    }
  }

  return link;
};

VP.SelectedProducts.RemoveLeadType = function (productId) {
  var product, index;
  product = VP.SelectedProducts.GetProducts(productId);
  index = $.inArray(product[0].DefaultActionId, VP.SelectedProducts.LeadTypes);
  if (index > -1) {
    VP.SelectedProducts.LeadTypes.splice(index, 1);
  }
};

VP.SelectedProducts.GetCategoryQueryString = function () {
  var queryComponent, category, categories, index;
  queryComponent = "";
  categories = [];
  for (i = 0; i < VP.SelectedProducts.Products.length; i++) {
    category = VP.SelectedProducts.Products[i].split("_")[1];
    index = $.inArray(category, categories);
    if (index == -1) {
      categories.push(category);
    }
  }

  if (categories.length == 1) {
    queryComponent = "&catid=" + categories[0];
  }

  return queryComponent;
};

VP.SelectedProducts.GetSelectedProductIds = function () {
  var productIds, i;
  productIds = [];
  for (i = 0; i < VP.SelectedProducts.Products.length; i++) {
    productIds.push(VP.SelectedProducts.Products[i].split("_")[0]);
  }

  return productIds.join();
};

VP.SelectedProducts.GetProductCategory = function (productId) {
  var productCategory, i;
  for (i = 0; i < VP.SelectedProducts.Products.length; i++) {
    productCategory = VP.SelectedProducts.Products[i];
    if (productCategory.split("_")[0] == productId) {
      break;
    }
  }

  return productCategory;
};

VP.SelectedProducts.GetProducts = function (productIds) {
  var products;
  $.ajax({
    type: "POST",
    async: false,
    cache: false,
    url: VP.AjaxWebServiceUrl + "/GetProductInformation",
    data: "{'productIds':'" + productIds + "', 'countryId':'" + VP.Login.CountryId + "'}",
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    success: function (msg) {
      products = msg.d;
    }
  });

  return products;
};

VP.SelectedProducts.ToggleGetQuoteButton = function () {
  if (VP.SelectedProducts.Products.length == 0 || VP.SelectedProducts.Products.length > VP.SelectedProducts.LeadDisabledProducts.length) {
    $("a[id$='lnkSelProAction']").attr('class', 'button');
  }
  else {
    $("a[id$='lnkSelProAction']").attr("class", "button disabled");
  }
};

VP.SelectedProducts.IsLeadEnabled = function (productId) {
  var leadEnabled;
  $.ajax({
    type: "POST",
    async: false,
    cache: false,
    url: VP.AjaxWebServiceUrl + "/IsLeadEnabled",
    data: "{'productId':'" + productId + "'}",
    contentType: "application/json; charset=utf-8",
    dataType: "json",
    success: function (msg) {
      leadEnabled = msg.d;
    }
  });

  return leadEnabled;
};

VP.SelectedProducts.GetLeadDisabledSelectedProducts = function () {
  var leadDisabledProductIds = "";
  $.each(VP.SelectedProducts.Products, function (index, value) {
    if (value != undefined && value.split("_")[0] != "") {
      if (!VP.SelectedProducts.IsLeadEnabled(value.split("_")[0])) {
        leadDisabledProductIds += value + ',';
      }
    }
  });

  if (leadDisabledProductIds.length > 0) {
    leadDisabledProductIds = leadDisabledProductIds.substr(0, leadDisabledProductIds.length - 1);
  }

  return leadDisabledProductIds;
};

VP.SelectedProducts.ClearAll = function () {
  $("li", VP.SelectedProducts.Container).remove();
  VP.SelectedProducts.Products = [];
  VP.SelectedProducts.LeadDisabledProducts = [];
  VP.SelectedProducts.FeaturedProducts = [];
  VP.SelectedProducts.ProductPositions = [];
  VP.SelectedProducts.LeadTypes = [];
  VP.SelectedProducts.ContainerHidden = true;
  VP.SelectedProducts.HasProducts = false;

  $.Cookie("selectedProducts", null);
  $.Cookie("selectedProductPositions", null);
  $.Cookie("selectedFeaturedProducts", null);
  $.Cookie("leadDisabledProducts", null);

  VP.SelectedProducts.RenderEmptyItems();
  VP.SelectedProducts.RenderCount();
  VP.SelectedProducts.ToggleGetQuoteButton();

  $("body").trigger("allProductsRemoved");
}

VP.SelectedProducts.Init();
