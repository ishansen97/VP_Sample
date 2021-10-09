(function () {
	tinymce.PluginManager.requireLangPack('vpcustomtags');

	tinymce.create('tinymce.plugins.VPCustomtagsPlugin', {
		init : function (ed, url) {
			// Register the command so that it can be invoked by using tinyMCE.activeEditor.execCommand('mceExample');
			ed.addCommand('mceVPCustomtags', function () {
				ed.windowManager.open({
					file : url + '/dialog.htm',
					width : 320 + parseInt(ed.getLang('vpcustomtags.delta_width', 0)),
					height : 120 + parseInt(ed.getLang('vpcustomtags.delta_height', 0)),
					inline : 1
				}, {
					plugin_url : url
				});
			});

			// Register example button
			ed.addButton('vpcustomtags', {
				title : 'Custom Tags',
				cmd : 'mceVPCustomtags',
				image : url + '/img/tag.png'
			});

		},

		createControl : function (n, cm) {
			return null;
		},
		getInfo : function () {
			return {
				longname : 'Custom Tags plugin',
				author : 'Calcey team',
				authorurl : 'http://tinymce.moxiecode.com',
				infourl : 'http://wiki.moxiecode.com/index.php/TinyMCE:Plugins/example',
				version : "1.0"
			};
		}
	});

	tinymce.PluginManager.add('vpcustomtags', tinymce.plugins.VPCustomtagsPlugin);
})();