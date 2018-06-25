$(function () {
    $('#bing-submit-button').click(function () {
        $('#bing-search-box-form').submit();
    });
    $('#bing-search-input-box-id-1').focus(function () {
        $('#bing-search-input-box-id-1, #bing-submit-column, #bing-submit-button').each(function (index, el) {
            $(el).addClass(el.id + '-focused');
        });
    }).blur(function () {
        $('#bing-search-input-box-id-1, #bing-submit-column, #bing-submit-button').each(function (index, el) {
            $(el).removeClass(el.id + '-focused');
        });
    })
});