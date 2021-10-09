tinyMCEPopup.requireLangPack();

var CustomtagsDialog = {
	init : function () {
		var ddlHtml = $('.ddlTags', window.parent.document).html();
		$('#customTags').html(ddlHtml);
		$('#customTags').val($("#customTags option:first").val());
	},

	insert : function () {
		tinyMCEPopup.editor.execCommand('mceInsertContent', false, $('#customTags').val());
		tinyMCEPopup.close();
	}
};

tinyMCEPopup.onInit.add(CustomtagsDialog.init, CustomtagsDialog);
