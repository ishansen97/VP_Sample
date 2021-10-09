RegisterNamespace("VP.LeadFormPopup");

VP.LeadFormPopup.leadFormParams = "";
VP.LeadFormPopup.leadSaveParams = "";
VP.LeadFormPopup.leadPopupServiceUrl = "";
VP.LeadFormPopup.popupIsOpenedSessionKey = "LeadFormPopupIsOpened_" + createProductSpecificKey();
VP.LeadFormPopup.isNewUserLoggedIn = 0;
VP.LeadFormPopup.isAutoLoad = false;
VP.LeadFormPopup.autoLoadScrollHeight = 0;
VP.LeadFormPopup.alreadyAutoLoaded = 0;
VP.LeadFormPopup.autoLoadTimeout = 0;
VP.LeadFormPopup.autoLoadLeadUrl = "";
VP.LeadFormPopup.enableOverlayButton = false;
VP.LeadFormPopup.overlayButtonText = "";
VP.LeadFormPopup.SendConfirmationEmail = 0;
VP.LeadFormPopup.RedirectUrl = "";

var inputTypeCheckBoxList = 3;
var inputTypeRadioButtonList = 6;
var inputTypeCheckBox = 15;
var inputSelectList = 1;

var originalAnalyticObj = {};


$(document).ready(function () {
    VP.LeadFormPopup.leadPopupServiceUrl = VP.BaseUrl + "WebServices/LeadPopup.asmx/";

    $(".lead-action-btn").each(function (index, item) {
        $(item).click(function (e) {
            e.preventDefault();
            var leadParams = $(this).attr("href").split("?")[1];
            VP.LeadFormPopup.loadLeadPopup(leadParams);
        });
    });

    //auto load lead popup if already opened (if page refreshed)
    if (sessionStorage.getItem(VP.LeadFormPopup.popupIsOpenedSessionKey) && window.performance.navigation.type == 1)
        VP.LeadFormPopup.loadLeadPopup(sessionStorage.getItem(VP.LeadFormPopup.popupIsOpenedSessionKey));
    else if (VP.LeadFormPopup.isAutoLoad)
        VP.LeadFormPopup.autoload();

    if (VP.LeadFormPopup.isAutoLoad) {
        if (VP.LeadFormPopup.enableOverlayButton) {
            var leadParams = VP.LeadFormPopup.getLeadFormParamters();
            VP.LeadFormPopup.setContainerOverlayButton(VP.LeadFormPopup.overlayButtonText, leadParams);
        }
    }
});


VP.LeadFormPopup.autoload = function () {
    var leadParams = VP.LeadFormPopup.getLeadFormParamters();

    //scroll load
    if (VP.LeadFormPopup.autoLoadScrollHeight) {
        $(document).scroll(function () {
            if (!VP.LeadFormPopup.alreadyAutoLoaded) {
                if ($(window).scrollTop() >= VP.LeadFormPopup.autoLoadScrollHeight) {
                    VP.LeadFormPopup.loadLeadPopup(leadParams);
                    VP.LeadFormPopup.alreadyAutoLoaded = true;
                }
            }
        });

    }
    if (VP.LeadFormPopup.autoLoadTimeout) {
        setTimeout(function () {
                if (!VP.LeadFormPopup.alreadyAutoLoaded) {
                    VP.LeadFormPopup.loadLeadPopup(leadParams);
                    VP.LeadFormPopup.alreadyAutoLoaded = true;
                }
            },
            VP.LeadFormPopup.autoLoadTimeout*1000);
    }
};


VP.LeadFormPopup.getLeadFormParamters = function () {
    var leadParams = VP.LeadFormPopup.autoLoadLeadUrl.split("?")[1];
    if (leadParams) {
        leadParams += "&sce=" + VP.LeadFormPopup.SendConfirmationEmail;
        leadParams += "&rurl=" + VP.LeadFormPopup.RedirectUrl;
    }
    return leadParams;
}


VP.LeadFormPopup.setContainerOverlayButton = function (btnText, leadParams){
    var videoContainer = $(".video-js");
    var containerOverlay = "<div class='container-overlay-background'>" +
        "<div class='container-overlay-content'> <input type='button' class='container-overlay-button' value='" + btnText+"'>" +
        "</div>" +
        "</div>";
    containerOverlay = $(containerOverlay);
    videoContainer.parent().css("position", "relative").append(containerOverlay);

    containerOverlay.find(".container-overlay-button").click(function () {
        VP.LeadFormPopup.loadLeadPopup(leadParams);
        VP.LeadFormPopup.alreadyAutoLoaded = true;
    });
    //disabling chapters
    $(".chapters").find("li").css("pointer-events", "none").unbind();
    if (videojs) {
        $(videojs.getAllPlayers()).each(function (index, player) {
            player.on('loadedmetadata', function () {
                player.autoplay(false);
                player.pause();
            });
        });
    }
    
}


VP.LeadFormPopup.setAutoload = function (timeOut, scrollHeight, enableOverlayButton, buttonText, leadUrl, sendConfirmationEmail, redirectUrl) {
    if (leadUrl) {
        VP.LeadFormPopup.isAutoLoad = true;
        VP.LeadFormPopup.autoLoadScrollHeight = scrollHeight;
        VP.LeadFormPopup.autoLoadTimeout = timeOut;
        VP.LeadFormPopup.autoLoadLeadUrl = leadUrl;
        VP.LeadFormPopup.enableOverlayButton = enableOverlayButton;
        VP.LeadFormPopup.overlayButtonText = buttonText;
        VP.LeadFormPopup.SendConfirmationEmail = sendConfirmationEmail;
        VP.LeadFormPopup.RedirectUrl = redirectUrl;
    } else {
        console.warn("Couldn't get lead url for autoload");
    }
};

VP.LeadFormPopup.loadLeadPopup = function (leadParams) {
    VP.Forms.LeadForm.Loader(true);
    VP.LeadFormPopup.leadFormParams = leadParams;
    $.ajax({
        type: "GET",
        //async: false,
        cache: false,
        url: VP.LeadFormPopup.leadPopupServiceUrl + "RenderLeadForm?" + VP.LeadFormPopup.leadFormParams,
        contentType: "application/json; charset=utf-8",
        success: function (msg) {
            //console.log(msg);
            VP.LeadFormPopup.loadLeadFormPopup(msg.d);
        },
        error: function (err) {
            console.log(err);
            VP.Forms.LeadForm.Loader(false);
        }
    });
};

function loadScript(src) {
    return new Promise(function (resolve, reject) {
        var script = document.createElement('script');
        script.src = src;
        script.onload = resolve;
        script.onerror = reject;
        document.head.appendChild(script);
    });
}

function createProductSpecificKey() {
    var urlParts = window.location.href.split("?")[0].split("/");
    for (var i = (urlParts.length) ; i > 0; i--) {
        if (urlParts[i])
            return urlParts[i];
    }
    return "";
}

VP.LeadFormPopup.loadLeadFormPopup = function (popupContent) {
    try {
        //saving global analytic object
        originalAnalyticObj = jQuery.extend(true, {}, s);

        //clearing global s object properties
        s.clearVars();
    } catch (ex) {
        console.warn(ex);
    }

    $("#leadFormPopup").remove();
    var popup = "<div class='lead-form-popup-overlay'>" +
                    "<div id='leadFormPopup' class='lead-form-popup'>" +
                        "<div class='lead-form-popup-header'><span class='lead-form-popup-close-btn'>X</span></div>" +
                        "<div class='lead-form-popup-content leadForm container'></div>" +
                    "</div>" +
                "</div>";

    popup = $(popup);
    popupContent = $(popupContent);

    //remove __VIEWSTATE
    popupContent.find("#__VIEWSTATE").remove();
    popupContent.find("#__VIEWSTATEGENERATOR").remove();
    popupContent.find("#__EVENTVALIDATION").remove();

    var inlineScripts = [];
    var externalScrripts = [];

    //set async false for dynamic scripts
    //https://developer.mozilla.org/en-US/docs/Web/HTML/Element/script
    for (var i = 0; i < popupContent.length; i++) {
        var itm = $(popupContent[i]);
        if (itm.is("script")) {
            itm.attr("async", false);
            //inline scripts
            if (!itm.attr("src")) {
                inlineScripts.push(itm);
                popupContent.splice(i, 1);
                i--;
            } else {
                externalScrripts.push(itm);
                popupContent.splice(i, 1);
                i--;
            }
        }
    }

    popup.find(".lead-form-popup-content").append(popupContent);

    var externalScripPromises = [];

    for (var i = 0; i < externalScrripts.length; i++) {
        var src = externalScrripts[externalScrripts.length - 1][0].src;
        externalScripPromises.push(loadScript(src));
    }

    //getting all external scripts asynchronosly
    Promise.all(externalScripPromises)
        .then(function() {
            //selected products alignment
            popup.find("#leadFormPopup").find("ul.formList").after(popup.find("div.leadFormProductList"));
            $("body").append(popup);
            $("body").css("overflow-y", "hidden");

            $(inlineScripts).each(function(index, item) {
                try {
                    $("#leadFormPopup").append(item);
                } catch (ex) {
                    console.warn(ex);
                }
            });

            VP.LeadFormPopup.bindPopupButtons();
            VP.Forms.LeadForm.Loader(false);
            $('.country.dropdownList').stateSelectBox();
        })
        .catch(function(err) {
            console.warn(err);
            VP.Forms.LeadForm.Loader(false);
        });

    //setting leadpopup opned to session storage
    sessionStorage.setItem(VP.LeadFormPopup.popupIsOpenedSessionKey, VP.LeadFormPopup.leadFormParams);
};


VP.LeadFormPopup.bindPopupButtons = function() {
    //close btn
    $("#leadFormPopup").find(".lead-form-popup-close-btn").click(function () {
        VP.LeadFormPopup.closePopup($(".lead-form-popup-overlay"));
    });

    //close btn
    $("#leadFormPopup").find("input[type='button'][value='Cancel']")
        .attr("onclick", "")
        .click(function () {
            VP.LeadFormPopup.closePopup($(".lead-form-popup-overlay"));
        });


    $(".lead-form-popup-overlay").click(function (e) {
        if (e.target !== this)
            return;
        VP.LeadFormPopup.closePopup($(".lead-form-popup-overlay"));
    });

    //submit button binding (overrriding submit button events validations etc.)
    var submitBtn = $("#leadFormPopup").find(".lead-server-submit");
    $(submitBtn).each(function (index, item) {
        var btn = $(item);
        //var submitBtnPreEvent = btn.attr("onclick");
        //submitBtnPreEvent = (submitBtnPreEvent.split("return").length > 1 && submitBtnPreEvent.split("return")[1]) || submitBtnPreEvent;
        btn.attr("onclick", "return false;");

        //overriding btn click event with leadform.next function
        btn.click(function () {
            var pages = $(this).parents(".formHolder");
            if (pages && pages.length > 0) {
                var currentPage = $(pages[0]).attr('id');
                VP.Forms.BaseForm.Next(currentPage);
            }
            //VP.LeadFormPopup.loadFormData(submitBtnPreEvent);
        });
    });

    //other related products on thankyou page
    var relatedProductsBtn = $("#leadFormPopup").find(".request_button:not(.lead-server-submit)");
    if (relatedProductsBtn && relatedProductsBtn.length > 0) {
        relatedProductsBtn.attr("href", "javascript:void(0);");
        relatedProductsBtn.click(VP.LeadFormPopup.submitOtherRelatedProducts);
    }

    var relatedArticlesBtn = $("#leadFormPopup").find(".popup_article_submit");
    if (relatedArticlesBtn && relatedArticlesBtn.length > 0) {
      relatedArticlesBtn.attr("href", "javascript:void(0);");
      relatedArticlesBtn.click(VP.LeadFormPopup.submitRelatedArticles);
    }

    //country list
    var coutryName = $('#imgCountryFlag', $.vp.domFragments.pageHeader).attr('alt');
    $('.country option:contains("' + coutryName + '")').first().attr('selected', 'selected');
};

VP.LeadFormPopup.closePopup = function(popup) {
    popup.remove();
    $("body").css("overflow-y", "auto");
    sessionStorage.setItem(VP.LeadFormPopup.popupIsOpenedSessionKey, "");
    VP.LeadFormPopup.alreadyAutoLoaded = true;

    try {
        //reverting global analytics object to original
        for (var k in originalAnalyticObj)
            if (originalAnalyticObj.hasOwnProperty(k))
                window.s[k] = originalAnalyticObj[k];
        //window.s.t();
    } catch (ex) {
         console.warn(ex);
    }

    if (VP.LeadFormPopup.isNewUserLoggedIn)
        location.reload(true);
};


VP.LeadFormPopup.loadFormData = function (preEvent) {
    if (eval(preEvent)) {
        VP.LeadFormPopup.submitLead();
    }
};


//overriding baseform next method for popup
VP.Forms.BaseForm.Next = function (pageId) {
    if (VP.Forms.BaseForm.Validate(false, pageId)) {
        if (VP.Forms.LeadForm.CheckEmail(null)) {
            var pages = $(".formHolder");
            var pageIndex = parseInt(pageId.split('_')[1]);
            if ((pages.length - 1) == pageIndex)
                return VP.LeadFormPopup.submitLead(pageIndex, pages.length);
            else {
                return VP.LeadFormPopup.submitLead(pageIndex, pages.length, function () {
                    VP.Forms.BaseForm.ShowPage("p_" + (pageIndex + 1));
                    //scroll popup to default
                    $("#leadFormPopup form:first")[0].scrollIntoView();
                });
            }
        }
    }
    return false;
};

//overrided the leadform validations due to default redirections
VP.Forms.LeadForm.ValidateLeadSubmit = function (isAll, pageId, btnId, btnHiddenLeadSubmit) {
    var ie9 = false;
    var ie10 = false;
    var ie11 = false;
    if (navigator.appName == 'Netscape' || navigator.appName == 'Microsoft Internet Explorer') {
        var ua = navigator.userAgent;
        var re = new RegExp("MSIE 9.0");
        if (re.exec(ua) != null) {
            ie9 = true;
        }

        re = new RegExp("MSIE 10.0");
        if (re.exec(ua) != null) {
            ie10 = true;
        }

        re = new RegExp("Trident/7.0"); ///Denotes IE 11
        if (re.exec(ua) != null) {
            ie11 = true;
        }
    }

    var isValidate;
    if (ie9 || ie10 || ie11) {
        isValidate = VP.Forms.BaseForm.Validate(isAll, pageId);
        if (isValidate) {
            return true;
        }
        else {
            return false;
        }
    }
    else {
        $("#" + pageId).find("#" + btnId).attr('disabled', 'disabled').addClass('disabled');
        isValidate = VP.Forms.BaseForm.Validate(isAll, pageId);
        if (isValidate) {
            return true;
        }
        else {
            $("#" + pageId).find("#" + btnId).removeAttr('disabled').removeClass('disabled');
            return false;
        }
    }
};


VP.LeadFormPopup.submitLead = function(pageIndex, totalPages, pageCallBack) {
    VP.Forms.LeadForm.Loader(true, $("#leadFormPopup"));

    var leadFormFeilds = [];

    //reading leadform feilds
    var formFeilds = $("#leadFormPopup").find(".formHolder").eq(pageIndex).find('*[data-formfeild]');
    formFeilds.each(function(index, item) {
        var feildJson = $(item).data("formfeild");

        if (feildJson.FeildType == inputTypeCheckBox) {
            var chkBox = $(item).find("input[type=checkbox]");
            feildJson.FeildValue = chkBox.is(":checked");
        } else if (feildJson.FeildType == inputTypeCheckBoxList) {
            var chkBox = $(item).find("input[type=checkbox]");
            if (chkBox.is(":checked")) {
                feildJson.FeildValue = chkBox.attr("value");
            } else {
                return true; //continue on unchecked feilds
            }
        } else if (feildJson.FeildType == inputTypeRadioButtonList) {
            var radioBtn = $(item).find("input[type=radio]");
            if (radioBtn.is(":checked")) {
                feildJson.FeildValue = radioBtn.attr("value");
            } else {
                return true; //continue on unchecked feilds
            }
        } else if (feildJson.FeildType == inputSelectList) {
            //skipping dynamic values
            if (feildJson.IsDynamic)
                return true;
            //addding dynamic child control value
            if ($(item).find($("option:selected")).text().toLowerCase() === "other") {
                for (var i = 0; i < formFeilds.length; i++) {
                    var feildData = $(formFeilds[i]).data("formfeild");
                    if (feildData.IsDynamic && feildData.Id === feildJson.Id) {
                        feildJson.OptionalValue = $(formFeilds[i]).val();
                        break;
                    }
                }
            }
            feildJson.FeildValue = $(item).val();
        } else {
            feildJson.FeildValue = $(item).val();
        }

        leadFormFeilds.push(feildJson);
    });

    var isFirstPage = (pageIndex == 0);
    var isLastPage = (pageIndex == totalPages - 1);
    //console.log(leadFormFeilds);
    var req = JSON.stringify({ leadformRequest: { FeildList: leadFormFeilds, FirstPage: isFirstPage}});

    $.ajax({
        type: "POST",
        //async: false,
        cache: false,
        url: VP.LeadFormPopup.leadPopupServiceUrl + "SaveLeadInfo?" + VP.LeadFormPopup.leadFormParams,
        data: req,
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        success: function (msg) {
            //saving lead information on first page
            if (isFirstPage && msg.d.RedirectUrl)
                VP.LeadFormPopup.leadSaveParams = msg.d.RedirectUrl;

            if (isLastPage) {
                if (msg.d.IsRedirect) {
                    sessionStorage.setItem(VP.LeadFormPopup.popupIsOpenedSessionKey, "");
                    window.location.href = msg.d.RedirectUrl;
                }
                else if (VP.LeadFormPopup.isAutoLoad) {
                    VP.LeadFormPopup.isNewUserLoggedIn = 1;
                    VP.LeadFormPopup.closePopup($(".lead-form-popup-overlay"));
                }
                else {
                    VP.LeadFormPopup.isNewUserLoggedIn = 1;
                    VP.LeadFormPopup.leadFormParams = VP.LeadFormPopup.leadSaveParams;
                    VP.LeadFormPopup.getThankyouPage();
                }
            } else {
                pageCallBack && pageCallBack();
                VP.LeadFormPopup.isNewUserLoggedIn = 1;
                //setting analytics
                if (msg.d.Data) {
                    try {
                        $("#leadFormPopup").append(msg.d.Data);
                    } catch (ex) {
                        console.warn(ex);
                    }
                }

                VP.Forms.LeadForm.Loader(false, $("#leadFormPopup"));
            }
        },
        error: function (err) {
            console.log(err);
            VP.Forms.LeadForm.Loader(false, $("#leadFormPopup"));
        }
    });
};

VP.LeadFormPopup.submitOtherRelatedProducts = function () {
    //reading selected other related products
    var selectedChks = $("#leadFormPopup").find('[id*=chk_pro_]:checked');
    if (selectedChks && selectedChks.length > 0) {
        VP.Forms.LeadForm.Loader(true, $("#leadFormPopup"));
        var idList = [];
        selectedChks.each(function(index, item) {
            var idSplits = $(item).attr("id").split("_");
            idList.push(idSplits[idSplits.length - 1]);
        });

        var req = JSON.stringify({ idList: idList });

        $.ajax({
            type: "POST",
            //async: false,
            cache: false,
            url: VP.LeadFormPopup.leadPopupServiceUrl + "SaveRelatedProducts?" + VP.LeadFormPopup.leadFormParams,
            data: req,
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function(msg) {
                sessionStorage.setItem(VP.LeadFormPopup.popupIsOpenedSessionKey, "");
                window.location.href = msg.d;
                VP.Forms.LeadForm.Loader(false, $("#leadFormPopup"));
            },
            error: function(err) {
                console.log(err);
                VP.Forms.LeadForm.Loader(false, $("#leadFormPopup"));
            }
        });
    } else {
        alert("Please select one or more products to request information.");
    }
};

//loading thankYou page 
VP.LeadFormPopup.getThankyouPage = function () {
    $.ajax({
        type: "GET",
        //async: false,
        cache: false,
        url: VP.LeadFormPopup.leadPopupServiceUrl + "GetThankYouPage?" + VP.LeadFormPopup.leadFormParams,
        contentType: "application/json; charset=utf-8",
        success: function (msg) {
            VP.LeadFormPopup.loadLeadFormPopup(msg.d);
            VP.Forms.LeadForm.Loader(false, $("#leadFormPopup"));
        },
        error: function (err) {
            console.log(err);
            VP.Forms.LeadForm.Loader(false, $("#leadFormPopup"));
        }
    });
};


//overriding checkmail for existing user
VP.Forms.LeadForm.CheckEmail = function (id) {
    if (id)
        VP.Forms.LeadForm.EmailTxtId = id;

    if (VP.Forms.LeadForm.EmailTxtId && !VP.LeadFormPopup.isNewUserLoggedIn) {
        var email = $("#" + VP.Forms.LeadForm.EmailTxtId).val();
        if (email != "") {
            var regularExpression = new RegExp(VP.EmailRegEx);
            if (email.match(regularExpression)) {
                var isEmailExist = VP.Forms.BaseForm.CheckEmail(email);
                if (isEmailExist) {
                    try {
                        VP.Login.ShowLoginDialog(email);
                    } catch (err) {
                        log.warn(err);
                    }
                    return false;
                } 
            }
        }
    }
    return true;
};

VP.Forms.LeadForm.Loader = function (show, element) {
    var loader = $("<div class='loader-ovelay'><div id='leadformPopupLoader' class='leadform-popup-loader'></div></div>");
    var parent = $('body');

    if (element) {
        parent = element;
        loader.removeClass("loader-ovelay").addClass("loader-ovelay-sm")
            .find(".leadform-popup-loader").removeClass("leadform-popup-loader").addClass("leadform-popup-loader-sm");
    }

    if (show) {
        parent.append(loader);
    } else {
        parent.find(".loader-ovelay, .loader-ovelay-sm").remove();
    }
};


VP.LeadFormPopup.submitRelatedArticles = function () {
  //reading selected other related products
  var selectedChks = $("#leadFormPopup").find('[id*=chk_pro_]:checked');
  if (selectedChks && selectedChks.length > 0) {
    VP.Forms.LeadForm.Loader(true, $("#leadFormPopup"));
    var idList = [];
    selectedChks.each(function (index, item) {
      var idSplits = $(item).attr("id").split("_");
      idList.push(idSplits[idSplits.length - 1]);
    });

    var req = JSON.stringify({ idList: idList });

    $.ajax({
      type: "POST",
      //async: false,
      cache: false,
      url: VP.LeadFormPopup.leadPopupServiceUrl + "SaveRelatedArticles?" + VP.LeadFormPopup.leadFormParams,
      data: req,
      contentType: "application/json; charset=utf-8",
      dataType: "json",
      success: function (msg) {
        VP.LeadFormPopup.loadLeadFormPopup(msg.d);
        VP.Forms.LeadForm.Loader(false, $("#leadFormPopup"));
      },
      error: function (err) {
        console.log(err);
        VP.Forms.LeadForm.Loader(false, $("#leadFormPopup"));
      }
    });
  } else {
    alert("Please select one or more articles to request information.");
  }
};
