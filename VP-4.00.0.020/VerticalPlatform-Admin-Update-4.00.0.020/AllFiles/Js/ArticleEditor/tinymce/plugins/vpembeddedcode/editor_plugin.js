
(function () {
	tinymce.PluginManager.requireLangPack('vpembeddedcode');

	tinymce.create('tinymce.plugins.VPEmbeddedCodePlugin', {		
		init : function (ed, url) {
			ed.addCommand('mceVPEmbeddedCode', function () {
				ed.windowManager.open({
					file : url + '/dialog.htm',
					width : 320 + parseInt(ed.getLang('vpembeddedcode.delta_width', 0)),
					height : 120 + parseInt(ed.getLang('vpembeddedcode.delta_height', 0)),
					inline : 1
				}, {
					plugin_url : url
				});
			});

			ed.addButton('vpembeddedcode', {
				title : 'Embedded Code',
				cmd : 'mceVPEmbeddedCode',
				image : url + '/img/embed.png'
			});

			ed.onNodeChange.add(function (ed, cm, n) {
				if (n.nodeName == 'IMG' && n.alt == 'EmbeddedCode') {
					cm.setActive('vpembeddedcode', true);
				} else {
					cm.setActive('vpembeddedcode', false);
				}
				
			});
		},

		createControl : function (n, cm) {
			return null;
		},
		
		getInfo : function () {
			return {
				longname : 'EmbeddedCode plugin',
				author : 'Calcey Team',
				authorurl : 'http://tinymce.moxiecode.com',
				infourl : 'http://wiki.moxiecode.com/',
				version : "1.0"
			};
		}
	});

	// Register plugin
	tinymce.PluginManager.add('vpembeddedcode', tinymce.plugins.VPEmbeddedCodePlugin);
})();