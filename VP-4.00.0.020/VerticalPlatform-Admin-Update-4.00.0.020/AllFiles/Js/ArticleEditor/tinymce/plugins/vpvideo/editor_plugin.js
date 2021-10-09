
(function () {
	tinymce.PluginManager.requireLangPack('vpvideo');

	tinymce.create('tinymce.plugins.VPVideoPlugin', {
		init : function (ed, url) {
			ed.addCommand('mceVPVideo', function () {
				ed.windowManager.open({
					file : url + '/dialog.htm',
					width : 320 + parseInt(ed.getLang('vpvideo.delta_width', 0)),
					height : 120 + parseInt(ed.getLang('vpvideo.delta_height', 0)),
					inline : 1
				}, {
					plugin_url : url
				});
			});

			// Register vpvideo button
			ed.addButton('vpvideo', {
				title : 'Video',
				cmd : 'mceVPVideo',
				image : url + '/img/video.png'
			});

			ed.onNodeChange.add(function (ed, cm, n) {
				if (n.nodeName == 'IMG' && n.alt == 'Video') {
					cm.setActive('vpvideo', true);
				} else {
					cm.setActive('vpvideo', false);
				}
			});
		},

		createControl : function (n, cm) {
			return null;
		},
		
		getInfo : function () {
			return {
				longname : 'vpvideo plugin',
				author : 'Calcey Team',
				authorurl : 'http://tinymce.moxiecode.com',
				infourl : 'http://wiki.moxiecode.com/',
				version : "1.0"
			};
		}
	});

	// Register plugin
	tinymce.PluginManager.add('vpvideo', tinymce.plugins.VPVideoPlugin);
})();