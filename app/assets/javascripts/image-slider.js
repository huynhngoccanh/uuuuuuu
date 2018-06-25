//image slider
initImageSlider = function(){
  var wrap = $('.image-window  ul');
  if(!wrap.length) return;
  if(wrap.children().length < 2) return;
  
  var step = wrap.children(':first').outerWidth();
  wrap.parent().css('height','auto');
  wrap.width(wrap.children().length * step);
  
  var slide = function(left) {
    wrap.children(':first').stop(true,true)
    if(left) {
      wrap.children(':last').prependTo(wrap)
      wrap.children(':first').css('marginLeft', -1*step).animate({marginLeft: 0}, 300, 'swing')
    } else {
      wrap.children(':first').animate({marginLeft: -1 * step}, 300, 'swing', function(){
        $(this).css('marginLeft','').appendTo(wrap)
      })
    }
  }
  
  $('.prev-image-slide').click( function(e){
    e.preventDefault();
    slide(true);
  })
  $('.next-image-slide').click( function(e){
    e.preventDefault();
    slide(false);
  })
  
}