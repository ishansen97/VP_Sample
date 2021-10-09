RegisterNamespace("VP.Tag");

VP.Tag.TagContentType = null;
VP.Tag.TagContentId = null;
VP.Tag.TagResultsUrl = null;
VP.Tag.TagUserId = null;

VP.Tag.Initialize = function() {
	$(document).ready(function() {
		$("#btnAddTag").click(function() {
			$("#tagError").text("");
			VP.Tag.AddTag();
		});
		$("#txtTagName").keypress(function(event) {
			if (event.which == 13) {
				$("#btnAddTag").click();
				return false;
			}
		});
	});
};

VP.Tag.ValidateTag = function() {
	if ($("#txtTagName").val() == "") {
		$("#rfvTagName").css("display", "inline");
		return false;
	}
	else {
		$("#rfvTagName").css("display", "none");
		return true;
	}
};

VP.Tag.FormatTag = function() {
	var tagName = $("#txtTagName").val();
	tagName = tagName.replace(/</g, '');
	tagName = tagName.replace(/>/g, '');
	tagName = tagName.replace(/^\s+/, '');
	tagName = tagName.replace(/\s+$/, '');
	$("#txtTagName").val(tagName);
};

VP.Tag.AddTag = function() {
	VP.Tag.FormatTag();
	if (VP.Tag.ValidateTag()) {
		var tagName = $("#txtTagName").val();
		$.ajax({
			type: "POST",
			url: VP.AjaxWebServiceUrl + "/AddTag",
			cache: false,
			async: false,
			data: "{'contentType':'" + VP.Tag.TagContentType + "','contentId':'" + VP.Tag.TagContentId + "','tagName':'" +
					tagName + "','userId':' " + VP.Tag.TagUserId + "','siteId':'" + VP.SiteId + "'}",
			contentType: "application/json; charset=utf-8",
			dataType: "json",
			success: function(msg) {
				if (msg.d == "00") {
					$("#tagError").text("Error occured while saving tag.");
				}
				else if (msg.d == "01") {
					$("#tagError").text("This tag name already exist.");
				}
				else {
					var tagId = msg.d;
					var url = VP.Tag.TagResultsUrl.replace(/-TagId-/i, tagId);
					var newTagHtml = "<li class='tagElement'>";
					newTagHtml += "<a class='tagLink' href='" + url + "'>" + tagName + "</a>";
					newTagHtml += "</li>";
					$("#tags").append(newTagHtml);
				}

				$("#txtTagName").val('');
			}
		});
	}
};

VP.Tag.Initialize();
