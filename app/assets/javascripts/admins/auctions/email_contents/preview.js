$(function(){
  var pendingRequest;
  var linkTxt = $('.preview-link:first').text();
  $('.preview-link').on('click',function(e){
    e.preventDefault();
    var $this = $(this);
    $this.text('Generating preview...');
    if(pendingRequest) pendingRequest.abort();
    $.ajax({
      type: 'POST',
      url: $this.attr('href'),
      complete: function(){
        $this.text(linkTxt);
        showDetailsBox($('#email-content-details-box'));
      },
      dataType: 'script'
    });
  });
})