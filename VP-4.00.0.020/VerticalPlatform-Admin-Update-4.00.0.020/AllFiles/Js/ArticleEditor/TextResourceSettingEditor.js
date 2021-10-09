
VP.ArticleEditor.TextResourceSettingEditor = function()
{
	VP.ArticleEditor.ResourceSettingEditor.apply(this);
};

VP.ArticleEditor.TextResourceSettingEditor.prototype = Object.create(VP.ArticleEditor.ResourceSettingEditor.prototype);

VP.ArticleEditor.TextResourceSettingEditor.prototype.Save = function()
{
	this._resource.DisabledResourceTypes = [];

	var checkBoxList = $(".chklPluginTypes input[type=checkbox]", this._element);
	
	for(var i=0; i<checkBoxList.length; i++)
	{
		if(checkBoxList[i].checked)
		{
			this._resource.DisabledResourceTypes[this._resource.DisabledResourceTypes.length] = 
					parseInt($(checkBoxList[i]).parent().attr('alt'));
		}
	}
};

VP.ArticleEditor.TextResourceSettingEditor.prototype.LoadEditor = function(element, parentId) 
{
	this._element = element;
	VP.ArticleEditor.ResourceSettingEditor.prototype.LoadEditor.apply(this);
	this.DisplayResourceTypeName("Text Resource");
	var checkBoxList = $(".chklPluginTypes input[type=checkbox]", this._element);
	var selectedItem = -1;
	
	if(typeof(this._resource.DisabledResourceTypes) != "undefined")
	{
		for(var item = 0; item<this._resource.DisabledResourceTypes.length; item++)
		{
			selectedItem = this._resource.DisabledResourceTypes[item];
			for(var i = 0; i<checkBoxList.length; i++)
			{
				if ($(checkBoxList[i]).parent().attr('alt') == selectedItem)
				{
					checkBoxList[i].checked = true;
				}
			}
		}
	}
};