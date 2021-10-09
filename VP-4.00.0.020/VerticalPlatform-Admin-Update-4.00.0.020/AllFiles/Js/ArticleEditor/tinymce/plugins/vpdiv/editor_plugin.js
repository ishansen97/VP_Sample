(function () {
	tinymce.PluginManager.requireLangPack('vpdiv');

	tinymce.create('tinymce.plugins.VPDivPlugin', {
		init : function (ed, url) {
			// Register the command so that it can be invoked by using tinyMCE.activeEditor.execCommand('mceExample');
			ed.addCommand('mceVPDiv', function () {
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
			ed.addButton('vpdiv', {
				title : 'Div Tag',
				cmd : 'mceVPDiv',
				image : url + '/img/div.png'
			});

		},

		createControl : function (n, cm) {
			return null;
		},
		getInfo : function () {
			return {
				longname : 'Div Tags plugin',
				author : 'Calcey team',
				authorurl : 'http://tinymce.moxiecode.com',
				infourl : 'http://wiki.moxiecode.com/index.php/TinyMCE:Plugins/example',
				version : "1.0"
			};
		}
	});

	tinymce.PluginManager.add('vpdiv', tinymce.plugins.VPDivPlugin);
})();