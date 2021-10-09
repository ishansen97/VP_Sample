
(function () {
	tinymce.PluginManager.requireLangPack('vpimage');

	tinymce.create('tinymce.plugins.VPImagePlugin', {
		init : function(ed, url) {
			ed.addCommand('mceVPImage', function () {
				ed.windowManager.open({
					file : url + '/dialog.htm',
					width : 320 + parseInt(ed.getLang('vpimage.delta_width', 0)),
					height : 120 + parseInt(ed.getLang('vpimage.delta_height', 0)),
					inline : 1
				}, {
					plugin_url : url // Plugin absolute URL
				});
			});

			ed.addButton('vpimage', {
				title : 'Image',
				cmd : 'mceVPImage',
				image : url + '/img/picture.png'
			});

			ed.onNodeChange.add(function (ed, cm, n) {
				if (n.nodeName == 'IMG' && n.alt == 'Image') {
					cm.setActive('vpimage', true);
				} else {
					cm.setActive('vpimage', false);
				}
			});
		},

		createControl : function (n, cm) {
			return null;
		},
			
		getInfo : function () {
			return {
				longname : 'vpimage plugin',
				author : 'Calcey Team',
				authorurl : 'http://tinymce.moxiecode.com',
				infourl : 'http://wiki.moxiecode.com/',
				version : "1.0"
				};
		}
	});

	// Register plugin
	tinymce.PluginManager.add('vpimage', tinymce.plugins.VPImagePlugin);
})();