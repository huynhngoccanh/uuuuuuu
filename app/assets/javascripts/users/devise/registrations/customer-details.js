$(function () {

  $("#continue-registration").bind("click", function (e) {
    //If the form is valid then go to next else dont
    var valid = true;
    // this will cycle through all visible inputs and attempt to valdate all of them.
    // if validations fail 'valid' is set to false
    $('[data-validate]:input:visible').each(function () {
      var settings = window[this.form.id];
      if (!$(this).isValid(settings.validators)) {
        valid = false
      }
    });
    if (valid) {
      //code to go to next step
      var slider_elem_width = "-624px";
      $('#customer-registration #step1_init').animate({marginLeft:slider_elem_width}, 300, 'swing');
      $('#customer-registration #step1_init').slideUp("slow");
      $('#customer-registration #step1_describe_customer').slideDown("slow");
    }
    // if any of the inputs are invalid we want to disrupt the click event
    return valid;
  });

  $('#describe-continue').click(function () {
    var slider_elem_width = "-624px";
    $('#customer-registration #step1_describe_customer').animate({marginLeft:slider_elem_width}, 300, 'swing');
    $('#customer-registration #step1_additional').slideDown("slow");
  });


});
