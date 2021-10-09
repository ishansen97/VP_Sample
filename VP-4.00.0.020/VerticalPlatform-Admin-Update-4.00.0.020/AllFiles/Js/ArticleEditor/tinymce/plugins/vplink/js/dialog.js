tinyMCEPopup.requireLangPack();

var PluginTypeId = "1";
var PluginTypeName = "Link";

var VPLinkDialog = {
	init: function () {
		var selection, id, alt;
		selection = tinyMCEPopup.editor.selection.getContent();

		if (selection.indexOf("id") != -1 && selection.indexOf("alt") != -1) {
			id = $(selection).attr('id');
			alt = $(selection).attr('alt');
		} else {
			id = "";
			alt = "";
		}

		if ((PluginTypeName == alt) && (id.indexOf("plugin_") != -1)) {
			var pluginManager, plugin;
			pluginManager = tinyMCEPopup.editor.pluginManager;
			plugin = pluginManager.GetPluginInstance(id);

			$('#txtUrl').val(plugin.Resource.Url);
			$('#cbInternal').attr('checked', plugin.Resource.IsInternalLink);
			$('#txtText').val(plugin.Resource.Text);
			$('#txtTitle').val(plugin.Resource.Title);
			$('#cbNewWindow').attr('checked', plugin.Resource.IsOpenInNewWindow);
			$('#txtCss').val(plugin.Resource.CustomCss);
			$('#txtImage').val(plugin.Resource.LinkImage);
			$('#nofollowCheck').attr('checked', plugin.Resource.IsNoFollowLink);
		} else if (selection.indexOf("plugin_") == -1) {
			$('#txtText').val(tinyMCEPopup.editor.selection.getContent({ format: 'text' }));
			this.getDefaultNoFollow();
		}

	},

	insert: function () {
		// Insert the contents from the input into the document
		var selection, pluginManager, plugin, update, placeHolder;
		selection = tinyMCEPopup.editor.selection.getContent();
		pluginManager = tinyMCEPopup.editor.pluginManager;
		plugin = null;
		update = false;
		if (selection.length > 0) {
			var id, alt;
			try {
				id = $(selection).attr('id');
				alt = $(selection).attr('alt');
				if ((PluginTypeName == alt) && (id.indexOf("plugin_") != -1)) {
					update = true;
				}
			} catch (e) { }
		}

		if (update) {
			plugin = pluginManager.GetPluginInstance(id);
		} else {
			plugin = pluginManager.CreatePluginInstance(PluginTypeId);
		}

		if (this.validate(plugin.Resource)) {
			plugin.Resource.Url = $('#txtUrl').val();
			plugin.Resource.IsInternalLink = $('#cbInternal').attr('checked');
			plugin.Resource.Text = $('#txtText').val();
			plugin.Resource.Title = $('#txtTitle').val();
			plugin.Resource.IsOpenInNewWindow = $('#cbNewWindow').attr('checked');
			plugin.Resource.CustomCss = $('#txtCss').val();
			plugin.Resource.LinkImage = $('#txtImage').val();
			plugin.Resource.IsNoFollowLink = $('#nofollowCheck').attr('checked');
			placeHolder = pluginManager.SetPluginInstance(plugin);
			tinyMCEPopup.editor.execCommand('mceInsertContent', false, placeHolder);
			pluginManager.Save();
			tinyMCEPopup.close();
		}
	},

	validate: function (Resource) {
		var valid, message, focus;
		valid = true;
		message = "";
		focus = new Array();

		if ($("#cbInternal").attr('checked')) {
			this.getFixedUrl(Resource);
			if (Resource.UrlId < 0) {
				message += "<li> Please enter valid internal Url </li>";
				focus[focus.length] = '#txtUrl';
				valid = false;
			}
		} else {
			if ($.trim($('#txtUrl').val()) != "") {
				var regexp = /(http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/
				if (!regexp.test($('#txtUrl').val())) {
					message += "<li> Please enter the valid Url format </li>";
					focus[focus.length] = '#txtUrl';
					valid = false;
				}
			} else {
				message += "<li> Please enter valid Url </li>";
				focus[focus.length] = '#txtUrl';
				valid = false;
			}
		}

		if ($.trim($('#txtText').val()) == "") {
			message += "<li> Please enter url text </li>";
			focus[focus.length] = '#txtText';
			valid = false;
		}

		if ($.trim($('#txtTitle').val()) == "") {
			message += "<li> Please enter url title </li>";
			focus[focus.length] = '#txtTitle';
			valid = false;
		}

		if (focus.length > 0) {
			$(focus[0]).focus();
		}
		$("ul.errorPanel").html(message);

		return valid;
	},

	getFixedUrl: function (Resource) {
		if ($("#cbInternal").attr('checked') && $("#txtUrl").val() != "") {
			serviceUrl = "../../../../../Services/ArticleEditorService.asmx/";
			var fixedUrl = $("#txtUrl").val();
			fixedUrl = fixedUrl.replace("http://", "");
			var siteId = $("input[id$='hdnSiteId']", window.parent.document)[0].value;
			$.ajax({
				type: "POST",
				async: false,
				cache: false,
				url: serviceUrl + "GetFixedUrlIdAndTitle",
				data: "{'internalUrl' : '" + fixedUrl + "','siteId' : '" + siteId + "'}",
				contentType: "application/json; charset=utf-8",
				dataType: "json",
				success: function (msg) {
					var urlDetails = msg.d;
					if (urlDetails.length > 0) {
						Resource.UrlId = urlDetails[0];
						if (urlDetails.length > 1) {
							$("#txtTitle").val(urlDetails[1]);
						}
					}
				},
				error: function (xmlHttpRequest, textStatus, errorThrown) {
					document.location("../../../../../Error.aspx");
				}
			});
		}
	},

	getDefaultNoFollow: function () {
		serviceUrl = "../../../../../Services/ArticleEditorService.asmx/";
		var articleId = $("input[id$='hdnArticleId']", window.parent.document)[0].value;
		$.ajax({
			type: "POST",
			async: false,
			cache: false,
			url: serviceUrl + "GetDefaultIsEnableNoFollow",
			data: "{'articleId' : '" + articleId + "'}",
			contentType: "application/json; charset=utf-8",
			dataType: "json",
			success: function (msg) {
				var defaultIsNoFollow = msg.d;
				$('#nofollowCheck').attr('checked', defaultIsNoFollow);
			}
		});
	}
};

tinyMCEPopup.onInit.add(VPLinkDialog.init, VPLinkDialog);