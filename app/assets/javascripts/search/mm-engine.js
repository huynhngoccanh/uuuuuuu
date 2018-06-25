//= require search/mm-box
//= require search/mm-icons

// JS Logic for base MM engine (login/logout, search bar icons, auto update when cookie set)
function MMEngine(baseUrl, mmUserInfo, mmIconContainerClassName, mmIconOuterClassName) {
    this.BASE_URL = baseUrl || '';
    this.currentUserInfo = mmUserInfo;
    this.isUserLoggedIn = mmUserInfo != null;

    // Insert search bar icons
    var mmIcon = $('.mm-search-bar-icon').addClass(mmIconOuterClassName).removeClass('hide');
    $('.' + mmIconContainerClassName).each($.proxy(function (index, value) {
        $(value).append(index ? mmIcon.clone() : mmIcon);
    }, this));
    // Bind listeners
    this.bindListeners();
    // Create widgets
    this.widgets = {box: new MMBoxWidget(this), icons: new MMIconsWidget(this)};
    // backup vars
    this.currentMerchantId = null;
    this.currentShoppingHref = null;
}

MMEngine.prototype.urlFor = function (path) {
    return this.BASE_URL + path;
};

MMEngine.prototype.getMMBox = function () {
    return this.widgets['box'].widget;
};

MMEngine.prototype.bindListeners = function () {
    var engine = this;

    // Success login
    $('#mm-auth-form').bind('ajax:success', $.proxy(function (e, data, status, xhr) {
            $('.mm-modal-messages').empty();
            if (data.message) {
                if (data.success)
                    $('#mm-auth-messages').html(data.message);
                else
                    $('#mm-auth-errors').html(data.message);
            }
            else
                $('#mm-auth-modal').modal('hide');
        }, this)).bind('ajax:error', function (e, data, status, xhr) {
        $('.mm-modal-messages').empty();
        $('#mm-auth-errors').html(data.responseText);
    });
    // Open new window
    $('[mm-href]').on('click', function (e) {
        e.preventDefault();
        engine.currentMerchantId = $(this).attr('mm-merchant-id');
        engine.currentShoppingHref = $(this).attr('mm-href');
        if(engine.currentUserInfo.skip_info_before_shopping)
            $('.mm-continue-shopping-button').click();
        else {
            $('#mm-info-display').attr('checked', false);
            $('#mm-info-before-shopping').fadeIn(300);
        }
    });

    $('.mm-continue-shopping-button').click(function () {
        window.open(engine.currentShoppingHref);
        $.post(engine.urlFor('/mm_activate_merchant'), {id: engine.currentMerchantId});
        $('#mm-info-before-shopping').fadeOut(300);
    });

    $('#mm-info-display').click(function () {
        if ($(this).is(':checked')) {
            engine.currentUserInfo.skip_info_before_shopping = true;
            $.post(engine.urlFor('/mm_skip_info_before_shopping'));
        }
    });

    $('.mm-call-now-btn').on('click', function (e) {
        var merchantId = $(this).attr('mm-merchant-id');
        $.post(engine.urlFor('/mm_activate_merchant'), {id: merchantId});
    });

    // Open popup window
    $('[mm-href-popup]').on('click', function (e) {
        e.preventDefault();
        if (isMobile()) {
            var iframe = $('#mm-coupons-iframe');
            iframe.contents().empty();
            var modal = $('#mm-coupons-modal');
            iframe.attr('src', $(this).attr('mm-href-popup') + '?mobile=1');
            iframe.css('height', modal.height());
            modal.modal('show');
        }
        else {
            var height = 660;
            var left = $(window).width() + 100;
            var winParams = 'innerWidth=440,height=' + height + ',resizable=no,location=no,scrollbars=yes';
            winParams += ',left=' + left;
            window.open($(this).attr('mm-href-popup'), 'couponsPopup', winParams);
        }
    });
    $('.mm-auth-link').click(function () {
        $('.mm-modal-messages').empty();
    });
    $('.mm-signup-link').click($.proxy(function () {
        $('.mm-auth-login-part, .mm-auth-preset-part').addClass('hide');
        $('.mm-auth-signup-part').removeClass('hide');
        $('.mm-auth-button').text('Sign up');
        $('#mm-auth-form').attr('action', this.urlFor('/signup/create'));
    }, this));
    $('.mm-login-link').click($.proxy(function () {
        $('.mm-auth-signup-part, .mm-auth-preset-part').addClass('hide');
        $('.mm-auth-login-part').removeClass('hide');
        $('.mm-auth-button').text('Log in');
        $('#mm-auth-form').attr('action', this.urlFor('/login'));
    }, this));
    $('.mm-forgot-password-link').click($.proxy(function () {
        $('.mm-auth-login-part, .mm-auth-signup-part').addClass('hide');
        $('.mm-auth-preset-part').removeClass('hide');
        $('.mm-auth-button').text('Send');
        $('#mm-auth-form').attr('action', this.urlFor('/reset/send'));
    }, this));
    $('#mm-auth-form').attr('action', this.urlFor('/login'));
};

MMEngine.prototype.onUserSessionChanged = function (isUserLoggedIn) {
    this.isUserLoggedIn = isUserLoggedIn;
    if (this.isUserLoggedIn && this.currentUserInfo == null) {
        $.get(this.urlFor('/mm_box_get_current_user'), $.proxy(function (data) {
            this.onUserLoggedIn(data);
        }, this));
    }
    if (!this.isUserLoggedIn && this.currentUserInfo)
        this.onUserLoggedOut();
};

MMEngine.prototype.onCheckUserMessages = function (cookie) {
    if(this.isUserLoggedIn && cookie != undefined && cookie != 0) {
        this.dispatch('onCheckUserMessages');
    }
};

MMEngine.prototype.onUserLoggedIn = function (user) {
    this.currentUserInfo = user;
    $('#mm-auth-errors').empty();
    $('.mm-search-bar-icon').removeClass('mm-search-bar-icon-not-logged-in').addClass('mm-search-bar-icon-logged-in').removeAttr('data-toggle').attr('data-confirm', 'MuddleMe: Are you sure you want to sign out?').attr('data-method', 'delete').attr('href', '/logout').attr('title', 'Sign out');
    this.dispatch('onUserLoggedIn', user);
};

MMEngine.prototype.onUserLoggedOut = function () {
    this.currentUserInfo = null;
    $('#mm-info-before-shopping').fadeOut(300);
    var parent = $('.mm-search-bar-icon').removeClass('mm-search-bar-icon-logged-in').addClass('mm-search-bar-icon-not-logged-in').attr('data-toggle', 'modal').removeAttr('data-method').removeAttr('data-confirm').attr('href', '#mm-auth-modal').attr('title', 'Log in').parent();
    var clone = $('.mm-search-bar-icon:first').clone();
    parent.empty().append(clone);
    this.dispatch('onUserLoggedOut');
};

MMEngine.prototype.dispatch = function (methodName, params) {
    for (var key in this.widgets)
        if (typeof this.widgets[key][methodName] == 'function')
            this.widgets[key][methodName](params);
};

MMEngine.prototype.get = function (widgetName, methodName, params) {
    if (!this.widgets[widgetName] || !(typeof this.widgets[widgetName][methodName] == 'function'))
        return null;
    return this.widgets[widgetName][methodName](params);
};