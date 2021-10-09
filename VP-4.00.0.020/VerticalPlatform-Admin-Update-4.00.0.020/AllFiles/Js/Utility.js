function RegisterNamespace(nameSpace) {
	var nsParts = nameSpace.split(".");
	var root = window;

	for (var i = 0; i < nsParts.length; i++) {
		if (typeof root[nsParts[i]] == "undefined")
			root[nsParts[i]] = new Object();
		root = root[nsParts[i]];
	}
}

if (typeof Object.create !== 'function') {
	Object.create = function(o) {
		function F() { }
		F.prototype = o;
		return new F();
	};
}

String.prototype.trim = function() {
	return this.replace(/^\s*/, "").replace(/\s*$/, "");
}

String.prototype.startsWith = function(str)
{ return (this.match("^" + str) == str) }


function GetId(controlId) {
	if (controlId == "") {
		return 0;
	}
	var ids = controlId.split("_");
	return ids[ids.length - 1];
}


RegisterNamespace("VP.Array");

VP.GetControlId = function(compoundId)
{
	var id = ""
	if(compoundId != "")
	{
		var parts = compoundId.split("_");
		id = parts[parts.length - 1];
	}
	return id;
}

VP.Array.Filter = function(array, fn)
{
	var ret = [];
	for(var i=0; i<array.length; i++)
	{
		var elem = array[i];
		if(fn(elem))
		{
			ret[ret.length] = elem;
		}
	}
	return ret;
};


VP.Array.FindFirst = function(array, fn)
{
	for(var i=0; i<array.length; i++)
	{
		var elem = array[i];
		if(fn(elem))
		{
			return elem;
		}
	}
	return null;
};

VP.Array.Count = function (array, fn) {
	var count = 0;
	for (var i = 0; i < array.length; i++) {
		var elem = array[i];
		if (fn(elem)) {
			count++;
		}
	}
	return count;
};

RegisterNamespace("VP");
VP.SiteId;
VP.AjaxWebServiceUrl;
VP.ArticleEditorWebServiceUrl;
VP.EmailRegEx = "^([\\w-+]+(?:\\.[\\w-+]+)*(?:[\\+]){0,1})@((?:[\\w-]+\\.)*\\w[\\w-]{0,66})\\.([A-Za-z]{2,6}(?:\\.[A-Za-z]{2})?)$";

VP.ValidateEmail = function (sender, args) {
	var regularExpression = new RegExp(VP.EmailRegEx);
	if (args.Value !== "" && args.Value.match(regularExpression)) {
		args.IsValid = true;
	}
	else {
		args.IsValid = false;
	}
};