$(document).ready ->
  if $('section.local-merchants.full-width').length > 0
    
    $('.ajax-spinner').on('ajax:beforeSend', (e, data, status, xhr) ->
      #TODO show spinner
    )
    $('.ajax-spinner').on('ajax:complete', (e, data, status, xhr) ->
      #TODO hide spinner
    )
