tinyMCEPopup.requireLangPack();

var DivTagDialog = {
	init : function () {
	},

	insert : function () {
		var cssClass= $('#ddlClasses').val();
		var styleName = $.trim($('#txtCustomStyle').val());
		var ed = tinyMCE.activeEditor, s = ed.selection, dom = ed.dom, sb, eb, n, div, bm, r, i;

		// Get start/end block
		sb = dom.getParent(s.getStart(), dom.isBlock);
		eb = dom.getParent(s.getEnd(), dom.isBlock);

		if (!sb && !eb) {
			return;
		}

		if (sb != eb || sb.childNodes.length > 1 || (sb.childNodes.length == 1 && sb.firstChild.nodeName != 'BR'))
			bm = s.getBookmark();

		tinymce.each(s.getSelectedBlocks(s.getStart(), s.getEnd()), function(e) {
			if (!div) {
				div = dom.create('div');
				e.parentNode.insertBefore(div, e);
			}

		if (div!=null)
			div.appendChild(dom.remove(e));
		});
			
		if (!tinyMCE.DOM.hasClass(div, cssClass) && cssClass != '-1') {
			tinyMCE.DOM.addClass(div, cssClass);
		}
		
		if (styleName != "") {
		tinyMCE.DOM.setAttribs(div,{'style' : styleName});
		}
		
		if (!bm) {
			// Move caret inside empty block element
			if (!tinymce.isIE) {
				r = ed.getDoc().createRange();
				r.setStart(sb, 0);
				r.setEnd(sb, 0);
				s.setRng(r);
			} else {
				s.select(sb);
				s.collapse(1);
			}
		} else {
			s.moveToBookmark(bm);
		}
		tinyMCEPopup.close();
		}
	};

tinyMCEPopup.onInit.add(DivTagDialog.init, DivTagDialog);
