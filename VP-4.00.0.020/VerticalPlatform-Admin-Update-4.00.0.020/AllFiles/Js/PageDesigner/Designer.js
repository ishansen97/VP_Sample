VP.Pages.Designer.DesignTimeElement = function() {
	VP.Forms.Designer.DesignTimeElement.apply(this);
};

VP.Pages.Designer.DesignTimeElement.prototype = Object.create(VP.Forms.Designer.DesignTimeElement.prototype);

VP.Pages.Designer.DesignTimeElement.prototype.MoveToOuterContainer = function() {
	if (this._parent._type !== 'Pane') {
		var parentId = this._parent._controlId;
		if (this._parent._parent !== null) {
			var grandParent = this._parent._parent;

			var arrayIndexId = "";
			var that = this;

			for (var i in grandParent._children) {
				if (grandParent._children[i]._controlId == parentId) {
					$("#" + grandParent._children[i]._controlId + "_designer").after(
							$("#" + this._controlId + "_designer"));

					for (var j in grandParent._children[i]._children) {
						if (grandParent._children[i]._children[j]._controlId == this._controlId) {
							arrayIndexId = j;
							delete grandParent._children[i]._children[j];
							break;
						}
					}
				}
			}

			that._parent = grandParent;

			var newChildren = [];
			for (var k in grandParent._children) {
				if (grandParent._children[k]) {
					newChildren[k] = grandParent._children[k];

					if (grandParent._children[k]._controlId == parentId) {
						newChildren[arrayIndexId] = that;
					}
				}
			}

			grandParent._children = newChildren;
		}
	}
};

VP.Pages.Designer.DesignTimeElement.prototype.MoveToInnerContainer = function() {
	if (this._parent) {
		var parent = this._parent;
		var isFound = false;
		var arrayIndex = "";
		for (var i in parent._children) {
			if (isFound) {
				if (parent._children[i]._type === 'Container') {
					var that = this;
					$("#" + parent._children[i]._controlId + "_designer .controlContainer").eq(0).append(
							$("#" + this._controlId + "_designer"));
					that._parent = parent._children[i];
					delete parent._children[arrayIndex];

					parent._children[i]._children[arrayIndex] = that;
				}
				break;
			}

			if (parent._children[i]._controlId == this._controlId) {
				isFound = true;
				arrayIndex = i;
			}
		}
	}
};