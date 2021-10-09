RegisterNamespace("VP.IPList");

VP.IPList.pageIndex = null;
VP.IPList.pageSize = null;
VP.IPList.ipGroup = null;
VP.IPList.ipCount = null;

VP.IPList = function () {
	$("a.iplist", "div.pager").live('click', function () {
		VP.IPList.pageIndex = $(this).attr("rel") * 1;
		VP.IPList.PopulateIpList();
	});
	
	$("a.lnkEdit", "tr.ipTableRow").live('click', function () {
		var ipId = $(this).attr("rel");
		$.popupDialog.openDialog(VP.ApplicationRoot + VP.IPList.GetIPAddressEditLink(ipId));
	});
	
	$("a.lnkDelete", "tr.ipTableRow").live('click', function () {
		var ipId, isDeleting;
		ipId = $(this).attr("rel");
		isDeleting = confirm("Are you sure to remove this ip?");
		if (isDeleting) {
			VP.IPList.DeleteIP(ipId);
			VP.IPList.PopulateIpList();
			VP.IPList.UpdateParentOnDelete();
		}
	});
};

VP.IPList.LoadIpList = function (ipGroup, ipCount) {
	VP.IPList.ipGroup = ipGroup;
	VP.IPList.ipCount = ipCount;
	VP.IPList.pageIndex = 1;
	VP.IPList.pageSize = 80;
	VP.IPList.PopulateIpList();
};

VP.IPList.PopulateIpList = function () {
	VP.IPList.GetIPAddressList();
	$("#ipAddress_" + VP.IPList.ipGroup).append(VP.IPList.BuildPagerHtml()); 
};

VP.IPList.GetIPAddressList = function () {
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: VP.AjaxWebServiceUrl + "/GetIPAddressList",
		data: "{'groupId' : " + VP.IPList.ipGroup + ",'pageSize':" + VP.IPList.pageSize + ",'pageIndex':" +
				 VP.IPList.pageIndex + "}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function (msg) {
			$("#ipAddress_" + VP.IPList.ipGroup).html(VP.IPList.BuildIPAddressTableHtml(msg.d));
		},
		error: function (xmlHttpRequest, textStatus, errorThrown) {
			$.notify({ message: 'Internal Server Error, IP Address List retrieve failed.', type: 'error' });
		}
	});
};

VP.IPList.DeleteIP = function (ipId) {
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: VP.AjaxWebServiceUrl + "/DeleteIPAddress",
		data: "{'ipId' : " + ipId + "}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function (msg) {
			$.notify({ message: 'IP Address deleted.', type: 'ok'});
		},
		error: function (xmlHttpRequest, textStatus, errorThrown) {
			$.notify({ message: 'Internal Server Error, IP Address deletion failed.', type: 'error' });
		}
	});
};

VP.IPList.GetIPAddressEditLink = function (ipId) {
	var url = "";
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: VP.AjaxWebServiceUrl + "/GetIPAddressEditLink",
		data: "{'ipId' : " + ipId + "}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function (msg) {
			url = msg.d;
		},
		error: function (xmlHttpRequest, textStatus, errorThrown) {
			$.notify({ message: 'Internal Server Error, IP Address edit failed.', type: 'error' });
		}
	});
	return url.replace("~", "..");
};

VP.IPList.BuildIPAddressTableHtml = function (ipAddress) {
	var html = "";
	if (ipAddress.length > 0) {
		html = "<table rules='all' cellspacing='0' border='1' style='border-collapse: collapse;'" +
				" class='common_data_grid inner_table'>\n<tr>" +
				"<th scope='col'>IP Address</th>" +
				"<th scope='col'>Status</th>" +
				"<th scope='col'>Description</th>" +
				"<th scope='col'>&nbsp;</th></tr>\n";
		for (index in ipAddress) {
			html += "<tr class='ipTableRow'><td>" + ipAddress[index].IPAddress + "</td>" +
				"<td>" + VP.IPList.GetStatusText(ipAddress[index].BlockedStatus) + "</td><td>" +
				ipAddress[index].Description +
				"<td><a class='lnkEdit aDailog' onclick='return false;' rel='" + ipAddress[index].Id +
				"'>Edit</a>&nbsp; <a class='lnkDelete' onclick='return false;' rel='" + ipAddress[index].Id +
				"'>Delete</a></td></tr>\n";
		}
		html += "</table>\n";
	}
	return html;
};

VP.IPList.BuildPagerHtml = function () {
	var html = "";
	if (VP.IPList.ipCount  > VP.IPList.pageSize) {
		var pages, pagerSize, first, last, next, prev, indexes, start, length, sDots, eDots, cssClass, i;
		pagerSize = 5;
		pages = VP.IPList.ipCount / VP.IPList.pageSize;
		if ((VP.IPList.ipCount % VP.IPList.pageSize) > 0) {
			pages += 0.5;
		}
		pages = Math.round(pages);
		first = "<a rel='1' class='enablePage iplist'>[First]</a>\n";
		last = "<a rel='" + pages + "' class='enablePage iplist'>[Last]</a>\n";
		next = "";
		prev = "";
		indexes = "";
		sDots = "";
		eDots = "";
		if (VP.IPList.pageIndex < pages) {
			next = "<a rel='" + (VP.IPList.pageIndex + 1) + "' class='enablePage iplist'>[Next]</a>\n";
		}
		if (VP.IPList.pageIndex > 1) {
			prev = "<a rel='" + (VP.IPList.pageIndex - 1) + "' class='enablePage iplist'>[Previous]</a>\n";
		}
		if (pages > pagerSize) {
			if (VP.IPList.pageIndex == 1) {
				first = "";
				prev = "";
				start = 1;
				length = pagerSize;
				eDots = "<span  class='enablePage'>...</span>\n";
			} else if (VP.IPList.pageIndex == pages) {
				last = "";
				next = "";
				start = (pages + 1) - pagerSize;
				length = pages;
				sDots = "<span  class='enablePage'>...</span>\n";
			} else {
				start = VP.IPList.pageIndex;
				length = VP.IPList.pageIndex + pagerSize - 1;
				if (length >= pages) {
					start = start - (length - pages);
					length = pages;
					sDots = "<span  class='enablePage'>...</span>\n";
				} else {
					eDots = "<span  class='enablePage'>...</span>\n";
				}
			}
		} else {
			start = 1;
			length = pages;
		}
		for (i = start; i <= length; i++) {
			cssClass = "'enablePage iplist'";
			if (i == VP.IPList.pageIndex) {
				cssClass = "'selectedPage iplist' disabled='disabled'";
			}
			indexes += "<a rel='" + i + "' class=" + cssClass + "> " + i + " </a>\n";
		}
		html = "<div class='pager'>" + first + prev + sDots + indexes + eDots + next + last + "</div>";
	}
	return html;
};

VP.IPList.UpdateParentOnDelete = function () {
	VP.IPList.ipCount = VP.IPList.ipCount - 1;
	$("span.ipGroup_" + VP.IPList.ipGroup).text(VP.IPList.ipCount);
};

VP.IPList.GetStatusText = function (status) {
	var statusText = "Disallowed";
	if (status == 2) {
		statusText = "Allowed";
	}
	else if (status == 0) {
		statusText = "None";
	}
	return statusText;
};
