
(function () {
	tinymce.PluginManager.requireLangPack('vpflash');

	tinymce.create('tinymce.plugins.VPFlashPlugin', {
		init : function (ed, url) {
			ed.addCommand('mceVPFlash', function () {
				ed.windowManager.open({
					file : url + '/dialog.htm',
					width : 320 + parseInt(ed.getLang('vpflash.delta_width', 0)),
					height : 120 + parseInt(ed.getLang('vpflash.delta_height', 0)),
					inline : 1
				}, {
					plugin_url : url
				});
			});

			ed.addButton('vpflash', {
				title : 'Flash',
				cmd : 'mceVPFlash',
				image : url + '/img/flash.png'
			});

			ed.onNodeChange.add(function (ed, cm, n) {
				if (n.nodeName == 'IMG' && n.alt == 'Flash') {
					cm.setActive('vpflash', true);
				} else {
					cm.setActive('vpflash', false);
				}
			});
		},

		createControl : function (n, cm) {
			return null;
		},
		
		getInfo : function () {
			return {
			    longname: 'VPFlashPlugin plugin',
				author : 'Calcey Team',
				authorurl : 'http://tinymce.moxiecode.com',
				infourl : 'http://wiki.moxiecode.com/',
				version : "1.0"
			};
		}
	});

	// Register plugin
	tinymce.PluginManager.add('vpflash', tinymce.plugins.VPFlashPlugin);
})();