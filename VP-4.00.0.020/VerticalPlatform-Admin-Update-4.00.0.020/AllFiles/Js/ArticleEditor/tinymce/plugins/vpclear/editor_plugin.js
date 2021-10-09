(function () {
	
	tinymce.create('tinymce.plugins.VPClearPlugin', {
		init : function (ed, url) {
			ed.addCommand('mceClear', function () {
				tinyMCE.activeEditor.windowManager.confirm("Are you sure to clear editor text?", function(s) {
					if (s) {
						tinyMCE.activeEditor.setContent("");
					}
				});
			});

			ed.addButton('vpclear', {
				title : 'Clear Editor',
				cmd : 'mceClear',
				image : url + '/img/clear.png'
			});
		},
		
		getInfo : function () {
			return {
				longname : 'VPClearPlugin plugin',
				author : 'Calcey Team',
				authorurl : 'http://tinymce.moxiecode.com',
				infourl : 'http://wiki.moxiecode.com/',
				version : "1.0"
			};
		}
	});

	// Register plugin
	tinymce.PluginManager.add('vpclear', tinymce.plugins.VPClearPlugin);
})();