initFormToggler = function(editButton, cancelButton, fieldsWrap, enabled) {
  var show = function(){
    editButton.add(fieldsWrap.find('.to-hide')).hide();
    fieldsWrap.find('.to-show, .actions').fadeIn('normal');
  }
  if(enabled) show();
  
  editButton.on('click', function(){
    show();
  })
  
  cancelButton.on('click', function(){
    editButton.add(fieldsWrap.find('.to-hide')).fadeIn('normal');
    fieldsWrap.find('.to-show, .actions').hide();
  })
}
