
(function () {
	tinymce.PluginManager.requireLangPack('vplink');

	tinymce.create('tinymce.plugins.VPLinkPlugin', {
		init: function (ed, url) {
			ed.addCommand('mceVPLink', function () {
				ed.windowManager.open({
					file: url + '/dialog.htm',
					width: 320 + parseInt(ed.getLang('vplink.delta_width', 0)),
					height: 120 + parseInt(ed.getLang('vplink.delta_height', 0)),
					inline: 1
				}, {
					plugin_url: url
				});
			});

			// Register vplink button
			ed.addButton('vplink', {
				title: 'Link',
				cmd: 'mceVPLink',
				image: url + '/img/link.png'
			});

			ed.onNodeChange.add(function (ed, cm, n) {
				if (n.nodeName == 'IMG' && n.alt == 'Link') {
					cm.setActive('vplink', true);
				} else {
					cm.setActive('vplink', false);
				}
			});
		},

		createControl: function (n, cm) {
			return null;
		},

		getInfo: function () {
			return {
				longname: 'vplink plugin',
				author: 'Calcey Team',
				authorurl: 'http://tinymce.moxiecode.com',
				infourl: 'http://wiki.moxiecode.com/',
				version: "1.0"
			};
		}
	});

	// Register plugin
	tinymce.PluginManager.add('vplink', tinymce.plugins.VPLinkPlugin);
})();