var initSearch = function (mmEngine) {
    var gcse = document.createElement('script');
    gcse.type = 'text/javascript';
    gcse.async = true;
    gcse.src = (document.location.protocol == 'https:' ? 'https:' : 'http:') +
        '//www.google.com/cse/cse.js?cx=' + _GSCE_CX;
    var s = document.getElementsByTagName('script')[0];
    s.parentNode.insertBefore(gcse, s);

    $('#cse-search-box-form-id').submit(function () {
        var input = $('#cse-search-input-box-id-1');
        var input2 = $('#cse-search-input-box-id-2');
        var searchText = input.val() || input2.val();

        // =================== update widgets ===================
        mmEngine.dispatch('setSearchText', searchText);
        mmEngine.dispatch('setSearchEngineLinkContainers', null);

        var element = google.search.cse.element.getElement('searchresults-only0');
        if (searchText == '') {
            element.clearAllResults();
        } else {
            if(input.val() == '' && input2.val() != '') {
                input.val(input2.val());
                input.focus();
            }
            $('#cse-middle-search-container').hide();
            $('#cse-slider-container').hide();
            input2.val('');
            element.execute(searchText);
        }
        return false;
    });
};

$(function () {
    $('.bxslider').bxSlider({
        minSlides: 2,
        maxSlides: isMobile() ? 2 : 6,
        slideWidth: isMobile() ? 110 : 140,
        slideMargin: 8,
        preloadImages: 'visible',
        pager: false
    });

    var options = {
        enableHighAccuracy: true,
        timeout: 25000,
        maximumAge: 0
    };

    var successFunction = function(position) {
        $.get('/mm_check_coupons_by_location?lat=' + position.coords.latitude + '&lng=' + position.coords.longitude);
    };

    var errorFunction = function(position) {
    };

    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(successFunction, errorFunction, options);
    }

    // create mm engine object
    var mmEngine = new MMEngine(null, _MM_USER_INFO, 'cse-mm-search-bar-icon-wrapper', 'cse-mm-search-bar-icon');
    if(_UNIVERSITY_PAGE_VISITED) {
        $('.mm-signup-link').click();
        $('#mm-auth-modal').modal('show');
    }

    setInterval(function () {
        mmEngine.onUserSessionChanged($.cookie('signed_in') != undefined);
    }, 500);

    setInterval(function () {
        mmEngine.onCheckUserMessages($.cookie('user_messages_count'));
    }, 2000);

    // init GCSE
    initSearch(mmEngine);

    // detect initiation of new search completed
    setInterval(function () {
        var resultInfo = $('.gsc-result-info');
        if (resultInfo.length > 0) {
            if($('#mm-refresh-label').length == 0) {
                // add some label, so we can detect if google results page was changed
                $('<div/>', {id: 'mm-refresh-label'}).appendTo(resultInfo);
                // set new google link containers
                mmEngine.dispatch('setSearchEngineLinkContainers', $('.gsc-resultsRoot div.gs-title:not(.gsc-thumbnail-left)'));
            }
            if(mmEngine.getMMBox().is(':hidden')) {
                mmEngine.getMMBox().insertAfter(resultInfo);
                mmEngine.getMMBox().fadeIn(500);
            }
        }
    }, 100);
});


 $(document).click(function() {
 //console.log($('gcse').html());
 //console.log($('#gcse-container').html());
 });
