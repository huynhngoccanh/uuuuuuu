$(document).ready(function(){
  $('#auction-image-thumbs img').click(function(){
    $('#auction-current-image').stop(true, true).
    hide().attr('src', $(this).data('normal-url'));
    $('#auction-current-image').fadeIn('fast');
  });
  
  
  $('#desired-time-first').change(function(){
    var val = $(this).val();
    if(val) {
      $('#desired-time-second').val('')
      $('#desired-time-to').val('')
    }
  });
  
  $('#desired-time-second').change(function(){
    var val = $(this).val();
    if(val) {
      $('#desired-time-first').val('')
    }
  });
  
  $('#desired-time-to').change(function(){
    var val = $(this).val();
    if(val) {
      if(!$('#desired-time-second').val()) {
        $('#desired-time-first').val()
      }
      $('#desired-time-first').val('');
    }
  });
  
  if($('#desired-time-to').val()) {
    $('#desired-time-first').val('');
  } else {
    $('#desired-time-second').val('');
  }
  
  $('#contact-time-first, #contact-time-ofday').change(function(){
    var val = $(this).val();
    if(val) {
      $('#contact-time-second').val('')
      $('#contact-time-to').val('')
    }
  });
  
  $('#contact-time-second, #contact-time-to').change(function(){
    var val = $(this).val();
    if(val) {
      $('#contact-time-first').val('');
      $('#contact-time-ofday').val('');
    }
  });
  
  if($('#contact-time-to').val()) {
    $('#contact-time-first').val('');
    $('#contact-time-ofday').val('');
  } else {
    $('#contact-time-second').val('');
  }
  
  /**
   * FIX for desired and contact time disable empty fields before submit so it posts the correct val
   */
  $('#desired-time-first').closest('form').submit( function(){
    if(!$('#desired-time-second').val() && !$('#desired-time-to').val()) {
      $('#desired-time-second, #desired-time-to').attr('disabled', true);
    } else if(!$('#desired-time-first').val()) {
      $('#desired-time-first').attr('disabled', true);
    }
  });
  $('#contact-time-first').closest('form').submit( function(){
    if(!$('#contact-time-second').val() && !$('#contact-time-to').val()) {
      $('#contact-time-second, #contact-time-to').attr('disabled', true);
    } else if(!$('#contact-time-first').val()) {
      $('#contact-time-first').attr('disabled', true);
    }
  });
  
  var activateForm = function(){
    $('form#new_auction_address [data-had-validate]:input')
    .attr('data-validate', true);
    $('form#new_auction_address .inputs').removeClass('masked');
  }
  
  var deactivateForm = function(){
    $('form#new_auction_address [data-validate]:input')
    .attr('data-had-validate', true)
    .data('changed', true)
    .removeAttr('data-validate').each(function(){
      clientSideValidations.formBuilders['SimpleForm::FormBuilder'].remove($(this), new_auction_address)
    });
    $('form#new_auction_address .inputs').addClass('masked');
  }
  
  $('input[name="use_default_address"]:checked').val() == 'no' ? activateForm() : deactivateForm();
  
  $('input[name="use_default_address"]').on('change', function(){
    $('input[name="use_default_address"]:checked').val() == 'no' ? activateForm() : deactivateForm();
  })
  
  $('form#new_auction_address :text').on('focus', function(){
    $('#use_default_address_no').attr('checked', true).change();
  })
  
});


function resolveMinMaxBudgetVisibility(){
    var val = $('select#auction_budget').val()
    var enable = val == 'custom'
    $('#budget-custom').toggle(enable);
    $('#budget-custom input').attr('disabled', !enable);
    if (val && val.split('-').length == 2) {
        val = val.replace(/ /g, "").replace(/\$/g, "");
        $('#auction_budget_min').data('changed', true).val(val.split('-')[0]);
        $('#auction_budget_max').data('changed', true).val(val.split('-')[1]);
    } else if (val && val.split('+').length == 2) {
        $('#auction_budget_min').data('changed', true).val(val.split('+')[0]);
        $('#auction_budget_max').data('changed', true).val('');

    }
}

$(document).ready(function () {
    resolveMinMaxBudgetVisibility();
    $('select#auction_budget').change(resolveMinMaxBudgetVisibility);
});
