//= require jquery_file_upload

$(function () {
    $("input[type=file]")
    .change(function(){
      $(this).closest('.input-file-wrap').find('input.fakeupload').val($(this).val().replace('C:\\fakepath\\',''))
    })
  
    locale.fileupload.errors.emptyResult = 'Error while loading file'
  
    // Initialize the jQuery File Upload widget:
    $('#fileupload').fileupload({
      autoUpload: true, 
      previewMaxWidth: 48, 
      previewMaxHeight: 48,
      maxFileSize: window.fileUploadMaxFileSize || (300 * 1000),
      maxNumberOfFiles: window.fileUploadMaxFiles || 10,
      acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i
    });
    
    var showHideDropMessage = function() {
      var fn = $('#fileupload .files').children().length ? 'hide' : 'show';
      $('#fileupload .drop-msg')[fn]();
    }
    
    $('#fileupload').bind('fileuploadadded', function () {showHideDropMessage()});
    $('#fileupload').bind('fileuploaddestroyed', function () {showHideDropMessage()});
    $('#fileupload input[type="file"]').attr('multiple', 'multiple');
    // 
    // Load existing files:
    $.getJSON($('#fileupload').data('image-list-url'), function (files) {
      var fu = $('#fileupload').data('fileupload'), 
        template;
      fu._adjustMaxNumberOfFiles(-files.length);
      template = fu._renderDownload(files)
        .appendTo($('#fileupload .files'));
      // Force reflow:
      fu._reflow = fu._transition && template.length &&
        template[0].offsetWidth;
      template.addClass('in');
      $('#loading').remove();
      showHideDropMessage();
    });

});