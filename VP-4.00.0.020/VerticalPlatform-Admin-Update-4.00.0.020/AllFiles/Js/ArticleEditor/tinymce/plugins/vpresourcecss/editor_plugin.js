(function () {
	
	tinymce.create('tinymce.plugins.VPResourceCssPlugin', {
		createControl : function (n, cm) {
			switch (n) {
				case 'vpresourcecsslist':
				var csslb = cm.createListBox('vpresourcecsslist', {
					title : 'CSS Classes',
					onselect : function (cssClass) {
						var selectedNode = tinyMCE.activeEditor.selection.getNode();
						var validTags = "P, DIV, LI, UL, OL, IMG, SPAN, A, TABLE, TBODY, TR, TH, TD, EM";
						if (validTags.indexOf(selectedNode.nodeName) > -1 && !tinyMCE.DOM.hasClass(selectedNode, cssClass)) {
							tinyMCE.DOM.addClass(selectedNode, cssClass);
						}
					}
				});
				var cssClasses = tinyMCE.activeEditor.pluginManager.GetCssClasses();
				var i=0;
				for (i=0; cssClasses.length > i; i++)
				{
					csslb.add(cssClasses[i], cssClasses[i]);
				}
				return csslb;
			}
			return null;
		},
		
		getInfo : function () {
			return {
				longname : 'ResourceCss plugin',
				author : 'Calcey Team',
				authorurl : 'http://tinymce.moxiecode.com',
				infourl : 'http://wiki.moxiecode.com/',
				version : "1.0"
			};
		}
	});

	// Register plugin
	tinymce.PluginManager.add('vpresourcecss', tinymce.plugins.VPResourceCssPlugin);
})();