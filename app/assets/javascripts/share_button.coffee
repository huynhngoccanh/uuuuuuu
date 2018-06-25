$(document).ready ->
 
  $('.share-btn').click ->
    $(this).next('.share-form').show()
    return
  $('.fa-close').click ->
    $('.share-form').hide()
    return