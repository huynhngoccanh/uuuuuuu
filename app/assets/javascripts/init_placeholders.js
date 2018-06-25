// ATTENTION: dont use 'disabled' inputs when jquery placeholder plugin is used

$(function(){
  initPlaceholders();
});

function initPlaceholders() {
  $('input[placeholder], textarea[placeholder]').placeholder();
  $('input[placeholder]:not([placeholder-overriden]), textarea[placeholder]:not([placeholder-overriden])')
  .attr('placeholder-overriden', '1')
  .focus(function(){
    var $this = $(this)
    $this.attr('placeholder-value', $this.attr('placeholder'))
    .removeAttr('placeholder')
  })
  .blur(function(){
    var $this = $(this)
    $this.attr('placeholder', $this.attr('placeholder-value'))
  })
}