
VP.ArticleEditor.SectionSettingEditor = function()
{
	this._element = null;
	this._errors = [];
	this._section = [];
};

VP.ArticleEditor.SectionSettingEditor.prototype.InitEditor = function(section)
{
	this._section = section;
};

VP.ArticleEditor.SectionSettingEditor.prototype.LoadEditor = function(element, parentId) 
{
	this._element = element;
	this.DisplaySectionTypeName();
	if(this._section.Locked)
	{
		$(".chkLocked", this._element).attr('checked', 'checked');
	}
	else
	{
		$(".chkLocked", this._element).removeAttr('checked');
	}
	
	if(this._section.IsTitleOptional)
	{
		$(".chkSectionTitleOptional", this._element).attr('checked', 'checked');
	}
	else
	{
		$(".chkSectionTitleOptional", this._element).removeAttr('checked');
	}
	
	if(this._section.EnableResourceReordering)
	{
		$(".chkItemReorder", this._element).attr('checked', 'checked');
	}
	else
	{
		$(".chkItemReorder", this._element).removeAttr('checked');
	}
	
	if( this._section.EnableChangeCssClass)	
	{
		$(".chkChangeCss", this._element).attr('checked', 'checked');
	}
	else
	{
		$(".chkChangeCss", this._element).removeAttr('checked');
	}

	var checkBoxList = $(".chklItemRestricted input[type=checkbox]", this._element);
	var selectedItem = -1;
	
	for(var item = 0; item<this._section.DisabledResourceTypes.length; item++)
	{
		selectedItem = this._section.DisabledResourceTypes[item];
		for(var i = 0; i<checkBoxList.length; i++)
		{
			if($(checkBoxList[i]).parent().attr('alt') == selectedItem)
			{
				checkBoxList[i].checked = true;
			}
		}
	}
};

VP.ArticleEditor.SectionSettingEditor.prototype.Save = function()
{
	this._section.Locked = $(".chkLocked", this._element).attr('checked');
	this._section.EnableResourceReordering = $(".chkItemReorder", this._element).attr('checked');
	this._section.EnableChangeCssClass = $(".chkChangeCss", this._element).attr('checked');
	this._section.IsTitleOptional = $(".chkSectionTitleOptional", this._element).attr('checked');
	this._section.DisabledResourceTypes = [];
	
	var checkBoxList = $(".chklItemRestricted input[type=checkbox]", this._element);
	
	for(var i=0; i<checkBoxList.length; i++)
	{
		if(checkBoxList[i].checked)
		{
			this._section.DisabledResourceTypes[this._section.DisabledResourceTypes.length] =
					parseInt($(checkBoxList[i]).parent().attr('alt'));
		}
	}
};

VP.ArticleEditor.SectionSettingEditor.prototype.Validate = function() {
	return true;
};

VP.ArticleEditor.SectionSettingEditor.prototype.DisplaySectionTypeName = function() {
	var container = $(".ArticleContentEdit");
	$(container).prepend("<h4>Section Settings</h4>");
};