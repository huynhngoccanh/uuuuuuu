$(function(){
  var pendingRequest;
  var linkTxt = $('.profile-link:first').text();
  $('.profile-link').on('click',function(e){
    e.preventDefault();
    var $this = $(this);
    $this.text('Generating preview...');
    if(pendingRequest) pendingRequest.abort();
    $.ajax({
      type: 'POST',
      url: $this.attr('href'),
      complete: function(){
        $this.text(linkTxt);
        showDetailsBox($('#profile-details-box'));
      },
      dataType: 'script'
    });
  });
})