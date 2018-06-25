// JS Logic for MMBox
function MMBoxWidget(engine) {
    this.engine = engine;
    this.messages = [];
    this.numListingsToDisplay = 3;
    this.isExpanded = false;
    this.currentSearchText = '';
    this.currentData = [];
    // ui
    this.widget = $('#mm-box-container');
    this.listingsTable = $('.mm-listings');
    // keep current request (abort it for new search)
    this.currentXhr = null;
    // center info div
    $('#mm-info-before-shopping').center();
    this.bindListeners();
}

MMBoxWidget.prototype.bindListeners = function () {
    var mmbox = this;

    // truncate long text
    $('.mm_data_company_name').trunk8();
    $('.mm_data_company_address').trunk8();
    $('.mm_data_offer_name').trunk8({lines: 2});
    $('.mm_data_coupon_code').trunk8({width: 10});

    // next offers pager
    var nextOffersFunction = $.proxy(function () {
        if (!this.engine.get('icons', 'isPopupVisible'))
            this.showMoreOffers();
    }, this);
    $('#mm-next-offers-btn').click(nextOffersFunction);

    // clear message and show next
    $('#mm-clear-message-button').click(function () {
        $.post(mmbox.engine.urlFor('/mm_box_remove_user_message'), {'id': mmbox.messages[0].id}, function (result) {
            if (result) {
                mmbox.messages.shift();
                if (mmbox.messages.length > 0)
                    $('#mm-current-message').html(mmbox.messages[0].message);
                else
                    $('#mm-box-message-container').slideUp();
            }
        });
    });

    // shake
    if (isMobile())
        $(window).on('shake', nextOffersFunction);
};

MMBoxWidget.prototype.clearResults = function () {
    $('.mm-listing').remove();
    this.isExpanded = false;
    $('#mm-next-offers-label').text('More Deals');
    this.currentData = [];
    this.listingsTable.fadeOut();
};

MMBoxWidget.prototype.onCheckUserMessages = function () {
    if (this.messages.length == 0) {
        $.get(this.engine.urlFor('/mm_box_get_user_messages'), $.proxy(function (data) {
            if (data && data.length) {
                this.messages = data;
                console.log(this.messages);
                var container = $('#mm-box-message-container');
                if (container.is(':hidden')) {
                    $('#mm-current-message').html(this.messages[0].message);
                    container.slideDown();
                }
            }
        }, this));
    }
};

MMBoxWidget.prototype.setSearchText = function (newSearchText) {
    if (this.engine.isUserLoggedIn && newSearchText != '' && newSearchText != this.currentSearchText) {
        this.clearResults();
        this.currentSearchText = newSearchText;
        this.loadMerchantsData();
    }
};

MMBoxWidget.prototype.loadMerchantsData = function () {
    if (this.currentXhr)
        this.currentXhr.abort();
    this.currentXhr = $.get(this.engine.urlFor('/mm_box_search'), {search: this.currentSearchText}, $.proxy(function (data) {
        this.appendData(data, true);
        this.currentXhr = null;
    }, this));
};

MMBoxWidget.prototype.appendData = function (data, reverse) {
    this.currentData = reverse ? data.concat(this.currentData) : this.currentData.concat(data);
    this.currentData = uniqueBy(this.currentData, function (x) {
        return x.company_name;
    });
    if (this.currentData.length) {
        this.listingsTable.fadeIn();
        this.buildListings();
        this.calculateTotalMoney();
    }
};

MMBoxWidget.prototype.buildListings = function () {
    for (var i = 0; i < this.currentData.length; i++) {
        var merchant = this.currentData[i];
        var newId = 'mm-listing-' + merchant['id'];
        var newRow = $('#' + newId);
        if (newRow.length == 0) {
            var template = $('#mm-listing-template');
            newRow = template.clone(true).addClass('mm-listing');
            newRow.attr('id', newId);
            template.closest('tbody').append(newRow);
        }
        if (i < this.numListingsToDisplay || this.isExpanded)
            newRow.removeClass('hide');
        else
            newRow.addClass('hide');
        for (var prop in merchant)
            newRow.find('.mm_data_' + prop).html(merchant[prop]);
        // truncation
        newRow.find('.mm_data_company_name').trunk8('update', merchant['company_name'].replace('Affiliate Program', ''));
        if (merchant['company_address'])
            newRow.find('.mm_data_company_address').trunk8('update', merchant['company_address']);
        newRow.find('.mm_data_offer_name').trunk8('update', merchant['offer_name']);
        newRow.find('.mm_data_coupon_code').trunk8('update', merchant['coupon_code']);
        if (merchant['offer_buy_url']) {
            newRow.find('.mm-shop-now-btn, .mm_data_company_name').attr('mm-href', merchant['offer_buy_url']);
            newRow.find('.mm_data_company_name').addClass('mm-active-link').end().find('.mm-shop-now-btn').removeClass('hide');
            if (merchant['coupon_code'] != 'No coupons')
                newRow.find('.mm_data_coupon_code').addClass('mm-active-link').end().find('.mm_data_company_name, .mm_data_coupon_code, .mm-shop-now-btn').attr('mm-href-popup', merchant['company_coupons_url']);
        }
        else {
            if (isMobile()) {
                newRow.find('.mm-call-now-btn').attr('href', 'tel:' + merchant['company_phone']);
                newRow.find('.mm-call-now-btn').removeClass('hide').html(merchant['company_phone']);
            }
            else {
                newRow.find('.mm-call-now-btn').attr({tooltip: merchant['company_phone']});
                newRow.find('.mm-call-now-btn').tipsy({title: 'tooltip'});
                newRow.find('.mm-call-now-btn').removeClass('hide').html('view number');
            }
            // muddleme service merchant popup
            if (merchant['merchant_email']) {
                newRow.find('.mm_data_company_name').addClass('mm-active-link').attr('data-toggle', 'modal').attr('href', '#mm-merchant-modal');
                var mmbox = this;
                newRow.find('.mm_data_company_name').click(function () {
                    var listing = $(this).parent().parent();
                    var merchantId = listing.attr('id').replace('mm-listing-', '');
                    var merchant = null;
                    for (var i = 0; i < mmbox.currentData.length; i++) {
                        if (merchantId == mmbox.currentData[i]['id']) {
                            merchant = mmbox.currentData[i];
                            break;
                        }
                    }
                    for (var prop in merchant)
                        $('#mm-merchant-modal').find('.mm_data_' + prop).html(merchant[prop]);
                    $('#mm-merchant-modal').find('.mm_data_merchant_email').html('Email: ' + merchant['merchant_email']).end().find('.mm_data_company_phone').html('Phone: ' + merchant['company_phone']).end().find('.mm_data_merchant_review_url').attr('href', merchant['merchant_review_url']).end().find('.mm_data_offer_service_url').attr('href', merchant['offer_service_url']);
                });
            }
        }
        // format and calculate money
        if (!isNaN(merchant['user_money'])) {
            var rowMoney = parseFloat(merchant['user_money']);
            newRow.find('.mm_data_user_money').html(formatMoney(rowMoney));
        }
        // add merchant id to activate it when clicked
        newRow.find('[mm-href], .mm-call-now-btn').attr('mm-merchant-id', merchant['id']);
    }
};

MMBoxWidget.prototype.calculateTotalMoney = function () {
    var total = 0;
    for (var i = 0; i < this.currentData.length; i++) {
        var merchant = this.currentData[i];
        if (!isNaN(merchant['user_money']))
            total += parseFloat(merchant['user_money']);
    }
    $('#mm-total-money').html('Your Cash Total: ' + formatMoney(total));
};

MMBoxWidget.prototype.showMoreOffers = function () {
    this.isExpanded = !this.isExpanded;
    $('#mm-next-offers-label').text(this.isExpanded ? 'Show Less' : 'More Deals');
    this.buildListings();
};

MMBoxWidget.prototype.getCurrentData = function () {
    return this.currentData;
};

MMBoxWidget.prototype.getSearchString = function () {
    return this.currentSearchText;
};

MMBoxWidget.prototype.onUserLoggedIn = function (user) {
    $('#mm_user_balance').html(formatMoney(user['balance']));
    $('#mm_user_score').html(user['score']);
    $('#mm-box-controls-logged-in').removeClass('hide');
    $('#mm-box-controls-not-logged-in').addClass('hide');
};

MMBoxWidget.prototype.onUserLoggedOut = function () {
    if (this.currentXhr)
        this.currentXhr.abort();
    this.messages = [];
    $('#mm-box-message-container').slideUp();
    $('#mm_user_score').html('--');
    $('#mm-box-controls-logged-in').addClass('hide');
    $('#mm-box-controls-not-logged-in').removeClass('hide');
    this.currentSearchText = '';
    this.clearResults();
};