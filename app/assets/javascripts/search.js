(function() {
    jQuery(window).scroll(function() {

        var header = jQuery(".services-search");  
        var headerHeight = header.height(); 
        var stickyElement = jQuery(".fixed-search");
        var scrollTop = jQuery(window).scrollTop();
        if (scrollTop > headerHeight) {
            if (!stickyElement.hasClass('sticky')) {
                if(jQuery('body').width() < 100) header.height(headerHeight);
                stickyElement.addClass('sticky');
                jQuery('body').addClass('fixed-header');
                header.animate({top: 0}, 600);
            }
        } else {
            if (stickyElement.hasClass('sticky') || jQuery('body').hasClass('fixed-header')) {
                stickyElement.removeClass('sticky');
                stickyElement.removeAttr('style');
                jQuery('body').removeClass('fixed-header');
                header.animate({top: 0}, 600);
                if(jQuery('body').width() < 100) header.height('auto');
            }
        }



    });




    var ScreenWidth = window.innerWidth;
    if(ScreenWidth <= 767) {
        // jQuery('.category-drop-down > li > a').attr("href", "javascript:void(0);");
        jQuery('.category-drop-down > li > a > .fa').hide();
        jQuery( '<i class="fa fa-angle-right"></i>' ).insertAfter( ".category-drop-down > li > a" );

        jQuery('.category-drop-down > li > .fa').click(function() {
            jQuery(this).next('.dropdown').toggle();
        }); 



    }
    jQuery(document).ready(function(){


        // jQuery('#cat-link').bind("click", function() {
        //     jQuery('.category-drop-down').slideToggle();

        // }); 

        var mainHeader = jQuery(".main-header"); 
        var mainHeaderHeight = mainHeader.height();
        var ScreenWidth = window.innerWidth;
        if(ScreenWidth >= 480) {
            jQuery('.main-conatiner').css("margin-top",mainHeaderHeight);     }


    });


})();
