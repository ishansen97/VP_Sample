RegisterNamespace("VP.ExhibitionShowSpecials");

VP.ExhibitionShowSpecials.ModalDialog = null;
VP.ExhibitionShowSpecials.ExhibitionId = "";

VP.ExhibitionShowSpecials.Initialize = function() {

	$(document).ready(function() {
		
		VP.ExhibitionShowSpecials.ModalDialog = $("#modalPopup");
		VP.ExhibitionShowSpecials.ModalDialog.jqm(
		{
			modal: true
		});
		// Popup Open
		$(".specialsPopup").click(function() {
			VP.ExhibitionShowSpecials.ShowMySpecialsPopup();
		});
		
		// Popup Close
		$("#btnClose").on('click', function() {
			VP.ExhibitionShowSpecials.HideDialog();
		});
		
		$("#btnSend").on('click', function(){
			var emailRegEx = VP.EmailRegEx;
			if(VP.ExhibitionShowSpecials.ValidateEmailId("txtFromEmailAddress", emailRegEx) && 
					VP.ExhibitionShowSpecials.ValidateEmailId("txtToEmailAddress", emailRegEx))
			{
				VP.ExhibitionShowSpecials.SendEmailToFriend();
			}else{
				$("#lblErrorMessage").show();
				$("#lblErrorMessage").text("Please enter valid email addresses");
			}
		});
		
		$("#btnEmailToFriend").on('click', function(){
			$("#lblErrorMessage").hide();
			$("#divEmailInfo").toggle();
			
		});
	});
};

//email exhibition specials list to given email
VP.ExhibitionShowSpecials.SendEmailToFriend = function() {
	var headerDivContent = RemoveButtons($('.headerMyshow').clone()).html();
	VP.ExhibitionShowSpecials.ActionClick("email");
	
	var fromAddress = $("#txtFromEmailAddress").val();
	var toAddress = $("#txtToEmailAddress").val();
	var subject = $("#txtSubject").val();

	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: VP.AjaxWebServiceUrl + "/EmailVendorSpecialToFriend",
		data: "{'fromEmail':'" + fromAddress + "','toEmails':'" + toAddress + "','headerDiv':'" +
				headerDivContent + "','subject':'" + subject + "','specialsIdList':'"+
				VP.ExhibitionShowSpecials.GetCookie('mySpecials')+ "' }",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function(msg) {
			$("#divEmailInfo").hide();
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) {
		}
	});
};

// Show the Specials Popup
VP.ExhibitionShowSpecials.ShowMySpecialsPopup = function() {
	VP.ExhibitionShowSpecials.ShowDialog("50px");
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: VP.AjaxWebServiceUrl + "/GetMySpecialsHtml",
		data: "{'specialsIdList':'"+VP.ExhibitionShowSpecials.GetCookie('mySpecials')+
				"','exhibitionId':'" + VP.ExhibitionShowSpecials.ExhibitionId + "'}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function(msg) {
			VP.ExhibitionShowSpecials.ModalDialog.append(msg.d);
			$("#divEmailInfo").hide();
		}
	});
};

// Show My Specials popup dialog
VP.ExhibitionShowSpecials.ShowDialog = function(top) {
	VP.ExhibitionShowSpecials.ModalDialog.empty();
	VP.ExhibitionShowSpecials.ModalDialog.css("top", top);
	VP.ExhibitionShowSpecials.ModalDialog.jqmShow();
};

// Hide the Specials Popup
VP.ExhibitionShowSpecials.HideDialog = function() {
	VP.ExhibitionShowSpecials.ModalDialog.jqmHide();
};

// Get the Cookie Value
VP.ExhibitionShowSpecials.GetCookie = function(cookieName) {
    if (document.cookie.length > 0) {
        var cookieStart = document.cookie.indexOf(cookieName + "=");
        if (cookieStart != -1) {
            cookieStart = cookieStart + cookieName.length + 1;
            cookieEnd = document.cookie.indexOf(";", cookieStart);
            if (cookieEnd == -1) {
                cookieEnd = document.cookie.length;
            }
            return unescape(document.cookie.substring(cookieStart, cookieEnd));
        }
    }

    return "";
};

// Removes the Specials Content from the Popup
VP.ExhibitionShowSpecials.RemoveSpecial = function(specialsId) {
    VP.ExhibitionShowSpecials.RemoveValue(VP.ExhibitionShowSpecials.GetCookie('mySpecials'), specialsId);
    $("#li" + specialsId).remove();
};

// Remove specials value from the cookie
VP.ExhibitionShowSpecials.RemoveValue = function (specialsList, value) {
	var list = specialsList.split('|');
	list.splice(jQuery.inArray(value.toString(), list), 1);	
	if(list.length == 0)
	{
		document.cookie = 'mySpecials=' + '; path=/'; 
	}
	else
	{
		document.cookie = 'mySpecials=' + list.join('|') + '; path=/'; 
	}
	VP.ExhibitionShowSpecials.UpdateSpecialCountLabel();
};

// Print the Popup Contents
VP.ExhibitionShowSpecials.Print = function () {
if (VP.ExhibitionShowSpecials.GetCookie('mySpecials') != null && 
	    VP.ExhibitionShowSpecials.GetCookie('mySpecials') != '')
	{
		var specials = VP.ExhibitionShowSpecials.GetCookie('mySpecials').split('|');
		if (specials.length != 0)
		{
			VP.ExhibitionShowSpecials.ActionClick("print");
			$("#divEmailInfo").hide();
			var divPrintClone = RemoveButtons($('#divPrintSpecials').clone());
			$(divPrintClone).printElement();

		}
	}
};

// Set the Specials Count
VP.ExhibitionShowSpecials.UpdateSpecialCountLabel = function() {
    if (VP.ExhibitionShowSpecials.GetCookie('mySpecials') != null &&
	VP.ExhibitionShowSpecials.GetCookie('mySpecials') != '') {
        var specials = VP.ExhibitionShowSpecials.GetCookie('mySpecials').split('|');
        if (specials.length != 0) {
            $("a[id*=lnkSpecialsPopup]").text("My Show Specials (" + specials.length + ")").removeClass('disabled');
            $('#lnkPrintMySpecials').removeClass('printBtnDisabled');
        }
    }
    else {
        $("a[id*=lnkSpecialsPopup]").text("My Show Specials").addClass('disabled');
        $('#lnkPrintMySpecials').addClass('printBtnDisabled');
        $('#lnkPrintMySpecials').hide();
        $("#divEmailInfo").hide();
        $("#btnEmailToFriend", "#divMyShowSpecial").hide();
        $("ul", "#divMyShowSpecial").text("You have not selected any show special.");
    }
};

//validate email address
VP.ExhibitionShowSpecials.ValidateEmailId = function (controlId, regexText) {
	var val = $("#" + controlId).val();
	var regex = null;
	try {
		regex = new RegExp(regexText);
	}
	catch (err) {
		return true;
	}
	if (val.match(regex) != null) {
		return true;
	}
	return false;
};

//remove the buttons and create print and email friendly document
function RemoveButtons(div) {
	$(".button",div).remove();
	$("#btnEmailToFriend",div).remove();
	return div;
}

VP.ExhibitionShowSpecials.ActionClick = function(action) {
	if (VP.ExhibitionHeader != null && VP.ExhibitionHeader.WebAnalyticsSupportOn) {
		var script = VP.ExhibitionShowSpecials.ActionClickScript(action);
		var re = new RegExp("<<.+>>");
		var match = re.exec(script);
		if (match != null) {
			var template = match[0];
			template = template.replace(/<</, "");
			template = template.replace(/>>/, "");
			var specialsDiv = $("#divMyShowSpecial");
			var products = "";
			$(".webAnalytics", specialsDiv).each(function(index, domElement) {
				var items = $.trim($(domElement).text()).split("^");
				if (items.length == 4) {
					var exhibitionId = items[0];
					var boothId = items[1];
					var vendorId = items[2];
					var vendorName = items[3];
					var itemTemplate = template;
					itemTemplate = itemTemplate.replace(/<ExhibitionId>/gi, exhibitionId);
					itemTemplate = itemTemplate.replace(/<BoothId>/gi, boothId);
					itemTemplate = itemTemplate.replace(/<VendorId>/gi, vendorId);
					itemTemplate = itemTemplate.replace(/<Vendor>/gi, vendorName);
					if (products != "") {
						products += "," + itemTemplate;
					} 
					else {
						products = itemTemplate;
					}
				}
			});
			
			script = script.replace(re, products);
		}
		
		//eval('alert(\'' + script + '\')');
		eval(script);
	}
};

VP.ExhibitionShowSpecials.ActionClickScript = function(action) {
	var script = "";
	if (action == "print") {
		script = 's.products="<<<ExhibitionId>;<BoothId>;;;;evar19=<VendorID>|evar6=<Vendor>>>";' +
			's.linkTrackVars="eVar16,events,products";' +
			's.linkTrackEvents="event32";' +
			's.events="event32";' +
			's.tl(true, "o", "' + s.pageName +  ':exhibitHallPrintCart");';
	}
	else if (action == "email") {
		script = 's.products="<<<ExhibitionId>;<BoothId>;;;;evar19=<VendorID>|evar6=<Vendor>>>";' +
			's.linkTrackVars="eVar16,events,products";' +
			's.linkTrackEvents="event33";' +
			's.events="event33";' +
			's.tl(true, "o", "' + s.pageName +  ':exhibitHallEmailCart");';
	}
	
	return script;
};

VP.ExhibitionShowSpecials.Initialize();