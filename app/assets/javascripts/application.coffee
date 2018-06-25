# This is a manifest file that'll be compiled into including all the files listed below.
# Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
# be included in the compiled file accessible from http:#example.com/assets/application.js
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# the compiled file.
#
#= require jquery
#= require jquery-ui
#= require jquery_ujs
#= require jquery-ui-timepicker-addon
#= require jquery.fancybox.pack
#= require jquery.fancybox
#= require jquery.multiselect.min
#= require jquery.uniform
#= require jquery.placeholder
#= require jquery.reveal
#= require h5bp
#= require global.js
#= require rails.validations
#= require rails.validations.extensions
#= require init_datepicker
#= require show_loader
#= require init_placeholders
#= require init_tooltips
#= require init_uniform
#= require tables
#= require details-box
#= require image-slider
#= require form-toggler
#= require common/auctions
#= require custom
#= require categories_multi_select
#= require constants.js
#= require jquery.inview.min.js
#= require owl.carousel.min.js
#= require autocomplete-rails
#= require search_by_services_form
#= require share_button
#= require prompt_zipcode_window
#= require zeroclipboard

#= require_self


$(document).ready -> 
  $('.nav-btn').click ->
    $('.main-nav').slideToggle();
  if $('#top_deal').length > 0
    if $('#top_deal')[0].value.length > 0
      modalLocation = $('#top_deal')[0].value
      $('#' + modalLocation).reveal();
    
  clip = new ZeroClipboard($(".my_clip_button")) 