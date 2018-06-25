$('.tag .close, .tag .preferred').on('click', function(){
    showLoader($('#affiliates-form-warp'))
})

$('.add-advertiser-button').on('click', function(e){
    e.preventDefault();
    var selected = $(this).parent().find('option:selected:first');
    if(!selected.length || !selected.val())
        return;
    var advertiserId = selected.val()
    if(!window.selected_category_id) return;


    var type;
    if($(this).hasClass('add-cj')) type = 'cj';
    if($(this).hasClass('add-avant')) type = 'avant';
    if($(this).hasClass('add-linkshare')) type = 'linkshare';
    if($(this).hasClass('add-pj')) type = 'pj';
    if($(this).hasClass('add-ir')) type = 'ir';
    if(!type) return;

    if($('.' + type + '_' + advertiserId).length) return;

    $.getScript(add_advertiser_mapping_url.
        replace('__category__id__', window.selected_category_id).
        replace('__type__',type).
        replace('__advertiser_id__',advertiserId)
        )
    showLoader($('#affiliates-form-warp'))
});
