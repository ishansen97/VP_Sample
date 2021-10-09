
(function () {
	tinymce.PluginManager.requireLangPack('vpgroupsnippet');

	tinymce.create('tinymce.plugins.VPGroupSnippetPlugin', {		
		init : function (ed, url) {
			ed.addCommand('mceVPGroupSnippet', function () {
				ed.windowManager.open({
					file : url + '/dialog.htm',
					width : 320 + parseInt(ed.getLang('vpgroupsnippet.delta_width', 0)),
					height : 120 + parseInt(ed.getLang('vpgroupsnippet.delta_height', 0)),
					inline : 1
				}, {
					plugin_url : url
				});
			});

			ed.addButton('vpgroupsnippet', {
				title : 'Render Content Item',
				cmd : 'mceVPGroupSnippet',
				image : url + '/img/snippet.png'
			});
			
		},

		createControl : function (n, cm) {
			return null;
		},
		
		getInfo : function () {
			return {
				longname : 'Snippet plugin',
				author : 'Calcey Team',
				authorurl : 'http://tinymce.moxiecode.com',
				infourl : 'http://wiki.moxiecode.com/',
				version : "1.0"
			};
		}
	});

	// Register plugin
	tinymce.PluginManager.add('vpgroupsnippet', tinymce.plugins.VPGroupSnippetPlugin);
})();