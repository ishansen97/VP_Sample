RegisterNamespace("VP.PrebuiltFixedGuidedBrowse");
(function ($) {
    $(document).ready(function () {
        var directoryColumn1 = $(".directoryModule ul[class='column1']");
        var directoryColumn2 = $(".directoryModule ul[class='column2']");

        $(".fixed-guided-list li[class^='move']").each(function () {
            var className = $(this).attr('class');
            var parameters = className.split('_');
            if (parameters.length == 3) {
                var column = parameters[1];
                var index = parameters[2];
                if (column == '1') {
                    if (directoryColumn1) {
                        var previousLiColumn1 = $("ul.column1 > li:nth-child(" + index + ")");
                        if (previousLiColumn1) {
                            $(this).insertBefore($(previousLiColumn1));
                        }
                    }
                } else if (column == '2') {
                    if (directoryColumn2) {
                        var previousLiColumn2 = $("ul.column2 > li:nth-child(" + index + ")");
                        if (previousLiColumn2) {
                            $(this).insertBefore($(previousLiColumn2));
                        }
                    }
                }
            }
        });
    });
})(jQuery);