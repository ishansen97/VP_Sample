RegisterNamespace("VP.BulkEmail.RegionConditionEditor");

VP.BulkEmail.RegionConditionEditor = function(fieldElement, segmentCondition, field, segmentTree) {
	VP.BulkEmail.ConditionEditor.apply(this, arguments);
};

VP.BulkEmail.RegionConditionEditor.prototype = Object.create(VP.BulkEmail.ConditionEditor.prototype);

VP.BulkEmail.RegionConditionEditor.prototype.LoadCondition = function() {
	VP.BulkEmail.ConditionEditor.prototype.LoadCondition.apply(this, arguments);

	var orRuleSection = $("ul.ulSegmentConditions", this._fieldElement);
	var newOrRule = $("<li></li>");
	newOrRule.data("conditionEditor", this);

	$(orRuleSection).append(newOrRule);
	var orUI = $("div.divSegmentConditionTemplate", "#divRuleTemplates").clone();
	$("span.valueSection", orUI).replaceWith(VP.BulkEmail.RegionTemplate.clone());
	if (this._segmentCondition.Value) {
		$('select.segmentCondition', orUI).val(this._segmentCondition.Value);
	}

	if (this._segmentCondition.OperatorId) {
		$("select.ddlOperations", orUI).val(this._segmentCondition.OperatorId);
	}

	this._conditionElement = newOrRule;
	this.RemoveOperations($("select.ddlOperations", orUI));
	$(newOrRule).append(orUI);
	this.InitializeDeleteButton();
};

VP.BulkEmail.LoadRegions = function() {
	var that = this;
	var regions;
	$.ajax({
		type: "POST",
		async: false,
		cache: false,
		url: VP.ApplicationRoot + "Services/BulkEmailWebService.asmx/GetRegions",
		data: "{'siteId' : " + VP.SiteId + "}",
		contentType: "application/json; charset=utf-8",
		dataType: "json",
		success: function(msg) {
			regions = msg.d;
		},
		error: function(xmlHttpRequest, textStatus, errorThrown) {
			document.location = "../../Error.aspx";
		}
	});

	var regionIndex = 0;
	if (regions.length > 0) {
		for (regionIndex in regions) {
			VP.BulkEmail.RegionTemplate.append("<option value='" + regions[regionIndex].Id +
					"'>" + regions[regionIndex].Name + "</option>");
		}
	}

	return regions;
};

VP.BulkEmail.Regions = [];
VP.BulkEmail.RegionTemplate = $("<select class='segmentCondition'></select>");

$(document).ready(function() {
	VP.BulkEmail.Regions = VP.BulkEmail.LoadRegions();
});