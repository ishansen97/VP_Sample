RegisterNamespace("VP.Scripting");

VP.Scripting.Snippet = function(language, contentType, groupName, snippetType, renderType) {
	this._language = language;
	this._contentType = contentType;
	this._groupName = groupName;
	this._snippetType = snippetType;
	this._renderType = renderType;
};

VP.Scripting.Snippet.prototype.GetSnippet = function() {
	var snippet = "";
	switch (this._contentType) {
		case 4:
			snippet = this.GetArticleSnippet();
			break;
		case 2:
			snippet = this.GetProductSnippet();
			break;
		case 1:
			snippet = this.GetCategorySnippet();
			break;
		case 6:
			snippet = this.GetVendorSnippet();
			break;
	}
	snippet += "<p>&nbsp;</p>";
	return snippet;
};

VP.Scripting.Snippet.prototype.GetArticleSnippet = function() {
	var html = "";
	var item = this._groupName.substring(0, 1);
	switch (this._renderType) {
		case "Full":
			if (this._snippetType == "Expressions") {

				//for loop start
				html += "{~" + this._groupName + ".each do |" + item + "|~}\n";
				html += "<table> \n";
				html += "<tr>\n";
				html += "<td><img src=\"http://{=" + item + ".ImageUrl=}\" alt=\"{=" + item + ".Article.Title=}\" title=\"{=" + item + ".Article.Title=}\"/></td>\n";
				html += "<td valign=\"top\">\n";
				html += "<h3>{=" + item + ".Article.Title=}</h3>\n";
				html += "<p>{=" + item + ".Article.Summary=}</p>\n";
				html += "<a href=\"http://{=" + item + ".NavigationUrl=}\" title=\"{=" + item + ".Article.Title=}\" target=\"_blank\">{=" + item + ".Article.Title=}</a>\n";
				html += "<br/>\n";
				html += "<span>{=" + item + ".DatePublished('')=}</span>\n";
				html += "</td></tr>\n";
				html += "</table>\n";	
				html += "{~end~}\n";
			}
			else {
				html += "{~" + this._groupName + ".each do |" + item + "|~}\n";
				html += "{=" + item + ".Render()=}\n";
				html += "{~end~}\n";
			}
			break;
		case "Summary":
			if (this._snippetType == "Expressions") {

				//for loop start
				html += "{~" + this._groupName + ".each do |" + item + "|~}\n";
				html += "<table>\n";
				html += "<tr>\n";
				html += "<td><img src=\"http://{=" + item + ".ImageUrl=}\" alt=\"{=" + item + ".Article.Title=}\" title=\"{=" + item + ".Article.Title=}\"/></td>\n";
				html += "<td valign=\"top\">\n";
				html += "<h3>{=" + item + ".Article.Title=}</h3>\n";
				html += "<p>\n";
				html += "{~if " + item + ".SummaryTextLength > " + item + ".TruncationLength~}\n";
				html += "{=" + item + ".Truncate(" + item + ".Article.Summary, " + item + ".TruncationLength)=}...\n";
				html += "{~else~}\n";
				html += "{=" + item + ".Article.Summary=}\n";
				html += "{~end~}\n";
				html += "</p>\n";
				html += "<a href=\"http://{=" + item + ".NavigationUrl=}\" title=\"{=" + item + ".Article.Title=}\" target=\"_blank\">{=" + item + ".Article.Title=}</a>\n";
				html += "<br/>\n";
				html += "<span>{=" + item + ".DatePublished('')=}</span>\n";
				html += "</td></tr>\n";
				html += "</table>\n";
				html += "{~end~}\n";
			}
			else {
				html += "{~" + this._groupName + ".each do |" + item + "|~}\n";
				html += "{=" + item + ".RenderSummary()=}\n";
				html += "{~end~}\n";
			}
			break;
		case "List":
			if (this._snippetType == "Expressions") {

				html += "<ul>\n";
				//for loop start
				html += "{~" + this._groupName + ".each do |" + item + "|~}\n";
				html += "<li>\n";
				html += "<a href=\"http://{=" + item + ".NavigationUrl=}\" title=\"{=" + item + ".Article.Title=}\" target=\"_blank\">{=" + item + ".Article.Title=}</a>\n";
				html += "</li>\n";
				html += "{~end~}\n";

				html += "</ul>\n";
			}
			else {
				html += "{~" + this._groupName + ".each do |" + item + "|~}\n";
				html += "{=" + item + ".RenderList()=}\n";
				html += "{~end~}\n";
			}
			break;
	}

	return html;
};

VP.Scripting.Snippet.prototype.GetProductSnippet = function() {
	var html = "";
	var item = this._groupName.substring(0, 1);
	switch (this._renderType) {
		case "Full":
			if (this._snippetType == "Expressions") {

				//for loop start
				html += "{~" + this._groupName + ".each do |" + item + "|~}\n";
				html += "<table> \n";
				html += "<tr>\n";
				html += "<td><img src=\"http://{=" + item + ".ImageUrl=}\" alt=\"{=" + item + ".Product.Name=}\" title=\"{=" + item + ".Product.Name=}\"/></td>\n";
				html += "<td valign=\"top\">\n";
				html += "<h3>{=" + item + ".Product.Name=}</h3>";
				html += "<p>{=" + item + ".Description=}</p>\n";
				html += "<a href=\"http://{=" + item + ".NavigationUrl=}\" title=\"{=" + item + ".Product.Name=}\" target=\"_blank\">{=" + item + ".Product.Name=}</a>\n";
				html += "</td></tr>\n";
				html += "</table>\n";
				html += "{~end~}\n";
			}
			else {
				html += "{~" + this._groupName + ".each do |" + item + "|~}\n";
				html += "{=" + item + ".Render()=}\n";
				html += "{~end~}\n";
			}
			break;
		case "Summary":
			if (this._snippetType == "Expressions") {
			
				//for loop start
				html += "{~" + this._groupName + ".each do |" + item + "|~}\n";
				html += "<table> \n";
				html += "<tr>\n";
				html += "<td><img src=\"http://{=" + item + ".ImageUrl=}\" alt=\"{=" + item + ".Product.Name=}\" title=\"{=" + item + ".Product.Name=}\"/></td>\n";
				html += "<td valign=\"top\">\n";
				html += "<h3>{=" + item + ".Product.Name=}</h3><p>\n";
				html += "{~if " + item + ".Description.length > " + item + ".TruncationLength~}\n";
				html += "{=" + item + ".Truncate(" + item + ".Description, " + item + ".TruncationLength)=}...\n";
				html += "{~else~}\n";
				html += "{=" + item + ".Description=}\n";
				html += "{~end~}\n";
				html += "</p>\n";
				html += "<a href=\"http://{=" + item + ".NavigationUrl=}\" title=\"{=" + item + ".Product.Name=}\" target=\"_blank\">{=" + item + ".Product.Name=}</a>\n";
				html += "</td></tr>\n";
				html += "</table>\n";
				html += "{~end~}\n";
			}
			else {
				html += "{~" + this._groupName + ".each do |" + item + "|~}\n";
				html += "{=" + item + ".RenderSummary()=}\n";
				html += "{~end~}\n";
			}
			break;
		case "List":
			if (this._snippetType == "Expressions") {

				html += "<ul>\n";
				//for loop start
				html += "{~" + this._groupName + ".each do |" + item + "|~}\n";
				html += "<li>\n";
				html += "<a href=\"http://{=" + item + ".NavigationUrl=}\" title=\"{=" + item + ".Product.Name=}\" target=\"_blank\">{=" + item + ".Product.Name=}</a>\n";
				html += "</li>\n";
				html += "{~end~}\n";

				html += "</ul>\n";
			}
			else {
				html += "{~" + this._groupName + ".each do |" + item + "|~}\n";
				html += "{=" + item + ".RenderList()=}\n";
				html += "{~end~}\n";
			}
			break;
	}

	return html;
};

VP.Scripting.Snippet.prototype.GetCategorySnippet = function() {
var html = "";
var item = this._groupName.substring(0, 1);
switch (this._renderType) {
	case "Full":
		if (this._snippetType == "Expressions") {

			//for loop start
			html += "{~" + this._groupName + ".each do |" + item + "|~}\n";
			html += "<table> \n";
			html += "<tr>\n";
			html += "<td valign=\"top\">\n";
			html += "<h3>{=" + item + ".Category.Name=}</h3>\n";
			html += "<p>{=" + item + ".Category.Description=}</p>\n";
			html += "<a href=\"http://{=" + item + ".NavigationUrl=}\" title=\"{=" + item + ".Category.Name=}\" target=\"_blank\">{=" + item + ".Category.Name=}</a>\n";
			html += "</td></tr>\n";
			html += "</table>\n";
			html += "{~end~}\n";

		}
		else {
			html += "{~" + this._groupName + ".each do |" + item + "|~}\n";
			html += "{=" + item + ".Render()=}\n";
			html += "{~end~}\n";
		}
		break;
	case "Summary":
		if (this._snippetType == "Expressions") {

			//for loop start
			html += "{~" + this._groupName + ".each do |" + item + "|~}\n";
			html += "<table> \n";
			html += "<tr>\n";
			html += "<td valign=\"top\">\n";
			html += "<h3>{=" + item + ".Category.Name=}</h3>\n";
			html += "<p>\n";
			html += "{~if " + item + ".Category.Description.length > " + item + ".TruncationLength~}\n";
			html += "{=" + item + ".Truncate(" + item + ".Category.Description, " + item + ".TruncationLength)=}...\n";
			html += "{~else~}\n";
			html += "{=" + item + ".Category.Description=}\n";
			html += "{~end~}\n";
			html += "</p>\n";
			html += "<a href=\"http://{=" + item + ".NavigationUrl=}\" title=\"{=" + item + ".Category.Name=}\" target=\"_blank\">{=" + item + ".Category.Name=}</a>\n";
			html += "</td></tr>\n";
			html += "</table>\n";
			html += "{~end~}\n";
			
		}
		else {
			html += "{~" + this._groupName + ".each do |" + item + "|~}\n";
			html += "{=" + item + ".RenderSummary()=}\n";
			html += "{~end~}\n";
		}
		break;
	case "List":
		if (this._snippetType == "Expressions") {

			html += "<ul>\n";
			//for loop start
			html += "{~" + this._groupName + ".each do |" + item + "|~}\n";
			html += "<li>\n";
			html += "<a href=\"http://{=" + item + ".NavigationUrl=}\" title=\"{=" + item + ".Category.Name=}\" target=\"_blank\">{=" + item + ".Category.Name=}</a>\n";
			html += "</li>\n";
			html += "{~end~}\n";

			html += "</ul>\n";
		}
		else {
			html += "{~" + this._groupName + ".each do |" + item + "|~}\n";
			html += "{=" + item + ".RenderList()=}\n";
			html += "{~end~}\n";
		}
		break;
}

return html;};

VP.Scripting.Snippet.prototype.GetVendorSnippet = function() {
var html = "";
var item = this._groupName.substring(0, 1);
switch (this._renderType) {
	case "Full":
		if (this._snippetType == "Expressions") {

			//for loop start
			html += "{~" + this._groupName + ".each do |" + item + "|~}\n";
			html += "<table> \n";
			html += "<tr>\n";
			html += "<td valign=\"top\">\n";
			html += "<h3>{=" + item + ".Vendor.Name=}</h3>\n";
			html += "<a href=\"http://{=" + item + ".NavigationUrl=}\" title=\"{=" + item + ".Vendor.Name=}\" target=\"_blank\">{=" + item + ".Vendor.Name=}</a>\n";
			html += "</td></tr>\n";
			html += "</table>\n";
			html += "{~end~}\n";

		}
		else {
			html += "{~" + this._groupName + ".each do |" + item + "|~}\n";
			html += "{=" + item + ".Render()=}\n";
			html += "{~end~}\n";
		}
		break;
	case "Summary":
		if (this._snippetType == "Expressions") {

			//for loop start
			html += "{~" + this._groupName + ".each do |" + item + "|~}\n";
			html += "<table> \n";
			html += "<tr>\n";
			html += "<td valign=\"top\">\n";
			html += "<h3>{=" + item + ".Vendor.Name=}</h3>\n";
			html += "<a href=\"http://{=" + item + ".NavigationUrl=}\" title=\"{=" + item + ".Vendor.Name=}\" target=\"_blank\">{=" + item + ".Vendor.Name=}</a>\n";
			html += "</td></tr>\n";
			html += "</table>\n";
			html += "{~end~}\n";

		}
		else {
			html += "{~" + this._groupName + ".each do |" + item + "|~}\n";
			html += "{=" + item + ".RenderSummary()=}\n";
			html += "{~end~}\n";
		}
		break;
	case "List":
		if (this._snippetType == "Expressions") {

			html += "<ul>\n";
			//for loop start
			html += "{~" + this._groupName + ".each do |" + item + "|~}\n";
			html += "<li>\n";
			html += "<a href=\"http://{=" + item + ".NavigationUrl=}\" title=\"{=" + item + ".Vendor.Name=}\" target=\"_blank\">{=" + item + ".Vendor.Name=}</a>\n";
			html += "</li>\n";
			html += "{~end~}\n";

			html += "</ul>\n";
		}
		else {
			html += "{~" + this._groupName + ".each do |" + item + "|~}\n";
			html += "{=" + item + ".RenderList()=}\n";
			html += "{~end~}\n";
		}
		break;
}
return html;};

