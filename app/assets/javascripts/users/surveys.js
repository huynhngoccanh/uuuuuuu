$(document).ready(function(){
  var wrap = $('#question-window ul');
  var step = wrap.children(':first').outerWidth();
  wrap.css('height','auto');
  wrap.width(wrap.children().length * step);
  
  var curNum = function(){
    var hashNum = parseInt(window.location.hash.replace('#',''), 10);
    return isNaN(hashNum) ? 1 : hashNum || 1
  }
  
  var setPage = function(){
    var qNum = curNum()
    
    $('#survey-back')[qNum == 1 ? 'hide': 'show']();
    
    $('#survey-next')[$('#question-num-' + qNum).hasClass('last') ? 'hide' : 'show']();
    $('#survey-skip')[$('#question-num-' + qNum).hasClass('last') ? 'hide' : 'show']();
    $('#survey-save-no-social')[$('#question-num-' + qNum).hasClass('last') ? 'show' : 'hide']();
    
    if($('#question-num-' + qNum).find('input:checked').length) {
      $('#survey-next').removeAttr('disabled');
    } else {
      $('#survey-next').attr('disabled', true);
    }
    
    wrap.stop(true,true)
    var lft = (qNum-1) * -step;
    var curLft = parseInt(wrap.css('margin-left'),10);
    if(lft == curLft) return;
    wrap.animate({marginLeft: lft}, 300, 'swing');
  }
  
  var go = function(back) {
    var qNum = curNum()
    var max = $('.question-wrap.last')[0].id.replace('question-num-','')
    window.location.hash = Math.max(1, Math.min(max, (qNum + (back?-1:1))));
  }
  
  $(window).bind('hashchange', function() {
    setPage();
  });
  
  $('#survey-next').click(function(){go()});
  $('#survey-back').click(function(){go(true)});
  $('#survey-skip').click(function(){
    var qNum = curNum();
    $('#question-num-' + qNum).find('input:checked').attr('checked', false);
    resolveScore();
    go();
  });
  
  var resolveScore = function(){
    var score = $('#your-score-stamp span');
    var val = parseInt(score.data('score'),10)
    if(!val) return;

    $('.question-wrap').each(function(){
     if($(this).find('input:checked').length) {
       val += POINTS_FOR_SURVEY_QUESTION
     }
    })
    if(parseInt(score.text(),10) != val) {
     score.hide().text(val).fadeIn()
    }
  }
  
  $('input:radio').change(function(){
     var qNum = curNum();
     if($(this).closest($('#question-num-' + qNum).length)) {
       $('#survey-next').removeAttr('disabled');
     }
     resolveScore();
  })
  
  setPage();
  resolveScore();
  
});