$(function () {
  var editingAdvanced = false
  var skippedAuction = true
  var currentStep = 2

  var showStep = function(num, dontValidate){
    if(currentStep == num) return;
    if(currentStep == 1 && num == 3) return;//cant go from 1 to 3 
    //maybe done better: validate second step if not valid than show second step instead

    if(num <= currentStep) dontValidate = true

    //enable fields on step 1
    if(num == 1) {
      skippedAuction = false
      
      //reenable validate inputs
      $('#customer-registration article.step-1').
      find('[data-validate]:input').removeAttr('data-was-validate').attr('data-validate', true)
      //reenable inputs
      $('#customer-registration article.step-1 :input').removeAttr('disabled')

      $('.reg-step-3').addClass('blocked')
    } else {
      $('.reg-step-3').removeClass('blocked')
    }

    if(num == 3) copyInputValues()
   
    //validate fields
    if(!dontValidate) {
      var valid = true;
      $('#customer-registration article.step-' + currentStep).
      find('[data-validate]:input').data('changed', true).each(function() {
        var input = $(this)
        input.data('changed', true);
        console.log(input);
        if (!input.isValid(window.ClientSideValidations.forms.user_registration_form.validators)) 
          valid = false; 
      });

      if(!valid) return;
    }

    $('#registration-steps li').removeClass('active')
    $('#registration-steps li.reg-step-' + num).addClass('active')

    $('#customer-registration article').hide()
    $('#customer-registration article.step-' + num).fadeIn()
    currentStep = num
  }

  var copyInputValues = function(){
    $('#customer-registration-confirm p > span:nth-child(2)').each(function(){
      var text, label = $(this), id = this.id, isAdvanced = label.hasClass('advanced')
      var input = $('#customer-registration').find('#' + id.replace(/_val$/,''))
      if(input.is('select')) {
        text = input.find(":selected").text()
      } else {
        text = input.val()
      }
      if(isAdvanced && !editingAdvanced) text += ' (default)'
      label.text(text)
    })
  }

  $('#edit-advanced').click(function(e){
    e.preventDefault()
    editingAdvanced = true
    $('#advanced-auction-attributes').fadeIn('fast')
  })

  $('#step-1-next').click(function(){
    showStep(2)
  })

  $('#skip-auction').click(function(){
    skippedAuction = true
    //dont validate inputs
    $('#customer-registration article.step-1').
    find('[data-validate]:input').removeAttr('data-validate').attr('data-was-validate', 1)
    //disable inputs
    $('#customer-registration article.step-1 :input').attr('disabled', true)

    $('#customer-registration-confirm .for-auction').hide()
    showStep(2, true)
  })

  $('#step-2-next').click(function(){showStep(3)})

  $('#step-2-back').click(function(){showStep(1)})

  $('#step-3-back').click(function(){showStep(2)})

  $('#registration-steps a').click(function(e){e.preventDefault()})
  $('#registration-steps li').click(function(){
    var step = this.className.match(/reg-step-(\d)/)[1]
    showStep(step)
  })

  $('select#user_auctions_attributes_0_service_category_id, select#user_auctions_attributes_0_duration, select#user_auctions_attributes_0_budget').multiselect({
    header: false,
    selectedList: 1,
    height: "auto",
    minWidth: "289",
    multiple: false,
    classes: "multiselect-button multiselect-dropdown",
    position: {
      my: 'left top',
      at: 'left top'
    }
  });
  
  $('select#user_auctions_attributes_0_min_vendors, select#user_auctions_attributes_0_max_vendors').multiselect({
    header: false,
    selectedList: 1,
    height: "auto",
    minWidth: "60",
    multiple: false,
    classes: "multiselect-button multiselect-dropdown off-top",
    position: {
      my: 'left top',
      at: 'left top'
    }
  });
});
