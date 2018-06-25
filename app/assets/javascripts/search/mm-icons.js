// JS Logic for MMIcons
function MMIconsWidget(engine) {
    this.engine = engine;
    this.searchEngineLinkContainers = null;
    this.currentXhr = null;
    this.bindListeners();
    // js popup stuff
    this.currentOfferIndex = 0;
}

MMIconsWidget.prototype.bindListeners = function () {
    var nextOfferFunction = $.proxy(function () {
        if(this.isPopupVisible())
          this.setNextOffer(null);
    }, this);
    $('.mm-popup-next-offer').click(nextOfferFunction);
    // shake
    if(isMobile())
      $(window).on('shake', nextOfferFunction);
};

MMIconsWidget.prototype.isPopupVisible = function () {
    return $('#mm-offer-modal').is(':hidden') == false;
};

MMIconsWidget.prototype.setNextOffer = function (companyName) {
    var currentData = this.engine.get('box', 'getCurrentData');
    this.currentOfferIndex = this.currentOfferIndex > currentData.length - 1 ? 0 : this.currentOfferIndex;
    for (var index in currentData) {
        var isAffiliateSource = currentData[index]['type'] != 'Search::SoleoMerchant' && currentData[index]['type'] != 'Search::LocalMerchant';
        if (!isAffiliateSource)
            continue;
        if (companyName) {
            if (companyName == currentData[index]['company_name']) {
                this.setMerchantData(currentData[index]);
                this.currentOfferIndex = index;
                break;
            }
        }
        else if (index >= this.currentOfferIndex) {
            this.setMerchantData(currentData[index]);
            this.currentOfferIndex = index;
            break;
        }
    }
    this.currentOfferIndex++;
};

MMIconsWidget.prototype.setSearchEngineLinkContainers = function (newContainers) {
    this.searchEngineLinkContainers = newContainers;
    if (this.engine.isUserLoggedIn && this.searchEngineLinkContainers != null) {
        this.clearResults();
        this.loadMerchantsByUrls();
    }
};

MMIconsWidget.prototype.clearResults = function () {
    $('.mm-affiliate-icon').remove();
};

MMIconsWidget.prototype.loadMerchantsByUrls = function () {
    if (this.currentXhr)
        this.currentXhr.abort();
    var links = [];
    this.searchEngineLinkContainers.each(function () {
        links.push($(this).find('a').attr('href'));
    });

    var search = this.engine.get('box', 'getSearchString');
    this.currentXhr = $.get(this.engine.urlFor('/mm_affiliate_merchants_search'), $.param({links: links, search: search}), $.proxy(function (data) {
        this.onMerchantsByUrlsDataLoaded(data);
        this.currentXhr = null;
    }, this));
};

MMIconsWidget.prototype.onMerchantsByUrlsDataLoaded = function (data) {
    var merchants = [];
    for (var i = 0; i < data.length; i++) {
        if (data[i]) {
            merchants.push(data[i]);
            this.insertMerchantIcon(i, data[i]['company_name']);
        }
    }
    this.engine.dispatch('appendData', merchants);
};

MMIconsWidget.prototype.setMerchantData = function (merchant) {
    var popupContainer = $('#mm-offer-modal');
    for (var prop in merchant)
        popupContainer.find('.mm_data_' + prop).html(merchant[prop]);
    popupContainer.find('.mm-popup-shop-now').attr('mm-href', merchant['offer_buy_url']).attr('mm-merchant-id', merchant['id']); // set merchant id
    if (merchant['coupon_code'] != 'No coupons') {
        popupContainer.find('.mm_data_coupon_code').addClass('mm-active-link');
        popupContainer.find('.mm-popup-shop-now, .mm_data_coupon_code').attr('mm-href-popup', merchant['company_coupons_url']);
    }
    else {
        popupContainer.find('.mm_data_coupon_code').removeClass('mm-active-link');
        popupContainer.find('.mm-popup-shop-now, .mm_data_coupon_code').removeAttr('mm-href-popup');
    }
};

MMIconsWidget.prototype.insertMerchantIcon = function (index, companyName) {
    var icon = $('<div/>', {'class': 'mm-affiliate-icon', 'data-toggle': 'modal', 'href': '#mm-offer-modal'});
    $(this.searchEngineLinkContainers[index]).prepend(icon);

    icon.click($.proxy(function () {
        this.setNextOffer(companyName);
    }, this));
};

MMIconsWidget.prototype.onUserLoggedOut = function () {
    if (this.currentXhr)
        this.currentXhr.abort();
    this.searchEngineLinkContainers = null;
    this.clearResults();
};