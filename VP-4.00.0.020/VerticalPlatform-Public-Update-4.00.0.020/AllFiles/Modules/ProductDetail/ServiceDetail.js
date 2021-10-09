/**
 * @author Jason Roy
 */
(function($) {
    //call or create vp namespace
    $.vp = $.vp ||
    {};
    $.vp.accordionIcons =
    {
        header: "ui-icon-circle-arrow-e",
        headerSelected: "ui-icon-circle-arrow-s"
    };
    $.vp.colorboxPadding =
	{
	    horizontal: 35,
	    vertical: 35
	};
    $.vp.setCurrentServiceCategory = function() {

        //Check to see if accordion exists
        if (!$.vp.servicesAccordion) {
            return;
        }
        $.vp.servicesAccordion.accordion(
        {
            icons: $.vp.accordionIcons,
            autoHeight: false
        });
    };

    $(document).ready(function() {
        $.vp.servicesContentTabs = $('#servicesContentTabs');
        $.vp.imageGalleryTabs = $('#imageGalleryTabs');
        $.vp.servicesAccordion = $('#servicesAccordion');


        $.vp.servicesContentTabs.tabs(
        {
            fx:
            {
                opacity: 'toggle'
            }
        });

        $.vp.imageGalleryTabs.tabs(
        {
            fx:
            {
                opacity: 'toggle'
            }
        });

        /*
        * add listeners for popup content
        */
        $.vp.imageGalleryTabs.find('.sectionsHolder').find('a').each(function(i, domElement) {
            if ($(domElement).hasClass('popup')) {
                var values = $(domElement).attr('class').split(" ");
                var width = Number(values[1].slice(1, values[1].length)) + $.vp.colorboxPadding.horizontal * 2;
                var height = Number(values[2].slice(1, values[2].length)) + $.vp.colorboxPadding.vertical * 2;
                $(domElement).colorbox(({ iframe: true, width: width + "px", height: height + "px" }));
            }
        });

        /*function that moves the current category up based on a query
        * This could/should be moved to a client side call from refering page.
        * I am using the query as an example, but, you just need to pass
        * a variable to the function.
        *
        */

        //First specification section is the requested categories specifications.
        $.vp.setCurrentServiceCategory();
    });

})(jQuery);

