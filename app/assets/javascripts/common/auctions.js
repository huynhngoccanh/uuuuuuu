$(document).ready(function(){
  /*
   * LIGHTBOX
   */
  if($('#auction-image-thumbs').length) {
    $('#auction-image-thumbs a').fancybox({
      padding: 0,
      overlayOpacity: 1,
      overlayColor: '#050505',
      titleFormat: function (title, currentArray, currentIndex, currentOpts) {
          return (currentIndex + 1) + '/' + currentArray.length
      }
    })
  }
  
  /*
   * COUNTDOWN
   */
  if(!$('#countdown').length) return
	
  var transitionEnd = "TransitionEnd"
  if ( $.browser.webkit ) {
    transitionEnd = "webkitTransitionEnd"
  } else if ( $.browser.mozilla ) {
    transitionEnd = "transitionend"
  } else if ( $.browser.opera ) {
    transitionEnd = "oTransitionEnd"
  }
  
  var changeTxt = function($el, txt) { 
    if($el.text() == txt) return; 
  
    if(Modernizr.csstransitions && !$.browser.safari) { 
      $el.data('text', txt);
      $el.addClass('fade-fast')
      $el.addClass('fade-out')

      var handler = function($el){
        if($el.hasClass('fade-out')) {
          $el.removeClass('fade-fast')
            $el.removeClass('fade-out')  
            $el.text($el.data('text'));
        }
      }

      if(!$el.data('handler-attchd')) {
        $el.bind(transitionEnd, function(){
          handler($el)
        })
        $el.data('handler-attchd', true)      
      }
    } else {
    	console.log(txt)
      $el.text(txt);
    }
    
  }
      
  var endsAt = new Date();
  endsAt.setSeconds(endsAt.getSeconds()+parseInt($('#countdown').attr('data-seconds-to-end'), 10));
  
  var now = new Date();
  var secLeft = (new Date(endsAt - now)).getUTCSeconds()
  
  var checkHour = function() {
    var now = new Date();
    
    var timeLeft = new Date(endsAt - now);
    console.log(now)
    var data = {
      'seconds' : timeLeft.getUTCSeconds(),
      'minutes' : timeLeft.getUTCMinutes(),
      'hours' : timeLeft.getUTCHours(),
      'days' : (timeLeft.getUTCDate()-1)
    } 
    for(var sel in data) {
    	
      changeTxt($('#countdown .'+sel), data[sel]);
    }
    
    now = new Date();
    
    var nextFullSecond = new Date(now);
    nextFullSecond.setSeconds(nextFullSecond.getSeconds() + 1);
    nextFullSecond.setMilliseconds(0);
    
    window.setTimeout(function(){
        checkHour();
    }, nextFullSecond - now)
  }
  
  checkHour();
});