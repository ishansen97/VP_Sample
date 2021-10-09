(function($) {
    $.fn.clickTargetOnEnter = function(options) {
        var defaults = { target: null, requiredField: true };
        var settings = $.extend({}, defaults, options);
        return this.each(function() {
            var $elm = $(this);
            if ($elm.is("input:text") && settings.target && settings.target.jquery != "undefined") {
                if (!$elm.data('clickTarget')) {
                    $elm.data('clickTarget', settings);
                    $elm.keypress(function(event) {
                        if (event.which == 13) {
                            var settings = $(this).data('clickTarget');
                            if ((settings.requiredField && $(this).val().length > 0) || !settings.requiredField) {
                                settings.target.click();
                            }
                            return false;
                        }
                    });
                }
            }
        });
    };
})(jQuery);