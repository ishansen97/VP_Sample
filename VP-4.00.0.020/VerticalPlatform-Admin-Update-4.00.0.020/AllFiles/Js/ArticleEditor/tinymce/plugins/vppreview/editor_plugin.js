
(function () {
	tinymce.PluginManager.requireLangPack('vppreview');

	tinymce.create('tinymce.plugins.VPPreviewPlugin', {
		init : function (ed, url) {
			ed.addCommand('mceVPPreview', function () {
				ed.pluginManager.TextSectionPreview();
			});

			ed.addButton('vppreview', {
				title : 'Preview',
				cmd : 'mceVPPreview',
				image : url + '/img/preview.png'
			});
			
		},

		createControl : function (n, cm) {
			return null;
		},
		
		getInfo : function () {
			return {
				longname : 'Preview plugin',
				author : 'Calcey Team',
				authorurl : 'http://tinymce.moxiecode.com',
				infourl : 'http://wiki.moxiecode.com/',
				version : "1.0"
			};
		}
	});

	// Register plugin
	tinymce.PluginManager.add('vppreview', tinymce.plugins.VPPreviewPlugin);
})();