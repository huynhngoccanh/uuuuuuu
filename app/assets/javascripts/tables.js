$(function(){
  
  $('table .actns-wrap .actns').on('mouseenter', function(){
    var $this = $(this);
    if($this.data('leaveTimer')) {
      window.clearTimeout($this.data('leaveTimer'))
    }
    if(!$this.data('styled')) {
      $this.data('styled', true);
    }
    $this.closest('tr').addClass('highlight');
    $this.closest('td.actns-cell').addClass('hover');
    $(this).find('.links').slideDown('fast');
  });
  
  var leaveHandler =  function($this){
    $this.closest('tr').removeClass('highlight');
    $this.find('.links').slideUp('fast', function(){
      $this.closest('td.actns-cell').removeClass('hover');
    });
  }
  
  $('table .actns-wrap .actns').on('mouseleave', function(){
    var $this = $(this);
    $this.data('leaveTimer', window.setTimeout(function(){
      leaveHandler($this);
    }, 50))
  })
})