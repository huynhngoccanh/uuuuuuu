// EXTENSION VARIABLES
var EXT = {};

EXT.WEB_APP_HOST = 'muddleme.com';
EXT.ORIGINS = ['http://www.google.com', 'https://www.google.com', 'http://www.yahoo.com', 'https://www.yahoo.com', 'http://search.yahoo.com', 'https://search.yahoo.com', 'https://www.bing.com', 'http://www.bing.com'];
EXT.SIGNED_IN_COOKIE_NAME = 'signed_in';

// command names
EXT.CHECK_USER_SESSION_COMMAND = 'extension.check.user.session.';
EXT.GET_USER_INFO_COMMAND = 'extension.get.user.info';
EXT.LOGIN_COMMAND = 'extension.login';
EXT.LOGOUT_COMMAND = 'extension.logout';
EXT.ACTIVATE_MERCHANT_COMMAND = 'extension.activate.merchant';
EXT.SEARCH_COMMAND = 'extension.search';
EXT.SEARCH_BY_LINKS_COMMAND = 'extension.search.by.links';
EXT.CHECK_USER_MESSAGES_COMMAND = 'extension.check.user.messages';
EXT.GET_USER_MESSAGES_COMMAND = 'extension.get.user.messages';
EXT.REMOVE_USER_MESSAGE_COMMAND = 'extension.remove.user.message';
EXT.SEARCH_LITE_COMMAND = 'extension.search.lite';

$(function () {
    var CURRENT_ORIGIN;

    window.addEventListener("message", receiveMessage, false);

    function xhrRequest(data, origin) {
        var originalCommand = data.command;
        var request_data = data.request.body || data.request.params || {};
        request_data.extension_origin = origin;
        $.ajax(data.request.url, { type: data.request.method, data: request_data})
            .done(function (data) {
                window.parent.postMessage({'command': originalCommand, 'response': data}, CURRENT_ORIGIN);
            }).fail(function( jqXHR, textStatus, errorThrown ) {
                window.parent.postMessage({'command': originalCommand, 'response': {'success': false, 'message': jqXHR.responseText}}, CURRENT_ORIGIN);
            });
    }

    function receiveMessage(event) {
        if ($.inArray(event.origin, EXT.ORIGINS) == -1)
            return;
        CURRENT_ORIGIN = event.origin;
        var data = event.data;
        switch (data.command) {
            case EXT.CHECK_USER_SESSION_COMMAND:
                window.parent.postMessage({'command': data.command, 'response': $.cookie(EXT.SIGNED_IN_COOKIE_NAME) != undefined}, CURRENT_ORIGIN);
                break;
            case EXT.CHECK_USER_MESSAGES_COMMAND:
                window.parent.postMessage({'command': data.command, 'response': $.cookie('user_messages_count')}, CURRENT_ORIGIN);
                break;
            case EXT.GET_USER_INFO_COMMAND:
            case EXT.LOGIN_COMMAND:
            case EXT.LOGOUT_COMMAND:
            case EXT.SEARCH_COMMAND:
            case EXT.SEARCH_BY_LINKS_COMMAND:
            case EXT.ACTIVATE_MERCHANT_COMMAND:
            case EXT.GET_USER_MESSAGES_COMMAND:
            case EXT.REMOVE_USER_MESSAGE_COMMAND:
            case EXT.SEARCH_LITE_COMMAND:
                xhrRequest(data, event.origin);
                break;
        }
    }
});